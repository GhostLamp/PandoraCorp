extends CharacterBody2D

class_name Player

var Left = true
var direction
var gravity = 40

enum state {GROUNDED, DASHING, AIRBORN, SLAMMING}
var player_state = state.GROUNDED

@export var wallbouncer : PackedScene
@export var hologran : PackedScene
@export var shock_wave : PackedScene
@export var malware : PackedScene
@export var ghost : PackedScene
@export var char_color:Color
@export var invulnerable: bool
@export var maxFuel:float = 100

@export var paletts:Array[ShaderMaterial]

@onready var camera_2d: Camera2D = $body/Camera2D
@onready var health_stat = $health
@onready var speed_stat = $speed
@onready var gun_maneger = $body/gun_maneger
@onready var anim_maneger = $body/animation_manager
@onready var dashing_time = $dashing_time
@onready var dash_cooldown = $dash_cooldown
@onready var coli = $body
@onready var colision = $body/CollisionShape2D
@onready var ghost_timer = $ghost_timer
@onready var adrenaline_bar = $CanvasLayer/HUD/adrenaline_bar
@onready var adrenaline_stat =  $adrenaline
@onready var timer = $CanvasLayer/HUD/timer
@onready var sprite: Sprite2D = $body/animation_manager/tevii_sprite
@onready var tevii_tree: AnimationTree = $body/animation_manager/tevii_tree
@onready var combo_counter: Node = $CanvasLayer/HUD/combo_counter
@onready var StyleBonus: Node = $StyleManger
@onready var special_maneger: Node2D = $body/special_maneger
@onready var damaged_anim: AnimationPlayer = $body/animation_manager/damaged_anim
@onready var fuel_counter: FuelCounter = $CanvasLayer/HUD/fuel_counter


var currentRoom:Room
var currentPalette:int


var flip_scale = Vector2(1,0)
var slam_counter = 0
var current_speed:float = 0
var accel = 6000
var friction = 8000
var dash_duration:float = 0
var fuel:float = 0
var spawn_position

var safe_position_timer:float = 1
var safe_positions:Array[Vector2] = [Vector2(0,0),Vector2(0,0),Vector2(0,0)]
 
@export var items: Array[BaseItemStrat] = []
@export var active_item:Array[ActivePickup] = []
@export var interaction: Array[interactive] = []
var item_pickup = preload("res://Items/item_pickup.tscn")

func _ready() -> void:
	stylish("enemy_hit")
	current_speed = speed_stat.speed
	_set_palette(currentPalette)

func _set_palette(palette:int):
	sprite.material = paletts[palette]

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
	fuel_counter.set_fuel(fuel,maxFuel)

func drop_item():
	var new_item:ItemPickUp = item_pickup.instantiate()
	new_item.item = active_item[0]
	new_item.position = global_position
	get_tree().root.call_deferred("add_child", new_item)
	active_item.pop_front()

func stylish(style_name):
	adrenaline_stat.adrenaline += StyleBonus.style_bonus[style_name]["adrenaline"]
	combo_counter.style_adder({"point":clamp(StyleBonus.style_bonus[style_name]["score"],0,99),"name":StyleBonus.style_bonus[style_name]["name"],"color":StyleBonus.style_bonus[style_name]["color"]})

func sort_interection_areas(area1, area2):
	var area1_to_player = self.global_position.distance_to(area1.global_position)
	var area2_to_player = self.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func check_tile(delta):
	var posColi = currentRoom.tiles.to_local(coli.global_position)
	var coordsColi = currentRoom.tiles.local_to_map(posColi)
	var dataColi: TileData = currentRoom.tiles.get_cell_tile_data(coordsColi)
	
	var pos = currentRoom.tiles.to_local(global_position)
	var coords = currentRoom.tiles.local_to_map(pos)
	var data: TileData = currentRoom.tiles.get_cell_tile_data(coords)
	
	if !data or !dataColi:
		return
	
	if data.get_custom_data("solid") or dataColi.get_custom_data("solid"):
		jump(-1000)
		return
	
	if data.get_custom_data("unsafe") and dataColi.get_custom_data("unsafe"):
		damaged(10)
		respawn()
		return
	
	set_collision_layer_value(8,true)
	set_collision_mask_value(8,true)
	set_safe_position(delta)

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
	await get_tree().create_timer(0.01).timeout
	tevii_tree["parameters/front/conditions/swing"] = false
	tevii_tree["parameters/back/conditions/swing"] = false
	


func ground_movement(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	dash_duration = 0
	if slam_counter > 0:
		slam_counter -= delta*10
	if direction:
		velocity = velocity.move_toward(current_speed*direction , (accel)*delta )
		adrenaline_stat.adrenaline += delta*5
	
	else:
		velocity = velocity.move_toward(Vector2(0,0), friction*delta)
	
	check_tile(delta)


func dash(delta):
	dash_duration -= delta
	if direction:
		if dash_duration<= 0:
			velocity = velocity.move_toward(current_speed*direction, friction*delta)
		else:
			velocity = current_speed*direction
	
	check_tile(delta)
	create_after_image()

func airborn(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	gravity = 40
	
	if direction.x != 0:
		velocity.x = lerp(velocity.x, direction.x * current_speed , 0.02)
	if direction.y != 0:
		velocity.y = lerp(velocity.y, direction.y * current_speed , 0.02)
		
	if Input.is_action_just_pressed("ui_accept"):
		coli.velocity.y += -2000
		player_state = state.SLAMMING
		slam_counter += 1
		tevii_tree["parameters/conditions/slam"] = true
		tevii_tree["parameters/conditions/Look_front"] = false
		tevii_tree["parameters/conditions/Look_back"] = false
		await get_tree().create_timer(delta).timeout
		tevii_tree["parameters/conditions/slam"] = false


func slam():
	gravity = 200
	if coli.is_on_floor():
		_on_slam_timer_timeout()
	create_after_image()


func damaged(damage):
	damaged_anim.play("damaged")
	HitstopEfect.hitstop_efect_short()
	HitstopManeger.hitstop_medium()
	for it in items:
		it.on_player_damaged(self)
	
	if invulnerable:
		return
	
	if timer.time <= 0:
		var world:Node2D = get_tree().current_scene
		var tween = get_tree().create_tween()
		tween.tween_property(world,"modulate",Color(1,1,1,0.01),1)
		get_node("body/animation_manager/lose_anim").play("lose")
		return
	
	
	timer.damaged(damage)
	invulnerability()
	



func flipping(_delta , mouse):
	if mouse.x >= 0:
		mouse.x = 1
	else:
		mouse.x = -1
	flip_scale = mouse
	
	anim_maneger.scale.x = flip_scale.x




func _process(delta):
	var mouse = (get_global_mouse_position() - global_position).normalized()
	current_speed = move_toward(current_speed,speed_stat.speed,delta*speed_stat.speed*2)
	
	
	if coli.is_on_floor() and player_state != state.SLAMMING:
		if Input.is_action_just_pressed("ui_down"):
			stylish("test")
		if Input.is_action_just_pressed("ui_accept") and adrenaline_stat.adrenaline >= 10 and player_state != state.DASHING:
			player_state = state.DASHING
			dashing_time.start()
			dash_duration = 0.3
			adrenaline_stat.adrenaline -= 10
			
			current_speed = speed_stat.speed*2.5
			
			
			tevii_tree["parameters/conditions/dash"] = true
			tevii_tree["parameters/conditions/Look_front"] = false
			tevii_tree["parameters/conditions/Look_back"] = false
			await get_tree().create_timer(delta).timeout
			tevii_tree["parameters/conditions/dash"] = false
		elif player_state != state.DASHING:
			player_state = state.GROUNDED
	
	
	elif not coli.is_on_floor() and player_state != state.SLAMMING:
		player_state = state.AIRBORN
	
	
	
	if player_state == state.GROUNDED:
		ground_movement(delta)
		flipping(delta, mouse)
		
	if player_state == state.DASHING:
		dash(delta)
		flipping(delta, direction)
	
	if player_state == state.SLAMMING:
		slam()
		flipping(delta, mouse)
		
	if player_state == state.AIRBORN:
		airborn(delta)
		flipping(delta, mouse)
		set_collision_layer_value(8,false)
		set_collision_mask_value(8,false)
	
	adrenaline_bar.value = adrenaline_stat.adrenaline
	coli.velocity.y += gravity *delta *60
	
	if interaction.size() > 0:
		interaction.sort_custom(sort_interection_areas)
	
	if Input.is_action_just_pressed("interact"):
		if interaction.size() > 0:
			interaction[0].interact(self)
	
	
	move_and_slide()
	animate()






func adrenaline_cost(cost):
	if adrenaline_stat.adrenaline >= cost:
		adrenaline_stat.adrenaline -= cost
		return true
	return false

func jump(vel):
	if player_state != state.AIRBORN and slam_counter < 1:
		coli.velocity.y = vel/2
	if slam_counter >1:
		slam_counter = 0

func _on_dashing_time_timeout():
	if player_state == state.DASHING:
		player_state = state.GROUNDED


func animate():
	var mouse = (get_global_mouse_position() - global_position)
	if dash_duration > 0 or player_state == state.SLAMMING:
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
		new_ghost.position = coli.global_position - Vector2(0,7)
		new_ghost.scale = anim_maneger.scale
		new_ghost.texture = sprite.texture
		new_ghost.hframes = sprite.hframes
		new_ghost.vframes = sprite.vframes
		new_ghost.frame = sprite.frame
		new_ghost.char_color = char_color
		get_tree().root.call_deferred("add_child", new_ghost)
		ghost_timer.start()


func _on_slam_timer_timeout():
	var new_shock_wave = shock_wave.instantiate()
	new_shock_wave.position = global_position + Vector2(0,40)
	new_shock_wave.damage = 1
	get_tree().root.call_deferred("add_child", new_shock_wave)
	player_state = state.GROUNDED


func invulnerability():
	invulnerable = true
	await get_tree().create_timer(0.5).timeout
	invulnerable = false




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = 1
		attack.direction = direction
		attack.knockback = 10
		body.handle_hit(attack)
		if body is Box:
			return
		HitstopManeger.hitstop_short()
