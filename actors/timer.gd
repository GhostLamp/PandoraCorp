extends Node

class_name stopwatch

@onready var wait_time = $wait_time

@export var time = 0.0
var time_drain = 0.0
var stopped = false
@export var time_lost = 5.0

signal time_changed

func _ready() -> void:
	time *= 60


func _process(delta: float) -> void:
	if stopped:
		return
	
	drain(delta)
	
	time -= delta
	time = clamp(time,0,99999999)

func drain(delta):
	if wait_time.is_stopped():
		if time_drain > 0:
			time_drain -= delta*time_lost
			time -= delta*time_lost

func damaged():
	time_drain += time_lost
	print(time_lost)
	time_lost *= 1.5
	wait_time.start()
	emit_signal("time_changed")

func time_left():
	if time <= 0:
		return "shield down don't get hit"
	
	var msec = fmod(time,1)*10
	var sec = fmod(time,60)
	var minu = time/60
	var format_string = "%02d : %02d : %01d"
	var real_string = format_string % [minu, sec, msec]
	return real_string

func time_drain_left():
	var msec = fmod(time_drain,1)*10
	var sec = fmod(time_drain,60)
	var minu = time_drain/60
	var format_string = "%02d : %02d : %01d"
	var real_string = format_string % [minu, sec, msec]
	return real_string
