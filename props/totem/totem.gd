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

# Le totem est basiquement l'inventaire.
# il stocke les objets du joueurs sous forme de Dictionnary {"ressource": quantité, ...., "ressource": quantité}
# Lors d'un achats d'upgrade, c'est ici que les transactions se font :
# le skill tree envoie une liste de course exemple : {"Wood" : 3, "Stone": 4}
# Le totem check si il a les font, si c'est le cas : il demande a une unité de remplir les condition d'achats
# ( emmener les ressources requise a l'achat ) 

#region init/ready/process
# Créer un inventire vide, contenant chaque type d'objet recoltable
func _init() -> void:
	for itemtype in Enum.ItemType :
		inventory[itemtype] = 0

# Se donne une Target pour le target manager
func _ready() -> void:
	TargetManager.register_target(self, [target_type])
#endregion

#region Fonctions
# Depose un item dans l'inventaire
func deposit_item(itemtype: String, amount: int) -> void :
	print_debug("Added 1 ", itemtype, " to inventory, Well done !")
	inventory[itemtype] += amount

# Mets la liste des "courses" dans la queue
func add_queue(shopping_list: Dictionary) -> void :
	Enum.ongoing_shopping_list.append(shopping_list)
	if Enum.ongoing_shopping_list.size() == 1 :
		queue_start(Enum.ongoing_shopping_list)
	
# Mets la liste des course en "current_list" et demande au Masked d'aller travailler 
func queue_start(shopping_list: Array[Dictionary]) -> void :
	var current_list = shopping_list[0]
	Enum.current_shopping_list = current_list
	for entity in current_list :
		if is_item_an_entity(entity) == true :
			var sacrificed = get_tree().get_nodes_in_group(entity)
			if sacrificed :
				for sacrifice_number in shopping_list[entity]:
#region Code à ajouter ici
					pass
					#Vérifier si sacrificed[sacrificed number] est dejà sous cette states, sinon le changer en state sacrifié
#endregion

# Enleve la liste effectué et relance la queue si elle n'est pas vide
func queue_remove_and_reboot() -> void :
	Enum.ongoing_shopping_list.remove_at(0)
	if Enum.ongoing_shopping_list[0] :
		queue_start(Enum.ongoing_shopping_list)
	
# Paye en ressource (Enleve "amount" "itemtype" de l'inventaire
func pay(itemtype: String, amount: int) -> void :
	inventory[itemtype] -= amount

# Verifie si les fond necessaire pour la liste sont dans l'inventaire
func has_fund_for_list(shopping_list: Dictionary) -> bool :
	for item in shopping_list :
		if inventory[item] < shopping_list[item] :
			return(false)
	for entity in shopping_list :
		if is_item_an_entity(entity) == true and inventory[entity] < shopping_list[entity]:
			return(false)
	return(true)

# Verifie si on a les fonds necessaire pour 1 item
func has_fund_for_item(itemtype: String, amount: int) -> bool :
	if inventory[itemtype] < amount :
			return(false)
	return(true)

#verifie si l'item est une entité
func is_item_an_entity(item : String) -> bool :
	for entity in entities :
		if item == entity :
			return(true)
	return(false)
#endregion

#region Outils dev
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
			print_debug(inventory)
#endregion
