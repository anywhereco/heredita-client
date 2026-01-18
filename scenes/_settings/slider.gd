extends HBoxContainer

var setting: ReactiveFloat

var percent := false
var log10 := false

func _ready() -> void:
	setting.value_changed.connect(_setting_changed)
	_set_label(setting.value)

func _get_value() -> float:
	if log:
		return Math.exp10($Slider.value)
	else:
		return $Slider.value

func _set_label(value: float) -> void:
	if percent:
		$Value.text = "%d%%" % (value * 100)
	else:
		$Value.text = "%.2f" % value

func _slider_changed(value: float) -> void:
	_set_label(_get_value())

func _slider_let_go(_value_changed: bool) -> void:
	setting.value = _get_value()

func _setting_changed(_setting: ReactiveFloat) -> void:
	$Slider.value = Math.log10(setting.value)
