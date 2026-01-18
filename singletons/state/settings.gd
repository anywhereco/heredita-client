extends Node

var settings: Dictionary[String, Reactive] = {}
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
	return settings[setting].value

func get_reactive(setting: String) -> Variant:
	return settings[setting]

func _ready() -> void:
	for setting in settings_data:
		if settings_data[setting] is SliderSetting:
			settings[setting] = ReactiveFloat.new((settings_data[setting] as SliderSetting).default)
