extends Sprite2D
@onready var alph = material.get_shader_parameter("shader_color")
@export var char_color:Color


func _ready():
	material.set_shader_parameter("shader_color", char_color)
	scale *= 0.5
	await get_tree().create_timer(0.2).timeout
	queue_free()
