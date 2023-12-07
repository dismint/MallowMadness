extends Area2D
signal finish_game
var crossed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Function to implement ui for when players clear level
func _on_body_entered(_body):
	if len(get_overlapping_bodies()) == 2:
		$WinSound.play()
		finish_game.emit()
		

# When player dies


