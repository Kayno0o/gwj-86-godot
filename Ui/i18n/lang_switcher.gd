extends Control


var languages = {
	"Automatic": "automatic",
	"English": "en",
	"Français": "fr"
}

@onready var option_button: OptionButton = $OptionButton

func _ready() -> void:
	option_button.item_selected.connect(_on_language_selected)

	option_button.clear()
	
	for lang_name in languages.keys():
		option_button.add_item(lang_name)
	
	var current_locale = TranslationServer.get_locale()
	var current_lang_name = languages.find_key(current_locale)
	if current_lang_name:
		var item_index = option_button.get_item_index_from_text(current_lang_name)
		option_button.select(item_index)
	else:
		option_button.select(0)

func _on_language_selected(index: int) -> void:
	var selected_lang_name = $OptionButton.get_item_text(index)
	
	var new_locale = languages[selected_lang_name]
	
	_on_language_changed(new_locale)

func _on_language_changed(new_language: String) -> void:
	I18n.set_and_save_language(new_language)
