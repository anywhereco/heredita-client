class_name Room

var name := ""
var description := ""
var user_limit := 8
var password := ""

var map: Map

var users: Dictionary[int, User]
var user_ids_chronological: Array[int]
var id_iterator := 0 #next id for use
var close_on_empty := true

var banned_ips := []

func taken_usernames() -> Array[String]:
	var l := []
	for user_id: int in users:
		if users[user_id].logged_in:
			l.append(users[user_id].username)
	return l

func user_info() -> Array:
	var l := []
	for user_id: int in users:
		l.append({"username": users[user_id].username,
				  "logged_in": users[user_id].logged_in,
				  "profile": users[user_id].profile})
	return l
