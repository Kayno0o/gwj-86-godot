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
