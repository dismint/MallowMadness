extends CharacterBody2D
signal cross_finish_1


const SPEED = 500.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doing_pound = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if doing_pound:
			velocity.y = 4 * gravity * delta
			var collision = move_and_collide(Vector2(0, velocity.y))
			if collision:
				doing_pound = false
				print("I collided with ", collision.get_collider().name)
			return

		if Input.is_action_just_pressed("p2_down"):
			doing_pound = true
			return

		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("p2_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("p2_left", "p2_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
