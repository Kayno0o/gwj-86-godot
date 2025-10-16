extends Control

var current_price: Dictionary[String, int] = {}

signal price_changed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManager.update_inventory.connect(_on_update_inventory)
	for ressource in get_parent().main_ressources :
		if get_parent().main_ressources[ressource] > 0 :
			current_price.get_or_add(ressource, get_parent().main_ressources[ressource])
	price_changed.connect(_on_price_changed)
	price_changed.emit()

func _on_update_inventory() :
	pass

func _on_button_pressed() -> void:
	if InventoryManager.pay_shopping_list(current_price):
		get_parent().spawn()
		for item in current_price :
			if current_price[item] != 0 :
				current_price[item] += 1
		price_changed.emit()

func _on_price_changed():
	var mask_instance = get_parent().mask_to_invok.instantiate()
	var new_text= Enum.EntityType.find_key(mask_instance.type)
	for item in current_price :
		new_text =new_text + "\n"+ item + ": " + str(current_price[item])
	$Button.text = new_text
