class_name RoomHandler 
extends VBoxContainer

@onready var loading_placeholder: CenterContainer = $LoadingPlaceholder
@onready var create: HBoxContainer = $Create

func _ready() -> void:
	_load_rooms()

func _process(_delta: float) -> void:
	pass


func _load_rooms() -> void:
	loading_placeholder.show()
	
	var children := get_children()
	for i in range(1, children.size() - 1): # Exclude the first since that's a loading indicator, and the last since that's the creation buttons
		var child_to_delete := children[i]
		child_to_delete.queue_free()
		
	var rooms := await HTTP.request(Statics.MPMAP_URL, "rooms")
	for room: Dictionary in rooms.val():
		print(room)
		pass
		add_child(RoomTemplate.of(
			self,
			room["id"],
			room["name"],
			room["description"],
			room["player_count"],
			room["player_limit"]
		))
	move_child(create, -1)
	loading_placeholder.hide()

func join_room(_id: String) -> void:
	pass
