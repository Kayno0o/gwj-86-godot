class_name HealthComponent extends Node

@export var health: float

signal death

## returns true if health <= 0
func on_damage(amount: float) -> bool:
	health -= amount

	if health <= 0:
		death.emit()

		return true

	return false
