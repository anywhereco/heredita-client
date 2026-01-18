class_name SliderSetting
extends SettingsResource

var type: Type
var default: float
@warning_ignore("shadowed_global_identifier")
var min: float
@warning_ignore("shadowed_global_identifier")
var max: float

enum Type {
	FLOAT,
	PERCENT,
	# LOG_FLOAT,
	LOG_PERCENT
}

func _init(_label: String, _type: Type, _default: float, _min: float, _max: float) -> void:
	self.label = _label
	self.type = _type
	self.default = _default
	self.min = _min
	self.max = _max

func is_percent() -> bool:
	return type in [Type.PERCENT, Type.LOG_PERCENT]

func is_log() -> bool:
	return type in [Type.LOG_PERCENT]
