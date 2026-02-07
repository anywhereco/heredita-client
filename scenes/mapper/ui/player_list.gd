extends HFlowContainer

var singleplayer := true

func _ready() -> void:
	if State.room:
		State.room.users.value_changed.connect(refresh_players)
		
func refresh_players(users: ReactiveDictionary) -> void:
	if singleplayer:
		singleplayer = false
		for player: User in users.value:
			var player_node := preload("res://scenes/mapper/ui/player.tscn").instantiate()
			player_node.text = player.username
