extends Node

@onready var main_menu_music = $MainMenuMusic
var is_main_menu_music_playing = false

func _ready():
	# Start playing the main menu music
	play_main_menu_music()

func play_main_menu_music():
	if main_menu_music and not main_menu_music.playing:
		main_menu_music.play()
		is_main_menu_music_playing = true

func stop_music():
	if main_menu_music:
		main_menu_music.stop()
		is_main_menu_music_playing = false

func pause_music():
	if main_menu_music and main_menu_music.playing:
		main_menu_music.stream_paused = true

func resume_music():
	if main_menu_music:
		main_menu_music.stream_paused = false

func _on_main_menu_music_finished():
	# Loop the music
	play_main_menu_music()
