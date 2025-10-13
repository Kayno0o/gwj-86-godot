class_name State extends Node

enum Type {
	Idle = 0,
	MoveToTarget = 1,
	Pickup = 2,
	Attack = 3,
	DepositItem = 4,
}

var parent: Entity
var type: Type

func init(p_parent: Entity) -> void:
	parent = p_parent

	assert(type != null, "%s must set type in init()" % get_script().resource_path)

func enter() -> void:
	pass

func exit() -> void:
	pass

func physics_process(_delta: float):
	return null

func process(_delta: float):
	return null
