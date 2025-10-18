extends TileMapLayer

@export var map_size : Vector2

enum case{
	up = 0,
	down = 1,
	}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_x = -90
	var top_y = 1
	var actual_y
	var down_y = 1
	var end_x = 90
	var status = case.up
	
	while start_x < end_x :
		actual_y = down_y
		while actual_y <= top_y :
			set_cell(Vector2(start_x, actual_y), 0, Vector2(randi_range(0, 2), randi_range(0, 0)), 0)
			actual_y += 1
		if start_x == 0 :
			status = case.down
		match status :
			case.up :
				top_y += 1
				down_y -= 1
			case.down :
				top_y -= 1
				down_y += 1
		start_x += 1
	#var star_x
	pass # Replace with function body.
