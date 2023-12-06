extends CharacterBody2D

const PATTERN = [
	Vector2(0, 1),
	Vector2(-1, 0),
	Vector2(0, -1),
	Vector2(0, -1),
	Vector2(1, 0),
	Vector2(1, 0),
	Vector2(0, 1),
	Vector2(0, 1),
	Vector2(-1, 0),
	Vector2(0, -1)
]

var pattern_idx = 0
var stuck_with = null # Variable to store nodes that this Sticky Terrain will stick to

func set_stick_velocity(vel):
	velocity = vel
	if stuck_with:
		stuck_with.set_stick_velocity(Vector2(velocity.x, velocity.y))

func _ready():
	pass

func _physics_process(_delta):
	var old_velocity = Vector2(velocity.x, velocity.y)
	move_and_slide()
	velocity = old_velocity
	
	# Don't want to detect collisions if already stuck
	if stuck_with:
		return
		
	var collision = move_and_collide(PATTERN[pattern_idx])
	pattern_idx = (pattern_idx + 1) % len(PATTERN)
	if not collision:
		return

	var collider = collision.get_collider()
	if not collider.name.contains("Sticky"):
		return
	
	# Only want to stick with terrains that have not been stuck yet
	if not collider.stuck_with:
		stuck_with = collider
