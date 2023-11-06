extends Activator

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	if bodies.size() == 0:
		activated = false
	for body in bodies:
		if body.name == "Player" && Input.is_action_pressed("ui_accept"):
			activated = true
