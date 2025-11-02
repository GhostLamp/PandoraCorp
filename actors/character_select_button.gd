extends Button
class_name CharSelButton

@export var player:PackedScene 
@export var pallets:Array[ShaderMaterial]
@export var names:Array[String]
@export var authors:Array[String]
@export var sprite: Sprite2D


var selected:bool = false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	button_down.connect(select)

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
