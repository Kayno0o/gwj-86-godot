extends Node

# il stocke les objets du joueurs sous forme de Dictionnary {"ressource": quantité, ..., "ressource": quantité}
# Lors d'un achats d'upgrade, c'est ici que les transactions se font :
# le skill tree envoie une liste de course exemple : {"Wood" : 3, "Stone": 4}
# check si il a les fonds, si c'est le cas : il demande a une unité de remplir les conditions d'achats
# ( emmener les ressources requise a l'achat ) 

var totem: Totem
var fire: Fire

# items waiting to be transported
var pending_items: Dictionary[String, int] = {}
# sacrifices waiting to be transported
var pending_sacrifices: Dictionary[String, Array] = {}
# items being transported
var transfering_items: Dictionary[String, Array] = {}

var current_mask_transfering: Array[Mask] = []

# { [ItemType]: int, [EntityType]: Array[Mask] }
var inventory: Dictionary = {}

var entities_keys = Enum.EntityType.keys()
var items_keys = Enum.ItemType.keys()

signal update_inventory()
signal has_paid()

func init() -> void:
	for entityType in entities_keys:
		inventory[entityType] = []

	for itemType in items_keys:
		inventory[itemType] = 0

	TargetManager.target_available.connect(_on_target_available)
	TargetManager.target_removed.connect(_on_target_removed)

	update_inventory.emit()

# instantly pay given shopping list and move items to pending
func pay_shopping_list(shopping_list: Dictionary[String, int], instantly = true) -> bool:
	if shopping_list.is_empty(): return false
	if not can_pay(shopping_list): return false

	for type in shopping_list:
		if _is_item_an_entity(type):
			# sacrifice random entities of given type
			for i in range(shopping_list[type]):
				var rand: int = randi_range(0, inventory[type].size() - 1)
				var entity: Mask = inventory[type].get(rand)
				entity.state_machine.change_state_type(State.Type.Sacrifice)
				inventory[type].erase(entity)

				if not pending_sacrifices.has(type): pending_sacrifices[type] = []
				pending_sacrifices[type].push_back(entity)

			continue

		# remove items from inventory if paying instantly
		if instantly:
			inventory[type] -= shopping_list[type]

			continue

		# add to pending
		pending_items.get_or_add(type, shopping_list[type])

	update_inventory.emit()

	if not is_pending():
		has_paid.emit()

	return true

# deposit item to inventory
func deposit_item_to_inventory(type: String, amount: int) -> void:
	inventory[type] += amount
	update_inventory.emit()

func sacrifice_mask_to_fire(mask: Mask):
	var type = Enum.EntityType.find_key(mask.type)
	if not pending_sacrifices.has(type): return false
	if pending_sacrifices.get(type).size() <= 0:
		pending_sacrifices.erase(type)
		return false

	pending_sacrifices[type].erase(mask)

	if not is_pending():
		has_paid.emit()

	return true

func sacrifice_item_to_fire(type: String, amount: int, mask: Mask) -> bool:
	if not pending_items.has(type): return false
	if pending_items.get(type) <= 0:
		pending_items.erase(type)
		return false

	pending_items[type] -= amount

	if transfering_items.has(type):
		transfering_items[type].erase(mask)

	if not is_pending():
		has_paid.emit()

	return true

func get_from_inventory(type: String, amount: int = 1) -> bool:
	if not inventory.has(type): return false
	if inventory.get(type) <= 0: return false

	inventory[type] -= amount
	update_inventory.emit()

	return true

# check if can pay from inventory
func can_pay(shopping_list: Dictionary[String, int]) -> bool:
	if has_pending_items(): return false

	for item in shopping_list:
		if not _has_fund_for_item(item, shopping_list[item]):
			return false

	return true

func is_pending() -> bool:
	return has_pending_sacrifices() or has_pending_items()

# check if there are pending sacrifice
func has_pending_sacrifices() -> bool:
	for item_type in pending_sacrifices:
		if pending_sacrifices[item_type].size() > 0:
			return true
		
		pending_sacrifices.erase(item_type)

	return false

# check if there are pending items
func has_pending_items() -> bool:
	for item_type in pending_items:
		if pending_items[item_type] > 0:
			return true
		
		pending_items.erase(item_type)

	return false

func get_item_scene_from_item_type(item_type: String) -> PackedScene:
	var item_type_lower = item_type.to_lower()
	var scene_path = "res://props/item/%s/%s.tscn" % [item_type_lower, item_type_lower]
	return load(scene_path)

func get_item_type_to_transfer(mask: Mask):
	for item_type in pending_items:
		if not transfering_items.has(item_type):
			transfering_items.set(item_type, [])

		if pending_items[item_type] - transfering_items[item_type].size() > 0:
			transfering_items[item_type].push_back(mask)
			return item_type
	
	return null

func total_pending_items() -> int:
	return Utils.iSum(pending_items.values())

func get_current_transfer_capacity(mask: Mask) -> int:
	return current_mask_transfering.size() * floor(mask.get_inventory_size())

func can_send_new_mask_to_transfer(mask: Mask):
	return total_pending_items() > get_current_transfer_capacity(mask)

func has_items_to_transfer() -> bool:
	for item_type in pending_items:
		if not transfering_items.get(item_type):
			transfering_items.set(item_type, [])

		if pending_items[item_type] - transfering_items[item_type].size() > 0:
			return true

	return false

func remove_mask_transfering(mask: Mask):
	for item_type in transfering_items:
		while transfering_items[item_type].has(mask):
			transfering_items[item_type].erase(mask)

	current_mask_transfering.erase(mask)

#region internal methods
# check if has enough of a given type
func _has_fund_for_item(type: String, amount: int) -> bool:
	if _is_item_an_entity(type):
		return inventory[type].size() >= amount

	return inventory[type] >= amount

# check if type is an EntityType
func _is_item_an_entity(type: String) -> bool:
	return entities_keys.has(type)
#endregion

#region signal methods
func _on_target_available(target: Node2D, target_types: Array[Enum.TargetType]):
	if not target_types.has(Enum.TargetType.Mask):
		return

	if target is not Mask or target is Hero:
		return

	var entity_type_string = Enum.EntityType.find_key(target.type)
	if inventory[entity_type_string].has(target):
		return

	inventory[entity_type_string].push_back(target)
	update_inventory.emit()

	return

func _on_target_removed(target: Node2D):
	var target_types = TargetManager.get_target_types(target)
	if not target_types.has(Enum.TargetType.Mask):
		return

	if target is not Mask or target is Hero:
		return

	for item_type in transfering_items:
		while transfering_items[item_type].has(target):
			transfering_items[item_type].erase(target)

	current_mask_transfering.erase(target)

	var entity_type_string = Enum.EntityType.find_key(target.type)
	if not inventory[entity_type_string].has(target):
		return

	inventory[entity_type_string].erase(target)
	update_inventory.emit()
#endregion
