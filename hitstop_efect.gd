extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var anim = $AnimationPlayer
@onready var room_finish_anim: AnimationPlayer = $roomFinishAnim

@onready var fuel_full_label: Label = $FuelFullLabel

@onready var level_name_1: Label = $levelName1
@onready var level_name_2: Label = $levelName2
@onready var level_name_3: Label = $levelName3



@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2

func overtime_start():
	print("bruh2")
	animation_player_2.play("overtime_wave")


func show_level(name1:String,name2:String,level:String):
	level_name_1.text = name1
	level_name_2.text = name2
	level_name_3.text = level
	animation_player_2.play("show_name")
	

func _ready():
	color_rect.visible = false
	anim.animation_finished.connect(_on_animation_finished)

func swap_to_level_in():
	animation_player_2.play("level_in")
	await  get_tree().create_timer(0.38).timeout
	return

func swap_to_level_out():
	animation_player_2.play("level_out")
	await get_tree().create_timer(0.38).timeout
	return

func _on_animation_finished(_anim_name):
	color_rect.visible = false
	anim.play("RESET")

func room_beat():
	room_finish_anim.play("roomFinish")

func hitstop_efect_short():
	color_rect.visible = true
	anim.play("hitstop_short")
