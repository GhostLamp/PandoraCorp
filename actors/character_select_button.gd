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
	
	sprite.visible = true

func _on_mouse_exited() -> void:
	if selected == true:
		return
	sprite.visible = false

func unselect():
	button_pressed = false
	selected = false
	_on_mouse_exited()
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",Vector2(position.x,847),0.1)


func select():
	var children = get_parent().get_children()
	for child in children:
		if child is CharSelButton:
			child.unselect()
	selected = true
	_on_mouse_entered()
	get_parent().selectCharacter(self)
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",Vector2(position.x,776),0.1)
