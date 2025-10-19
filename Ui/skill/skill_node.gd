class_name SkillNode extends Button

@export var infinite: bool = false

@export_category("Label")
@export var skill_name: String = "health"

@export_category("Stats")
@export var entity_type: Enum.EntityType
@export var items_shopping_list: Dictionary[Enum.ItemType, int] = {}
@export var entities_shopping_list: Dictionary[Enum.EntityType, int] = {}
@export var bonuses: Dictionary[Enum.Stat, float] = {}
@export var buy_instant: bool = false

var is_unlocked: bool = false
var description_panel: PanelContainer
var description_label: Label

var shopping_list: Dictionary[String, int]:
	get:
		var new_shopping_list: Dictionary[String, int] = {}
		for item in items_shopping_list:
			new_shopping_list[Enum.ItemType.find_key(item)] = items_shopping_list[item]
		for entity in entities_shopping_list:
			new_shopping_list[Enum.EntityType.find_key(entity)] = entities_shopping_list[entity]
		return new_shopping_list

var font_size: int = 60
var border_width_pixels: int = 12
var corner_radius_pixels: int = 32

var title: String:
	get: return tr("skill.%s.name" % skill_name)
var description: String:
	get: return Utils.t("skill.%s.description" % skill_name)

signal on_bought()

func _ready():
	_setup_ui()
	
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	InventoryManager.update_inventory.connect(_update_border)
	_update_border()

func buy():
	if not _can_buy(): 
		return

	InventoryManager.has_paid.connect(_on_paid)
	InventoryManager.pay_shopping_list(shopping_list, buy_instant)

func _on_paid():
	# Apply stat bonuses to the appropriate entity type
	var target_entity_type = _get_entity_type()
	StatsManager.add_bonuses(target_entity_type, bonuses)

	on_bought.emit()

	# if upgrade is infinite, do not delete it
	if infinite: return
	
	for children in get_children():
		if not children is Button:
			continue
		remove_child(children)
		get_parent().add_child(children)

	tree_exited.connect(get_parent()._expand_skills.bind())
	queue_free()

func _get_entity_type() -> Enum.EntityType:
	if not entity_type:
		var parent_node: SkillTree = get_parent()
		if parent_node.default_entity_type:
			return parent_node.entity_type
	
	return entity_type

func _can_be_enabled() -> bool:
	var parent_node = get_parent()
	if parent_node and parent_node is SkillTree:
		return true
			
	return false

func _can_buy() -> bool:
	if is_unlocked:
		return false

	if not _can_be_enabled():
		return false
	
	return InventoryManager.can_pay(shopping_list)

func _setup_ui():
	# show upgrades/bonuses
	var upgrades_text = title + "\n"
	if bonuses.size() > 0:
		for stat_type in bonuses:
			var bonus_value = bonuses[stat_type]
			var sign_text = "+" if bonus_value >= 0 else ""
			upgrades_text += "%s%s %s\n" % [sign_text, bonus_value, tr("stat.%s" % Enum.Stat.find_key(stat_type))]
	
	text = upgrades_text.strip_edges()
	add_theme_font_size_override("font_size", font_size)
	
	# show description + shopping_list
	if description != "" or shopping_list.size() > 0:
		description_panel = PanelContainer.new()
		description_panel.visible = false
		description_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		description_label = Label.new()
		description_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		description_label.custom_minimum_size.x = 300  # Set a reasonable max width for wrapping

		# Combine description and shopping list
		var full_text = ""
		if description != "":
			full_text += description + "\n\n"
		
		if shopping_list.size() > 0:
			full_text += tr("cost") + tr(":") + "\n"
			for item in shopping_list:
				full_text += "- %s%s %d\n" % [tr("item.%s" % item), tr(":"), shopping_list[item]]
		
		description_label.text = full_text.strip_edges()
		description_label.add_theme_font_size_override("font_size", font_size)
		
		description_panel.add_child(description_label)
		description_panel.theme = get_theme()
		add_child(description_panel)
		move_child(description_panel, INTERNAL_MODE_FRONT)

	_update_border()

func _update_border():
	if _can_buy():
		disabled = false
	else:
		disabled = true

func _on_mouse_entered():
	if description_panel:
		description_panel.visible = true
		await get_tree().process_frame
		# Center the description panel horizontally above the button
		var panel_x = (size.x - description_panel.size.x) / 2.0
		description_panel.position = Vector2(panel_x, -description_panel.size.y - 10)

func _on_mouse_exited():
	if description_panel:
		description_panel.visible = false

func _on_pressed():
	buy()
