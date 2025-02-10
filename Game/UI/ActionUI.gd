extends Control

@export var action_item_scene: PackedScene  # Assign this in the editor!
@onready var action_list = $ScrollContainer/VBoxContainer

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
	execute_action(first_action.action_name)
	# Optionally remove the executed action from the list
	first_action.queue_free()

func execute_action(action_name: String):
	match action_name:
		"Left":
			print("Hi")  # Replace with your "Left" action logic
		"Right":
			print("Bye")  # Replace with your "Right" action logic
		_:
			push_error("Unknown action: ", action_name)
