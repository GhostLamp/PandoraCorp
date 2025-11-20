extends Button
class_name CharSelButton

@export var player:PackedScene 
@export var pallets:Array[ShaderMaterial]
@export var names:Array[String]
@export var authors:Array[String]
@export var sprite: Sprite2D
@export var Special1Region:Rect2
@export_multiline var Special1Descr:String
@export var Special2Region:Rect2
@export_multiline var Special2Descr:String



var selected:bool = false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	button_down.connect(select)
	var special_sprite: Panel = $"../Panel/SpecialSprite"
	var special_sprite_2: Panel = $"../Panel/SpecialSprite2"
	
	special_sprite.position.x -= 300
	special_sprite_2.position.x -= 300

func _on_mouse_entered() -> void:
	var children = get_parent().get_children()
	for child in children:
		if child is CharSelButton:
			if child == self:
				continue
			child._on_mouse_exited()
			if child.selected == true:
				return
	
	var tween = get_tree().create_tween()
	$"../Panel/ColorRect".material["shader_parameter/noise_amount"] = 0.3
	$"../Panel/ColorRect".material["shader_parameter/interference_amount"] = 1
	$"../Panel/ColorRect".material["shader_parameter/roll_speed"] = 8
	$"../Panel/ColorRect".material["shader_parameter/scan_line_strength"] = -1
	tween.tween_property($"../Panel/ColorRect","material:shader_parameter/noise_amount",0.03,0.2)
	tween.parallel().tween_property($"../Panel/ColorRect","material:shader_parameter/interference_amount",0.2,0.2)
	tween.parallel().tween_property($"../Panel/ColorRect","material:shader_parameter/roll_speed",1,0.2)
	tween.parallel().tween_property($"../Panel/ColorRect","material:shader_parameter/scan_line_strength",-8,0.2)
	sprite.visible = true

func _on_mouse_exited() -> void:
	if selected == true:
		return
	sprite.visible = false

func unselect():
	button_pressed = false
	selected = false
	_on_mouse_exited()


func select():
	var children = get_parent().get_children()
	for child in children:
		if child is CharSelButton:
			child.unselect()
	selected = true
	_on_mouse_entered()
	get_parent().selectCharacter(self)
	
	var special_sprite: Panel = $"../Panel/SpecialSprite"
	var special_sprite_2: Panel = $"../Panel/SpecialSprite2"
	
	var tween = get_tree().create_tween()
	tween.tween_property(special_sprite,"position",Vector2(328,89),0.1).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel().tween_property(special_sprite_2,"position",Vector2(328,314),0.1).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(special_sprite,"position",Vector2(728,89),0.2).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel().tween_property(special_sprite_2,"position",Vector2(728,314),0.2).set_trans(Tween.TRANS_CUBIC)
