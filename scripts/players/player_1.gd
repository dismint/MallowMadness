extends MallowPlayer

@export var something : String

func _ready():
	down = "p1_down"
	up = "p1_jump"
	left = "p1_left"
	right = "p1_right"
	
	starting_position = Vector2(511, 548)
	
	player_number = 1
	
	animation_player = $AnimationPlayer
	GameState.add_player_movements(self, up, down, left, right)
