## A container of constants.
class_name Statics
extends Object

#const HEREDITA_URL := "http://localhost:9000"
static var HEREDITA_URL := "https://demo.heredita.net"
static var SERVER_URL := "wss://demo.heredita.net:443"

# const LOGIN_URL := "login.infernity.dev"

static func initialize() -> void:
	var user_args := OS.get_cmdline_user_args()
	for i in range(user_args.size()):
		if user_args[i].contains("--heredita-url="):
			HEREDITA_URL = user_args[i].split("=")[1]
			SERVER_URL = "ws" + HEREDITA_URL.right(-4)
