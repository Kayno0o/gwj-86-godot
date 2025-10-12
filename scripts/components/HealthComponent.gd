class_name HealthComponent extends Component

@export var health: float

signal death

func _init() -> void:
	type = Component.Type.Health

## returns true if health <= 0
func on_damage(amount: float) -> bool:
	health -= amount

	if health <= 0:
		death.emit()

		return true

	return false
