class_name User

var peer_id: int
var username: String
var logged_in: bool
var profile := {}
var flags: int
var status: int

func _init(peer: int, dict: Dictionary) -> void:
	peer_id = peer
	username = dict.username
	logged_in = dict.logged_in
	flags = dict.get("flags", 0)
	status = dict.get("status", 0)
