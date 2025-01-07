extends Weapon

# Cena a ser instanciada como objeto giratório
var object_scene: PackedScene = preload("res://weapons/aux_scenes/rotation_circle_object.tscn")

var objects = []

func _ready() -> void:
	attributes.base_cooldown = 0.3
	attributes.base_damage = 10
	attributes.base_speed = PI
	attributes.n_projectiles = 1
	attributes.base_area = 40.0
	image = preload("res://textures/GUI/weapons/2_back.png")
	descriptions= [
		"Descricao rotation circle",
		"Descricao rotation circle",
		"Descricao rotation circle",
		"Descricao rotation circle",
		"Descricao rotation circle"]
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
		attributes.base_damage += 12
	elif level == 3:
		attributes.base_area += 100.0
	elif level == 4:
		attributes.base_damage += 12
	elif level == 5:
		attributes.n_projectiles += 1
	level += 1
	update_objects()
