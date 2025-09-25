extends Marker2D


@onready var sprite_2d_back: Sprite2D = $Sprite2DBack
@onready var sprite_2d_front: Sprite2D = $Sprite2DFront

func _process(delta):
	sprite_2d_back.rotation += delta*180
	sprite_2d_front.rotation += delta*180*1.5
