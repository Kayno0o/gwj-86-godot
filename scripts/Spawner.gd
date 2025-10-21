extends Node

#region @Onready
@onready var threat_cost :int = 10
@onready var world = get_tree().get_first_node_in_group("gamemaster")
#endregion

#region @Export
@export var villains : Array[PackedScene]
@export var offset : float
@export var difficulty_curve : Curve
#endregion

#region Signals
signal spawner_ded
#endregion

# Feat du Spawner :
# Dispose d'un budget de spawn qui augmente en fonction de la difficulté
# Possede un Array de Villains, le plus couteux étant rangé en 0 manuellement et le moins couteux en "villains.size() - 1"
# L'offset permet de definir une zone dans laquelle les villains spawn autour du spawner
# Depense comme un grand son budget aléatoirement et dans la totalité :
# - Regarde combien il peu acheter d'unité la plus cher
# - En achete un nombre aleatoire dans ses capacitées
# - Fait de meme pour chaque unité jusqu'à la moins cher
# - Depense le reste de ses economies reservé a soigné sa mamie dans l'achat d'unité faible

#region _Ready / _Process
# Se connecte a la commande dev pour tout tuer et lance la selection / spawn des villains
func _ready() -> void:
	world.kill_villain.connect(_on_game_master_kill_villain)
	_villain_picker()
#endregion

#region Fonctions
# Selectionne les villains a spawn selon son budget
func _villain_picker() :
	var allowed = 0
	var spawn_budget = int(world.difficulty * threat_cost * difficulty_curve.sample(world.difficulty))
	for current_villain in villains :
		var villain_instance = current_villain.instantiate()
		if spawn_budget >= villain_instance.cost :
			if current_villain == villains.back() :
				allowed = spawn_budget / villain_instance.cost
			else :
				allowed = randi_range(0, spawn_budget / villain_instance.cost)
			for i in allowed :
				villain_instance = current_villain.instantiate()
				spawn_budget -= villain_instance.cost
				villain_instance.position = Vector2(randf_range(offset, -offset), randf_range(offset, -offset))
				add_child(villain_instance)
#endregion

#region Signal catching
# Tue le spawner si tout les villains sont mort
func _on_child_exiting_tree(_node: Node) -> void:
	if self.get_child_count() == 1:
		spawner_ded.emit()
		self.queue_free()

# Tue tout les enfants du spawner suite a la demande du Dev
func _on_game_master_kill_villain() -> void:
	for childrens in self.get_children() :
		childrens.free()
#endregion
