extends Button

@export_file var lvl_path 
var original_size := size
var grow_size := Vector2(1.1, 1.1)

func _on_lvl_btn_mouse_entered() -> void:
	grow_size_tween(grow_size, .1)
	
func _on_lvl_btn_mouse_exited() -> void:
	grow_size_tween(original_size, .1)


func grow_size_tween(end_size: Vector2, duration: float) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'size', end_size, duration)
	
	
func _on_button_pressed():
	pass # Replace with function body.


func _on_lvl_button_pressed():
	if lvl_path == null:
		return
	get_tree().change_scene_to_file(lvl_path)
