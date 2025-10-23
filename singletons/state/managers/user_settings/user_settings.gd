class_name UserSettingsManager
extends Node

var persistent: bool = OS.is_userfs_persistent()

func _ready() -> void:
	if OS.has_feature("web"):
		var window := JavaScriptBridge.get_interface("window")
		var callback := JavaScriptBridge.create_callback(_save_js)
		window.onbeforeunload = callback # CRITICAL: why does this not fucking run???

func _notification(what: int) -> void:
	print(what)
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
		save()
	var file := FileAccess.open("user://testa.txt", FileAccess.WRITE)
	file.store_string(str(randi()))

func _save_js(js_args: Array) -> bool:
	print(js_args)
	js_args[0].preventDefault()
	save()
	return true

func save() -> void:
	print("saving info...")
	var file := FileAccess.open("user://testb.txt", FileAccess.WRITE)
	file.store_string(str(randi()))
