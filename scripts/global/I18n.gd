extends Node

const SETTINGS_FILE = "user://i18n.cfg"

var current_language_setting: String = ""

var is_loaded: bool = false

func set_language(language: String):
	current_language_setting = language
	if language == "automatic":
		var preferred_language = OS.get_locale_language()
		TranslationServer.set_locale(preferred_language)
	else:
		TranslationServer.set_locale(language)

func load_and_set_language() -> String:
	# return without re-loading config
	if is_loaded: return current_language_setting

	is_loaded = true

	var config = ConfigFile.new()
	var err = config.load(SETTINGS_FILE)

	if err != OK:
		return "automatic"

	var language = config.get_value("user", "language", "automatic")

	set_language(language)

	return language

func set_and_save_language(language: String) -> void:
	set_language(language)

	var config = ConfigFile.new()
	config.load(SETTINGS_FILE)

	config.set_value("user", "language", language)
	var err = config.save(SETTINGS_FILE)
	if err != OK:
		printerr("Failed to save settings file!")
