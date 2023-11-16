extends Camera2D

@export var player1: CharacterBody2D
@export var player2: CharacterBody2D
var screen_size: Vector2
var screen_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size
	screen_position = self.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (is_instance_valid(player1) and is_instance_valid(player2)):
		self.global_position = (player1.global_position + player2.global_position) * 0.5

		var zoom_factor1 = abs(player1.global_position.x-player2.global_position.x)/(1920-100)
		var zoom_factor2 = abs(player1.global_position.y-player2.global_position.y)/(1080-100)
		var zoom_factor = max(1-max(zoom_factor1, zoom_factor2), 0.5)
		self.zoom = Vector2(zoom_factor, zoom_factor)
		
		screen_size = get_viewport().get_visible_rect().size
		screen_position = self.global_position
		
