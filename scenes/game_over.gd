extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_finish_line_finish_game():
	$clear2.show()
	$menu2.show()
	$retry2.show()
