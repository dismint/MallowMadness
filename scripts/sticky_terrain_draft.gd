extends Area2D

class_name Sticky

var following = null
var delta_position = Vector2(0, 0)

func _ready():
	print("hey")

func _physics_process(_delta):
	if following:
		follow_player()
	
func follow_player():
	# need to calculate distance such that it doesn't overlap with other obstacles
	var prev_position = position
	position = following.position - delta_position
#	var rigid_body_node = get_node("RigidBody2D/CollisionShape2D")
#	rigid_body_node.position += position - prev_position
	
func _on_area_entered(area):
	if not following and area is Sticky:
		following = area.following
		delta_position = following.get_position() - position
		follow_player()

func _on_body_entered(body):
	if not following and body.name.contains("Player"):
		var rigid_body_node = get_node("RigidBody2D")
		body.add_stuck_tile(rigid_body_node)
		
		following = body
		delta_position = body.get_position() - position
		follow_player()

