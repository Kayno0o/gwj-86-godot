extends Node

@export var ennemies : Array[PackedScene]

@onready var threat_cost :int = 50
@onready var world = get_tree().get_nodes_in_group("Master")[0]
@onready var spawned : bool = false

signal spawner_ded

func _ready() -> void:
	world.spawn_enemy.connect(_on_game_master_spawn_enemy)
	world.kill_villain.connect(_on_game_master_kill_villain)

func _process(_delta: float) -> void:
	if self.get_child_count() == 0 and spawned == true:
		spawner_ded.emit()
		self.free()

func _ennemi_picker() :
	var allowed = 0
	var spawn_budget = world.difficulty * threat_cost
	for current_ennemi in ennemies :
		var ennemi_instance = current_ennemi.instantiate()
		if spawn_budget > ennemi_instance.cost :
			if current_ennemi == ennemies[ennemies.size()- 1] :
				allowed = spawn_budget / ennemi_instance.cost
			else :
				allowed = randi_range(0, spawn_budget / ennemi_instance.cost)
			for i in allowed :
				ennemi_instance = current_ennemi.instantiate()
				spawn_budget -= ennemi_instance.cost
				add_child(ennemi_instance)

func _on_game_master_spawn_enemy() -> void:
	print("we are here")
	_ennemi_picker()
	spawned = true

func _on_game_master_kill_villain() -> void:
	self.get_child(0).free()
