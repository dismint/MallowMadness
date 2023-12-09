extends Sprite2D
@export var spriteFrame: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_level_button_pressed():
	pass


func _on_level_button_mouse_entered():
	modulate.a = .75


func _on_level_button_mouse_exited():
	modulate.a = 1
