extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
#	get_parent().get_node('FinishLine').finish_game.connect(_on_finish_line_finish_game)
	hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_finish_line_finish_game():
	show()
