extends CanvasLayer

@onready var control = $Control
@onready var pause_panel = $Control/PausePanel
@onready var resume_button = $Control/PausePanel/VBoxContainer/ResumeButton
@onready var main_menu_button = $Control/PausePanel/VBoxContainer/MainMenuButton
@onready var quit_button = $Control/PausePanel/VBoxContainer/QuitButton

var is_paused = false

func _ready():
	# Connect button signals
	resume_button.pressed.connect(_on_resume_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Hide pause menu initially
	control.hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC key
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	if is_paused:
		control.show()
		get_tree().paused = true
	else:
		control.hide()
		get_tree().paused = false

func _on_resume_pressed():
	toggle_pause()

func _on_main_menu_pressed():
	get_tree().paused = false
	# Resume main menu music when returning to main menu
	if has_node("/root/MainMenuAudio"):
		get_node("/root/MainMenuAudio").play_main_menu_music()
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
