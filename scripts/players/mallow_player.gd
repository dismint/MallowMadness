extends CharacterBody2D

class_name MallowPlayer

const PLAYER_UTILS = preload("player_utils.gd")

const RESET_TIME = 5
const SPEED = 500.0
const JUMP_VELOCITY = -500.0
const POUND_SCALE = 0.75
const MAX_POUNDS = 4
const TILE_SIZE = 1.75 # Number obtained through experimentation

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doing_pound = false
var curr_pound = 0
var just_expanded = 0
var timer = 0

# Define directions for each player
@export var down : String
@export var up : String
@export var left : String
@export var right : String

# Define other player attributes
@export var starting_position : Vector2
@export var player_number : int

# Animation Engine
@onready var animation_player = $AnimationPlayer

var sticking = true
var stuck_tiles = []
var stuck_players = []

func add_stuck_tile(tile):
	stuck_tiles.append(tile)
		
func is_sticking():
	return sticking

# currently checking if velocity is in that direction
# should be checking if the key is pressed
func check_move_condition(direction) -> bool:
	stuck_players = []
	for tile in stuck_tiles:
		for player in tile.get_stuck_players():
			stuck_players.append(player)
	var direction_code:int = (direction[0])*3 + (direction[1])
	for player in stuck_players:
		if player == self:
			continue
		var player_directions = GameState.get_player_directions(player)
		var player_direction_key = player_directions[direction_code]
		if not Input.is_action_pressed(player_direction_key):
			return false
	return true

func reset_position():
	PLAYER_UTILS.reset_player(self)
func reset_size():
	PLAYER_UTILS.reset_size(self)
func in_corridor():
	return scale.y == TILE_SIZE

func handle_y(delta):
	if Input.is_action_pressed(down) and check_move_condition(Vector2(0, 1)):
		print(name)
		velocity.y = 0
		doing_pound = true
	
	if not doing_pound:
		velocity.y += gravity * delta
		return

	# Player is ground-pounding
	velocity.y = 4 * gravity * delta
	var collision = move_and_collide(Vector2(0, velocity.y))
	if not collision:
		return
	
	# Player collided with something
	doing_pound = false
	velocity.y = 0
	var collider = collision.get_collider()
	if not collider.name.contains("Player"):
		return
	
	# Collided with player so squish them!
	collider.scale.y *= POUND_SCALE
	collider.curr_pound += 1
	collider.timer = 0

func should_reset_size(delta):	
	if (scale.y == scale.x):
		return false
	
	if (in_corridor()):
		return false

	timer += delta
	if timer < RESET_TIME:
		return false

	timer = 0
	return true

func do_expand_collision():
	# Add negligible movement to get collisions
	var collision = move_and_collide(Vector2(0, -0.1))
	if not collision:
		return
	
	# We collided with something
	var collider = collision.get_collider()

	# We collided with a player, so let's launch them!
	if collider.name.contains("Player"):
		PLAYER_UTILS.launch_player(collider, JUMP_VELOCITY * 0.5 * just_expanded)
		return
	
	# TODO Should we really kill them or not if squashed under ceiling? Playtest!!!
	# We collided with a ceiling, let's reset the game.
#	if collider.name == "Ceiling":
#		GameState.reset = true
#		return
	
	# We collided with a ceiling, let's squish ourselves to fit exactly into the corridor!
	if collider.name == "Ceiling":
		scale.y = TILE_SIZE
		curr_pound = MAX_POUNDS - 1 # Allow players to pound one more time to reset
		return
	
	# Else you just die
	GameState.reset = true

func _physics_process(delta):
	if GameState.reset or (curr_pound > MAX_POUNDS):
		GameState.reset_positions()
		return
		
	if should_reset_size(delta):
		just_expanded = curr_pound # Save number of pounds for expand collision
		PLAYER_UTILS.reset_size(self)
		return

	if bool(just_expanded): # We need to process expand collisions on the next frame
		do_expand_collision()
		just_expanded = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var can_move_left = false
	var can_move_right = false
	if Input.is_action_pressed(left):
		can_move_left = check_move_condition(Vector2(-1, 0))
		if can_move_left:
			velocity.x = -1 * SPEED
			animation_player.play("walk_right")
			$Sprite2D.flip_h = true
	if Input.is_action_pressed(right):
		can_move_right = check_move_condition(Vector2(1, 0))
		if can_move_right:
			velocity.x = 1 * SPEED
			animation_player.play("walk_right")
			$Sprite2D.flip_h = false
	if not (Input.is_action_pressed(left) or Input.is_action_pressed(right)) or not (can_move_left or can_move_right):
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation_player.play("idle")
		
	# Handle the gravity.
	if is_on_floor():
		if not in_corridor() and Input.is_action_pressed(up) and check_move_condition(Vector2(0, -1)):
			velocity.y = JUMP_VELOCITY
	else:
		handle_y(delta)
	
	var old_velocity = Vector2(velocity.x, velocity.y)
	move_and_slide()
#	velocity = old_velocity # Prevents gravity buildup on move_and_slide()
