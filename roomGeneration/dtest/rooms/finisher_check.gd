extends Area2D
@onready var label: Label = $Label



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.fuel >= body.maxFuel:
			label.visible = true
