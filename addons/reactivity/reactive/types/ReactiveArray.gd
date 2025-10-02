class_name ReactiveArray
extends Reactive

var value: Array : set = _set_value

func _set_value(new_value: Array):
	value = new_value
	value_changed.emit(self)
	return value

func _init(initial_value: Array, initial_owner: Reactive = null) -> void:
	super._init(initial_owner)
	value = initial_value


func get_at(i : int) -> Variant:
	return value[i]

func set_at(i : int, v : Variant) -> void:
	value[i] = v
	value_changed.emit(self)

func append(v : Variant) -> void:
	value.append(v)
	value_changed.emit(self)
	

func append_array(array : Array) -> void:
	value.append_array(array)
	value_changed.emit(self)

func assign(array : Array) -> void:
	value.assign(array)
	value_changed.emit(self)

func clear() -> void:
	value.clear()
	value_changed.emit(self)

func erase(v : Variant) -> void:
	value.erase(v)
	value_changed.emit(self)

func insert(position : int, v : Variant) -> void:
	value.insert(position, v)
	value_changed.emit(self)

func pop_at(index : int) -> Variant:
	var tmp = value.pop_at(index)
	value_changed.emit(self)
	return tmp

func pop_back() -> Variant:
	var tmp = value.pop_back()
	value_changed.emit(self)
	return tmp

func pop_front() -> Variant:
	var tmp = value.pop_front()
	value_changed.emit(self)
	return tmp

func remove_at(index : int) -> void:
	value.remove_at(index)
	value_changed.emit(self)

func shuffle() -> void:
	value.shuffle()
	value_changed.emit(self)

func sort() -> void:
	value.sort()
	value_changed.emit(self)

func sort_custom(callable : Callable) -> void:
	value.sort_custom(callable)
	value_changed.emit(self)
