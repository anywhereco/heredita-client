## A container of constants.
class_name Statics
extends Object

#const HEREDITA_URL := "http://localhost:9000"
static var HEREDITA_URL := "https://demo.heredita.net"

const SERVER_URL := "http://localhost:443"

const LOGIN_URL := "login.infernity.dev"

func _init() -> void:
	if OS.has_feature("beta-d"):
		HEREDITA_URL = "https://beta-drc.heredita.net"
	if OS.has_feature("beta-w"):
		HEREDITA_URL = "https://beta-wrc.heredita.net"
