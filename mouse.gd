extends Node2D
@onready var base_mouse: Sprite2D = $BaseMouse

@export var mouse_type = mouseType.MenuMouse

var mouse

var color: Color = Color.WHITE
var radius: float = 0
var start_angle: float = 10
var end_angle: float = -10


var color_charge: Color = Color.TRANSPARENT
var start_angle_charge: float = 10
var end_angle_charge:float = 10

var line_color:Color = Color.TRANSPARENT

enum mouseType{
	MenuMouse,
	BulletMouse,
	ProjectileMouse,
	MeleeMouse,
}

func _process(delta: float) -> void:
	mouse = get_global_mouse_position()
	match mouse_type:
		mouseType.MenuMouse:
			MenuMouse()
		mouseType.BulletMouse:
			BulletMouse()
		mouseType.MeleeMouse:
			MeleeMouse()
		mouseType.ProjectileMouse:
			ProjectileMouse()
	
	queue_redraw()


func MenuMouse():
	base_mouse.visible = true
	global_position = mouse
	start_angle = 0
	end_angle = 0
	color_charge = Color.TRANSPARENT
	line_color = Color.TRANSPARENT

func BulletMouse():
	color = Color.WHITE
	var  player:Player = get_tree().current_scene.player
	var gun:Gun = player.gun_maneger.current_weapon
	global_position = gun.barrel_origin.global_position
	radius = global_position.distance_to(mouse)
	start_angle = deg_to_rad(gun.arc)/2
	end_angle = -deg_to_rad(gun.arc)/2
	base_mouse.visible = false
	look_at(mouse)
	ChargeUpBullet(gun)

func MeleeMouse():
	color = Color.WHITE
	var  player:Player = get_tree().current_scene.player
	var gun:Gun = player.gun_maneger.current_weapon
	global_position = gun.barrel_origin.global_position
	radius = gun.attack_distance
	start_angle = deg_to_rad(gun.arc)/2
	end_angle = -deg_to_rad(gun.arc)/2
	base_mouse.visible = false
	look_at(mouse)
	ChargeUpMelee(gun)

func ProjectileMouse():
	color = Color.WHITE
	var  player:Player = get_tree().current_scene.player
	var gun:Gun = player.gun_maneger.current_weapon
	global_position = (gun.barrel_origin.global_position*(1-gun.charge_level.charge))+(mouse*(gun.charge_level.charge))
	radius = gun.aoe_range
	start_angle = 0
	end_angle = 360
	base_mouse.visible = false
	look_at(mouse)
	ChargeUpProjectile(gun)

func ChargeUpBullet(gun:Gun):
	start_angle_charge = deg_to_rad(gun.arc)/2
	end_angle_charge = start_angle_charge - deg_to_rad(gun.arc)/2 * gun.charge_level.charge
	color_charge = gun.color
	line_color = color_charge

func ChargeUpMelee(gun:Gun):
	start_angle_charge = deg_to_rad(gun.arc)/2
	end_angle_charge = start_angle_charge - deg_to_rad(gun.arc)/2 * (gun.ammo.ammo/gun.ammo.max_ammo)
	color_charge = gun.color
	line_color = color_charge

func ChargeUpProjectile(gun:Gun):
	start_angle_charge = 0
	end_angle_charge = deg_to_rad(180) * gun.charge_level.charge
	color_charge = gun.color
	line_color = color_charge

func _draw() -> void:
	var center: Vector2 = Vector2(0,0)
	var point_count: int = 50
	var width: float = 5
	var antialiased: bool = false
	draw_arc(center,radius,start_angle,end_angle,point_count,color,width,antialiased)
	
	draw_arc(center,radius,start_angle_charge,end_angle_charge,point_count,color_charge,width,antialiased)
	draw_arc(center,radius,-start_angle_charge,-end_angle_charge,point_count,color_charge,width,antialiased)
	
	draw_line(
		Vector2((radius-10)*cos(start_angle),(radius-10)*sin(start_angle)),
		Vector2((radius+10)*cos(start_angle),(radius+10)*sin(start_angle)),
		color,width,antialiased)
	
	draw_line(
		Vector2((radius-10)*cos(end_angle),(radius-10)*sin(end_angle)),
		Vector2((radius+10)*cos(end_angle),(radius+10)*sin(end_angle)),
		color,width,antialiased)
