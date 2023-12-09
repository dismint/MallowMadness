extends Button

@export_file var lvl_path 
var original_size := size

func _on_pressed():
	$MouseClick.play()
	if lvl_path == null:
		return
	get_tree().change_scene_to_file(lvl_path)


func _on_mouse_entered():
	$MouseHover.play()


func _on_mouse_exited():
	pass
