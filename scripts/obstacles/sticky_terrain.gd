extends RigidBody2D

var stuck_to = null # Variable to store node that this Sticky Terrain will stick to
var delta_position = null # Variable to store amount of following space between this and stuck_to

func set_stuck_to(body):
	if stuck_to:
		return
	stuck_to = body
	delta_position = position - body.get_position()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(1)

func _physics_process(_delta):
	if not stuck_to:
		return

	position = stuck_to.get_position() - delta_position

func _on_body_entered(body):
	print(body.name)
	if stuck_to:
		return
	
	if (body.name.contains("Sticky")):
		if body.stuck_to:
			set_stuck_to(body)
			print("I collided with a sticky terrain.")
		return
	
	if (body.name.contains("Player")):
		print("I collided with a player.")
		set_stuck_to(body)
		return
		
