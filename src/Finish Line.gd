extends Area2D
signal finish_game
var crossed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body):
	crossed += 1
	
	if crossed == 3:
		finish_game.emit()
		crossed = 1
