extends Node

const PORT = 443

var _tcp_server: TCPServer = TCPServer.new()

var _peers: Dictionary[int, WebSocketPeer] = {}

var last_peer_id := 1

func _ready() -> void:
	var err := _tcp_server.listen(PORT)
	if err == OK:
		print("Server started.")
	else:
		push_error("Unable to start server.")
		set_process(false)

signal text_data(data: String)

signal binary_data(data: PackedByteArray)

signal closed(peer_id: int, code: int, reason: String)

func _process(_delta: float) -> void:
	while _tcp_server.is_connection_available():
		last_peer_id += 1
		print("+ Peer %d connected." % last_peer_id)
		var ws := WebSocketPeer.new()
		ws.accept_stream(_tcp_server.take_connection())
		_peers[last_peer_id] = ws

	# Iterate over all connected peers using "keys()" so we can erase in the loop
	for peer_id: int in _peers.keys():
		var peer := _peers[peer_id]

		peer.poll()

		var peer_state := peer.get_ready_state()
		if peer_state == WebSocketPeer.STATE_OPEN:
			while peer.get_available_packet_count():
				var packet := peer.get_packet()
				if peer.was_string_packet():
					var packet_text := packet.get_string_from_utf8()
					text_data.emit(packet_text)
				else:
					binary_data.emit(packet)
		elif peer_state == WebSocketPeer.STATE_CLOSED:
			# Remove the disconnected peer.
			_peers.erase(peer_id)
			var code := peer.get_close_code()
			var reason := peer.get_close_reason()
			closed.emit(peer_id, code, reason)
