extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	rotation -= get_parent().rotation
