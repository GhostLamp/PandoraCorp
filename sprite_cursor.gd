extends AnimatedSprite2D


func _on_frame_changed():
	Input.set_custom_mouse_cursor(sprite_frames.get_frame_texture(animation, frame), Input.CURSOR_ARROW, Vector2(sprite_frames.get_frame_texture(animation, frame).get_width(), sprite_frames.get_frame_texture(animation, frame).get_height()/2))
