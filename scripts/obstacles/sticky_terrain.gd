extends Area2D

var following
var delta_position
var collision_disable

func _on_area_entered(area):
	if area.name.contains("Sticky") and area.following:
		following = area.following
		delta_position = following.position - position
		collision_disable = true
		
func _process(_delta):
	if following:
		follow_player()
	if collision_disable:
		disable_collision()
		collision_disable = false
		
func disable_collision():
	get_node("CollisionShape2D").disabled = true
	get_node("RigidBody2D/CollisionShape2D").disabled = true
	
	
func follow_player():
	position = following.position - delta_position
	


#extends Area2D
#
#@export var bgm : AudioStreamPlayer2D
#
#const PATTERN = [
#	Vector2(-1, 0),
#	Vector2(0, -1),
#	Vector2(0, -1),
#	Vector2(1, 0),
#	Vector2(1, 0),
#	Vector2(0, 1),
#	Vector2(0, 1),
#	Vector2(-1, 0),
#]
#
#var pattern_idx = 0
#var stuck_with = null # Variable to store node that this Sticky Terrain will stick to
#var delta_position = 0 # Variable to store distance adjustment away from stuck_with
#var the_sticky_one = false # Variable used so sticky happens one-way, DAG
#
#func set_stick_position(pos):
#	position = pos - delta_position
#	if stuck_with:
#		stuck_with.set_stick_position(position)
#
#func _ready():
#	pass
#
#func _physics_process(delta):
#	# Maybe we don't need this but it looks cool
#	position += PATTERN[pattern_idx]
#	pattern_idx = (pattern_idx + 1) % len(PATTERN)
#
#func _on_area_entered(area):
#	# Sticky terrain can only stick to new sticky terrain!
#	if the_sticky_one and area.name.contains("Sticky") and not area.the_sticky_one:
#		stuck_with = area
#		area.delta_position = position - area.get_position()
##		bgm.volume_db += 0.1
#
#func _on_body_entered(body):
#	# Sticky terrain cannot unstick!
#	if not (the_sticky_one or stuck_with) and body.name.contains("Player"):
#		body.stuck_with.append(self)
#		delta_position = body.get_position() - position
#		the_sticky_one = true
##		bgm.volume_db += 0.1
