extends Panel

@export var item_sprite : Texture2D
@export var item_type : Enum.ItemType
@export var entity_type : Enum.EntityType = null

func _ready() -> void:
	InventoryManager.update_inventory.connect(_update_slot)
	$text/Sprite.texture = item_sprite

func _update_slot() -> void :
	if item_type :
		$text/number.text = str(InventoryManager.inventory[item_type])
	if entity_type 
