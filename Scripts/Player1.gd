extends CharacterBody2D

@export var camera: NodePath
@onready var cam: Camera2D = get_node("/root/Tutorial/Camera2D")
# @onready var cam_pos : Vector2 = cam.get("camera_position")

const TIMER = 5
const SPEED = 500.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doing_pound = false
var timer = 0

func check_reset_size(delta):
	if (scale.y == scale.x):
		return

	timer += delta
	if timer < TIMER:
		return

	timer = 0
	scale.y = scale.x
	var collision = move_and_collide(Vector2(0, -0.1))
	if not collision:
		return
		
	if collision.get_collider() is TileMap:
		var tile_rid = get_last_slide_collision().get_collider_rid()
		var layer_of_collision = PhysicsServer2D.body_get_collision_layer(tile_rid)
		if layer_of_collision == 3:
			_on_finish_line_finish_game()
	

func _physics_process(delta):
	check_reset_size(delta)

	# Add the gravity.
	if not is_on_floor():
		if doing_pound:
			velocity.y = 4 * gravity * delta
			var collision = move_and_collide(Vector2(0, velocity.y))
			if collision:
				doing_pound = false
				if not collision.get_collider().name.contains("Player"):
					return
				collision.get_collider().scale.y *= 0.75
#				collision.get_collider().scale.x *= 1.25
				print("I collided with ", collision.get_collider().name)
			return

		if Input.is_action_just_pressed("p1_down"):
			doing_pound = true
			return
		
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("p1_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("p1_left", "p1_right")
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

func _on_finish_line_finish_game():
	set_position(Vector2(511, 548))
