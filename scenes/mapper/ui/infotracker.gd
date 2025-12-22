extends Label

@onready var mapper: MapperRoot = $"../../../../../.."

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	text = "\n"
	text += "fps: %s\n" % Engine.get_frames_per_second()
