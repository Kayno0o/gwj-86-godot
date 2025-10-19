class_name MiniTotemBubble extends SkillNode

var base_item_price: Dictionary[Enum.ItemType, int]
var minitotem : Node2D

func _ready() -> void:
	minitotem = get_parent().get_parent()

	base_item_price = items_shopping_list

	on_bought.connect(_on_bought)

	super._ready()

func _on_bought() -> void:
	minitotem.spawn()
	var entity_count = InventoryManager.inventory[Enum.EntityType.find_key(minitotem.totem_type)].size()
	for item in items_shopping_list:
		if items_shopping_list[item] != 0:
			items_shopping_list[item] += entity_count / base_item_price[item]
