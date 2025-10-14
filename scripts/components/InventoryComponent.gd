class_name InventoryComponent extends Component

var parent: Node2D
var inventory_node: Node2D
var inventory: Array[Item] = []
var inventory_size: int = 0

signal inventory_full

func _init(p_parent: Node2D, p_inventory_size: int) -> void:
	type = Component.Type.Inventory

	parent = p_parent
	inventory_size = p_inventory_size

func _ready() -> void:
	inventory_node = Node2D.new()
	inventory_node.name = 'Inventory'
	parent.add_child(inventory_node)

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
	return inventory.size() >= inventory_size

func is_empty() -> bool:
	return inventory.is_empty()
