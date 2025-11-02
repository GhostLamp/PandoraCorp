extends Area2D
@onready var label: Label = $Label

var first_time:bool = true


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if first_time:
			HitstopEfect.show_level(" pandora ", " corp. ", " level - 0 ")
			first_time = false
		
		if body.fuel >= body.maxFuel:
			label.visible = true
