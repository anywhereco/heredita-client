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
		
	var rooms := await HTTP.request(Statics.HEREDITA_URL, "rooms")
	# TODO error check!!
	for room: Dictionary in rooms.val():
		add_child(RoomTemplate.of(
			self,
			room["id"] as String,
			room["name"] as String,
			room["description"] as String,
			room["player_count"] as int,
			room["player_limit"] as int
		))
	move_child(create, -1)
	loading_placeholder.hide()

func join_room(_id: String) -> void:
	pass
