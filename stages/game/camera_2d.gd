extends Camera2D

const MIN_ZOOM: float = 0.2
const MAX_ZOOM: float = 1.0
const ZOOM_INCREMENT: float = 0.05
const ZOOM_RATE: float = 8.0

var _target_zoom: float = 1.0

func _physics_process(delta: float) -> void:
	zoom = lerp(zoom, _target_zoom * Vector2.ONE, ZOOM_RATE * delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion :
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE :
			position -= event.relative / zoom
			print(event.position)
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_mask == 16 :
				zoom_in()
			if event.button_mask == 8 :
				zoom_out()
			if event.button_index == 3 :
				zoom_in_click()
		if event.is_released():
			if event.button_index == 3 :
				zoom_out_click()

func zoom_in() -> void :
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)

func zoom_out() -> void :
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)

func zoom_in_click() -> void :
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT * zoom.x, MIN_ZOOM - ZOOM_INCREMENT)
	set_physics_process(true)

func zoom_out_click() -> void :
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT * zoom.x, MAX_ZOOM)
	set_physics_process(true)
