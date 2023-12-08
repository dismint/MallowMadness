extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.add_players(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Label.text = "%d:%02d" % [floor($Timer.time_left / 60), int($Timer.time_left) % 60]
	$Label.position = $camera_both.screen_position
	$Label.position.y -= $camera_both.screen_size.y * 0.5

func _on_timer_timeout():
	GameState.reset_positions()
	$Timer.start($Timer.LEVEL_DURATION)
