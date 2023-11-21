# contains global game state variables
extends Node

var players = []
var reset = false
var num_players = 2

# calls at the very beginning when the game starts
# to get each player we would probably have to create a screen to add players
#func _ready():
#	for i in num_players:
#		players.append(get_node("/root/Tutorial/Player"+str(i+1)))

func add_players():
	for i in num_players:
		players.append(get_node("/root/Tutorial/Player"+str(i+1)))

func reset_positions():
	for player in players:
		# player.reset_position()
		player.reset_size()
	reset = false
