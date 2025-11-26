class_name Gun
extends CharacterBody2D

signal bullet_shot

@export var bullet : PackedScene
@export var alt_fire : PackedScene

@export var color:Color = Color.WHITE

@export var base_bullet_count: int = 1
@export var bullet_count: int = 1
@export_range(0, 360) var arc:float = 0
@export var barrel_origin: Marker2D

@export var basic_shot_cost:float = 0
@export var alt_shot_cost:float = 0
@export var basic_shot_speed:float = 0
@export var alt_shot_speed:float = 0
@export var basic_shot_damage:float = 0
@export var alt_shot_damage:float = 0
@export var texture_under:Texture
@export var texture_progress:Texture
@export var attack_distance:float = 252
@export var aoe_range:float

@onready var anim = $amin
@onready var atack_cooldown = $attack_cooldown
@onready var reload_timer = $reload_timer
@onready var nuzzel = $nuzzel
@onready var anim_tree = $AnimationTree
@onready var ammo:Ammo = $ammo
@onready var reload:Reload = $reload
@onready var charge_level:ChargeLevel = $charge_level
@onready var anim_maneger: Node2D = $anim_maneger


var mouse:Vector2
var bullet_direction:Vector2
var shooting = false

func shoot():
	pass

func alt_laser():
	pass


func follow_mouse():
	mouse = get_global_mouse_position()
	if mouse < global_position:
		anim_maneger.scale.y = -1
	if mouse > global_position :
		anim_maneger.scale.y = 1
	
	
	bullet_direction = (barrel_origin.global_position - global_position).normalized()
	look_at(mouse)

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		shooting = true
	if event.is_action_released("shoot"):
		shooting = false

func swap_in():
	Mouse.mouse_type = Mouse.mouseType.BulletMouse

func update_reload(delta:float):
	if not reload_timer.is_stopped():
		anim_maneger.rotation = 0
		reload.reload = 0
		return
	if ammo.ammo < ammo.max_ammo:
		reload.reload += delta
		
	if reload.reload >= reload.max_reload:
		get_parent().reload_boost(ammo.ammo,ammo.max_ammo)
		ammo.ammo = ammo.max_ammo
	
	if reload.reload > 0 and reload.reload < reload.max_reload:
		anim_maneger.rotation += 1
	else:
		anim_maneger.rotation = 0
