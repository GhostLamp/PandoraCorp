extends Bullet
class_name Projectile

@onready var sprite = $Sprite2D
@onready var coli: CharacterBody2D = $body

var target = Vector2.RIGHT
var charge:float = 1
var paried = false
var gravity:float = 10.0
var yvel: float = 0
var spin = 20
var drag = 18
var initial_height:float = 0
var dist:Vector2
var dono:Array =[]


func _ready():
	direction = Vector2.RIGHT.rotated(global_rotation)
	coli.velocity.y = -gravity * 60 /2
	
	speed = global_position.distance_to(target)
	if target.x < position.x:
		sprite.flip_v = true
		spin *= -1
		drag *= -1

func _physics_process(delta: float) -> void:
	airborn()

func airborn():
	sprite.position = coli.position
	coli.velocity.y += gravity
	
	if !sprite.flip_v:
		if coli.position.y > -initial_height and coli.velocity.y > 0:
			die()
	else:
		if coli.position.y < initial_height and coli.velocity.y > 0:
			die()
	
