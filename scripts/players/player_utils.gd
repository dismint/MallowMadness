
static func reset_player(player: CharacterBody2D):
	player.doing_pound = false
	player.timer = 0
	player.velocity.x = 0
	player.velocity.y = 0
	player.set_position(player.starting_position)

static func reset_size(player: CharacterBody2D):
	player.scale.y = player.scale.x 
	player.curr_pound = 0

static func launch_player(player: CharacterBody2D, y_dist):
	player.velocity.y += y_dist
