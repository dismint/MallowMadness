extends CharacterBody2D

class_name MallowPlayer

const PLAYER_UTILS = preload("player_utils.gd")

const RESET_TIME = 5
const SPEED = 500.0
const JUMP_VELOCITY = -500.0
const POUND_SCALE = 0.75
const MAX_POUNDS = 4

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doing_pound = false
var curr_pound = 0
var timer = 0

# Define directions for each player
@onready var down : String
@onready var up : String
@onready var left : String
@onready var right : String

# Define other player attributes
@onready var starting_position : Vector2
@onready var player_number : int

func reset_position():
	PLAYER_UTILS.reset_player(self)
func reset_size():
	PLAYER_UTILS.reset_size(self)

func handle_gravity(delta):
	if Input.is_action_just_pressed(down):
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
	print("I collided with ", collision.get_collider().name) # For debugging
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

	timer += delta
	if timer < RESET_TIME:
		return false

	timer = 0
	return true

func do_expand():
	PLAYER_UTILS.reset_size(self)
	var collision = move_and_collide(Vector2(0, -0.1))
	if not collision:
		return

	print(collision.get_collider().name)
	if collision.get_collider().name == "Ceiling":
		GameState.reset = true

func _physics_process(delta):
	if (curr_pound > MAX_POUNDS):
		GameState.reset = true

	if GameState.reset:
		GameState.reset_positions()
		return
		
	if should_reset_size(delta):
		do_expand()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(left, right)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle jump or add the gravity.
	if is_on_floor():
		if Input.is_action_just_pressed(up):
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = 0
	else:
		handle_gravity(delta)
	
	var old_velocity = Vector2(velocity.x, velocity.y)
	move_and_slide()
	velocity = old_velocity # Prevents gravity buildup on move_and_slide()
