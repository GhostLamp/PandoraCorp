@tool
class_name SpecialManeger
extends Node2D

@onready var player: Player = $"../.."
@onready var slot_1: Sprite2D = $"../../CanvasLayer/SpcSpriteHolder/item"
@onready var slot_2: Sprite2D = $"../../CanvasLayer/SpcSpriteHolder/item2"
@onready var slot_3: Sprite2D = $"../../CanvasLayer/SpcSpriteHolder/item3"

@onready var texture_progress_bar: TextureProgressBar = $"../../CanvasLayer/SpcSpriteHolder/TextureProgressBar"
@onready var texture_progress_bar_2: TextureProgressBar = $"../../CanvasLayer/SpcSpriteHolder/TextureProgressBar2"
@onready var texture_progress_bar_3: TextureProgressBar = $"../../CanvasLayer/SpcSpriteHolder/TextureProgressBar3"



var item_pickup = preload("res://Items/item_pickup.tscn")
@export var needs_update := false


var specials: Array = [BaseActiveStrat]
var slots: Array[Sprite2D]
var bars:Array[TextureProgressBar]

func _ready():
	specials = get_children()
	slots = [slot_1,slot_2,slot_3]
	bars = [texture_progress_bar,texture_progress_bar_2,texture_progress_bar_3]
	needs_update = true

func add_special(special:PackedScene):
	if specials.size() <= 2:
		var new_special = special.instantiate()
		add_child(new_special)
		specials.append(new_special)
		needs_update = true
	else:
		swap_special(special)

func swap_special(special:PackedScene):
	var new_special = special.instantiate()
	specials[2].finish()
	specials[2].queue_free()
	specials.pop_back()
	add_child(new_special)
	specials.append(new_special)
	needs_update = true

func _process(_delta: float) -> void:
	if needs_update:
		for i in specials.size():
			slots[i].region_rect = specials[i].item_region
			slots[i].visible = true
			if specials[i].special_cooldown.is_stopped():
				slots[i].modulate = Color("ffffff")
			else:
				slots[i].modulate = Color("444444")
		needs_update = false
	
	if !Engine.is_editor_hint():
		for i in specials.size():
			bars[i].value = player.adrenaline_stat.adrenaline
			bars[i].max_value = specials[i].get_adrenaline_cost()



func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("special 1"):
		if specials.size() > 0:
			var special = specials[0]
			if special:
				if not special.special_cooldown.is_stopped():
					return
				var cost = special.get_adrenaline_cost()
				if player.adrenaline_cost(cost):
					special.special_activation()
	if Input.is_action_just_pressed("special 2"):
		if specials.size() > 1:
			var special = specials[1]
			if special:
				if not special.special_cooldown.is_stopped():
					return
				var cost = special.get_adrenaline_cost()
				if player.adrenaline_cost(cost):
					special.special_activation()
	if Input.is_action_just_pressed("special 3"):
		if specials.size() > 2:
			var special = specials[2]
			if special:
				if not special.special_cooldown.is_stopped():
					return
				var cost = special.get_adrenaline_cost()
				if player.adrenaline_cost(cost):
					special.special_activation()
