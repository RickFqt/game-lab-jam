extends Node2D

#const WAVE_DURATION : float = 30.0

#var boss_spawn_interval: float = 0.5 # Intervalo entre spawns de bosses
var spawn_mato_interval: float = 1.0  # Intervalo entre spawns de matos

#var current_wave: int = 0  # Onda atual
#var time_since_last_wave: float = 0.0
var spawn_timer: float = 0.0

@export var spawns: Array[Spawn_info] = []
@export var time = 0

func _ready() -> void:
	%SpawnMatoTimer.wait_time = spawn_mato_interval
	%SpawnTimer.start()
	%BossTimer.start()
	%SpawnMatoTimer.start()
	

#func _process(delta: float) -> void:
	#time_since_last_wave += delta
	#if time_since_last_wave >= WAVE_DURATION:
		#start_new_wave()

func start_new_wave():
	#current_wave += 1
	#time_since_last_wave = 0.0
	spawn_mato_interval = max(0.5, spawn_mato_interval - 0.1)  # Reduz o intervalo, mas mantém limite mínimo
	%SpawnMatoTimer.wait_time = spawn_mato_interval
	#print("Starting wave:", current_wave)

#func spawn_mob(is_boss = false):
	#var new_mob = preload("res://mob.tscn").instantiate()
	#%PathFollow2D.progress_ratio = randf()
	#new_mob.global_position = %PathFollow2D.global_position
	#if is_boss:
		#new_mob.change_to_boss()
	#add_child(new_mob)

func spawn_mato():
	var new_mato = preload("res://mato.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mato.global_position = %PathFollow2D.global_position
	add_child(new_mato)
	
func _on_timer_timeout() -> void:
	time += 1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while  counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					%PathFollow2D.progress_ratio = randf()
					enemy_spawn.global_position = %PathFollow2D.global_position
					add_child(enemy_spawn)
					counter += 1


func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	$AudioManager.para_tudo()
	get_tree().paused = true


func _on_boss_timer_timeout() -> void:
	#spawn_mob(true)
	pass


func _on_spawn_mato_timer_timeout() -> void:
	spawn_mato() # Replace with function body.
