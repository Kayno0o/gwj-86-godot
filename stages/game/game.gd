extends Node

const SETTINGS_FILE = "user://i18n.cfg"

func _init() -> void:
	TargetManager.init()
	InventoryManager.init()
	StatsManager.init()

	I18n.load_and_set_language()
