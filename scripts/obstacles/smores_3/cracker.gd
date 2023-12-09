extends TileMap

var rng = RandomNumberGenerator.new()
var alive_timer = rng.randf_range(3.5, 6.5)
var dead_timer = 0
var num_players_atop = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive_timer <= 0 and dead_timer <= 0:
		self.hide()
#		get_node("CollisionShape2D").disabled = true
#		get_node("RigidBody2D/CollisionShape2D").disabled = true
		dead_timer = rng.randf_range(4.5, 7.5)
	if num_players_atop > 0:
		alive_timer -= delta * num_players_atop
		
	if dead_timer > 0:
		dead_timer -= delta
		if dead_timer <= 0:
			alive_timer = rng.randf_range(3.5, 6.5)
			self.show()
#			get_node("CollisionShape2D").disabled = false
#			get_node("RigidBody2D/CollisionShape2D").disabled = false
			

func _on_body_entered(body):
	if body is CharacterBody2D:
		num_players_atop += 1
		# add animation
		
func _on_body_exited(body):
	if body is CharacterBody2D:
		num_players_atop -= 1
		# stop animation

