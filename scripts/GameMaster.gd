extends Node

signal end_night()
signal spawn_enemy()
signal kill_villain()

@export var day_lenght = 5.0
@export var difficulty : int = 1

@onready var is_midnight : bool = false

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_D:
			spawn_enemy.emit()
		if event.pressed and event.keycode == KEY_W:
			kill_villain.emit()



func _on_day_night_cycler_midday() -> void:
	var spawner = preload("res://stages/main/spawner.tscn").instantiate()
	add_child(spawner)
	self.get_child(0).spawner_ded.connect(_spawner_is_ded)
	spawn_enemy.emit()


func _on_day_night_cycler_midnight() -> void:
	is_midnight = true
	if self.get_child_count() == 0 :
		is_midnight = false
		end_night.emit()
	pass # Replace with function body.

func _spawner_is_ded() :
	difficulty += 1
	if is_midnight == true :
		is_midnight = false
		end_night.emit()
