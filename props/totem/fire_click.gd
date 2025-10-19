extends Node2D

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton :
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			pass #faire apparaitre l'inventaire
