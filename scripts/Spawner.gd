extends Node

@export var ennemies : Array[PackedScene]

@onready var threat_cost = 100
@onready var world = get_tree().get_nodes_in_group("Master")[0]

func _ready() -> void:
	world.spawn_enemy.connect(_on_game_master_spawn_enemy)
	print_debug(world)

func _ennemie_picker() :
	

func _on_game_master_spawn_enemy() -> void:
	_spawn_ennemi()
	pass # Replace with function body.
