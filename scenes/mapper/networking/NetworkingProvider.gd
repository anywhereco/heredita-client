@abstract 
extends Node
class_name NetworkingProvider

enum NetworkingType {
	LOCAL,
	NETWORKED
}

@warning_ignore("unused_signal")
signal message_recieved(from: int, message: String)

@warning_ignore("unused_signal")
signal pixels_recieved(from: int, color: Color, pixels: Array[Vector2i])

@warning_ignore("unused_signal")
signal player_moved(from: int, location: Vector3)

@abstract
func send_pixels(color: Color, pixels: Array[Vector2i]) -> void

@abstract
func send_message(message: String) -> void

@abstract
func move_player(to: Vector3) -> void

@abstract
func get_locked_colors() -> Array[Color]

@abstract
func get_networking_type() -> NetworkingType
