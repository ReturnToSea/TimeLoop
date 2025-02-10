extends CharacterBody2D

@export var move_speed: int = 16  # Distance to move per step (16 pixels for your tile size)
@export var tilemaps_parent: Node2D  # Parent that contains your TileMapLayer nodes
var is_moving: bool = false  # Track if the player is currently moving

@onready var sprite = $AnimatedSprite2D

# Array to cache all TileMapLayer nodes
var tilemap_layers: Array = []

func _ready():
	# Cache all TileMapLayer nodes under tilemaps_parent and print their names.
	for child in tilemaps_parent.get_children():
		if child is TileMapLayer:
			tilemap_layers.append(child)
			print("Found TileMapLayer: ", child.name)

func _physics_process(delta):
	if not is_moving:
		handle_input()


func move_player(direction: Vector2):
	if not is_moving:
		var target_position = position + (direction * move_speed)
		if is_tile_walkable(target_position):
			move_to(target_position)
			play_animation(direction)
			

func play_animation(direction: Vector2):
	var animation_name = "idle"
	if direction.x > 0:
		animation_name = "right"
	elif direction.x < 0:
		animation_name = "left"
	elif direction.y > 0:
		animation_name = "down"
	elif direction.y < 0:
		animation_name = "up"
	
	sprite.play(animation_name)


func handle_input():
	var direction = Vector2.ZERO
	var animation_name = "idle"

	if Input.is_action_pressed("Right"):
		direction.x += 1
		animation_name = "right"
	elif Input.is_action_pressed("Left"):
		direction.x -= 1
		animation_name = "left"
	elif Input.is_action_pressed("Down"):
		direction.y += 1
		animation_name = "down"
	elif Input.is_action_pressed("Up"):
		direction.y -= 1
		animation_name = "up"

	if direction != Vector2.ZERO:
		var target_position = position + (direction * move_speed)
		if is_tile_walkable(target_position):
			play_animation(direction)
			move_to(target_position)

func is_tile_walkable(target_position: Vector2) -> bool:
	# Iterate over each TileMapLayer node
	for layer in tilemap_layers:
		# Convert the target position to this layer's local space.
		var local_position = layer.to_local(target_position)
		# Get the tile coordinates in this layer.
		var tile_coords = layer.local_to_map(local_position)
		
		# Get the tile data at these coordinates.
		# (Assuming each TileMapLayer is one layer so no need for a layer index parameter.)
		var tile_data = layer.get_cell_tile_data(tile_coords)
		
		if tile_data:
			# Check if the tile has a custom property "non-walkable".
			if tile_data.get_custom_data("non-walkable"):
				print("Cant walk here!")
				return false  # If any tile is non-walkable, return false.
	return true  # All checked tiles are walkable.

func move_to(target_position: Vector2):
	is_moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, 0.2)  # Adjust duration as needed
	tween.tween_callback(func(): is_moving = false)  # Mark movement as complete
