extends Control

var current_price : Dictionary[String, int]
var minitotem : Node2D
var current_state : bool = false
var tween :Tween

@export var time_to_tween : float

signal price_changed()

func _init() -> void:
	self.visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("position : " + str(self.size))
	self.visible = false
	minitotem = get_parent().get_parent()
	InventoryManager.update_inventory.connect(_on_update_inventory)
	for ressource in minitotem.main_ressources :
		if minitotem.main_ressources[ressource] > 0 :
			current_price.get_or_add(ressource, minitotem.main_ressources[ressource])
	price_changed.connect(_on_price_changed)
	price_changed.emit()

func _on_update_inventory() :
	pass
	#print_debug(InventoryManager.inventory)
	#pass

func _on_button_pressed() -> void:
	if InventoryManager.pay_shopping_list(current_price):
		minitotem.spawn()
		for item in current_price :
			if current_price[item] != 0 :
				current_price[item] += 1
		price_changed.emit()

func _on_price_changed() -> void:
	var mask_instance = minitotem.mask_to_invok.instantiate()
	var new_text= Enum.EntityType.find_key(mask_instance.type)
	for item in current_price :
		new_text =new_text + "\n"+ item + ": " + str(current_price[item])
	$Button.text = new_text

func _open_anim() -> void:
	if tween :
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position", Vector2(- $Button.size.x / 2, 300), time_to_tween)
	tween.tween_property(self, "scale", Vector2(1, 1), time_to_tween)
	pass

func _close_anim() -> void:
	if tween :
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position", Vector2(0, 0), time_to_tween)
	tween.tween_property(self, "scale", Vector2(0, 0), time_to_tween)
	#self.visible = false

func switch_state() -> void:
	if current_state == false :
		scale = Vector2(0.1,0.1)
		current_state = true
		self.visible = true
		_open_anim()
	else :
		current_state = false
		#self.visible = false
		_close_anim()
