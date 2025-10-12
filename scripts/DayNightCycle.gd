extends CanvasModulate

@onready var gamemaster = $"../../GameMaster"
@onready var time = 0
@onready var actual_state = null
@onready var timer = 0.0

@export var time_to_switch : float
@export var time_curve : Curve
@export var time_curve_reversed : Curve
@export var moon_normal : GradientTexture1D

signal midday()
signal midnight()

func _ready() -> void:
	time_curve.max_domain = time_to_switch
	time_curve.add_point(Vector2(time_to_switch, 1),0,0,Curve.TANGENT_FREE,Curve.TANGENT_FREE)
	time_curve_reversed.max_domain = time_to_switch
	time_curve_reversed.add_point(Vector2(time_to_switch, 0),0,0,Curve.TANGENT_FREE,Curve.TANGENT_FREE)

func _process(delta: float) -> void:
	if actual_state != null :
		if actual_state == "day_to_night" :
			_day_to_night_state(delta)
		elif actual_state == "night_to_day" :
			_night_to_day_state(delta)

func _day_to_night_state(delta):
	timer = timer + delta
	self.color = moon_normal.gradient.sample(time_curve_reversed.sample(timer))
	print_debug(timer/time_to_switch)
	if timer >= time_to_switch :
		midnight.emit()
		timer = 0
		actual_state = null

func _night_to_day_state(delta):
	timer = timer + delta
	self.color = moon_normal.gradient.sample(time_curve.sample(timer))
	if timer >= time_to_switch :
		midday.emit()
		timer = 0
		actual_state = null
	pass

func _new_state(new_state: String):
	actual_state = new_state

func _on_game_master_end_day() -> void:
	timer = 0
	_new_state("day_to_night")
	pass # Replace with function body.


func _on_game_master_end_night() -> void:
	timer = 0
	_new_state("night_to_day")
	pass # Replace with function body.
