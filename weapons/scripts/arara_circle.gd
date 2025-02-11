extends Weapon


func _ready() -> void:
	attributes.base_cooldown = 2
	attributes.base_damage = 2
	attributes.base_speed = 150
	attributes.n_projectiles = 1
	attributes.base_area = 30.0
	image = preload("res://textures/GUI/weapons/10_back.png")
	descriptions= [
		"Aumenta o dano base das araras em 2.",
		"Diminui o tempo entre voos de araras em 33%.",
		"Aumenta o dano base das araras em 2.",
		"Aumenta a velocidade das araras em 33%.",
		"Diminui o tempo entre voos de araras em 50%."]
	weapon_name = "Arara"
	%TimerArara.wait_time = calculate_cooldown()
	%TimerArara.start()



func shoot():
	const BULLET = preload("res://weapons/aux_scenes/arara.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = global_position + Vector2(0, -30)
	new_bullet.damage = calculate_damage()
	new_bullet.speed = calculate_speed()
	add_child(new_bullet)

func level_up(amount: int) -> void:
	for i in amount:
		_level_up()
	
func _level_up() -> void:
	if level == 1:
		attributes.base_damage += 2.0
	elif level == 2:
		attributes.base_cooldown /= 1.5
	elif level == 3:
		attributes.base_damage += 2.0
	elif level == 4:
		attributes.base_speed *= 1.5
	elif level == 5:
		attributes.base_cooldown /= 2.0
	level += 1

func _on_timer_arara_timeout() -> void:
	shoot()
	%TimerArara.wait_time = calculate_cooldown()
