extends TileMap

@export var activator: NodePath
@onready var activ: Activator = get_node(activator)
var speed = 100
@onready var new_position : Vector2
@onready var rest_position : Vector2


func _physics_process(_delta):
	if activ.activated:
		position = position.move_toward(new_position, _delta * speed)
	else:
		position = position.move_toward(rest_position, _delta * speed)
		

# Called when the node enters the scene tree for the first time.
func _ready():
	# when button is pressed slider should move up
	new_position = Vector2(position.x, position.y -120)
	rest_position = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
