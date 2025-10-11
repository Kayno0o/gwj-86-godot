extends Node2D
class_name ResourceNode

@export var loot: Item
var health: int

func on_damage(damage: int):
	print("on_damage")
	health -= damage

	if health < 0:
		on_break()

func on_break():
	print("break")
	queue_free()
	return
