extends Node2D

#region Enums
#endregion

#region var
var target_type: Enum.TargetType = Enum.TargetType.Totem;
var inventory: Dictionary = {}
@export var entities : Dictionary = Enum.EntityType
#endregion

#region @export
#endregion

#region @onready
#endregion

#region signal
#endregion


func _init() -> void:
	for itemtype in Enum.ItemType :
		inventory[itemtype] = 0

func _ready() -> void:
	TargetManager.register_target(self, [target_type])

func deposit_item(itemtype: Enum.ItemType, amount: int) -> void :
	inventory[itemtype] += amount

func command(shopping_list: Dictionary) -> void :
	for item in shopping_list :
		if is_item_an_entity(item) == false :
			Enum.ongoing_shopping_list.get_or_add(item, shopping_list[item])
	for entity in shopping_list :
		if is_item_an_entity(entity) == true :
			var sacrificed = get_tree().get_nodes_in_group(entity)
			if sacrificed :
				for sacrifice_number in shopping_list[entity]:
#region Code à ajouter ici
					pass
					#Vérifier si sacrificed[sacrificed number] est dejà sous cette states, sinon le changer en state sacrifié
#endregion

func pay(itemtype: String, amount: int) -> void :
	print_debug("Vous avez payé ", amount, " de ",itemtype )
	inventory[itemtype] -= amount
	print_debug("Il vous reste : ", inventory[itemtype], " de ", itemtype, "dans votre inventaire")

func has_fund_for_list(shopping_list: Dictionary) -> bool :
	for item in shopping_list :
		if inventory[item] < shopping_list[item] :
			return(false)
	return(true)

func has_fund_for_item(itemtype: String, amount: int) -> bool :
	if inventory[itemtype] < amount :
			return(false)
	return(true)

func is_item_an_entity(item : String) -> bool :
	for entity in entities :
		if item == entity :
			return(true)
	return(false)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_M:
			var shoplist = {"Wood": 2}
			if has_fund_for_list(shoplist) :
				print_debug("Je possede des thunes, je suis a l'aise financierement")
			else :
				print_debug("t'es pauvres batard")
		if event.pressed and event.keycode == KEY_K:
			inventory["Wood"] += 1
			print_debug("+1 wood")
		if event.pressed and event.keycode == KEY_N:
			print_debug(" vous avez : ", inventory["Wood"], " wood")
