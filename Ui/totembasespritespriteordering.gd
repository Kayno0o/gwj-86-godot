extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.z_index = self.global_position.y
	pass # Replace with function body.
