extends State

## Picking up state - entity picks up an item and immediately transitions back to idle
## This is a quick state that just handles the pickup logic

func enter() -> void:
	# Stop movement
	if entity:
		entity.velocity = Vector2.ZERO

	# Pick up the item immediately
	_pickup_item()

func exit() -> void:
	pass

func update(_delta: float) -> String:
	# Always transition back to idle after picking up
	return "IdleState"

func _pickup_item() -> void:
	if not entity.current_target or not is_instance_valid(entity.current_target):
		entity.current_target = null
		return

	# Make sure it's an item
	if not entity.current_target is Item:
		entity.current_target = null
		return

	# TODO: Add inventory logic here when implemented
	# For now, just destroy the item

	# Destroy the item
	entity.current_target.queue_free()
	entity.current_target = null
