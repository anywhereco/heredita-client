extends TabContainer

func make_slider(setting_data: Dictionary, percent := false, log10 := false) -> Control:
	var node: Control = preload("res://scenes/_settings/slider.tscn").instantiate()
	var slider: Control = node.find_child("Slider")
	if log:
		slider.min_value = Math.log10(setting_data.min)
		slider.max_value = Math.log10(setting_data.max)
		slider.value = Math.log10(setting_data.default)
	else:
		slider.min_value = setting_data.min
		slider.max_value = setting_data.max
		slider.value = setting_data.default
	slider.step = (slider.max_value - slider.min_value)/50.0
	node.percent = percent
	node.log10 = log10
	return node

func tab_add_setting(tab: Container, setting: String) -> void:
	var setting_data := Settings.settings_data[setting]
	var setting_node: Control
	match setting_data.type:
		Settings.STYPE.FLOAT:
			setting_node = make_slider(setting_data, false, false)
		Settings.STYPE.PERCENT:
			setting_node = make_slider(setting_data, true, false)
		Settings.STYPE.LOGPERCENT:
			setting_node = make_slider(setting_data, true, true)
	setting_node.setting = Settings.get_reactive(setting)
	var setting_label: Label = preload("res://scenes/_settings/setting_label.tscn").instantiate()
	setting_label.text = setting_data.label
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
