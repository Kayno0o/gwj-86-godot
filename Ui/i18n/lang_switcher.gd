extends OptionButton


var languages = {
	"Automatic": "automatic",
	"English": "en",
	"Français": "fr",
}

var ids = {
	"Automatic": 0,
	"English": 1,
	"Français": 2,
}

func _ready() -> void:
	item_selected.connect(_on_language_selected)

	clear()
	
	for lang_name in languages.keys():
		add_item(lang_name)

	I18n.load_and_set_language()
	var current_locale = TranslationServer.get_locale()
	var current_lang_name = languages.find_key(current_locale)
	if current_lang_name:
		var item_index = get_item_index(ids[current_lang_name])
		select(item_index)
	else:
		select(0)

func _on_language_selected(index: int) -> void:
	var selected_lang_name = get_item_text(index)
	
	var new_locale = languages[selected_lang_name]
	
	_on_language_changed(new_locale)

func _on_language_changed(new_language: String) -> void:
	I18n.set_and_save_language(new_language)
