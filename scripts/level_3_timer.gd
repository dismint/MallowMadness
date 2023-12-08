extends Timer

const LEVEL_DURATION = 90 # Seconds


# Called when the node enters the scene tree for the first time.
func _ready():
	start(LEVEL_DURATION)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
