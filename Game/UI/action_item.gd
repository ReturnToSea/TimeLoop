extends Control

@export var action_name: String = ""

func _ready():
	update_action()

func update_action():
	# Set ONLY the text (the sprite is already defined in the scene)
	$TextureRect/Label.text = action_name
