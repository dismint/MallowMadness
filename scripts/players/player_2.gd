extends MallowPlayer

func _ready():
	down = "p2_down"
	up = "p2_jump"
	left = "p2_left"
	right = "p2_right"
	
	starting_position = Vector2(701, 548)

	player_number = 2
	
	GameState.add_player_movements(self, up, down, left, right)
