extends Control

@onready var play_button = $VBoxContainer/PlayButton
@onready var options_button = $VBoxContainer/OptionsButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var options_menu = $OptionsMenu
@onready var master_volume_slider = $OptionsMenu/OptionsPanel/VBoxContainer/MasterVolumeSlider
@onready var music_volume_slider = $OptionsMenu/OptionsPanel/VBoxContainer/MusicVolumeSlider
@onready var sfx_volume_slider = $OptionsMenu/OptionsPanel/VBoxContainer/SFXVolumeSlider

func _ready():
	# Connect button signals
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Connect volume slider signals
	master_volume_slider.value_changed.connect(_on_master_volume_changed)
	music_volume_slider.value_changed.connect(_on_music_volume_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
	
	# Hide options menu initially
	options_menu.visible = false
	
	# Load saved settings
	_load_settings()

func _on_play_pressed():
	# Load the level selection screen
	get_tree().change_scene_to_file("res://level_select.tscn")

func _on_options_pressed():
	# Show options menu
	options_menu.visible = true

func _on_quit_pressed():
	# Quit the game
	get_tree().quit()

func _on_options_back_pressed():
	# Hide options menu and save settings
	options_menu.visible = false
	_save_settings()

func _on_master_volume_changed(value: float):
	# Adjust master volume
	var db_value = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db_value)

func _on_music_volume_changed(value: float):
	# Adjust music volume
	var db_value = linear_to_db(value / 100.0)
	var music_bus = AudioServer.get_bus_index("Music")
	if music_bus != -1:
		AudioServer.set_bus_volume_db(music_bus, db_value)

func _on_sfx_volume_changed(value: float):
	# Adjust SFX volume
	var db_value = linear_to_db(value / 100.0)
	var sfx_bus = AudioServer.get_bus_index("SFX")
	if sfx_bus != -1:
		AudioServer.set_bus_volume_db(sfx_bus, db_value)

func _save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume_slider.value)
	config.set_value("audio", "music_volume", music_volume_slider.value)
	config.set_value("audio", "sfx_volume", sfx_volume_slider.value)
	config.save("user://settings.cfg")

func _load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err == OK:
		master_volume_slider.value = config.get_value("audio", "master_volume", 100.0)
		music_volume_slider.value = config.get_value("audio", "music_volume", 100.0)
		sfx_volume_slider.value = config.get_value("audio", "sfx_volume", 100.0)
		
		# Apply the loaded values
		_on_master_volume_changed(master_volume_slider.value)
		_on_music_volume_changed(music_volume_slider.value)
		_on_sfx_volume_changed(sfx_volume_slider.value)
