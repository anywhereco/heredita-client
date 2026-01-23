extends Node
class_name RoomServer

var room: Room = null

func _text_data(peer_id: int, data: String) -> void:
	pass

func _binary_data(peer_id: int, data: PackedByteArray) -> void:
	pass

func _closed(peer_id: int, code: int, reason: String) -> void:
	pass
