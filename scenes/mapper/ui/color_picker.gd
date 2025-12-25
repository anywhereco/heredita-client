extends Control

enum MODE {
	HSV,
	RGB,
	PRESET
}

var color: ReactiveColor = ReactiveColor.new(Color(0,0,0))
@onready var active_picker: Control = $Pickers/HSV

func _ready() -> void:
	color.value_changed.connect(_value_changed)

func _value_changed(new_color: ReactiveColor) -> void:
	$Color.color = new_color.value
	active_picker._value_changed(new_color)

func set_mode(mode: MODE) -> void:
	for child in $Pickers.get_children():
		child.hide()
	if mode == MODE.HSV:
		active_picker = $Pickers/HSV
	elif mode == MODE.RGB:
		active_picker = $Pickers/RGB
	elif mode == MODE.PRESET:
		active_picker = $Pickers/Preset
	else:
		push_error("???")
	active_picker.show()
	active_picker._value_changed(color)
