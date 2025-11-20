extends Node2D
class_name ResultsScreen

@onready var damage_taken_labelDisplay: Label = $GridContainer/DamageTaken
@onready var total_fuelDisplay: Label = $GridContainer/TotalFuel
@onready var timeDisplay: Label = $GridContainer/Time
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var _container: VBoxContainer = $VBoxContainer
@onready var ranksprite: Sprite2D = $Ranksprite
@onready var ranksprite_2: Sprite2D = $Ranksprite2
@onready var final_resDisplay: Label = $final_res


@export var styleLabel:PackedScene

var charsel = load("res://actors/character_select.tscn")
var win:bool
var extras:Array[Dictionary]
var time:float
var amount_hit:float
var max_combo
var total_fuel:float
var final_res

func _ready() -> void:
	total_fuel = PlayerHolder.totalfuel
	time = PlayerHolder.time
	amount_hit = PlayerHolder.amountHit
	max_combo = ComboCount.max_combo
	win = PlayerHolder.win
	extras.append_array(PlayerHolder.extras)
	
	PlayerHolder.reset()
	ComboCount.reset()
	
	await get_tree().create_timer(0.4).timeout
	get_results()

func get_results():
	if win:
		$winStatus.text += "well done"
	else:
		$winStatus.text += "defeat"
	
	final_res = time*total_fuel * max_combo/10 
	var msec = fmod(time,1)*10
	var sec = fmod(time,60)
	var minu = time/60
	var format_string = "%02d : %02d : %01d"
	var real_string = format_string % [minu, sec, msec]
	timeDisplay.text = real_string
	total_fuelDisplay.text = str(floor(total_fuel * 100)) + "%"
	#if amount_hit > 1:
		#damage_taken_labelDisplay.text = str(amount_hit) + " times"
	#else:
		#damage_taken_labelDisplay.text = str(amount_hit) + " time"
	damage_taken_labelDisplay.text = str(max_combo)
	
	animation_player.play("results")

func addExtras():
	for i in extras:
		await get_tree().create_timer(0.1).timeout
		var label:Label = styleLabel.instantiate()
		label.text = i["name"]
		final_res += i["score"]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.modulate = Color.RED
		$VBoxContainer.call_deferred("add_child",label)
	final_rank()

func final_rank():
	final_resDisplay.text = str(floor(final_res))
	if final_res >= 400:
		ranksprite.frame = 0
		ranksprite_2.frame = 0
	elif final_res >= 300:
		ranksprite.frame = 1
		ranksprite_2.frame = 1
	elif final_res >= 250:
		ranksprite.frame = 2
		ranksprite_2.frame = 2
	elif final_res >= 175:
		ranksprite.frame = 3
		ranksprite_2.frame = 3
	elif final_res >= 100:
		ranksprite.frame = 4
		ranksprite_2.frame = 4
	elif final_res >= 0:
		ranksprite.frame = 5
		ranksprite_2.frame = 5
	else:
		ranksprite.frame = 6
		ranksprite_2.frame = 6
	animation_player.play("final_rank")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://actors/character_select.tscn")
