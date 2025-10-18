extends AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	@warning_ignore("integer_division")
	
	var check = (int(self.global_position.y))
	if check > 4100 :
		check = 4100
	elif check < -4100 :
		check = -4100
	self.z_index = check
