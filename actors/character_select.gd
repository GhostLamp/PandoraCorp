extends Node2D

@onready var next: Button = $next
@onready var pallate_author: Label = $pallate_author
@onready var character_name: Label = $character_name

var bru = load("res://world.gd")
var sprite:Sprite2D
var paletts:Array[ShaderMaterial]
var names:Array[String]
var authors:Array[String]

var current_palette:int = 0
var current_character:PackedScene

func selectCharacter(charSel:CharSelButton):
	current_character = charSel.player
	sprite = charSel.sprite
	paletts = charSel.pallets
	names = charSel.names
	authors = charSel.authors
	current_palette = 0
	next.disabled = false
	next.visible = true
	setPalette()

func setPalette():
	if current_character:
		sprite.material = paletts[current_palette]
		character_name.text = names[current_palette]
		if pallate_author:
			pallate_author.text = "made by:"+authors[current_palette]
		pallate_author.visible = true
		character_name.visible = true




func _on_next_pressed() -> void:
	PlayerHolder.player = current_character
	PlayerHolder.paletts = paletts
	PlayerHolder.current_palette = current_palette
	get_tree().change_scene_to_file("res://world.tscn")
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		current_palette -= 1
		if current_palette < 0:
			current_palette = paletts.size() - 1
		setPalette()
	if event.is_action_pressed("right"):
		current_palette += 1
		if current_palette >= paletts.size():
			current_palette = 0
		setPalette()
