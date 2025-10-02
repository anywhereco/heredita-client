extends Resource
class_name UserAccount

# TODO: Complete. The idea for this is it represents the current user [i.e. if they're logged in, their username, stuff like that].

static func of_token(token: String) -> UserAccount:
	return UserAccount.new()

func _init() -> void:
	pass
