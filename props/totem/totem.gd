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
	for entity in entities :
		if is_item_an_entity(entity) == true :
			var sacrificed = get_tree().get_nodes_in_group(entity)
			for sacrifice_number in 3 - 1:
				print_debug(sacrificed[sacrifice_number])
			print_debug("they ded")
	#for item in entities :
		#if is_item_an_entity(item) :
			#Enum.ongoing_shopping_list.get_or_add(item, entities[item])
			#pass
		#else :
			#pass
	#print_debug(Enum.ongoing_shopping_list)
	TargetManager.register_target(self, [target_type])

func deposit_item(itemtype: Enum.ItemType, amount: int) -> void :
	inventory[itemtype] += amount

func command(shopping_list: Dictionary) -> void :
	Enum.ongoing_shopping_list = shopping_list
	for item in shopping_list :
		if is_item_an_entity(item) == false :
			Enum.ongoing_shopping_list.get_or_add(item, shopping_list[item])
	for entity in shopping_list :
		if is_item_an_entity(entity) == true :
			var sacrificed = get_tree().get_nodes_in_group(entity)
			for sacrifice_number in shopping_list[entities] - 1 :
				
				sacrificed[sacrifice_number] = null #Changer le states du sacrifié

func has_fund(shopping_list: Dictionary) -> bool :
	for item in shopping_list :
		if inventory[item] < shopping_list[item] :
			return(false)
	return(true)

func is_item_an_entity(item : String) -> bool :
	for entity in entities :
		if item == entity :
			return(true)
	return(false)
