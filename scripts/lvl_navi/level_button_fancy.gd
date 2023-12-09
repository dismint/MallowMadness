extends Node2D

@export var spriteFrame: int
var path = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.frame = spriteFrame
	if spriteFrame < 4:
		path = "res://levels/Intro_%s.tscn" % [spriteFrame + 1]
	else:
		path = "res://levels/Level_%s.tscn" % [spriteFrame % 4 + 1]
		
func _on_level_button_pressed():
	get_tree().change_scene_to_file(path)
