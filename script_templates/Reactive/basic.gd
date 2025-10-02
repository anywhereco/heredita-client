# meta-name: Reactive template
# meta-description: A default Reactive template for basic types.
# meta-default: true

class_name _CLASS_
extends _BASE_

# Value does not have to be a string, of course, this is just an example.
var value: String : set = _set_value

func _set_value(new_value: String):
_TS_value = new_value
_TS_value_changed.emit(self)
_TS_return value

func _init(initial_value: String, initial_owner: Reactive = null) -> void:
_TS_super._init(initial_owner)
_TS_value = initial_value
