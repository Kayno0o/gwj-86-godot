extends Node

@export var ennemies : Array[PackedScene]
@export var offset : float

@onready var threat_cost :int = 50
@onready var world = get_tree().get_nodes_in_group("Master")[0]
@onready var spawned : bool = false

signal spawner_ded

func _ready() -> void:
	world.spawn_enemy.connect(_on_game_master_spawn_enemy)
	world.kill_villain.connect(_on_game_master_kill_villain)

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
				ennemi_instance.position = Vector2(randf_range(offset, -offset), randf_range(offset, -offset))
				add_child(ennemi_instance)

func _on_game_master_spawn_enemy() -> void:
	print("we are here")
	_ennemi_picker()
	spawned = true

func _on_game_master_kill_villain() -> void:
	for childrens in self.get_children() :
		childrens.free()

func _on_child_exiting_tree(_node: Node) -> void:
	if self.get_child_count() == 1 and spawned == true:
		spawner_ded.emit()
		self.queue_free()
