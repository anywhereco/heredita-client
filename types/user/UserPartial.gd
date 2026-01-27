## Represents an API UserPartial.
extends Resource
class_name UserPartial

var id: int
var username: String

func _init(_id: int, _username: String) -> void:
	id = _id
	username = _username
