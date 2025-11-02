extends Node2D

@onready var next: Button = $next
@onready var pallate_author: Label = $Panel/pallate_author
@onready var character_name: Label = $Panel/character_name

var tween:Tween
var bru = load("res://world.gd")
var sprite:Sprite2D
var paletts:Array[ShaderMaterial]
var names:Array[String]
var authors:Array[String]
var stuff:Array 

var current_palette:int = 0
var current_character:PackedScene

func _ready() -> void:
	tween = get_tree().create_tween()
	stuff = [$teviiselect,$kboomselect,$next,$ParallaxBackground/Parallax2D/SquiglyLine2]
	for i in stuff.size():
		stuff[i].position.x += 1600 + 100*i
	$Panel.position.x -= 1500
	$ParallaxBackground/Parallax2D/SquiglyLine.position.x -= 100
	tween.tween_property($Panel,"position",$Panel.position+ Vector2(1500,0),1).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel().tween_property($ParallaxBackground/Parallax2D/SquiglyLine,"position",$ParallaxBackground/Parallax2D/SquiglyLine.position+ Vector2(100,0),1).set_trans(Tween.TRANS_CUBIC)
	for i in stuff.size():
		tween.set_parallel().tween_property(stuff[i],"position",stuff[i].position- Vector2(1600 + 100*i,0),1).set_trans(Tween.TRANS_CUBIC).set_delay(0.1*i)

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
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		sprite.material = paletts[current_palette]
		character_name.text = names[current_palette]
		
		$Panel/ColorRect.material["shader_parameter/noise_amount"] = 0.3
		$Panel/ColorRect.material["shader_parameter/interference_amount"] = 1
		$Panel/ColorRect.material["shader_parameter/roll_speed"] = 8
		$Panel/ColorRect.material["shader_parameter/scan_line_strength"] = -1
		sprite.material["shader_parameter/alpha"] = 1.0
		tween.tween_property(sprite, "material:shader_parameter/alpha", 0, 0.2)
		tween.parallel().tween_property($Panel/ColorRect,"material:shader_parameter/noise_amount",0.03,0.2)
		tween.parallel().tween_property($Panel/ColorRect,"material:shader_parameter/interference_amount",0.2,0.2)
		tween.parallel().tween_property($Panel/ColorRect,"material:shader_parameter/roll_speed",1,0.2)
		tween.parallel().tween_property($Panel/ColorRect,"material:shader_parameter/scan_line_strength",-8,0.2)

		pallate_author.text = "swap pallets with <"
		if authors[current_palette]:
			pallate_author.text = "made by:"+authors[current_palette]
		pallate_author.visible = true
		character_name.visible = true




func _on_next_pressed() -> void:
	PlayerHolder.player = current_character
	PlayerHolder.paletts = paletts
	PlayerHolder.current_palette = current_palette
	
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	
	var world = load("res://world.gd")
	for i in stuff.size():
		if stuff[i] == $Panel:
			tween.tween_property(stuff[i],"position",stuff[i].position+ Vector2(0,1500),0.5).set_trans(Tween.TRANS_CUBIC)
			continue
		tween.set_parallel().tween_property(stuff[i],"position",stuff[i].position+ Vector2(0,1500),0.5).set_trans(Tween.TRANS_CUBIC).set_delay(0.1*i)
	
	tween.set_parallel(false).tween_callback(change_to_world)

func change_to_world():
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
