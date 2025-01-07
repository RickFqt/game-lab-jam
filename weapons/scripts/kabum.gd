extends Weapon

func _ready() -> void:
	visible = false
	attributes.base_cooldown = 120
	attributes.base_damage = 1000
	#attributes.base_area = 200
	%Timer.wait_time = 0.01
	image = preload("res://textures/GUI/weapons/50_back.png")
	descriptions= [
		"Descricao kabum",
		"Descricao kabum",
		"Descricao kabum",
		"Descricao kabum",
		"Descricao kabum"]
	weapon_name = "Onça"
	

func _physics_process(_delta: float) -> void:
	
	if visible:
		var current_modulate = %Sprite2D.modulate
		current_modulate.a = max(0, current_modulate.a - 0.015)
		%Sprite2D.modulate = current_modulate
		if current_modulate.a == 0:
			visible = false


func _on_timer_timeout() -> void:
	
	var current_modulate = %Sprite2D.modulate
	current_modulate.a = 0.8
	%snd_rawr.play(1.1)
	%Sprite2D.modulate = current_modulate
	visible = true
	%Timer.wait_time = calculate_cooldown()
	
	kill_them_all()

func kill_them_all():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(calculate_damage())

func level_up(amount: int) -> void:
	for i in amount:
		_level_up()
	
func _level_up() -> void:
	if level == 1:
		attributes.base_cooldown -= 10
	elif level == 2:
		attributes.base_cooldown -= 15
	elif level == 3:
		attributes.base_cooldown -= 15
	elif level == 4:
		attributes.base_cooldown -= 20
	elif level == 5:
		attributes.base_cooldown -= 30
	level += 1
	_on_player_attributes_changed() # Boas praticas de programacao


func _on_player_attributes_changed() -> void:
	#%DeathArea.shape.radius = calculate_area()
	%Timer.wait_time = calculate_cooldown()
	
