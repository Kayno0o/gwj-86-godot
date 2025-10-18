extends Node

#region @Onready
@onready var is_midnight : bool = false
#endregion

#region @Export
@export var difficulty : int = 1 # Augmente chaque matin
@export var map_size : Array[Vector2] # connecte chaque point au precedent et le dernier au premier
@export var day_lenght : float # durée de la journée en SECONDE
#endregion

#region Signals
signal end_night()
signal kill_villain() # Dev purpose
#endregion

# Feat du GameMaster : 
# Gere la difficulté ainsi que le placement du spawner de villain
# Selection de zone modulable
# Communique avec le Day/Night cycler

#region Signal Catching
# Si la nuit se termine apres la mort du spawner, commencer la journée
func _on_day_night_cycler_midnight() -> void:
	is_midnight = true
	if self.get_child_count() == 0 :
		is_midnight = false
		end_night.emit()

# Augmente la difficulté a la mort du spawner et commence la journée si la lune est au zenith
func _spawner_is_ded() :
	difficulty += 1
	if is_midnight == true :
		is_midnight = false
		end_night.emit()

# Catch les action du joueurs, sert uniquement a tuer les villains pour des test (pour le moment)
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_K:
			kill_villain.emit()

# Ajoute un spawner lors de la fin de la journée
func _on_timer_timeout() -> void:
	_place_spawner()
#endregion

#region Fonctions
# Selectionne l'une des lignes virtuelles de map_size et place le spawner dessus, se connecte egalement au signal pour savoir quand le spawner meurt
func _place_spawner() :
	var rand_choice = randi_range(0, map_size.size() - 1)
	var location_choice = Vector2(randf_range(map_size[rand_choice].x, map_size[(rand_choice + 1) % 4].x), randf_range(map_size[rand_choice].y, map_size[(rand_choice + 1) % 4].y))
	var spawner = preload("uid://cnoupnbe0nfrg").instantiate()
	#spawner.position = location_choice
	var mob_spawn_location = $Path2D/PathFollow2D
	mob_spawn_location.progress_ratio = randf()
	spawner.position = mob_spawn_location.position
	spawner.spawner_ded.connect(_spawner_is_ded)
	add_child(spawner)
	
	#self.get_child(0).spawner_ded.connect(_spawner_is_ded)
#endregion
