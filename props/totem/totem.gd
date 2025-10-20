class_name Totem extends Node2D


#region Enums
#endregion

#region var
var target_type: Enum.TargetType = Enum.TargetType.Totem;
var inventory: Dictionary = {}
#endregion

#region @export
@export var entities : Dictionary = Enum.EntityType
@export var health: float = 5.0
#endregion

#region @onready
@onready var health_component: HealthComponent = HealthComponent.new(func(): return health)
@onready var hero_totem = $Sprites/base/Sprite2D/base/Sprite2D/base/Sprite2D/base/Sprite2D/base/Sprite2D/base/Sprite2D/base/AnimatedSprite2D

@onready var components: Dictionary[Component.Type, Component] = {
	Component.Type.Health: health_component,
}
#endregion

#region signal
signal hero_switch
#endregion

#region init/ready/process
# Se donne une Target pour le target manager
func _ready() -> void:
	TargetManager.register_target(self, [target_type])
	InventoryManager.totem = self
	health_component.death.connect(_on_death)
#endregion

#region Fonctions
#endregion

func _on_death():
	# TODO totem death
	TargetManager.unregister_target(self, [target_type])
	queue_free()
	get_tree().change_scene_to_packed(preload("res://stages/main_menu/main_menu.tscn"))

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			var new_mask = (hero_totem.frame + 1) % 6
			hero_switch.emit(new_mask)
			hero_totem.frame = new_mask
			print_debug(new_mask)
			return

		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
			var new_mask = (6 + hero_totem.frame - 1) % 6
			hero_switch.emit(new_mask)
			hero_totem.frame = new_mask
			print_debug(new_mask)
