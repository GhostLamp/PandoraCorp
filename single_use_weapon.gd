extends CharacterBody2D
class_name SingleUseWeapon

signal remove_weapon

@export var bullet : PackedScene
@export var bullet_count: int = 1
@export_range(0, 360) var arc:float = 0
@export var barrel_origin: Marker2D

@export var texture: Texture2D
@export var texture_region:Rect2

@export var bullet_sprite: Texture2D
@export var bullet_region: Rect2

@export var effect:PackedScene

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ammo: Node2D = $ammo
@onready var max_ammo: Node2D = $max_ammo
@onready var reload: Node2D = $reload
@onready var max_reload: Node2D = $max_reload
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var await_time = 0.2
var quick = false







var mouse
var Left = true
var charging = false
var charge_text = false
var charged = false
@export var shooting = false
var melee_mode = false
var bullet_direction



func _ready() -> void:
	get_parent().add_weapon(self)
	get_parent().connect_signals(self)
	if texture:
		sprite_2d.texture = texture
		
		if texture_region:
			sprite_2d.region_enabled = true
			sprite_2d.region_rect = texture_region


func follow_mouse():
	mouse = get_global_mouse_position()
	if mouse < global_position:
		sprite_2d.flip_v = true
	if mouse > global_position :
		sprite_2d.flip_v = false
	bullet_direction = (-barrel_origin.global_position + global_position).normalized()
	look_at(mouse)
	

func _unhandled_input(event):
	if event.is_action_pressed("shoot") or  event.is_action_pressed("alt_fire"):
		animation_player.play("trow")
		if await_time > 0:
			await get_tree().create_timer(0.2).timeout
		shooting = true

func swap_out():
	animation_player.play("trow")
	if await_time > 0:
		await get_tree().create_timer(0.2).timeout
	shoot()

func shoot():
	for i in bullet_count:
			var new_bullet:Bullet = bullet.instantiate()
			new_bullet.position = barrel_origin.global_position if barrel_origin else global_position
			if bullet_sprite:
				new_bullet.text =  bullet_sprite
				
				if bullet_region:
					new_bullet.text_region = bullet_region
				
			
			new_bullet.quick = quick
			new_bullet.damage = 2
			new_bullet.speed = 3000
			if bullet_count == 1:
				new_bullet.rotation = global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (bullet_count - 1)
				new_bullet.global_rotation = ( global_rotation + increment * i - arc_rad / 2)
			
			get_tree().root.call_deferred("add_child", new_bullet)
			
			if effect:
				var new_effect = effect.instantiate()
				new_bullet.status_manager.new_effect(new_effect)
			
	look_at(mouse)
	emit_signal('remove_weapon')
	queue_free()
		
		
		

func _process(_delta):
	if shooting == true: 
		shoot()

	
func _physics_process(_delta):
	follow_mouse()
