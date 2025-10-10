extends CharacterBody2D

@export var mask_task: MaskTask.Type = MaskTask.Type.ChopWood
@export var sprite_texture: Texture2D
@export var color: Color = Color.WHITE
@export var mask_name: String = "Mask"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	apply_mask_properties()

func apply_mask_properties():
	if not sprite:
		return

	# Apply sprite texture
	if sprite_texture:
		var sprite_frames = SpriteFrames.new()
		sprite_frames.add_animation("default")
		sprite_frames.add_frame("default", sprite_texture)
		sprite.sprite_frames = sprite_frames

	# Apply color modulation
	sprite.modulate = color

func get_mask_task() -> MaskTask.Type:
	return mask_task

func get_mask_name() -> String:
	return mask_name
