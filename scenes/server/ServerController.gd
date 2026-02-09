extends Node
class_name ServerController

var rooms: Dictionary[int, RoomServer]
var peer_rooms: Dictionary[int, int]
var ws_server := WSServer.new()

func _ready() -> void:
	add_child(ws_server)
	ws_server.text_data.connect(_text_data)
	ws_server.binary_data.connect(_binary_data)
	ws_server.connected.connect(_connected)
	ws_server.closed.connect(_closed)

func new_room_id() -> int:
	var id := randi()
	while id in rooms:
		id = randi()
	return id

func create_room(data: Dictionary = {}) -> int:
	var id := new_room_id()
	var room := Room.new()
	for key: String in data:
		if key == "name":
			room.name = data[key]
	var room_server := RoomServer.new()
	room_server.room = room
	rooms[id] = room_server
	add_child(room_server)
	return id
	
func close_room(id: int) -> void:
	rooms[id].close_room()
	rooms.erase(id)

func _room_find_id(room: RoomServer) -> int:
	return rooms.find_key(room)

func get_text_data(peer_id: int) -> String:
	var peer := 0x7fffffffffffffff
	var ret: Array
	while peer != peer_id:
		ret = await ws_server.text_data
		peer = ret[0]
	return ret[1]
	
func parse_json(text: String) -> Result:
	var json := JSON.new()
	var error := json.parse(text)
	if error != OK:
		return Result.err(error)
	return Result.ok(json.data)

func get_json_data(peer_id: int) -> Result:
	var data := await get_text_data(peer_id)
	return parse_json(data)

func _connected(peer_id: int) -> void:
	ws_server.send_targeted_event(peer_id, "_is2_handshake")
	var json := await get_json_data(peer_id)
	if ISUtil.valid_event(json, "_is2_room_info"):
		var rid := int(json.val()["details"])
		peer_rooms[peer_id] = rid
		var r := rooms[rid]
		r._connected(peer_id)
		return
	elif ISUtil.valid_event(json, "_is2_create_room"):
		var rid := create_room(json.val()["details"])
		peer_rooms[peer_id] = rid
		var r := rooms[rid]
		r._connected(peer_id)
		return
	ws_server.close(peer_id, 4096, "Protocol failure")

func _text_data(peer_id: int, data: String) -> void:
	if peer_id in peer_rooms:
		rooms[peer_rooms[peer_id]]._text_data(peer_id, data)
	else:
		var data_json := await parse_json(data)
		if not (ISUtil.valid_event(data_json, "_is2_room_info") or ISUtil.valid_event(data_json, "_is2_create_room")):
			ws_server.close(peer_id, 4096, "Protocol failure")

func _binary_data(peer_id: int, data: PackedByteArray) -> void:
	if peer_id in peer_rooms:
		rooms[peer_rooms[peer_id]]._binary_data(peer_id, data)
	else:
		ws_server.close(peer_id, 4096, "Protocol failure")

func _closed(peer_id: int, code: int, reason: String) -> void:
	if peer_id in peer_rooms:
		rooms[peer_rooms[peer_id]]._closed(peer_id, code, reason)
		peer_rooms.erase(peer_id)
