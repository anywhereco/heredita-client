extends Button

func enter_mapper() -> void:
	const MAPPER_3D = preload("uid://bmfinmmve5h47")
	var mapper: MapperRoot = MAPPER_3D.instantiate()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(mapper)
	get_tree().current_scene = mapper

func _pressed() -> void:
	State.client = InfernoSocketClient.new(Statics.HEREDITA_URL, 0)
	
