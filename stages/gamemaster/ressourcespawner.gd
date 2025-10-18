extends CollisionShape2D


@onready var spawnArea = $".".shape.extents
@onready var origin = $".".global_position -  spawnArea

@export var spawn_rate : int

@export var tree : PackedScene
@export var rock : PackedScene
@export var wheat : PackedScene

func _ready() -> void:
	$Timer.start(spawn_rate)
	
func gen_random_pos():
	var x = randf_range(origin.x, spawnArea.x)
	var y = randf_range(origin.y, spawnArea.y)
	
	return(Vector2(x, y))

func _on_timer_timeout():
	var ressource_instance
	var x = randi_range(0, 2)
	match x :
		0 :
			ressource_instance = tree.instantiate()
		1 :
			ressource_instance = rock.instantiate()
		2 :
			ressource_instance = wheat.instantiate()
	ressource_instance.position = gen_random_pos()
	$"../../game".add_child(ressource_instance)
