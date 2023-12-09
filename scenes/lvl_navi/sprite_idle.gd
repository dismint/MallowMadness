extends Sprite2D
@export var flip: int


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")
	if flip == 1:
		flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
