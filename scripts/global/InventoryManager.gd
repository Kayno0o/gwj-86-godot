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
	TargetManager.target_removed.connect(_on_target_removed)

	update_inventory.emit()

# Depose un item dans l'inventaire
func deposit_item(itemtype: String, amount: int) -> void:
	inventory[itemtype] += amount
	update_inventory.emit()

# Mets la liste des "courses" dans la queue
func add_shopping_list(shopping_list: Dictionary[String, int]) -> bool:
	if not can_pay(shopping_list):
		return false

	shopping_lists.append(shopping_list)
	queue_start()

	return true
	
# Mets la liste des course en "current_list" et demande au Masked d'aller travailler 
func queue_start() -> void:
	if not current_list.is_empty() or shopping_lists.is_empty():
		return

	current_list = shopping_lists.pop_front()
	_pay_current_list()

func has_item_to_remove() -> bool:
	for item in current_list:
		if current_list[item] > 0:
			return true
		
		current_list.erase(item)

	return false

# Verifie si les fond necessaire pour la liste sont dans l'inventaire
func can_pay(shopping_list: Dictionary) -> bool:
	for item in shopping_list:
		if not _has_fund_for_item(item, shopping_list[item]):
			return false

	return true

#region internal methods
# Verifie si on a les fonds necessaire pour 1 item
func _has_fund_for_item(item: String, amount: int) -> bool:
	if _is_item_an_entity(item):
		return inventory[item].size() >= amount

	return inventory[item] >= amount

# verifie si l'item est une entité
func _is_item_an_entity(item: String) -> bool:
	return entities_keys.has(item)

# enlève les ressources de l'inventaire, et sélectionne les entités à sacrifier
func _pay_current_list() -> void:
	for item in current_list:
		if _is_item_an_entity(item):
			# TODO select random entities for sacrifice
			# remove them from the current shopping list
			var entities: Array = inventory[item]
			for i in range(current_list[item]):
				var rand = randi_range(0, entities.size() - 1)
				var entity: Mask = entities.get(rand)
				entity.state_machine.change_state_type(State.Type.Sacrifice)

			current_list.erase(item)
			continue
		
		inventory[item] -= current_list[item]
#endregion

func _on_target_available(target: Node2D, target_types: Array[Enum.TargetType]):
	if not target_types.has(Enum.TargetType.Mask):
		return
	
	if target is not Mask:
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
	
	if target is not Mask:
		return

	var entity_type_string = Enum.EntityType.find_key(target.type)
	if not inventory[entity_type_string].has(target):
		return

	inventory[entity_type_string].erase(target)
	update_inventory.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not event.pressed: return
		if event.keycode == KEY_T:
			print_debug(can_pay({
				"MaskTransporter": 2
			}))
		if event.keycode == KEY_P:
			print_debug(add_shopping_list({
				"MaskTransporter": 2
			}))
