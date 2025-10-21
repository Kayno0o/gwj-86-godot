extends CanvasLayer

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("interactable") :
		node.visible = false


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://stages/main_menu/main_menu.tscn")


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
