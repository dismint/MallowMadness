# contains global game state variables
extends Node

var players = []
var reset = false
var num_players = 2
var player_movements = {}

# calls at the very beginning when the game starts
# to get each player we would probably have to create a screen to add players
#func _ready():
#	for i in num_players:
#		players.append(get_node("/root/Tutorial/Player"+str(i+1)))

func add_players(node):
	players = []
	for i in num_players:
		players.append(node.get_node("Player"+str(i+1)))
	print(players)

func reset_positions():
	for player in players:
		player.reset_position()
		player.reset_size()
	reset = false

func add_player_movements(player_num, up, down, left, right):
	var directions = {}
	directions[-1] = up
	directions[1] = down
	directions[-3] = left
	directions[3] = right
	player_movements[player_num] = directions
	
func get_player_directions(player_num):
	return player_movements[player_num]
	
