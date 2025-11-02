extends Node
@export var combo_amout: int
@export var combo_timer: float
var stopped = false
@export var style_bonus: Array
@export var style_label: PackedScene
signal add_style
signal remove_style
@onready var wait_time: Timer = $wait_time

var timer_left:int = 0
var kill_count:int = 0
var remove_time:float = 2

func _process(delta: float) -> void:
	if stopped:
		return
	
	combo_timer -= delta*10 * (combo_amout**2/2500 + 1)
	
	combo_amout = timer_left/100
	
	
	if remove_time > 0:
		remove_time-=delta
	else:
		emit_signal("remove_style")
		remove_time = 2


func combo_left():
	var combo = combo_amout
	var format_string = "%02d"
	var real_string = format_string % [combo]
	ComboCount.comboCount = combo_amout
	return real_string

func style_adder(style):
	if style["name"] == "kill":
		var player:Player = get_parent().get_parent().get_parent()
		
		kill_count += 1
		wait_time.start()
		if kill_count > 20:
			player.stylish("ultrakill")
			return
		if kill_count > 2:
			player.stylish("multikill")
			return
		if kill_count > 2:
			player.stylish("triple_kill")
			return
		if kill_count > 1:
			player.stylish("double_kill")
			return
	
	combo_timer += style["point"]
	
	if style["point"] == 0:
		return
	
	style_bonus.append(style)
	var new_label:Label = style_label.instantiate()
	new_label.text = style["name"]
	if style["color"]:
		new_label.modulate = style["color"]
	else:
		var c = 255 - (style["point"]*25)
		new_label.modulate = Color8(255,c,c)
	add_style.emit(new_label)

func time_added(time):
	combo_timer = 0.0
	combo_timer += time

func combo_time_left():
	if timer_left < combo_timer:
		timer_left = move_toward(timer_left,combo_timer,get_process_delta_time()*2*(combo_timer-timer_left))
	else:
		timer_left = move_toward(timer_left,combo_timer,get_process_delta_time()*200)
	timer_left = clamp(timer_left,0 , 9999999999999)
	return timer_left


func _on_wait_time_timeout() -> void:
	kill_count = 0
