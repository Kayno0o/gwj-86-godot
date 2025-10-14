extends Node

# il stocke les objets du joueurs sous forme de Dictionnary {"ressource": quantité, ..., "ressource": quantité}
# Lors d'un achats d'upgrade, c'est ici que les transactions se font :
# le skill tree envoie une liste de course exemple : {"Wood" : 3, "Stone": 4}
# check si il a les fonds, si c'est le cas : il demande a une unité de remplir les conditions d'achats
# ( emmener les ressources requise a l'achat ) 

var shopping_lists: Array[Dictionary] # Array of Dictionnary full of Enums, it counts
var current_list: Dictionary[String, int] = {}

var inventory: Dictionary = {}

var entities_keys = Enum.EntityType.keys()
var items_keys = Enum.ItemType.keys()

signal update_inventory

func init() -> void:
	for entityType in entities_keys:
		inventory[entityType] = []

	for itemtype in items_keys:
		inventory[itemtype] = 0

	TargetManager.target_available.connect(_on_target_available)

# Depose un item dans l'inventaire
func deposit_item(itemtype: String, amount: int) -> void:
	print_debug("Added 1 ", itemtype, " to inventory, Well done !")
	inventory[itemtype] += amount

# Mets la liste des "courses" dans la queue
func add_queue(shopping_list: Dictionary[Enum.ItemType, int]) -> void:
	shopping_lists.append(shopping_list)
	queue_start()
	
# Mets la liste des course en "current_list" et demande au Masked d'aller travailler 
func queue_start() -> void:
	if not current_list.is_empty() or shopping_lists.is_empty():
		return

	current_list = shopping_lists.pop_front()
	for entity in current_list:
		if is_item_an_entity(entity):
			# TODO
			pass

# Paye en ressource (Enleve "amount" "itemtype" de l'inventaire
func pay(itemtype: String, amount: int) -> void:
	inventory[itemtype] -= amount

# Verifie si les fond necessaire pour la liste sont dans l'inventaire
func has_fund_for_list(shopping_list: Dictionary) -> bool:
	for item in shopping_list:
		if is_item_an_entity(item):
			if inventory[item].size() < shopping_list[item]:
				return false
			continue

		if inventory[item] < shopping_list[item]:
			return false

	return true

# Verifie si on a les fonds necessaire pour 1 item
func has_fund_for_item(itemtype: String, amount: int) -> bool:
	if inventory[itemtype] < amount:
			return false

	return true

# verifie si l'item est une entité
func is_item_an_entity(item: String) -> bool:
	return entities_keys.has(item)

func _on_target_available(target: Node2D, target_types: Array[Enum.TargetType]):
	if not target_types.has(Enum.TargetType.Mask) or target is not Entity:
		return

	var entity_type_string = Enum.EntityType.find_key(target.entity_type)
	if inventory[entity_type_string].has(target):
		return

	inventory[entity_type_string].push(target)
	update_inventory.emit()

	return

func _on_target_removed(target: Node2D):
	var target_types = TargetManager.get_target_types(target)
	if not target_types.has(Enum.TargetType.Mask) or target is not Entity:
		return

	var entity_type_string = Enum.EntityType.find_key(target.entity_type)
	if not inventory[entity_type_string].has(target):
		return

	inventory[entity_type_string].erase(target)
	update_inventory.emit()
