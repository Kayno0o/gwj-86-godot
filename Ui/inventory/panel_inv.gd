extends Panel

@export var item_sprite : Texture2D
@export var item_type : Enum.ItemType
@export var entity_type : Enum.EntityType
@export var is_entity : bool
@export var unique_scale : float

func _ready() -> void:
	$text/Sprite.scale *= unique_scale
	if is_entity :
		$text/Sprite.position.y -= ($text/Sprite.texture.get_height() * $text/Sprite.scale.y) / 3
	InventoryManager.update_inventory.connect(_update_slot)
	$text/Sprite.texture = item_sprite
	if is_entity :
		$text/Sprite.position.y += 20
	_update_slot()

func _update_slot() -> void :
	for item in InventoryManager.inventory :
		if is_entity :
			if InventoryManager._is_item_an_entity(item) and item == Enum.EntityType.find_key(entity_type):
				$text/number.text = str(InventoryManager.inventory[item].size())
				if str(InventoryManager.inventory[item].size()) == "0" :
					$".".visible = false
				else :
					$".".visible = true
		elif item == Enum.ItemType.find_key(item_type) :
			$text/number.text = str(InventoryManager.inventory[item])
			if str(InventoryManager.inventory[item]) == "0" :
				$".".visible = false
			else :
				$".".visible = true
