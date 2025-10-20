class_name MiniTotemBubble extends SkillNode

@export var price_multiplicator: Curve

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
			items_shopping_list[item] = ceil(base_item_price[item] * price_multiplicator.sample(clamp(entity_count, price_multiplicator.min_domain, price_multiplicator.max_domain)))
	_setup_ui()
