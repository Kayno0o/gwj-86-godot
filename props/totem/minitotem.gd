class_name MiniTotem extends Node2D

#region Enums
#endregion

#region var
var mask_name : String
#endregion

#region @export
@export var mask_to_invok: PackedScene
@export var top_sprite : Texture
@export var main_ressources = Enum.ItemType
@export var totem_type : Enum.EntityType
#endregion

#region @onready
#endregion

#region signal
#endregion

#func _init() -> void:
#	$Sprite.texture = top_sprite

func _ready() -> void:
	$Minitoteminteractable.get_node("totemheadsprite").texture = top_sprite
	var mask_instance = mask_to_invok.instantiate()
	mask_name = Enum.EntityType.find_key(mask_instance.type)
	
func spawn() -> void:
	var mask_instance = mask_to_invok.instantiate()
	self.add_child(mask_instance)
	mask_instance.global_position = get_parent().global_position
