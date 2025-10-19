class_name Mask extends Entity

func _ready():
	inventory_component = InventoryComponent.new(self)
	components[Component.Type.Inventory] = inventory_component
	inventory_component._ready()
	super._ready()
