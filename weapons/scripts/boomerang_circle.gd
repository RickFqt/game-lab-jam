extends Weapon

var object_scene: PackedScene = preload("res://weapons/aux_scenes/boomerang_banana.tscn")

func _ready() -> void:
	attributes.base_cooldown = 1.2
	attributes.base_damage = 15
	attributes.base_speed = 100
	attributes.n_projectiles = 2
	attributes.base_area = 30.0
	image = preload("res://textures/enemy/kolbold_strong.png")
	
	%TimerBoomerang.wait_time = calculate_cooldown()
	%TimerBoomerang.start()


func shoot():
	#const banana = preload("res://weapons/aux_scenes/boomerang_banana.tscn")
	# Cria os novos objetos
	for i in range(calculate_projectiles()):
		var obj = object_scene.instantiate()
		obj.damage = calculate_damage()
		obj.speed = calculate_speed()
		var angle = (2 * PI / calculate_projectiles()) * i
		var p = Vector2(cos(angle), sin(angle)) * calculate_area()
		obj.global_rotation = angle
		obj.global_position = global_position + p
		add_child(obj)
	
	#var new_bullet = banana.instantiate()
	#new_bullet.global_position = %ShootingPoint.global_position
	#new_bullet.global_rotation = %ShootingPoint.global_rotation
	#new_bullet.damage = calculate_damage()
	#new_bullet.speed = calculate_speed()
	#%ShootingPoint.add_child(new_bullet)


func level_up(amount: int) -> void:
	for i in amount:
		_level_up()
		
func _level_up() -> void:
	if level == 1:
		attributes.n_projectiles += 1
	elif level == 2:
		attributes.base_cooldown /= 2.0
	elif level == 3:
		attributes.base_damage += 15
	elif level == 4:
		attributes.n_projectiles += 1
	elif level == 5:
		attributes.base_speed *= 1.5
	level += 1


func _on_timer_boomerang_timeout() -> void:
	shoot()
	%TimerBoomerang.wait_time = calculate_cooldown()
