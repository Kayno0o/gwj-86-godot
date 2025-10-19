class_name Mask extends Entity

@onready var state_machine: StateMachine = $StateMachine

func _ready():
	inventory_component = InventoryComponent.new(self)
	components[Component.Type.Inventory] = inventory_component
	inventory_component._ready()
	super._ready()
	state_machine.ready(self)

func _physics_process(delta: float):
	state_machine.physics_process(delta)

func _process(delta: float):
	state_machine.process(delta)

	update_sprite_direction()

func update_sprite_direction():
	if velocity.length() > 10:
		# going to left/right
		if abs(velocity.x) > abs(velocity.y):
			sprite.frame = 2
			sprite.flip_h = velocity.x < 0
		else:
			# going to bottom
			if velocity.y > 0:
				sprite.frame = 0
			else:
				# going to top
				sprite.frame = 1
			sprite.flip_h = false
