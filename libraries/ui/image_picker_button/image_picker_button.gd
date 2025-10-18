class_name ImagePickerButton
extends Button

const _CONTAINER = preload("uid://b1070265sjc22")
const DEFAULT_IMAGE = preload("uid://xo4ohmgui0xg")

var error_tween: Tween

var NO_SVG_NO_MAP_FILTER := PackedStringArray(["*.png,*.jpg,*.jpeg,*.webp,*.bmp;Image Files;image/png,image/jpeg,image/webp,image/bmp"])
var SVG_NO_MAP_FILTER := PackedStringArray(["*.png,*.jpg,*.jpeg,*.svg,*.webp,*.bmp;Image Files;image/png,image/jpeg,image/svg+xml,image/webp,image/bmp"])
var NO_SVG_MAP_FILTER := PackedStringArray(["*.png,*.jpg,*.jpeg,*.webp,*.bmp,*.mp;Image and Map Files;image/png,image/jpeg,image/webp,image/bmp,application/mpmap-map"])
var SVG_MAP_FILTER := PackedStringArray(["*.png,*.jpg,*.jpeg,*.svg,*.webp,*.bmp,*.mp;Image and Map Files;image/png,image/jpeg,image/svg+xml,image/webp,image/bmp,application/mpmap-map"])

var image := ReactiveImage.new(null)

## Potential extra data along with the image.
var extra_data: Variant = null

@onready var content: MarginContainer = _CONTAINER.instantiate()
@onready var web_file_dialog := HTML5FileDialog.new()
@onready var file_dialog: FileDialog = FileDialog.new()
@onready var error: Label = content.find_child("Error")
@onready var filename: Label = content.find_child("Filename")
@onready var image_rect: TextureRect = content.find_child("Image")

## If SVGs should be allowed or not.
@export var allow_svgs := false
## If maps [.mp] should be allowed or not.
@export var allow_maps := false

var is_web := OS.get_name() == 'Web'

var prev_content_size: Vector2

enum PickedImageError {
	OK,
	UNKNOWN,
	SVG_NOT_ACCEPTED,
	MP_NOT_ACCEPTED,
	NOT_VALID_FILE_FORMAT
}

#region Private methods
func _new_image(fname: String) -> void:
	if not content.visible:
		content.show()
	image_rect.texture = ImageTexture.create_from_image(image.value)
	filename.text = fname

func _ready() -> void:
	add_child(content)
	prev_content_size = content.size
	web_file_dialog.file_mode = HTML5FileDialog.FileMode.OPEN_FILE
	web_file_dialog.filters = PackedStringArray(["image/*"])
	web_file_dialog.file_selected.connect(_on_file_selected_html5)
	add_child(web_file_dialog, false, INTERNAL_MODE_BACK)
	file_dialog.use_native_dialog = true
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_selected.connect(_on_file_selected)
	add_child(file_dialog, false, INTERNAL_MODE_BACK)
	content.show()
	filename.text = text
	text = ""

func _process(_delta: float) -> void:
	if not content:
		return
	_state_drawer()
	if content.size == prev_content_size:
		return
	prev_content_size = content.size
	custom_minimum_size = prev_content_size

func _pressed() -> void:
	if is_web:
		web_file_dialog.show()
	else:
		if allow_svgs:
			if allow_maps:
				file_dialog.filters = SVG_MAP_FILTER
			else:
				file_dialog.filters = SVG_NO_MAP_FILTER
		else:
			if allow_maps:
				file_dialog.filters = NO_SVG_MAP_FILTER
			else:
				file_dialog.filters = NO_SVG_NO_MAP_FILTER
		file_dialog.popup_centered(file_dialog.min_size)

func _err(code: PickedImageError) -> void:
	if code == 0: 
		return
	var msg := "File not accepted."
	match code:
		PickedImageError.SVG_NOT_ACCEPTED:
			msg = "SVGs aren't allowed here."
		PickedImageError.NOT_VALID_FILE_FORMAT:
			msg = "Invalid file format."
	error.text = msg
	if error_tween:
		error_tween.kill()
	error_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	error.show()
	error.modulate = Color(1,1,1,1)
	error_tween.tween_property(error, "modulate", Color(1,1,1,0), 1)
	error_tween.tween_callback(error.hide)

func _on_file_selected_html5(file: HTML5FileHandle) -> void:
	var res := await _file_handle_to_image(file)
	if res.is_err():
		_err(res.err_code() as int)
		return
	image.value = res.val()
	_new_image(file.filename as String) # If the filename is not a string i will Literally die

func _on_file_selected(path: String) -> void:
	if path.rsplit(".", false, 1)[1] == "svg":
		_err(PickedImageError.SVG_NOT_ACCEPTED)
		return
	var img: Image = Image.load_from_file(path)
	print(img)
	if img == null:
		_err(PickedImageError.NOT_VALID_FILE_FORMAT)
		return
	image.value = img
	_new_image(path.get_file())

func _file_handle_to_image(file: HTML5FileHandle) -> Result:
	var fmt := file.name.rsplit(".", false, 1)[1]
	var buf := await file.as_buffer()
	var _image := Image.new()
	match fmt:
		"png":
			_image.load_png_from_buffer(buf)
		"bmp":
			_image.load_bmp_from_buffer(buf)
		"jpg", "jpeg":
			_image.load_jpg_from_buffer(buf)
		"tga":
			_image.load_tga_from_buffer(buf)
		"svg":
			if allow_svgs:
				_image.load_svg_from_buffer(buf)
			else:
				return Result.err(PickedImageError.SVG_NOT_ACCEPTED)
		"webp":
			_image.load_webp_from_buffer(buf)
	if _image.is_empty():
		return Result.err(PickedImageError.NOT_VALID_FILE_FORMAT)
	return Result.ok(_image)

func _state_drawer() -> void:
	var state := get_draw_mode()
	var modulus := Color(1,1,1,1)
	match state:
		DrawMode.DRAW_NORMAL:
			modulus = get_theme_color("font_color")
		DrawMode.DRAW_PRESSED:
			modulus = get_theme_color("font_pressed_color")
		DrawMode.DRAW_HOVER:
			modulus = get_theme_color("font_hover_color")
		DrawMode.DRAW_DISABLED:
			modulus = get_theme_color("font_disabled_color")
		DrawMode.DRAW_HOVER_PRESSED:
			modulus = get_theme_color("font_hover_pressed_color")
		_:
			assert(false, "all draw modes should have been accounted for, but drawmode %d was not!" % state)
	content.modulate = modulus

#endregion
#region Public methods

func reset() -> void: # TODO allow resetting of the image
	image.value = null
	image_rect.texture = DEFAULT_IMAGE
	
#endregion
