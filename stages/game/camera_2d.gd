extends Camera2D

const MIN_ZOOM: float = 0.2
const MAX_ZOOM: float = 1.0
const ZOOM_INCREMENT: float = 0.05
const ZOOM_RATE: float = 8.0

var _target_zoom: float = 1.0
var limit_x = 15000
var limit_y = 8000
var cam_speed = 5

func _physics_process(delta: float) -> void:
	zoom = lerp(zoom, _target_zoom * Vector2.ONE, ZOOM_RATE * delta)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("go up") :
		if _can_move(Vector2(0, 1)):
			position.y -= cam_speed / zoom.x
	if Input.is_action_pressed("go down") :
		if _can_move(Vector2(0, -1)):
			position.y += cam_speed / zoom.x
	if Input.is_action_pressed("go right") :
		if _can_move(Vector2(-1, 0)):
			position.x += cam_speed / zoom.x
	if Input.is_action_pressed("go left") :
		if _can_move(Vector2(1, 0)):
			position.x -= cam_speed / zoom.x

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion :
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE :
			if _can_move(event.relative) :
				position -= event.relative / zoom
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

func _can_move(relative : Vector2) -> bool :
	var cam_border = get_viewport_rect().size / 2
	var can_move = false
	if relative.x > 0 and relative.y > 0 :
		if position.x - cam_border.x > -limit_x and position.y - cam_border.y > -limit_y :#haut gauche
			can_move = true
	elif relative.x > 0 and relative.y < 0 :
		if position.x - cam_border.x > -limit_x and position.y + cam_border.y < limit_y :#bas gauche
			can_move = true
	elif relative.x < 0 and relative.y < 0 :
		if position.x + cam_border.x < limit_x and position.y + cam_border.y < limit_y : #bas droite
			can_move = true
	elif relative.x < 0 and relative.y > 0 :
		if position.x + cam_border.x < limit_x and position.y - cam_border.y > -limit_y :#haut droite
			can_move = true
	elif relative.x > 0 and relative.y == 0 : #gauche
		if position.x - cam_border.x > -limit_x :
			can_move = true
	elif relative.x < 0 and relative.y == 0 : #droite
		if position.x + cam_border.x < limit_x :
			can_move = true
	elif relative.x == 0 and relative.y < 0 : #bas
		if position.y + cam_border.y < limit_y :
			can_move = true
	elif relative.x == 0 and relative.y > 0 : # haut
		if position.y - cam_border.y > -limit_y :
			can_move = true
	return can_move
