extends Node
class_name ServerController

var rooms: Dictionary[int, RoomServer]
var peer_rooms: Dictionary[int, int]
var ws_server := WSServer.new()

func _ready() -> void:
	ws_server.text_data.connect(_text_data)
	ws_server.binary_data.connect(_binary_data)
	ws_server.closed.connect(_closed)

func new_room_id() -> int:
	var id := randi()
	while id in rooms:
		id = randi()
	return id

func create_room() -> int:
	var id := new_room_id()
	rooms[id] = RoomServer.new()
	add_child(rooms[id])
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

func get_json_data(peer_id: int) -> Result:
	var data := await get_text_data(peer_id)
	var json := JSON.new()
	var error := json.parse(data)
	if error != OK:
		return Result.err(error)
	return Result.ok(json.data)

func _connected(peer_id: int) -> void:
	ws_server.send_text(peer_id, "_is2_handshake")
	var json := await get_json_data(peer_id)
	if json.is_err() or not ISUtil.json_event(json.val()) or json.val()["details"] != "_is2_room_info":
		ws_server.close(peer_id, 4096, "Protocol failure")
		return
	var rid: int = int(json.val()["details"])
	peer_rooms[peer_id] = rid
	var r := rooms[rid]
	r._connected(peer_id)

func _text_data(peer_id: int, data: String) -> void:
	if peer_id in peer_rooms:
		rooms[peer_rooms[peer_id]]._text_data(peer_id, data)
	else:
		push_error("stop. you are violating the law (peer %d d=%s)" % [peer_id, data])

func _binary_data(peer_id: int, data: PackedByteArray) -> void:
	if peer_id in peer_rooms:
		rooms[peer_rooms[peer_id]]._binary_data(peer_id, data)
	else:
		push_error("stop. you are violating the law (peer %d)" % peer_id)

func _closed(peer_id: int, code: int, reason: String) -> void:
	if peer_id in peer_rooms:
		rooms[peer_rooms[peer_id]]._closed(peer_id, code, reason)
		peer_rooms.erase(peer_id)
	else:
		push_error("stop. you are violating the law (peer %d c=%d r=%s)" % [peer_id, code, reason])
