extends Node
var full = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		full = !full
		if full:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			return
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
