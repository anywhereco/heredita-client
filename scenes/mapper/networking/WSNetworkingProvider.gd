@abstract 
extends NetworkingProvider

var client: InfernoSocketClient = InfernoSocketClient.new()

func initialize() -> void:
	pass

@abstract
func send_pixels(color: Color, pixels: Array[Vector2i]) -> void

func send_message(message: String) -> void:
	pass #locate server, send to server

@abstract
func get_server_settings() -> Variant

@abstract
func get_networking_type() -> NetworkingType
