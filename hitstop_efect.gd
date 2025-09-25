extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var anim = $AnimationPlayer
@export var bruh: int

func _ready():
	color_rect.visible = false
	anim.animation_finished.connect(_on_animation_finished)
	
	
func _on_animation_finished(anim_name):
	if anim_name == "hitstop_short":
		color_rect.visible = false


func hitstop_efect_short():
	color_rect.visible = true
	anim.play("hitstop_short")
