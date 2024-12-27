extends Weapon

func _ready() -> void:
	attributes.base_cooldown = 0.3
	attributes.base_damage = 10
	attributes.base_speed = 1000
	

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func shoot():
	const BULLET = preload("res://weapons/scenes/bullet.tscn")
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
		level += 1
		_level_up()
	
func _level_up() -> void:
	if level == 2:
		attributes.base_damage += 12
	elif level == 3:
		attributes.base_cooldown /= 2.0
	elif level == 4:
		attributes.base_damage += 15
	elif level == 5:
		attributes.base_cooldown /= 2.0
	elif level == 6:
		attributes.base_speed *= 1.5
