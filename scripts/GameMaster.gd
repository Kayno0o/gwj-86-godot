extends Node

signal end_day()
signal end_night()
signal spawn_enemy()

@export var day_lenght = 5.0
@export var difficulty : int = 1

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_D:
			end_day.emit()
		if event.pressed and event.keycode == KEY_N:
			end_night.emit()
		if event.pressed and event.keycode == KEY_C:
			spawn_enemy.emit()



func _on_day_night_cycler_midday() -> void:
	var spawner = preload("res://stages/main/spawner.tscn").instantiate()
	add_child(spawner)


func _on_day_night_cycler_midnight() -> void:
	pass # Replace with function body.
