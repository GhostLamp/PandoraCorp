extends Button

var tween:Tween

func  _ready() -> void:
	size.x = 268

func _on_mouse_entered() -> void:
	if tween:
		tween.kill
	$"../../ParallaxBackground/Parallax2D".scroll_scale = Vector2(1,4)
	tween = get_tree().create_tween()
	tween.tween_property(self,"size",Vector2(716,126),0.2).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($"../../ParallaxBackground/Parallax2D","scroll_scale",Vector2(1,1),1)


func _on_mouse_exited() -> void:
	if tween:
		tween.kill
	tween = get_tree().create_tween()
	tween.tween_property(self,"size",Vector2(268,126),0.2).set_trans(Tween.TRANS_CUBIC)
