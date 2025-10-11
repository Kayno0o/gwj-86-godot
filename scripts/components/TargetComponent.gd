class_name TargetComponent extends Node

var is_targeted: bool = false
var targetter: Node

func get_is_targeted() -> bool:
	return is_targeted and targetter and is_instance_valid(targetter)

func can_target() -> bool:
	if get_is_targeted():
		return false

	return true

## returns true if target was changed
func target(p_targetter: Node) -> bool:
	if get_is_targeted():
		return false

	targetter = p_targetter
	is_targeted = true

	return true

## returns true if stopped targetting
func stop_targetting() -> bool:
	if not get_is_targeted():
		return false

	targetter = null
	is_targeted = false

	return true
