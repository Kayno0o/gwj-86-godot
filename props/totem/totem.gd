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

@onready var components: Dictionary[Component.Type, Component] = {
	Component.Type.Health: health_component,
}
#endregion

#region signal
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
