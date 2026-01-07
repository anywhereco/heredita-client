extends HBoxContainer

const MAP_BLANK = preload("uid://do2qcumlvx0lo")
const MAP_1935 = preload("uid://bb1h8pyo0qcav")

@onready var image_picker_button: ImagePickerButton = $ImagePickerButton
@onready var map_name: Label = $"../../MapName"

var image: ReactiveImage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	image = image_picker_button.image
	image.value = MAP_BLANK.duplicate()
	map_name.text = "Selected map: Blank"
