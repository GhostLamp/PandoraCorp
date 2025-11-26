extends CharacterBody2D

class_name Player

var Left = true
var direction= Vector2(0,0)
var gravity = 40



@export var wallbouncer : PackedScene
@export var hologran : PackedScene
@export var shock_wave : PackedScene
@export var malware : PackedScene
@export var ghost : PackedScene
@export var char_color:Color
@export var invulnerable: bool

@export var paletts:Array[ShaderMaterial]

@export var dash_knockback:float = 10
@export var dash_damage:float = 1

var camera_2d: Camera2D 
var camera_manager:CameraManager

@onready var health_stat = $health
@onready var speed_stat:SpeedStat = $speed

@onready var gun_maneger:PlayerGunManager = $body/gun_maneger

@onready var anim_maneger:Node2D = $body/animation_manager

@onready var dashing_time = $dashing_time
@onready var dash_cooldown = $dash_cooldown
@onready var dash_area:Area2D = $body/Area2D
@onready var dash_hammer: Sprite2D = $body/Area2D/Sprite2D
var can_dash:bool = false


@onready var coli:CharacterBody2D = $body
@onready var collision:CollisionShape2D = $CollisionShape2D
@onready var ghost_timer = $ghost_timer
@onready var adrenaline_bar = $CanvasLayer/HUD/adrenaline_bar
@onready var adrenaline_stat =  $adrenaline
@onready var timer:stopwatch = $CanvasLayer/HUD/timer
@onready var sprite: Sprite2D = $body/animation_manager/tevii_sprite
@onready var tevii_tree: AnimationTree = $body/animation_manager/tevii_tree
@onready var combo_counter: Node = $CanvasLayer/HUD/combo_counter
@onready var StyleBonus: Node = $StyleManger
@onready var special_maneger: Node2D = $body/special_maneger
@onready var damaged_anim: AnimationPlayer = $body/animation_manager/damaged_anim

@onready var fuel_counter: FuelCounter = $CanvasLayer/HUD/fuel_counter

@onready var player_state_machine: PlayerStateMachine = $player_state_machine

var rooms_to_explore:Array[Room]

var currentRoom:Room
var currentPalette:int
var base_direction:Vector2 = Vector2(0,0)

var flip_scale = Vector2(1,0)
var slam_counter = 0
var dash_duration:float = 0
var fuel:float = 0
var spawn_position

var maxFuel:float = 100
var safe_position_timer:float = 1
var safe_positions:Array[Vector2] = [Vector2(0,0),Vector2(0,0),Vector2(0,0)]
 
var items: Array[BaseItemStrat] = []
var active_item:Array[ActivePickup] = []
var interaction: Array[interactive] = []

var amount_hit:float = 0
var win = true
var max_combo:int = 0

var extras:Array[Dictionary]

var item_pickup = preload("res://Items/item_pickup.tscn")

func _ready() -> void:
	stylish("enemy_hit")
	fuel_counter.dungeon_fuel = maxFuel
	fuel_counter.maxFuel = maxFuel
	speed_stat.current_speed = speed_stat.speed
	coli.position.y -= 4000
	_set_palette(currentPalette)

func _set_palette(palette:int):
	sprite.material = paletts[palette]
	char_color = paletts[palette].get_shader_parameter("shader_color")

func item(it:BaseItemStrat):
	if it is ActivePickup:
		if active_item.size() == 0:
			active_item.append(it)
		else:
			drop_item()
			active_item.append(it)
	else:
		items.append(it)
	it.apply_boost(self)

func gainFuel():
	fuel += 1
	fuel_counter.set_fuel(fuel)

func drop_item():
	var new_item:ItemPickUp = item_pickup.instantiate()
	new_item.item = active_item[0]
	new_item.position = global_position
	get_tree().root.call_deferred("add_child", new_item)
	active_item.pop_front()

func addExtra(extraName:String):
	extras.append(StyleBonus.extra_bonus[extraName])
	

func stylish(style_name):
	adrenaline_stat.adrenaline += StyleBonus.style_bonus[style_name]["adrenaline"]
	combo_counter.style_adder({"point":clamp(StyleBonus.style_bonus[style_name]["score"],0,99),"name":StyleBonus.style_bonus[style_name]["name"],"color":StyleBonus.style_bonus[style_name]["color"]})

func sort_interection_areas(area1:interactive, area2:interactive):
	area1.hideFKey()
	area2.hideFKey()
	var area1_to_player = self.global_position.distance_to(area1.global_position)
	var area2_to_player = self.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func check_tile(delta) -> String:
	var posColi = currentRoom.tiles.to_local(coli.global_position+Vector2(0,40))
	var coordsColi = currentRoom.tiles.local_to_map(posColi)
	var dataColi: TileData = currentRoom.tiles.get_cell_tile_data(coordsColi)
	
	var pos = currentRoom.tiles.to_local(global_position)
	var coords = currentRoom.tiles.local_to_map(pos)
	var data: TileData = currentRoom.tiles.get_cell_tile_data(coords)
	
	if !data or !dataColi:
		return "no_tile"
	
	if data.get_custom_data("solid") or dataColi.get_custom_data("solid"):
		jump(-1000)
		return "solid"
	
	if data.get_custom_data("unsafe") and dataColi.get_custom_data("unsafe"): 
		if player_state_machine.current_state.stateName != "dashing":
			player_state_machine.force_swap("falling")
		return "unsafe"
	
	if dataColi.get_custom_data("moving"):
		base_direction = dataColi.get_custom_data("moving")
	else:
		base_direction = Vector2(0,0)
	
	set_collision_layer_value(8,true)
	set_collision_mask_value(8,true)
	set_safe_position(delta)
	return "safe"

func set_safe_position(delta):
	safe_position_timer -= delta
	if safe_position_timer <= 0:
		safe_position_timer = 1
		safe_positions.append(position)
		safe_positions.pop_front()

func respawn():
	position = safe_positions[ safe_positions.size()-1 ]

func interact():
	tevii_tree["parameters/front/conditions/swing"] = true
	tevii_tree["parameters/back/conditions/swing"] = true
	await get_tree().create_timer(0.02).timeout
	tevii_tree["parameters/front/conditions/swing"] = false
	tevii_tree["parameters/back/conditions/swing"] = false
	

func end_level():
	if amount_hit <= 0:
		addExtra("no_hit")
	if rooms_to_explore.size() <= 0:
		addExtra("explorer")
	PlayerHolder.totalfuel = fuel/maxFuel
	PlayerHolder.time = timer.time
	PlayerHolder.amountHit = amount_hit
	PlayerHolder.win = win
	PlayerHolder.extras.append_array(extras)
	Mouse.mouse_type = Mouse.mouseType.MenuMouse
	get_parent().change_to_results()


func damaged(damage):
	damaged_anim.play("damaged")
	HitstopEfect.hitstop_efect_short()
	HitstopManeger.hitstop_medium()
	for it in items:
		it.on_player_damaged(self)
	
	if invulnerable:
		return
	
	amount_hit +=1
	if timer.time <= 0:
		win = false
		addExtra("defeat")
		var world:Node2D = get_tree().current_scene
		var tween = get_tree().create_tween()
		tween.tween_property(world,"modulate",Color(1,1,1,0.01),1)
		get_node("body/animation_manager/lose_anim").play("lose")
		await get_tree().create_timer(0.625).timeout
		HitstopEfect.animation_player_2.play("loose")
		await get_tree().create_timer(1-0.625).timeout
		end_level()
		return
	
	timer.damaged(damage)
	invulnerability(0.5)
	



func flipping(_delta , mouse):
	if mouse.x >= 0:
		mouse.x = 1
	else:
		mouse.x = -1
	flip_scale = mouse
	
	anim_maneger.scale.x = flip_scale.x




func _process(delta):
	player_state_machine.state_process(delta)
	camera_manager.update_camera()
	speed_stat.current_speed = move_toward(speed_stat.current_speed,speed_stat.speed,delta*speed_stat.speed*2)
	
	
	
	adrenaline_bar.value = adrenaline_stat.adrenaline
	coli.velocity.y += gravity *delta *60
	
	if interaction.size() > 0:
		interaction.sort_custom(sort_interection_areas)
		interaction[0].showFKey()
	
	if Input.is_action_just_pressed("interact"):
		if interaction.size() > 0:
			interaction[0].interact(self)
		
	if Input.is_action_just_pressed("ui_down"):
		stylish("test")
	
	
	move_and_slide()
	animate()

func combo_gain():
	for it in items:
			it.on_combo_gain(self)

func adrenaline_cost(cost):
	if adrenaline_stat.adrenaline >= cost:
		adrenaline_stat.adrenaline -= cost
		return true
	return false

func jump(vel):
	if player_state_machine.current_state.stateName != "airborn" and slam_counter < 1:
		coli.velocity.y = vel/2
	if slam_counter >1:
		slam_counter = 0




func animate():
	var mouse = (get_global_mouse_position() - global_position)
	if dash_duration > 0 or player_state_machine.current_state.stateName == "slamming":
		return
	
	
	if mouse.y >= -100:
		tevii_tree["parameters/conditions/Look_front"] = true
		tevii_tree["parameters/conditions/Look_back"] = false
		gun_maneger.show_behind_parent = false
		gun_maneger.z_index = 1
	
	else:
		tevii_tree["parameters/conditions/Look_front"] = false
		tevii_tree["parameters/conditions/Look_back"] = true
		gun_maneger.show_behind_parent = true
		gun_maneger.z_index = 0
	
	if direction:
		if direction.x > 0 and flip_scale.x < 0:
			tevii_tree["parameters/back/conditions/moving_back"] = true
			tevii_tree["parameters/front/conditions/moving_back"] = true
			tevii_tree["parameters/back/conditions/moving_front"] = false
			tevii_tree["parameters/front/conditions/moving_front"] = false
			tevii_tree["parameters/back/conditions/idle"] = false
			tevii_tree["parameters/front/conditions/idle"] = false
			
		elif direction.x < 0 and flip_scale.x >= 0:
			tevii_tree["parameters/back/conditions/moving_back"] = true
			tevii_tree["parameters/front/conditions/moving_back"] = true
			tevii_tree["parameters/back/conditions/moving_front"] = false
			tevii_tree["parameters/front/conditions/moving_front"] = false
			tevii_tree["parameters/back/conditions/idle"] = false
			tevii_tree["parameters/front/conditions/idle"] = false
			
		else:
			tevii_tree["parameters/back/conditions/moving_back"] = false
			tevii_tree["parameters/front/conditions/moving_back"] = false
			tevii_tree["parameters/back/conditions/moving_front"] = true
			tevii_tree["parameters/front/conditions/moving_front"] = true
			tevii_tree["parameters/back/conditions/idle"] = false
			tevii_tree["parameters/front/conditions/idle"] = false
			
	else:
		tevii_tree["parameters/back/conditions/moving_back"] = false
		tevii_tree["parameters/front/conditions/moving_back"] = false
		tevii_tree["parameters/back/conditions/moving_front"] = false
		tevii_tree["parameters/front/conditions/moving_front"] = false
		tevii_tree["parameters/back/conditions/idle"] = true
		tevii_tree["parameters/front/conditions/idle"] = true
		

func create_after_image():
	if ghost_timer.is_stopped():
		var new_ghost = ghost.instantiate()
		new_ghost.position = sprite.global_position
		new_ghost.scale = anim_maneger.scale
		new_ghost.texture = sprite.texture
		new_ghost.hframes = sprite.hframes
		new_ghost.vframes = sprite.vframes
		new_ghost.frame = sprite.frame
		new_ghost.char_color = char_color
		get_tree().current_scene.call_deferred("add_child", new_ghost)
		ghost_timer.start()



func invulnerability(time:float):
	invulnerable = true
	await get_tree().create_timer(time).timeout
	invulnerable = false




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = dash_damage
		attack.direction = direction
		attack.knockback = dash_knockback
		body.handle_hit(attack)
		if body is Box or body is Chest or body is Door:
			return
		can_dash = true
		for it in items:
			it.on_dash_hit(self)
		
		HitstopManeger.hitstop_short()
