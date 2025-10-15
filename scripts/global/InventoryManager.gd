extends Node

# il stocke les objets du joueurs sous forme de Dictionnary {"ressource": quantité, ..., "ressource": quantité}
# Lors d'un achats d'upgrade, c'est ici que les transactions se font :
# le skill tree envoie une liste de course exemple : {"Wood" : 3, "Stone": 4}
# check si il a les fonds, si c'est le cas : il demande a une unité de remplir les conditions d'achats
# ( emmener les ressources requise a l'achat ) 

var totem: Totem

var shopping_lists: Array[Dictionary] # Array of Dictionnary full of Enums, it counts

var current_list: Dictionary[String, int] = {}

# { [ItemType]: int, [EntityType]: Array[Mask] }
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

# dépose un item dans l'inventaire
func deposit_item(itemtype: String, amount: int) -> void:
	inventory[itemtype] += amount
	update_inventory.emit()

# instantly pay given shopping list
func pay_shopping_list(shopping_list: Dictionary[String, int]) -> bool:
	if shopping_list.is_empty(): return false
	if not can_pay(shopping_list): return false

	_pay_given_list(shopping_list, true)

	return true

# ajoute la liste d'achat
func add_shopping_list(shopping_list: Dictionary[String, int]) -> bool:
	if shopping_list.is_empty(): return false
	if not can_pay(shopping_list): return false

	shopping_lists.append(shopping_list)
	_queue_start()

	return true

# vérifie si les fond necessaire pour la liste sont dans l'inventaire
func can_pay(shopping_list: Dictionary[String, int]) -> bool:
	for item in shopping_list:
		if not _has_fund_for_item(item, shopping_list[item]):
			return false

	return true

# current list is not empty
func has_sacrifice() -> bool:
	for item in current_list:
		if current_list[item] > 0:
			return true

		current_list.erase(item)

	current_list = {}

	return false

func sacrifice_item(item: Item):
	current_list[Enum.ItemType.find_key(item.item_type)] -= 1
	item.queue_free()

	if _is_current_list_paid():
		_queue_start()

func sacrifice_mask(entity: Entity):
	current_list[Enum.EntityType.find_key(entity.type)] -= 1
	entity.queue_free()

	if _is_current_list_paid():
		_queue_start()

#region internal methods
# put first element of queue in current list
func _queue_start() -> bool:
	if not current_list.is_empty(): return false
	if shopping_lists.is_empty(): return false

	current_list = shopping_lists.pop_front()
	_pay_current_list()

	return true

# vérifie si on a les fonds necessaire pour 1 item ou entité
func _has_fund_for_item(item: String, amount: int) -> bool:
	if _is_item_an_entity(item):
		return inventory[item].size() >= amount

	return inventory[item] >= amount

func _is_current_list_paid() -> bool:
	for item in current_list:
		if current_list[item] > 0:
			return false
		
		current_list.erase(item)

	return true

# vérifie si l'item est une entité
func _is_item_an_entity(item: String) -> bool:
	return entities_keys.has(item)

# enlève les ressources de l'inventaire, et sélectionne les entités à sacrifier
func _pay_current_list() -> void:
	_pay_given_list(current_list)

func _pay_given_list(given_list: Dictionary[String, int], instantly: bool = false) -> void:
	for item in given_list:
		if _is_item_an_entity(item):
			# send random entities of given type to sacrifice
			for i in range(given_list[item]):
				var rand: int = randi_range(0, inventory[item].size() - 1)
				var entity: Mask = inventory[item].get(rand)
				entity.state_machine.change_state_type(State.Type.Sacrifice)
				inventory[item].erase(entity)

			continue

		inventory[item] -= given_list[item]

		if instantly:
			given_list.erase(item)
#endregion

#region signal methods
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
#endregion
