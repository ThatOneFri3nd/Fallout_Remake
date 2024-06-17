extends Control



func _on_new_game_pressed():
	pass


func _on_load_game_pressed():
	pass # Replace with function body.


func _on_intro_cutscene_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
