@abstract
extends Node
class_name Server

var rooms: Dictionary[int, Room]

@abstract
func get_requests() -> void #Receive requests and, if applicable, pass them to the right room

@abstract
func send_request() -> void
