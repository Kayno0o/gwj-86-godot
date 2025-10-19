class_name HealthComponent extends Component

var damage: float = 0
var get_health: Callable
var parent: Node2D

signal death
signal on_damage(amount: float)

func _init(p_get_health: Callable) -> void:
	type = Component.Type.Health
	get_health = p_get_health

func reset():
	damage = 0.0

## returns true if health <= 0
func hit(amount: float) -> bool:
	damage += amount

	on_damage.emit(amount)

	if get_health.call() - damage <= 0:
		death.emit()

		return true

	return false
