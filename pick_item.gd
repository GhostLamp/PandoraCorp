@tool
extends interactive
class_name ItemPickUp
@export var item:BaseItemStrat

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var needs_update := false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var itemName: Label = $CanvasLayer/item_name
@onready var descripition: Label = $CanvasLayer/descripition
@onready var activation: Label = $CanvasLayer/activation



func _ready() -> void:
	sprite_2d.region_rect = item.item_region
	itemName.text = item.name
	descripition.text = item.descripition + "\n" + "f to pickup"
	activation.text = item.activation

func showFKey():
	if showing:
		return
	showing = true
	animation_player.play("show_info")

func hideFKey():
	showing = false
	animation_player.play("hide_info")

func body_entered(body: Node2D) -> void:
	if body is Player:
		body.interaction.append(self)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if needs_update:
			sprite_2d.texture = item.texture
			sprite_2d.region_rect = item.item_region
			needs_update = false

func body_exited(body: Node2D) -> void:
	hideFKey()
	if body is Player:
		body.interaction.erase(self)


func setItem(newItem:BaseItemStrat):
	item = newItem

func setItemActive(newItem:ActivePickup):
	item = newItem


func interact(player:Player):
	await player.interact()
	player.item(item)
	queue_free()
