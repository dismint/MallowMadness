extends CharacterBody2D

class_name MallowPlayer

const PLAYER_UTILS = preload("player_utils.gd")

const SPEED = 500.0
const JUMP_VELOCITY = -500.0
const PRESS_MIN = 5
const PRESS_SCALE = 0.9
const PRESS_SPEED = 300.0
const BONUS_SCALE = 50
const POUND_SCALE = 0.8
const POUND_MIN = 2 # It looks like this number is min before we get weird bugs
const NUM_POUND_SPRITES = 4 # Use later for making pound sprites

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doing_pound = false
var can_pound = true
var pound_lock = false
var press_lock = false
var scale_mag = 0

# Current move_and_slide() has a carrying bug. Use these variables to hack it
var carrying = false
var carrier = null

# Sticky
var stuck_with = []

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

# Sets the player this player landed on as carrying
func set_carrying():
	# Check if player is landing on something
	var collision = move_and_collide(Vector2(0, 1))
	if not collision:
		return
	
	# Player collided onto something
	var collider = collision.get_collider()
	if not collider.name.contains("Player"):
		# We jumped off the carrier, reset attributes
		carrying = false
		if carrier:
			carrier.carrying = false
			carrier = null
		return
	
	# Collided with player, so set corresponding attributes
	carrier = collider
	carrier.carrying = true

# Given direction, returns node that this player pressed on
func get_pressed_node(direction):
	# Check if player is moving into something
	var collision = move_and_collide(direction)
	if not collision:
		return null
	
	# Player collided with something
	var collider = collision.get_collider()
	if collider.name.contains("Hazard"):
		GameState.reset_positions()
		return null
	
	# We must be pressing a node
	return collider

func change_size(vertical):
	if vertical:
		scale.x *= POUND_SCALE
		scale.y *= 1 / POUND_SCALE
		scale_mag += 1
	else:
		scale.y *= POUND_SCALE
		scale.x *= 1 / POUND_SCALE
		scale_mag -= 1

func do_press(key, dir, collider):
	if not collider:
		return
	
	# We collided with a Sticky object so let's grab it
	if collider.name.contains("Sticky"):
		if not collider.stuck_with:
			stuck_with.append(collider)
			collider.delta_position = 1.1 * (collider.get_position() - position)
		return

	if not collider.name.contains("Player"):
		return

	# Collided with player, so check if player collides with wall
	var collision_2 = collider.move_and_collide(dir)
	if not collision_2:
		return
	
	# Collided player collided with something
	var collider_2 = collision_2.get_collider()
	if not collider_2.name.contains("Map"):
		return
	
	press_lock = true
	var press_scale = 1 if key == left else -1
	velocity.x = press_scale * PRESS_SPEED
	collider.change_size(true)

func do_ground_pound(delta):
	# Player is ground-pounding
	velocity.y = 1 * gravity * delta
	var collision = move_and_collide(Vector2(0, velocity.y))
	if not collision:
		return
	
	# Player collided with something
	doing_pound = false
	pound_lock = true
	velocity.y += 2 * gravity * delta
	velocity.x = 0
	var collider = collision.get_collider()
	if not collider.name.contains("Player"):
		return
	
	# Collided with player so squish them!
	collider.change_size(false)
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "pound":
		pound_lock = false
	
func _ready():
	GameState.add_player_movements(player_number, up, down, left, right)

func _physics_process(delta):
	# Keep track of which animation we should be doing
	var animation = ""
	var frame = -1
	
	# Useful constants
	var LEFT_PRESS = Input.is_action_pressed(left)
	var RIGHT_PRESS = Input.is_action_pressed(right)
	var UP_PRESS = Input.is_action_pressed(up)
	var DOWN_PRESS = Input.is_action_pressed(down)
	
	# print(player_number, scale)
	if GameState.reset or scale.x < POUND_MIN or scale.y < POUND_MIN:
		# print(player_number, "resetting")
		GameState.reset_positions()
		return
	
	if press_lock:
		if abs(velocity.x) < PRESS_MIN:
			press_lock = false
			return
		velocity.x *= PRESS_SCALE
		velocity.y += gravity * delta # Add gravity for free-fall
		move_and_slide()
		return

	# Input.is_action_pressed instead of Input.is_action_just_pressed allows margin of error
	# when players try to move when pressing the same movement keys at the same time.
	if Input.is_action_just_pressed(down):
		can_pound = true

	# Handle x-movement
	if not pound_lock:
		if LEFT_PRESS and not carrying:
			velocity.x = -1 * SPEED
			animation = "walk"
			do_press(left, Vector2(-1, 0), get_pressed_node(Vector2(-1, 0)))
		elif RIGHT_PRESS and not carrying:
			velocity.x = 1 * SPEED
			animation = "walk"
			do_press(right, Vector2(1, 0), get_pressed_node(Vector2(1, 0)))
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# Handle y-movement
		if is_on_floor():
			velocity.y = 0
			if UP_PRESS and not carrying:
				velocity.y = JUMP_VELOCITY - BONUS_SCALE * scale_mag
		else:
			# In air so slow down movement
			velocity.x /= 1.5
			# Set it to in air animation
			animation = "set"
			if velocity.y < 0:
				frame = 15
			else:
				frame = 0
				
			if DOWN_PRESS and can_pound:
				velocity.y = 0
				doing_pound = true
				can_pound = false

			if not doing_pound:
				velocity.y += gravity * delta # Add gravity for free-fall
			else:
				do_ground_pound(delta)

		# Block instance where player can carry another player
		set_carrying()

	# Using this player's current velocities, move them
	var old_velocity = Vector2(velocity.x, velocity.y)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name.contains("Hazard"):
			GameState.reset_positions()
			return
		elif collision.get_normal().y == 1:
			old_velocity.y = 0 # If we hit ceiling, want to reset y

	velocity = old_velocity # Prevents gravity buildup on move_and_slide()

	# Update sticky nodes to tag along
	for sticky in stuck_with:
		sticky.set_stick_position(position)
	
	# Handle animations
	if pound_lock:
		animation_player.play("pound")
	elif animation == "walk":
		animation_player.play("walk")
	elif animation == "set":
		animation_player.stop(true)
		$Sprite2D.frame = frame
	else:
		animation_player.play("idle")
		
	# Handle flips
	if LEFT_PRESS:
		$Sprite2D.flip_h = true
	elif RIGHT_PRESS:
		$Sprite2D.flip_h = false
	
	for tile in stuck_tiles:
		tile.position += velocity * delta
#		tile.apply_central_force(velocity.normalized() * 20)
