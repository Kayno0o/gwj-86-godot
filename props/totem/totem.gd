class_name Totem extends Node2D

#region Enums
#endregion

#region var
var target_type: Enum.TargetType = Enum.TargetType.Totem;
var inventory: Dictionary = {}
@export var entities : Dictionary = Enum.EntityType
#endregion

#region @export
#endregion

#region @onready
#endregion

#region signal
#endregion

#region init/ready/process
# Se donne une Target pour le target manager
func _ready() -> void:
	TargetManager.register_target(self, [target_type])
#endregion

#region Fonctions
#endregion
