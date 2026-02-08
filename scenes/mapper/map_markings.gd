extends Node3D

@onready var cities: MultiMeshInstance3D = $Cities
@onready var text_meshes: Node3D = $TextMeshes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cities.multimesh.instance_count = 8192
	#cities.multimesh.visible_instance_count = 256
	
	for i: int in cities.multimesh.visible_instance_count:
		cities.multimesh.set_instance_transform(i, Transform3D(Basis.IDENTITY, Vector3(randf_range(-1000, 1000), 0.01, randf_range(-1000, 1000))))
		cities.multimesh.set_instance_color(i, Color((randf()/10)+.5, (randf()/10)+.5, (randf()/10)+.5, 1))
	
func _process(_delta: float) -> void:
	pass
