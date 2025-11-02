extends Node2D

var charsel = load("res://actors/character_select.tscn")


func _on_button_2_pressed():
	get_tree().quit()


func _on_button_pressed():
	var tween:Tween = get_tree().create_tween()
	var vbox:BoxContainer = $VBoxContainer
	var sprite:Sprite2D = $PandoraLogo
	
	tween.tween_property(vbox,"position",vbox.position - Vector2(1500,0),0.5).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(sprite,"position",sprite.position + Vector2(1500,0),0.5).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($ParallaxBackground/Parallax2D/SquiglyLine,"position",$ParallaxBackground/Parallax2D/SquiglyLine.position + Vector2(1500,0),0.5).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($ParallaxBackground/Parallax2D/SquiglyLine2,"position",$ParallaxBackground/Parallax2D/SquiglyLine2.position - Vector2(1500,0),0.5).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(change_to_main)
	

func change_to_main():
	get_tree().change_scene_to_file("res://actors/character_select.tscn")
