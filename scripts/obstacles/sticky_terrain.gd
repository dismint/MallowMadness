extends Area2D

class_name StickyTerrain

var stuck_players = []
var delta

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	if bodies.size() > stuck_players.size():
		for body in bodies:
			if body.name.contains("Player"):
				if not body.is_sticking():
					stuck_players.erase(body)
				elif not (body in stuck_players):
					if stuck_players.size() == 0:
						delta = body.get_position() - position
					stuck_players.append(body)
					body.add_stuck_tile(self)
	if stuck_players:
		var first_player = stuck_players[0]
		position = first_player.get_position() - delta
			
func get_stuck_players():
	return stuck_players
