extends Area2D
signal finish_game
var crossed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_body_entered(_body):
	crossed += 1
	
	if crossed == 2:
		if len(get_overlapping_bodies()) == 2:
			finish_game.emit()
			
			get_tree().change_scene_to_file("res://scenes/lvl_navi/level_menu.tscn")
			print('game finished!')
		crossed = 0
