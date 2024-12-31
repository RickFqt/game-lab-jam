extends Node2D

const WAVE_DURATION : float = 30.0

var monster_scenes: Array = []  # Array de cenas de monstros
var spawn_interval: float = 2.0  # Intervalo entre spawns
var current_wave: int = 0  # Onda atual
var time_since_last_wave: float = 0.0
var spawn_timer: float = 0.0

func _ready() -> void:
	%SpawnTimer.wait_time = spawn_interval

func _process(delta: float) -> void:
	time_since_last_wave += delta
	if time_since_last_wave >= WAVE_DURATION:
		start_new_wave()

func start_new_wave():
	current_wave += 1
	time_since_last_wave = 0.0
	spawn_interval = max(0.5, spawn_interval - 0.1)  # Reduz o intervalo, mas mantém limite mínimo
	%SpawnTimer.wait_time = spawn_interval
	print("Starting wave:", current_wave)

func spawn_mob(is_boss = false):
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	if is_boss:
		new_mob.change_to_boss()
	add_child(new_mob)


func _on_timer_timeout() -> void:
	spawn_mob(false)


func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true


func _on_boss_timer_timeout() -> void:
	spawn_mob(true)
