class_name ResourceProps extends Node2D

enum TweenType { DAMAGE, USER_CLICK }

@export var target_types: Array[Enum.TargetType]
@export var health: float

@export_category("Loot")
@export var loot_scene: PackedScene
@export var loot_amount: int
@export var spawn_spread: float = 16.0

@onready var health_component: HealthComponent = HealthComponent.new(func(): return health)
@onready var loot_component: LootComponent = LootComponent.new(loot_scene, loot_amount, spawn_spread)
@onready var area: Area2D = $Area2D

var tweens: Dictionary[TweenType, Tween] = {}
var original_rotation: float = 0.0

@onready var components = {
	Component.Type.Health: health_component,
	Component.Type.Loot: loot_component,
}

func _ready() -> void:
	original_rotation = rotation_degrees

	health_component.death.connect(_on_death)
	health_component.on_damage.connect(_on_damage)

	area.input_event.connect(_on_area_input_event)

	TargetManager.register_target(self, target_types)

func reset_tween(type: TweenType, force = false) -> bool:
	if tweens.has(type) and tweens[type].is_running():
		if not force: return false

		tweens[type].pause()
		tweens[type].custom_step(999)
		tweens.erase(type)
	
	return true

func _on_damage(_damage: float):
	if not reset_tween(TweenType.DAMAGE, true): return

	tweens[TweenType.DAMAGE] = get_tree().create_tween()
	tweens[TweenType.DAMAGE].tween_property(self, "rotation_degrees", original_rotation+6, 0.5) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	tweens[TweenType.DAMAGE].tween_property(self, "rotation_degrees", original_rotation-6, 0.5) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

func _on_death():
	TargetManager.unregister_target(self, target_types)

	if loot_component.spawn_loot(global_position, get_parent()):
		queue_free()

func _on_click():
	if not reset_tween(TweenType.USER_CLICK): return

	$AudioStreamPlayer.play() # play a random sound
	if $Sprite2D/particlesanchor :
		$Sprite2D/particlesanchor/CPUParticles2D.emitting = true
	tweens[TweenType.USER_CLICK] = get_tree().create_tween()
	tweens[TweenType.USER_CLICK].tween_property(self, "rotation_degrees", original_rotation+2, 0.1) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	tweens[TweenType.USER_CLICK].tween_property(self, "rotation_degrees", original_rotation-2, 0.1) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_on_click()
