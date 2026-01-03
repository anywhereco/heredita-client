extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:
	var img: Image = Map._instance.get_map_as_image()
	if OS.has_feature("web"):
		var buffer := img.save_png_to_buffer()
		JavaScriptBridge.download_buffer(buffer, "saved_map.png", "image/png")
	else:
		img.save_png("saved_map.png")
