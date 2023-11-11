# contains global game state variables
extends Node

var players = []
var reset = false
var num_players = 2

func _ready():
	for i in num_players:
		players.append(get_node("/root/Tutorial/Player"+str(i+1)))

func reset_positions():
	for player in players:
		player.reset_position()
		player.reset_size()
	reset = false
