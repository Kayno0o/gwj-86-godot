class_name MiniTotem extends Node2D

#region Enums
#endregion

#region var
#endregion

#region @export
@export var mask_to_invok: PackedScene
@export var top_sprite : Sprite2D
#endregion

#region @onready
#endregion

#region signal
#endregion

func _init() -> void:
	$Sprite.texture = top_sprite

func _spawn() -> void:
	var mask_instance = mask_to_invok.instantiate()
	self.add_child(mask_instance)
