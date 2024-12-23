extends CanvasLayer



func _reset_game() -> void:
	get_tree().reload_current_scene()
	Log.info("Reloading...")
	hide()
