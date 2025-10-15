extends Control

var current_price : Dictionary

signal price_changed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_parent().inventorychanged.connect(_on_inventory_changed)
	for ressource in get_parent().main_ressources :
		if get_parent().main_ressources[ressource] > 0 :
			current_price.get_or_add(ressource, get_parent().main_ressources[ressource])
	price_changed.connect(_on_price_changed)
	price_changed.emit()

func _on_inventory_changed(inventory : Dictionary) :
	print_debug(inventory)
	pass

func _on_button_pressed() -> void:
	if get_parent().get_parent().has_fund_for_list(current_price) :
		get_parent().get_parent().pay_list(current_price)
		get_parent().spawn()
		for item in current_price :
			if current_price[item] != 0 :
				current_price[item] += 1
		price_changed.emit()

func _on_price_changed():
	var mask_instance = get_parent().mask_to_invok.instantiate()
	var new_text= Enum.EntityType.find_key(mask_instance.type) + "\n"
	for item in current_price :
		new_text =new_text + item + ": " + str(current_price[item])
	$Button.text = new_text
