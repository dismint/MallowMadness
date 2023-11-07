extends TileMap

@export var activator: NodePath
@onready var activ: Activator = get_node(activator)
var speed = 13
@onready var new_position : Vector2


func _physics_process(_delta):
	if activ.activated:
		position = position.move_toward(new_position, _delta * speed)
		
	if (position - new_position).length() <= 0.2:
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	# when button is pressed slider should move up
	new_position = Vector2(position.x, position.y * -2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
