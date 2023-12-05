extends CanvasLayer
var currently_paused = false
var stop_pause = false



# Called when the node enters the scene tree for the first time.
func _ready():
	# Sense for game over signal so that the pause screen functionality can be 
	# stopped
	get_parent().get_node('FinishLine').finish_game.connect(_on_finish_line1_finish_game)
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not stop_pause:
		if Input.is_action_just_pressed("pause"):
			if not currently_paused:
				get_tree().paused = true
				
				currently_paused = true
				show()
			else:
				get_tree().paused = false
				
				currently_paused = false
				hide()
			

func _on_finish_line1_finish_game():
	stop_pause = true
