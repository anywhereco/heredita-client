extends HBoxContainer

const MAP_BLANK = preload("uid://do2qcumlvx0lo")
const MAP_1935 = preload("uid://bb1h8pyo0qcav")

@onready var default_maps: OptionButton = $DefaultMaps
@onready var image_picker_button: ImagePickerButton = $ImagePickerButton

var image: ReactiveImage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	image = image_picker_button.image
	var img := MAP_BLANK.duplicate()
	img.resource_name = "Pick an image or use default (Blank)"
	image.value = img

func _on_default_maps_item_selected(index: int) -> void:
	var img: Image
	match default_maps.get_item_text(index):
		"Blank":
			img = MAP_BLANK.duplicate()
			img.resource_name = "Default: Blank"
		"1935":
			img = MAP_1935.duplicate()
			img.resource_name = "Default: 1935"
	image.value = img
	default_maps.select(0)
