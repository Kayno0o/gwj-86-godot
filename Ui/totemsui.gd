extends Window



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_requested() -> void:
	self.queue_free()

func _unhandled_input(event: InputEvent) -> void:
	pass
