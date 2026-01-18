extends Node

enum STYPE {
	FLOAT,
	PERCENT,
	LOGPERCENT
}

var settings: Dictionary[String, Variant] = {}
var settings_data: Dictionary[String, Dictionary] = {
	"mouse_sensitivity": {
		label = "Mouse sensitivity",
		type = STYPE.LOGPERCENT,
		default = 1,
		min = 0.1,
		max = 10
	}
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
		if settings_data[setting].type in [STYPE.FLOAT, STYPE.PERCENT, STYPE.LOGPERCENT]:
			settings[setting] = ReactiveFloat.new(settings_data[setting].default)
