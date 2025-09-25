extends Button


func _on_mouse_entered() -> void:
	self.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	get_parent().get_parent().buttonEntered()


func _on_mouse_exited() -> void:
	self.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	get_parent().get_parent().buttonLeft()
