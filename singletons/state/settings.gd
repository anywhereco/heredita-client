extends Node

const SAVE_PATH: String = "user://settings.json"

var settings: ReactiveDictionary = ReactiveDictionary.new({})
var settings_data: Dictionary[String, SettingsResource] = {
	"mouse_sensitivity": SliderSetting.new(
		"Mouse sensitivity",
		SliderSetting.Type.LOG_PERCENT,
		1.0,
		0.1,
		10
	)
}
var settings_tabs: Dictionary[String, Array] = {
	"Input": [
		"mouse_sensitivity"
	]
}

func getv(setting: String) -> Variant:
	return settings.get(setting).value

func get_reactive(setting: String) -> Variant:
	return settings.get(setting)

func _ready() -> void:
	_load_settings()
	for setting in settings_data:
		if settings.has(setting):
			continue
		if settings_data.get(setting) is SliderSetting:
			settings.set(setting, ReactiveFloat.new((settings_data[setting] as SliderSetting).default))
	settings.value_changed.connect(_save_settings)

func reactive_cleanup(data: Dictionary) -> Dictionary:
	var new := {}
	for key: Variant in data.keys():
		data[key] = _reactive_cleanup_inner(data[key])
	return new

func _reactive_cleanup_inner(value: Variant) -> Variant:
	if value is Reactive:
		return _reactive_cleanup_inner(value.value)
	elif typeof(value) == TYPE_DICTIONARY:
		var dict := {}
		for key: Variant in value:
			dict[key] = _reactive_cleanup_inner(value[key])
		return dict
	elif typeof(value) == TYPE_ARRAY:
		var new_array := []
		for i: int in range(value.size()):
			var inner: Variant = value[i]
			inner = _reactive_cleanup_inner(inner)
			new_array[i] = inner
		return new_array
	else:
		return value

func _load_settings() -> void:
	pass
	
func _save_settings() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(JSON.from_native(reactive_cleanup(settings.value))))
