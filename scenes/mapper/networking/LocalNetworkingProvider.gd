@abstract 
extends NetworkingProvider

var server: LocalServer = LocalServer.new()

@abstract
func send_pixels(color: Color, pixels: Array[Vector2i]) -> void

func send_message(message: String) -> void:
	pass #locate server, send to server

@abstract
func get_locked_colors() -> Array[Color]

@abstract
func get_networking_type() -> NetworkingType
