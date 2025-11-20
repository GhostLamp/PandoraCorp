extends Button

var tween:Tween
@export var start_size:Vector2 = Vector2(268,126)
@export var final_sze:Vector2 = Vector2(716,126)


func  _ready() -> void:
	size.x = 268

func _on_mouse_entered() -> void:
	if tween:
		tween.kill
	tween = get_tree().create_tween()
	tween.tween_property(self,"size",final_sze,0.2).set_trans(Tween.TRANS_CUBIC)


func _on_mouse_exited() -> void:
	if tween:
		tween.kill
	tween = get_tree().create_tween()
	tween.tween_property(self,"size",start_size,0.2).set_trans(Tween.TRANS_CUBIC)
