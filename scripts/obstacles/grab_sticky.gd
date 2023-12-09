extends Area2D

var delta_position
var following

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if delta_position:
		follow_player()
	
func follow_player():
	position = following.position - delta_position
	
func _on_body_entered(body):
	# Sticky terrain cannot unstick!
	if body.name.contains("Player"):
		following = body
		delta_position = body.get_position() - position
#		bgm.volume_db += 0.1


