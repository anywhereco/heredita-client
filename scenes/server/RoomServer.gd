extends Node
class_name RoomServer

var room: Room = null
@onready var server_controller: ServerController = get_parent()
@onready var ws_server: WSServer = get_parent().ws_server

func get_text_data(peer_id: int) -> String:
	var peer := 0x7fffffffffffffff
	var ret: Array
	while peer != peer_id:
		ret = await ws_server.text_data
		peer = ret[0]
	return ret[1]

func get_json_data(peer_id: int) -> Result:
	var data := await get_text_data(peer_id)
	var json := JSON.new()
	var error := json.parse(data)
	if error != OK:
		return Result.err(error)
	return Result.ok(json.data)

func peer_close(peer_id: int, code := 1000, reason := "") -> void:
	ws_server.close(peer_id, code, reason)
	server_controller.peer_rooms.erase(peer_id)
	if room.close_on_empty and not room.users:
		server_controller.close_room(server_controller._room_find_id(self))

func send_event(event: String, details: Dictionary, origin_id := -1) -> Error:
	for user_id: int in room.users:
		var peer_id: int = room.users.getv(user_id).peer_id
		var error := ws_server.send_text(peer_id, JSON.stringify({"event": event, "user_id": origin_id, "details": details}))
		if error:
			return error
	return OK

func close_room() -> void:
	for user_id in room.users:
		ws_server.close(room.users[user_id].peer_id)

func _connected(peer_id: int) -> void:
	if len(room.users) >= room.user_limit:
		ws_server.close(peer_id, 6144, "The room is at maximum capacity.")
		return
	if ws_server.peer_ip(peer_id) in room.banned_ips:
		ws_server.close(peer_id, 6145, "You are banned from this room.")
		return
	var user_id := room.id_iterator
	room.id_iterator += 1
	while room.id_iterator in room.users.keys():
		room.id_iterator += 1

	ws_server.send_targeted_event(peer_id, "_is2_room_info", {"user_id": user_id})
	if room.password:
		ws_server.send_targeted_event(peer_id, "_is2_login")
		var attempts := 1
		while attempts <= 5:
			var password_json := await get_json_data(peer_id)
			if not ISUtil.valid_event(password_json, "_is2_password_attempt"):
				ws_server.close(peer_id, 4096, "Protocol failure")
				return
			if password_json["details"] == room.password:
				ws_server.send_targeted_event(peer_id, "_is2_login_valid_password")
				break
			ws_server.send_targeted_event(peer_id, "_is2_login_invalid_password", 5-attempts)
			attempts += 1
		if attempts > 5:
			ws_server.close(peer_id, 4097, "Too many password attempts")
			return
	
	ws_server.send_targeted_event(peer_id, "_is2_username")
	var username_json := await get_json_data(peer_id)
	var user: User
	if not ISUtil.valid_event(username_json, "_is2_username"):
		ws_server.close(peer_id, 4096, "Protocol failure")
		return
	else:
		user = User.new(peer_id, {username=username_json["details"], logged_in=false})
	
	if len(user.username) < 3 or len(user.username) > 20:
		ws_server.close(peer_id, 4099, "Invalid username")
		return
		
	if user.username in room.taken_usernames():
		ws_server.close(peer_id, 4100, "Username in use")
		return
		
	#token stuff
	
	send_event("_is2_user_join", {"user_id": user_id, "details": {"username": user.username, "logged_in": user.logged_in, "profile": user.profile}})
	room.users.setv(user_id, user)
	ws_server.send_targeted_event(peer_id, "_is2_handshake_complete", {"name": room.name, "description": room.description, "users": room.user_info()})
	room.user_ids_chronological.append(user_id)

func _closed(peer_id: int, code: int, reason: String) -> void:
	pass

func _text_data(peer_id: int, data: String) -> void:
	pass

func _binary_data(peer_id: int, data: PackedByteArray) -> void:
	pass
