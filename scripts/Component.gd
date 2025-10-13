class_name Component extends Node

enum Type {
	Health = 0,
	Loot = 1,
}

var type: Type

func _ready() -> void:
	assert(type != null, "%s must set type in _init() or _ready()" % get_script().resource_path)
