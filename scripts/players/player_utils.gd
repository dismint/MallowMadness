
static func reset_size(player: MallowPlayer):
	player.scale = player.original_scale

static func reset_player(player: MallowPlayer):
	player.doing_pound = false
	player.velocity.x = 0
	player.velocity.y = 0
	player.set_position(player.starting_position)

static func player_equals(p1: MallowPlayer, p2: MallowPlayer):
	return p1.player_number == p2.player_number

# We've removed the launching feature for now.
#static func launch_player(player: CharacterBody2D, y_dist):
#	player.velocity.y += y_dist
