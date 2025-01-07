extends Weapon

# Cena a ser instanciada como objeto giratório
var object_scene: PackedScene = preload("res://weapons/aux_scenes/rotation_circle_object.tscn")

var objects = []

var original_area

func _ready() -> void:
	attributes.base_cooldown = 0.3
	attributes.base_damage = 3
	attributes.base_speed = PI
	attributes.n_projectiles = 1
	attributes.base_area = 40.0
	original_area = attributes.base_area
	image = preload("res://textures/GUI/weapons/2_back.png")
	descriptions= [
		"Aumenta o número de cascos em 1.",
		"Aumenta o dano base em 2.",
		"Aumenta a velocidade de rotação dos cascos.",
		"Aumenta o número de cascos em 1.",
		"Aumenta o tamanho dos cascos."]
	weapon_name = "Tartaruga"
	update_objects()

func update_objects():
	# Remove objetos antigos
	for obj in objects:
		obj.queue_free()
	objects.clear()
	rotation = 0
	
	# Cria os novos objetos
	for i in range(calculate_projectiles()):
		var obj = object_scene.instantiate()
		obj.damage = calculate_damage()
		obj.scale.x = calculate_area() * 1.5 / original_area
		obj.scale.y = calculate_area() * 1.5 / original_area
		add_child(obj)
		objects.append(obj)
	
	for i in range(calculate_projectiles()):
		var angle = (2 * PI / calculate_projectiles()) * i
		var position = Vector2(cos(angle), sin(angle)) * calculate_area()
		objects[i].position = position

func _physics_process(delta: float) -> void:
	
	rotate(calculate_speed() * delta)
	for obj in objects:
		obj.rotate(-calculate_speed() * delta)
	
	

func level_up(amount: int) -> void:
	for i in amount:
		_level_up()
	
func _level_up() -> void:
	if level == 1:
		attributes.n_projectiles += 1
	elif level == 2:
		attributes.base_damage += 2
	elif level == 3:
		attributes.speed += PI/2
	elif level == 4:
		attributes.n_projectiles += 1
	elif level == 5:
		attributes.base_area += 50.0
	level += 1
	update_objects()
