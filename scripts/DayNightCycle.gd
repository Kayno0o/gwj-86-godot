extends CanvasModulate

@onready var gamemaster = $"../../GameMaster"
@onready var time = 0
@onready var actual_state = null
@onready var timer = 0.0

@export var day_lenght : float = 5.0
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
	$Timer.start(day_lenght)

func _process(delta: float) -> void:
	if actual_state != null :
		if actual_state == "day_to_night" :
			_day_to_night_state(delta)
		elif actual_state == "night_to_day" :
			_night_to_day_state(delta)

func _day_to_night_state(delta):
	timer = timer + delta
	self.color = moon_normal.gradient.sample(time_curve_reversed.sample(timer))
	if timer >= time_to_switch :
		timer = 0
		actual_state = null
		midnight.emit()

func _night_to_day_state(delta):
	timer = timer + delta
	self.color = moon_normal.gradient.sample(time_curve.sample(timer))
	if timer >= time_to_switch :
		timer = 0
		actual_state = null
		$Timer.start(day_lenght)
		midday.emit()
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


func _on_timer_timeout() -> void:
	$Timer.stop()
	_new_state("day_to_night")
