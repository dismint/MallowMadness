extends CharacterBody2D

class_name MallowPlayer

const PLAYER_UTILS = preload("player_utils.gd")

const SPEED = 500.0
const JUMP_VELOCITY = -500.0
const POUND_SCALE = 0.75
const POUND_MIN = 1
const NUM_POUND_SPRITES = 4 # Use later for making pound sprites

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doing_pound = false
var can_pound = true

# Define variables for specific player
var down : String
var up : String
var left : String
var right : String
var player_number : int

# Init other player attributes
@onready var starting_position = Vector2(position.x, position.y)
@onready var starting_scale = Vector2(scale.x, scale.y)

# Animation Engine
@onready var animation_player = $AnimationPlayer

var sticking = true
var stuck_tiles = []
var stuck_players = []

# Accessor functions
func add_stuck_tile(tile):
	stuck_tiles.append(tile)
func is_sticking():
	return sticking
func reset_position():
	PLAYER_UTILS.reset_player(self)
func reset_size():
	PLAYER_UTILS.reset_size(self)

# Given direction, returns true iff player can move in that direction while being stuck
func not_stuck(direction) -> bool:
	stuck_players = []
	for tile in stuck_tiles:
		for player in tile.get_stuck_players():
			stuck_players.append(player)
	var direction_code:int = (direction[0])*3 + (direction[1])
	for player in stuck_players:
		if PLAYER_UTILS.player_equals(player, self):
			continue
		var player_direction_key = GameState.get_player_directions(player)[direction_code]
		if not Input.is_action_pressed(player_direction_key):
			return false
	return true

func do_ground_pound(delta):
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
	collider.scale.x *= 1 / POUND_SCALE

func _ready():
	GameState.add_player_movements(self, up, down, left, right)

func _physics_process(delta):
	if GameState.reset or scale.x < POUND_MIN or scale.y < POUND_MIN:
		GameState.reset_positions()
		return

	# Input.is_action_pressed instead of Input.is_action_just_pressed allows margin of error
	# when players try to move when pressing the same movement keys at the same time.
	# Uses Input.is_action_just_released to block 2nd ground-pound.
	if Input.is_action_just_released(down):
		can_pound = true

	# Handle x-movement
	if Input.is_action_pressed(left) and not_stuck(Vector2(-1, 0)):
		velocity.x = -1 * SPEED
		animation_player.play("walk_right")
		$Sprite2D.flip_h = true
	elif Input.is_action_pressed(right) and not_stuck(Vector2(1, 0)):
		velocity.x = 1 * SPEED
		animation_player.play("walk_right")
		$Sprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation_player.play("idle")
		
	# Handle y-movement
	if is_on_floor():
		if Input.is_action_pressed(up) and not_stuck(Vector2(0, -1)):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_pressed(down) and not_stuck(Vector2(0, 1)) and can_pound:
			velocity.y = 0
			doing_pound = true
			can_pound = false

		if not doing_pound:
			velocity.y += gravity * delta # Add gravity for free-fall
		else:
			do_ground_pound(delta)

	# Using this player's current velocities, move them
	var old_velocity = Vector2(velocity.x, velocity.y)
	move_and_slide()
	velocity = old_velocity # Prevents gravity buildup on move_and_slide()
