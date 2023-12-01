extends Area2D

var rng = RandomNumberGenerator.new()
var timer = rng.randf_range(3.5, 8)
var alive = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if timer <= 0:
		alive = not alive
		timer = rng.randf_range(3.5, 8)
	
	if alive:
		self.show()
		get_node("CollisionShape2D").disabled = false
		get_node("RigidBody2D/CollisionShape2D").disabled = false
	else:
		self.hide()
		get_node("CollisionShape2D").disabled = true
		get_node("RigidBody2D/CollisionShape2D").disabled = true
