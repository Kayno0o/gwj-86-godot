extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = "Score : " + str((get_tree().get_first_node_in_group("gamemaster").max_score - 1) * 100)
