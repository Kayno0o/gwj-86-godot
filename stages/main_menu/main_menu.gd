extends Control



func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://stages/game/game.tscn"))


func _on_credits_pressed() -> void:
	for button in get_tree().get_nodes_in_group("main_button") :
		button.visible = false
	for ui in get_tree().get_nodes_in_group("credits_button") :
		ui.visible = true


func _on_quit_credits_pressed() -> void:
	for button in get_tree().get_nodes_in_group("main_button") :
		button.visible = true
	for ui in get_tree().get_nodes_in_group("credits_button") :
		ui.visible = false
