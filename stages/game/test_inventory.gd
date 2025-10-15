extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManager.update_inventory.connect(_test)
	InventoryManager.update_inventory.emit()


func _test() :
	var _texte : String
	var number = 0
	for item in InventoryManager.inventory :
		
		if InventoryManager.entities_keys.has(item) :
			number = InventoryManager.inventory[item].size()
		elif InventoryManager.inventory[item] == null :
			number = 0
		else :
			number = InventoryManager.inventory[item]
		_texte = _texte + item + " : " + str(number) + "\n"
	self.text= _texte
