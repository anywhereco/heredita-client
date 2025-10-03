extends Node

var _localStorage := JavaScriptBridge.get_interface("localStorage") if OS.has_feature("web") else null
var _tempStorage := {}
const _save_path = "user://token_DO_NOT_SHARE.save" # Technically doesn't just store the token but I think that
													# this is better since it conveys more danger
 
enum LocalStorageResult {
	SUCCESSFUL,
	KEY_DOESNT_EXIST,
}

func _init() -> void: # We use _init to load stuff *first* before any ready calls occur
	if not OS.has_feature("web"):
		_load_data()

func _notification(notif: int) -> void:
	if notif == NOTIFICATION_APPLICATION_PAUSED: # Mobile exclusive
		_save_data() # The app could be killed without warning so we save the data in advance
	if notif == NOTIFICATION_WM_CLOSE_REQUEST:
		if not OS.has_feature("web"): # Save data if not on web
			_save_data()
		get_tree().quit()

func _save_data() -> void: 
	var file := FileAccess.open(_save_path, FileAccess.WRITE)
	file.store_var(_tempStorage)

func _load_data() -> void:
	if FileAccess.file_exists(_save_path):
		var file := FileAccess.open(_save_path, FileAccess.READ)
		var storage: Variant = file.get_var()
		if storage != null:
			_tempStorage = storage

func set_item(key: String, value: String) -> LocalStorageResult:
	if not OS.has_feature("web"): 
		_tempStorage.set(key, value)
		return LocalStorageResult.SUCCESSFUL
	else: _localStorage.setItem(key, value)
	return LocalStorageResult.SUCCESSFUL

func get_item(key: String) -> Result:
	var item: Variant
	if not OS.has_feature("web"):
		item = _tempStorage.get(key)
	else:
		item = _localStorage.getItem(key)
	if item != null:
		return Result.ok(item)
	return Result.err(LocalStorageResult.KEY_DOESNT_EXIST)

func get_item_or_fallback(key: String, fallback: Variant = null) -> Variant:
	var item: Variant
	if not OS.has_feature("web"):
		item = _tempStorage.get(key)
	else:
		item = _localStorage.getItem(key)
	if item != null:
		return item
	return fallback

func remove_item(key: String) -> LocalStorageResult:
	if not OS.has_feature("web"):
		_tempStorage.erase(key)
		return LocalStorageResult.SUCCESSFUL
	else: _localStorage.removeItem(key)
	return LocalStorageResult.SUCCESSFUL
	
