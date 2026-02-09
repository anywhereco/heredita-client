extends HFlowContainer

var singleplayer := true

func _ready() -> void:
	if State.room:
		State.room.users.value_changed.connect(refresh_players)
	refresh_players(State.room.users)

func add_player(player_id: int) -> void:
	var player_node := preload("res://scenes/mapper/ui/player.tscn").instantiate()
	player_node.text = State.room.users.getv(player_id)['username']
	add_child(player_node)
		
func refresh_players(users: ReactiveDictionary) -> void:
	if singleplayer:
		singleplayer = false
		get_child(0).hide()
		for player: int in users.keys():
			add_player(player)
