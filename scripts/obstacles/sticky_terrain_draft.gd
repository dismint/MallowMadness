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
	
#extends Area2D
#
#class_name Sticky
#
#var following = null
#var delta_position = Vector2(0, 0)
#
#func _ready():
#	pass
#
#func _physics_process(_delta):
#	if following:
#		follow_player()
#
#func follow_player():
#	# need to calculate distance such that it doesn't overlap with other obstacles
#	var prev_position = position
#	position = following.position - delta_position
##	var rigid_body_node = get_node("RigidBody2D/CollisionShape2D")
##	rigid_body_node.position += position - prev_position
#
##func _on_area_entered(area):
##	if not following and area is Sticky:
##		following = area.following
##		delta_position = following.get_position() - position
##		follow_player()
##
##func _on_body_entered(body):
##	if not following and body.name.contains("Player"):
##		var rigid_body_node = get_node("RigidBody2D")
##		body.add_stuck_tile(rigid_body_node)
##
##		following = body
##		delta_position = body.get_position() - position
##		follow_player()
#
#
