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

#func _init() -> void:
#	$Sprite.texture = top_sprite

func _spawn() -> void:
	var mask_instance = mask_to_invok.instantiate()
	self.add_child(mask_instance)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_L:
			if $"..".has_fund_for_item("Wood", 2) :
				$"..".pay("Wood", 2)
				_spawn()
				print_debug("Vous avez payé 2 wood pour mettre au monde ce mask, mazel tof")
			else :
				print_debug("Il vous manque ", 2 - $"..".inventory["Wood"] , " wood pour vous acheter un esclave")
