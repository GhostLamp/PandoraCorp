extends TextureProgressBar



func _on_adrenaline_bar_value_changed(new_value: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self ,"value" ,new_value , 0.5)
