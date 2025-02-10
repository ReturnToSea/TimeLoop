extends Control

@export var action_item_scene: PackedScene  # Assign this in the editor!
@export var player_character: CharacterBody2D
@onready var action_list = $PanelContainer/ScrollContainer/VBoxContainer

func _ready():
	$Left.pressed.connect(_on_left_button_pressed)
	$Right.pressed.connect(_on_right_button_pressed)
	$Execute.pressed.connect(_on_execute_button_pressed)  # Add this line

func _on_left_button_pressed():
	add_action_to_list("Left")

func _on_right_button_pressed():
	add_action_to_list("Right")

func add_action_to_list(action_name: String):
	if action_item_scene == null:
		push_error("Action Item Scene is not set!")
		return

	var new_action = action_item_scene.instantiate()
	new_action.action_name = action_name  # Set the text
	new_action.update_action()  # Refresh the display
	action_list.add_child(new_action)

func _on_execute_button_pressed():
	# Loop through all actions in the list and execute them
	#for action in action_list.get_children():
		#execute_action(action.action_name)
	
	var first_action = action_list.get_child(0)
	if action_list.get_child_count() > 0:
		execute_action(first_action.action_name)
		# Optionally remove the executed action from the list
		first_action.queue_free()

func execute_action(action_name: String):
	match action_name:
		"Left":
			move_character(Vector2(-1, 0))  # Move left
		"Right":
			move_character(Vector2(1, 0))  # Move right
		_:
			push_error("Unknown action: ", action_name)

func move_character(direction: Vector2):
	if player_character:
		# Call the move_player function from the player script
		player_character.move_player(direction)
