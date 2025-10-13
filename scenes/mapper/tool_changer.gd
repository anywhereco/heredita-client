extends HBoxContainer

@onready var mapper: MapperRoot = $"../../../../.."

func _ready() -> void:
	connect_buttons_recursively(self)

func connect_buttons_recursively(node: Node) -> void:
	for child in node.get_children():
		if child is Button:
			child.pressed.connect(_on_button_pressed.bind(child.name))
		else:
			connect_buttons_recursively(child)

func _on_button_pressed(button_name: String) -> void:
	mapper.tool.value = MapperRoot.Tool.get(button_name.to_upper())
	print(mapper.tool.value)
