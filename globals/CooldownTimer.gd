extends RefCounted
class_name Cooldown

var default_value: float
var value: float

func _init(p_default_value: float) -> void:
	default_value = p_default_value

func start() -> void:
	value = default_value

func advance(delta: float) -> bool:
	value -= delta

	return is_end()

func is_end() -> bool:
	return value <= 0

func reset() -> void:
	value = default_value
