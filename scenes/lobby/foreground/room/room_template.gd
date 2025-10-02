class_name RoomTemplate
extends PanelContainer

signal _readied

const ROOM_TEMPLATE = preload("uid://cfjumnaqf88s3")

var handler: RoomHandler

@export var lobby_id: String

@onready var join: Button = %Join
@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var player_count: Label = %PlayerCount

@warning_ignore("shadowed_variable") # This is static, so shadowing doesn't matter
static func of(handler: RoomHandler,
			   lobby_id: String,
			   title: String,
			   desc: String,
			   players: int,
			   max_players: int) -> RoomTemplate:
	var inst: RoomTemplate = ROOM_TEMPLATE.instantiate()
	inst._readied.connect(func():
		inst.handler = handler
		inst.lobby_id = lobby_id
		inst.title.text = title
		inst.description.text = desc
		inst.player_count.text = "%d/%d" % [players, max_players]
	)
	return inst

func _ready() -> void:
	_readied.emit()
	join.pressed.connect(handler.join_room.bind(lobby_id))
