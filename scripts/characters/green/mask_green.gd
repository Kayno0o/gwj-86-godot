extends Mask

var target_tree: Node2D = null

func abstract_ready():
	if mask_task == MaskTask.Type.ChopWood:
		find_nearest_tree()

func abstract_physics_process(_delta):
	if target_tree:
		move_to_target()

func find_nearest_tree():
	var trees = get_tree().get_nodes_in_group("trees")
	if trees.is_empty():
		print(mask_name + ": No trees found!")
		return

	var nearest_tree = null
	var nearest_distance = INF

	for tree in trees:
		var distance = global_position.distance_to(tree.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_tree = tree

	if nearest_tree:
		target_tree = nearest_tree
		print(mask_name + " found nearest tree at distance: " + str(nearest_distance))

func move_to_target():
	if not target_tree or not is_instance_valid(target_tree):
		target_tree = null
		find_nearest_tree()
		return

	var direction = (target_tree.global_position - global_position).normalized()
	var distance = global_position.distance_to(target_tree.global_position)

	if distance < 30.0:
		velocity = Vector2.ZERO
		print(mask_name + " reached the tree!")
		return

	velocity = direction * movement_speed
	move_and_slide()
