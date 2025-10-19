extends Node2D

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton :
		if event.button_mask == 1 :
			pass #faire apparaitre l'inventaire
