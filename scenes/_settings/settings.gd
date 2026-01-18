extends TabContainer

func make_slider(setting_data: Dictionary, percent := false, log := false) -> Control:
	var node: Control = preload("res://scenes/_settings/slider.tscn").instantiate()
	var slider: Control = node.find_child("Slider")
	slider.min_value = setting_data.min
	slider.max_value = setting_data.max
	slider.value = setting_data.default
	return node

func tab_add_setting(tab: Container, setting: String) -> void:
	var setting_data := Settings.settings_data[setting]
	var setting_node: Control
	match setting_data.type:
		Settings.STYPE.FLOAT, Settings.STYPE.PERCENT, Settings.STYPE.LOGPERCENT:
			setting_node = preload("res://scenes/_settings/slider.tscn").instantiate()
			setting_node.min_value = setting_data.min
			setting_node.max_value = setting_data.max
			setting_node.value = setting_data.default
	var setting_label: Label = preload("res://scenes/_settings/setting_label.tscn").instantiate()
	setting_label.text = setting_data.type
	tab.add_child(setting_label)
	tab.add_child(setting_node)

func _ready() -> void:
	for tab in Settings.settings_tabs:
		var tab_node := GridContainer.new()
		tab_node.columns = 2
		tab_node.name = tab
		for setting: String in Settings.settings_tabs[tab]:
			tab_add_setting(tab_node, setting)
		add_child(tab_node)
