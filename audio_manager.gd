extends Node

@onready var background_music_player: AudioStreamPlayer = $BackgroundMusicPlayer
var current_area:String
var current_Low_time:String

func _ready() -> void:
	current_area = AudioGlobal.current_area
	current_Low_time = AudioGlobal.low_time_left

func _process(_delta: float) -> void:
	if current_area != AudioGlobal.current_area or current_Low_time != AudioGlobal.low_time_left:
		current_area = AudioGlobal.current_area
		current_Low_time = AudioGlobal.low_time_left
		update_music()
		background_music_player.play()

func update_music():
	background_music_player["parameters/switch_to_clip"] = str(current_area + "Music" + current_Low_time)
