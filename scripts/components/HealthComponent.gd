class_name HealthComponent extends Component

var health: float

signal death

func _init(p_health: float) -> void:
	type = Component.Type.Health
	health = p_health

## returns true if health <= 0
func on_damage(amount: float) -> bool:
	health -= amount

	if health <= 0:
		death.emit()

		return true

	return false
