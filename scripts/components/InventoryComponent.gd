class_name InventoryComponent extends Component

var parent: Mask

var drop_spread: float

var inventory_node: Node2D
var inventory: Array[Item] = []

signal inventory_full

func _init(
	p_parent: Mask,
	p_drop_spread: float = 16.0,
) -> void:
	type = Component.Type.Inventory

	parent = p_parent
	drop_spread = p_drop_spread

func _ready() -> void:
	inventory_node = Node2D.new()
	inventory_node.name = 'Inventory'
	parent.add_child(inventory_node)

func drop_inventory() -> void:
	for item in inventory:
		Utils.reparent_without_moving(item, inventory_node, parent.get_parent())
		TargetManager.register_target(item, [item.target_type])

		var offset = Vector2(
			randf_range(-drop_spread, drop_spread),
			randf_range(-drop_spread, drop_spread),
		)
		item.global_position += offset

func set_items_position() -> void:
	var offset = Vector2(0, -8)
	var current_position = Vector2(16, 0)

	for item in inventory:
		current_position += offset
		item.tween_to(current_position, .25, "position")

func add_item(item: Item) -> bool:
	if is_inventory_full():
		return false

	inventory.push_back(item)
	Utils.reparent_without_moving(item, item.get_parent(), inventory_node)

	set_items_position()

	if is_inventory_full():
		inventory_full.emit()

	return true

func pop_item() -> Item:
	if inventory.size() == 0:
		return null

	var item = inventory.pop_front()
	inventory_node.remove_child(item)
	set_items_position()

	return item

func is_inventory_full() -> bool:
	return inventory.size() >= parent.get_inventory_size()

func is_empty() -> bool:
	return inventory.is_empty()
