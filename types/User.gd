class_name User

var username: String
var logged_in: bool
var settings
var flags: int
var status: int

enum Format {
	NONE = 0,
	BOLD = 1,
	AUTHOR = 2
}

func _init(dict):
	username = dict.username
	logged_in = dict.logged_in
	flags = dict.get("flags", 0)
	status = dict.get("status", 0)
