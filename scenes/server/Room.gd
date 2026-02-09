class_name Room

var name := "Unnamed Room"
var description := ""
var user_limit := 8
var password := ""

var map: Map

var users: ReactiveDictionary = ReactiveDictionary.new({})
var user_ids_chronological: Array[int] = []
var id_iterator := 0 #next id for use
var close_on_empty := true
var hosts: Array[int] = []

var banned_ips := []

func taken_usernames() -> Array[String]:
	var l: Array[String] = []
	for user_id: int in users.keys():
		if users.getv(user_id).logged_in:
			l.append(users.getv(user_id).username)
	return l

func user_info() -> Dictionary:
	var l := {}
	for user_id: int in users.keys():
		l[user_id] = {"username": users.getv(user_id).username,
					  "logged_in": users.getv(user_id).logged_in,
					  "profile": users.getv(user_id).profile}
	return l
