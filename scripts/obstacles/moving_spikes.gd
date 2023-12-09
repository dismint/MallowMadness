extends TileMap

var rng = RandomNumberGenerator.new()
var timer = rng.randf_range(1.5, 2)
var directions = [Vector2(1, 0), Vector2(-1, 0)]
var direction_ind : int
var moving : bool = false
var speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer < 0:
		moving = not moving
		if moving:
			timer = rng.randf_range(3, 7)
			direction_ind = int(rng.randf_range(0, 1) + 0.5)
		else: 
			timer = rng.randf_range(3, 5)
	
	if moving:
		position += directions[direction_ind] * delta * speed
		
	timer -= delta
