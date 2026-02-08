## Handles InfernoSocket v2 connections.
class_name InfernoSocketClient
extends Node

var return_handshake := {
	"infernosocket_version" = [2, 1],
	"software_version" = ProjectSettings.get_setting_with_override("application/config/version") 
}

var handshake_headers: PackedStringArray
var supported_protocols: PackedStringArray
var tls_options: TLSOptions = null
var websocket_url: String

var room_id: int

var ping_timer: float = 0

const PING_INTERVAL: float = 60

var socket := WebSocketPeer.new()
var last_state := WebSocketPeer.STATE_CLOSED
var user_id: int = -2 # -1 is reserved for the server, so we default to -2
var host := -2

var _prompt: PromptInstance
var _prompt_instance: Node
var _attempts := 5

var room: Room

signal connected_to_server()
signal connection_closed()

signal handshake_complete()

signal message_received(event: String, user_id: int, details: Variant)

signal binary_message_received(event: int, user_id: int, details: PackedByteArray)

## Same as [code]message_recieved[/code], but shows handshake events and is not parsed.
signal raw_message_received(string: String)

signal raw_message_sent(string: String)

func _init(url: String = "", _room: int = 0) -> void:
	websocket_url = url
	room_id = _room

func _ready() -> void:
	var err := self.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	

#region Encode and Decode
func _encode_data(value: Variant) -> String:
	return JSON.stringify(value)

func _decode_data(string: String) -> Result:
	var json := JSON.new()
	var error := json.parse(string)
	if error != OK:
		return Result.err(error)
	return Result.ok(json.data)
#endregion

func connect_to_url(url: String) -> int:
	socket.supported_protocols = supported_protocols
	socket.handshake_headers = handshake_headers

	var err := socket.connect_to_url(url, tls_options)
	if err != OK:
		return err

	last_state = socket.get_ready_state()
	return OK

func send(event: String, message: Variant = null) -> int:
	var data := _encode_data({
		"event": event,
		"details": message,
	})
	raw_message_sent.emit(data)
	return socket.send_text(data)

func send_binary(event: int, target: int, message: PackedByteArray = PackedByteArray(), compress: bool = true) -> int:
	assert(event >= 0 and event <= 65535, "The event value should fit within a 16-bit int")
	assert(target >= -32768 and target <= 32767, "The target value should fit within a 16-bit signed int")
	raw_message_sent.emit("<Binary event %d>" % event)
	var compression_size := 0xFFFF # Compression disabled
	if compress:
		compression_size = len(message)
		message = message.compress(FileAccess.COMPRESSION_FASTLZ)
	var bytes := PackedByteArray()
	bytes.resize(6)
	bytes.encode_u16(0, event)
	bytes.encode_s16(2, target)
	bytes.encode_u16(4, compression_size)
	bytes.append_array(message)
	return socket.send(bytes)
	
func get_message_raw() -> Variant:
	if socket.get_available_packet_count() < 1:
		return null
	var pkt := socket.get_packet()
	if socket.was_string_packet():
		return pkt.get_string_from_utf8()
	else:
		return pkt

func close(code: int = 1000, reason: String = "") -> void:
	socket.close(code, reason)
	last_state = socket.get_ready_state()

func clear() -> void:
	socket = WebSocketPeer.new()
	last_state = socket.get_ready_state()

func get_socket() -> WebSocketPeer:
	return socket

func int_keys(dict: Dictionary) -> Dictionary[int, Variant]:
	var new_dict: Dictionary[int, Variant] = {}
	for key: Variant in dict:
		new_dict[key as int] = dict[key]
	return new_dict

#region Polling
func poll() -> void:
	if socket.get_ready_state() != socket.STATE_CLOSED:
		socket.poll()

	var state := socket.get_ready_state()

	if last_state != state:
		last_state = state
		if state == socket.STATE_OPEN:
			connected_to_server.emit()
		elif state == socket.STATE_CLOSED:
			connection_closed.emit()
	while socket.get_ready_state() == socket.STATE_OPEN and socket.get_available_packet_count():
		_poll_loop()

func _poll_loop() -> void:
	var message_raw: Variant = get_message_raw()
	if message_raw is String:
		raw_message_received.emit(message_raw)
		var message_res := _decode_data(message_raw as String) # Godot, I promise you this String is a String. I swear.
		if message_res.is_err():
			return
		_poll_string(message_res.val() as Dictionary)
	else:
		if message_raw == null:
			return
		_poll_binary(message_raw as PackedByteArray)

func _poll_string(message: Dictionary) -> void:
	if message == null:
		return
	if message.has("event") and message.has("user_id"):
		message["user_id"] = message["user_id"] as int
		if message["user_id"] != -1:
			message_received.emit(message["event"], message["user_id"], message.get("details", null))
			return
		match message["event"]:
			"_is2_handshake":
				send("_is2_room_info", room_id)
				return
			"_is2_room_info":
				user_id = message.get("details").get("user_id") as int
				host = message.get("details").get("host")
				return
			"_is2_login":
				_prompt_instance = load("res://types/ui/PasswordPrompt.tscn").instantiate()
				(_prompt_instance.find_child("PasswordEdit") as LineEdit).text_submitted.connect(
					func password_attempt(pwd: String) -> void:
						send("_is2_password_attempt", pwd)
				)
				var _prompt_res := Prompts.new_fullscreen_prompt()
				if _prompt_res.is_err():
					close(1006, "Could not create login prompt, aborting")
				_prompt = _prompt.val()
				_prompt.add_child(_prompt_instance)
				return
			"_is2_login_valid_password":
				return
			"_is2_login_invalid_password":
				_attempts -= 1
				if _attempts == 0:
					_prompt.close()
					socket.close()
					return
				var attempts_label: Label = _prompt_instance.find_child("AttemptsLabel")
				attempts_label.show()
				attempts_label.text = "%d attempts remaining" % _attempts
				return
			"_is2_username":
				send("_is2_username", State.user.name)
				return
			"_is2_token":
				#var token_res: Variant = LocalStorage.get_item("token")
				#if token_res.is_err() or not State.user.is_account:
				#	send("_is2_token", "")
				#send("_is2_token", token_res.val())
				return
			"_is2_handshake_complete":
				room = Room.new()
				State.room = room
				room.name = message.get("details").get("name")
				room.description = message.get("details").get("description")
				room.users = ReactiveDictionary.new(message.get("details").get("users") as Dictionary)
				handshake_complete.emit()
				return
			"_is2_user_join":
				room.users.setv(message.get("details").get("user_id") as int, message.get("details").get("details"))
				message_received.emit("is2_user_join", -1, message.get("details"))
				return
			"_is2_user_exit":
				room.users.erase(message.get("details"))
				message_received.emit("is2_user_exit", -1, message.get("details"))
				return
			"_is2_new_host":
				host = message.get("details")
				message_received.emit("is2_new_host", -1, message.get("details"))
				return
			"_is2_pong":
				return
			_:
				message_received.emit(message["event"], message["user_id"], message.get("details", null))

func _poll_binary(message: PackedByteArray) -> void:
	var event := message.decode_u16(0)
	var uid := message.decode_s16(2)
	var size := message.decode_u16(4)
	var data := message.slice(6)
	raw_message_received.emit("<Binary event %d, \"userid\"=%d>" % [event, uid])
	if size != 0xFFFF:
		data = data.decompress(size, FileAccess.COMPRESSION_FASTLZ)
	binary_message_received.emit(event, uid, data)

func _process(delta: float) -> void:
	poll()
	ping_timer += delta
	if ping_timer > PING_INTERVAL and socket.get_ready_state() != socket.STATE_CLOSED:
		send("_is2_ping")
		ping_timer -= PING_INTERVAL
#endregion
