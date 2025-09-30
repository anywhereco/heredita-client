extends Button

func _pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://scenes/mapper/mapper.tscn"))
