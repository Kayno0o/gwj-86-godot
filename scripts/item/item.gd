extends Resource
class_name Item

var type: ItemType
var amount: int

func _init(p_type: ItemType = ItemType.Wood, p_amount: int = 1):
	type = p_type
	amount = p_amount
