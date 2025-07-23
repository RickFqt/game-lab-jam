extends CanvasLayer

@onready var restart_button = $Control/VBoxContainer/RestartButton
@onready var main_menu_button = $Control/VBoxContainer/MainMenuButton

var current_scene_path: String

func _ready():
	# Connect button signals
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
	# Store the current scene path for restart functionality
	current_scene_path = get_tree().current_scene.scene_file_path

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(current_scene_path)

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")

func show_game_over():
	visible = true
	get_tree().paused = true
