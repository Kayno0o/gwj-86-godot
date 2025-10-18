extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var check = int(self.global_position.y)
	if check > 4100 :
		check = 4100
	elif check < -4100 :
		check = -4100
	self.z_index = check
	pass # Replace with function body.
