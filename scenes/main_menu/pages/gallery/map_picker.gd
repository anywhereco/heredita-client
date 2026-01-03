extends HBoxContainer

const MAP_BLANK = preload("uid://do2qcumlvx0lo")
const MAP_1935 = preload("uid://bb1h8pyo0qcav")

@onready var default_maps: OptionButton = $DefaultMaps
@onready var image_picker_button: ImagePickerButton = $ImagePickerButton
@onready var map_name: Label = $"../MapName"

var image: ReactiveImage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	image = image_picker_button.image
	image.value = MAP_BLANK.duplicate()
	map_name.text = "Selected map: Blank"
	$DefaultMaps.get_popup().theme_type_variation = &"PopupMenuSimplified"

func _on_default_maps_item_selected(index: int) -> void:
	var img: Image
	match default_maps.get_item_text(index):
		"Blank":
			img = MAP_BLANK.duplicate()
		"1935 by Tibet Maps":
			img = MAP_1935.duplicate()
	map_name.text = "Selected map: %s" % default_maps.get_item_text(index)
	image.value = img
	default_maps.select(0)
