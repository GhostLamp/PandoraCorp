extends Projectile
class_name Grapple
var pulling = false
var realing = false
var dire
var attached = []
var startTimer = 0.1
@onready var player_dector: Area2D = $player_dector
@onready var line_2d: Line2D = $Line2D


func _ready():
	direction = Vector2.RIGHT.rotated(global_rotation)
	speed = (((target.x - position.x)**2 + (target.y - position.y)**2)**0.5)*4
	speed = 4000



func _process(_delta: float) -> void:
	velocity = speed * direction
	var colision_info = move_and_collide(direction)
	if colision_info and startTimer <= 0:
		pullPlayer(dono[0])
		speed = 0
	move_and_slide()
	startTimer -= _delta
	
	
	if pulling == true:
		if attached.size() >0:
			if is_instance_valid(attached[0]):
				pullEnemey(dono[0])
				global_position = attached[0].global_position
			else:
				rell_back(dono[0])
		else:
			pullPlayer(dono[0])
	
	if realing == true:
		rell_back(dono[0])
	
	
	line_2d.rotation = -rotation
	line_2d.set_point_position(1,dono[0].coli.global_position - global_position)

func pullPlayer(player:Player):
	pulling = true
	player_dector.monitoring = true
	dire = (global_position - player.coli.global_position).normalized()
	player.velocity = 4000 * dire
	player.coli.position.y = -150

func pullEnemey(player:Player):
	pulling = true
	dire = (attached[0].global_position - player.coli.global_position).normalized()
	
	var attack = Attack.new()
	pulling = true
	attack.damage = 0
	attack.knockback = -40
	attack.direction = dire 
	attached[0].handle_hit(attack)
	
	player_dector.monitoring = true


func rell_back(player:Player):
	realing = true
	pulling = false
	player_dector.monitoring = true
	look_at(player.coli.global_position)
	direction = Vector2.RIGHT.rotated(global_rotation)

func _on_area_2d_body_entered(body):
	if body is Door:
		return
	
	if attached.size() == 0:
		if body.has_method("handle_hit"):
			var attack = Attack.new()
			pulling = true
			attack.damage = 1
			attack.direction = direction * 0
			body.handle_hit(attack)
			attached.append(body)


func _on_player_dector_body_entered(body: Node2D) -> void:
	if body is Player:
		pulling = false
		var player:Player = dono[0]
		player.velocity = player.velocity/2
		if attached.size() >0:
			if is_instance_valid(attached[0]):
				attached[0].velocity = Vector2(0,0)
		queue_free()
