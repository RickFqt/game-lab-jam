extends Control

@onready var level1_button = $VBoxContainer/Level1Button
@onready var level2_button = $VBoxContainer/Level2Button
@onready var back_button = $VBoxContainer/BackButton

func _ready():
	# Connect button signals
	level1_button.pressed.connect(_on_level1_pressed)
	level2_button.pressed.connect(_on_level2_pressed)
	back_button.pressed.connect(_on_back_pressed)

func _on_level1_pressed():
	# Load level 1 (survivors_game.tscn)
	get_tree().change_scene_to_file("res://survivors_game.tscn")

func _on_level2_pressed():
	# Load level 2
	get_tree().change_scene_to_file("res://level2.tscn")

func _on_back_pressed():
	# Go back to main menu
	get_tree().change_scene_to_file("res://main_menu.tscn")
