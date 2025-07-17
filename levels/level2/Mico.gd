extends BossBase

@export var banana_scene: PackedScene
@export var clone_scene: PackedScene
@export var arbustos: Array[Node2D] # Lista de arbustos disponíveis no mapa
@export var visibility_distance: float = 150.0
@export var hide_distance: float = 400.0
@export var bullet_speed : float = 2.0
var flee_direction: Vector2

var current_arbusto: Node2D
var is_hidden: bool = true
var is_fleeing: bool = false
var clones: Array[CharacterBody2D] = []

signal start_waves
signal mico_hidden

func initialize():
	stage = 0
	randomize()
	go_to_random_arbusto()

func adapt_behavior():
	clear_clones()
	match stage:
		1:
			start_waves.emit()
		2:
			pass
		3:
			pass
		4:
			die()


func _physics_process(delta: float) -> void:
	if is_fleeing:
		flee_direction = (global_position - player.global_position).normalized()
		velocity = flee_direction * speed
		if global_position.distance_to(player.global_position) >= hide_distance:
			velocity = Vector2.ZERO
			stop_and_hide()
	elif is_hidden:
		# Detecta se o jogador se aproxima
		#if player.global_position.distance_to(global_position) < visibility_distance:
			#reveal_and_flee()
		pass
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func reveal_and_flee():
	$Sprite2D.visible = true
	is_hidden = false
	throw_banana_at((player.global_position - global_position).normalized())
	spawn_clones()
	flee_direction = (global_position - player.global_position).normalized()
	is_fleeing = true

func stop_and_hide():
	is_fleeing = false
	go_to_random_arbusto()
	is_hidden = true
	clear_clones()
	mico_hidden.emit()
	
func throw_banana_at(dir: Vector2):
	var p = banana_scene.instantiate()
	p.global_position = global_position
	p.speed = bullet_speed
	p.rotation = dir.angle()
	p.RANGE = 1200
	#p.direction = dir
	get_tree().current_scene.add_child(p)

func spawn_clones():
	clear_clones()
	var n_clones = max(stage - 1, 0) # Fase 2: 1 clone, Fase 3: 2 clones
	for i in range(n_clones):
		var clone = clone_scene.instantiate()
		get_parent().add_child(clone)
		
		var offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
		clone.global_position = global_position + offset

		var dir = (global_position - player.global_position).rotated(randf_range(-0.5, 0.5)).normalized()
		clone.direction = dir
		clones.append(clone)

func clear_clones():
	for clone in clones:
		if is_instance_valid(clone):
			clone.queue_free()
	clones.clear()

func hide_in_nearest_arbusto():
	is_fleeing = false
	go_to_random_arbusto()
	is_hidden = true

func go_to_random_arbusto():
	current_arbusto = arbustos[randi() % arbustos.size()]
	current_arbusto.has_mico = true
	global_position = current_arbusto.global_position
	$Sprite2D.visible = false


func take_damage(_damage: int):
	# O mico eh imortal!!!!!!!!!!!!!!
	pass


func _on_touch_zone_body_entered(body: Node2D) -> void:
	if body == player:
		
		$TouchZone/CollisionShape2D.call_deferred("set_disabled", true)
		change_stage(stage + 1)
		var original_speed = speed
		speed = speed * 5
		await get_tree().create_timer(2.0).timeout # espera 2 segundos
		$TouchZone/CollisionShape2D.call_deferred("set_disabled", false)
		speed = original_speed

func _on_mico_found():
	reveal_and_flee()
