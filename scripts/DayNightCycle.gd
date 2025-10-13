extends CanvasModulate

#region @Onready
@onready var gamemaster = $"../../GameMaster"
@onready var time = 0
@onready var actual_state = null
@onready var timer = 0.0
#endregion

#region @Export
@export var day_lenght : float = 5.0
@export var time_to_switch : float
@export var time_curve : Curve
@export var time_curve_reversed : Curve
#endregion

#region Signals
signal midnight()
#endregion

#region Cycle lunaire
@export var moon_normal : GradientTexture1D
#endregion

# Feat du Day/Night cycler :
# 2 courbes (time_curve et time_curve_reversed) servant à regler la "teinte" du jour ou de la nuit.
# 1 predisposition à un ajout de systeme de lune (lune bleu, lune de sang, etc...).
# la durée de la journée "day_lenght" est en seconde, reglable pour changer aussi la difficulté si necessaire.
# change d'etat selon passage au jour et à la nuit. (Hardcord, a changer)
# communique avec le GameMaster par le biais de signaux.

#region _Ready / _Process
# Setup la curve, et active le timer pour la durée "day_lenght"
func _ready() -> void:
	time_curve.max_domain = time_to_switch
	time_curve.add_point(Vector2(time_to_switch, 1),0,0,Curve.TANGENT_FREE,Curve.TANGENT_FREE)
	time_curve_reversed.max_domain = time_to_switch
	time_curve_reversed.add_point(Vector2(time_to_switch, 0),0,0,Curve.TANGENT_FREE,Curve.TANGENT_FREE)
	$Timer.start(day_lenght)

# Le process ne sert qu'à lancer les fonction lors des differents états du Cycler
func _process(delta: float) -> void:
	if actual_state != null :
		if actual_state == "day_to_night" :
			_day_to_night_state(delta)
		elif actual_state == "night_to_day" :
			_night_to_day_state(delta)
#endregion

#region Etats du Cycler
# Change la couleur général du terrain (filtre) graduellement pour simuler la tombé de la nuit
# Signal egalement le Zenith de la lune à Gamemaster :
# GameMaster diras au Cycler qu'il faut passer au jours si le spawner est mort
func _day_to_night_state(delta):
	timer = timer + delta
	self.color = moon_normal.gradient.sample(time_curve_reversed.sample(timer))
	if timer >= time_to_switch :
		timer = 0
		actual_state = null
		midnight.emit()

# Change la couleur général du terrain (filtre) graduellement pour simuler le levé du soleil
# Redemarre également le timer 
func _night_to_day_state(delta):
	timer = timer + delta
	self.color = moon_normal.gradient.sample(time_curve.sample(timer))
	if timer >= time_to_switch :
		timer = 0
		actual_state = null
		$Timer.start(day_lenght)
	pass
#endregion

#region Signal catching
# A la fin du timer, change l'etat du Cycler pour signaler la fin du la journée
func _on_timer_timeout() -> void:
	$Timer.stop()
	_new_state("day_to_night")
	
# Change l'etat du cycler vers Nuit -> Jour
# Reset du timer (oui, redondant, mais curieusement j'me sens en securité avec un timer reset
func _on_game_master_end_night() -> void:
	timer = 0
	_new_state("night_to_day")
#endregion

#region Fonctions générales
# Fonction de changement d'etat
func _new_state(new_state: String):
	actual_state = new_state
#endregion
