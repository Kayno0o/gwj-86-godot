class_name HealthComponent extends Component

var damage: float = 0
var get_health: Callable

signal death
signal on_damage(amount: float)

func _init(p_health: Callable) -> void:
	type = Component.Type.Health
	get_health = p_health

## returns true if health <= 0
func hit(amount: float) -> bool:
	damage += amount

	on_damage.emit(amount)

	if get_health.call() - damage <= 0:
		death.emit()

		return true

	return false
