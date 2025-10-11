extends StaticBody2D
class_name ResourceProps

@export var loot: Item
@export var health: float

var is_targeted: bool = false

func on_damage(damage: float):
	print("on_damage")
	health -= damage

	if health < 0:
		on_break()

func on_break():
	print("break")
	queue_free()
	return
