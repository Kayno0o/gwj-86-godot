extends Control


@export var totem_ui = preload("res://Ui/totem/minitotem/minitotembubble.tscn")

var ui_instance
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_instance = totem_ui.instantiate()
	add_child(ui_instance)
	pass # Replace with function body.

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton :
		if event.button_mask == 1 :
			ui_instance.switch_state()
			print(event)
	#print("viewport : " + str(viewport))
	#print("event : " + str(event))
	#print("shape idx : " + str(shape_idx))
