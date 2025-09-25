@tool
extends interactive
class_name ItemPickUp
@export var item:BaseItemStrat

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var needs_update := false

func _ready() -> void:
	sprite_2d.region_rect = item.item_region


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
