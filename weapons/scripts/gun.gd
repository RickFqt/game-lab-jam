extends Weapon


func _ready() -> void:
	attributes.base_cooldown = 2
	attributes.base_damage = 10
	attributes.base_speed = 300
	image = preload("res://textures/GUI/weapons/1_back.png")
	descriptions= [
		"Diminui o intervalo entre tiros em 33%.",
		"Aumenta o dano base dos projéteis em 10.",
		"Diminui o intervalo entre tiros em 33%.",
		"Aumenta o dano base dos projéteis em 10.",
		"Diminui o intervalo entre tiros em 50%."]
	weapon_name = "Beija-flor"
	%AnimatedSprite2D.play("default")
	%Timer.wait_time = calculate_cooldown()
	%Timer.start()
	
	

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_pressed("move_left"):
		%AnimatedSprite2D.scale.x = abs(%AnimatedSprite2D.scale.x)
	elif Input.is_action_pressed("move_right"):
		%AnimatedSprite2D.scale.x = - abs(%AnimatedSprite2D.scale.x)

	var enemies_in_range = get_overlapping_bodies()
	var min_dist = 0x3f3f3f3f
	var target_enemy = null
	if enemies_in_range.size() > 0:
		for enemy in enemies_in_range:
			var dist = enemy.global_position.distance_to(global_position)
			if dist < min_dist:
				min_dist = dist
				target_enemy = enemy
	
	if target_enemy != null:
		$WeaponPivot.look_at(target_enemy.global_position)

func shoot():
	const BULLET = preload("res://weapons/aux_scenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	new_bullet.damage = calculate_damage()
	new_bullet.speed = calculate_speed()
	%ShootingPoint.add_child(new_bullet)


func _on_timer_timeout() -> void:
	shoot()
	%Timer.wait_time = calculate_cooldown()

func level_up(amount: int) -> void:
	for i in amount:
		_level_up()
	
func _level_up() -> void:
	if level == 1:
		attributes.base_cooldown /= 1.5
	elif level == 2:
		attributes.base_damage += 10
	elif level == 3:
		attributes.base_cooldown /= 1.5
	elif level == 4:
		attributes.base_damage += 15
	elif level == 5:
		attributes.base_cooldown /= 2.0
	level += 1
