extends CharacterBody2D

class_name Player

@onready var cam: Camera2D = get_node("/root/Tutorial/Camera2D")

const TIMER = 5
const SPEED = 500.0
const JUMP_VELOCITY = -500.0
const POUND_SCALE = 0.75

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doing_pound = false
var timer = 0

# Define directions for each player
@onready var down : String
@onready var up : String
@onready var left : String
@onready var right : String

# Define reset position
@onready var starting_position : Vector2

# Define player number
@onready var player_number : int

func _physics_process(delta):
	if GameState.reset:
		GameState.reset_positions()
		return
		
	check_size(delta)

	# Add the gravity.
	if not is_on_floor():
		if doing_pound:
			velocity.y = 4 * gravity * delta
			var collision = move_and_collide(Vector2(0, velocity.y))
			if collision:
				doing_pound = false
				var collider = collision.get_collider()
				if collider.name.contains("Player"):
					collider.scale.y *= POUND_SCALE
					collider.timer = 0
				print("I collided with ", collision.get_collider().name)
			return

		if Input.is_action_just_pressed(down):
			doing_pound = true
			return
		
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed(up) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(left, right)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# focus the player position within camera view
	var cam_size = cam.get_viewport().get_visible_rect().size
	var cam_pos = cam.get_screen_center_position()
	if (cam_pos.x - cam_size.x) > position.x:
		velocity.x = 0
		position.x = (cam_pos.x - cam_size.x)
	if position.x > (cam_pos.x + cam_size.x):
		velocity.x = 0
		position.x = (cam_pos.x + cam_size.x)

	move_and_slide()

func reset_position():
	set_position(starting_position)

func check_size(delta):
	var max_pounds = 4
	var min_yscale = scale.x * pow(POUND_SCALE, 4)
	if (scale.y < min_yscale):
		scale.y = min_yscale
	
	if (scale.y == scale.x):
		return

	timer += delta
	if timer < TIMER:
		return

	reset_size()
	var collision = move_and_collide(Vector2(0, -0.1))
	if not collision:
		return

	print(collision.get_collider().name)
#	if collision.get_collider() is TileMap:
#		var tile_rid = get_last_slide_collision().get_collider_rid()
#		print(tile_rid)
#		var layer_of_collision = PhysicsServer2D.body_get_collision_layer(tile_rid)
#		print(layer_of_collision)
#		if layer_of_collision == 7:
	if collision.get_collider().name == "Ceiling":
#		GameState.reset_positions()
		GameState.reset = true
			
func reset_size():
	timer = 0
	scale.y = scale.x 
			
