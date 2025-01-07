extends CharacterBody2D

signal health_depleted
signal player_attributes_changed

var player_attributes : PlayerAttributes = PlayerAttributes.new()
var experience: int = 0
var experience_needed: int = 10

var weapons_inventory : Dictionary = {}
var items_inventory : Array = []

var weapon_scenes: Array[PackedScene]


var weapons_image_path : Dictionary = {
	"gun": ["res://textures/GUI/weapons/1_back.png", 
			"Atira um projétil no inimigo mais próximo",
			"Beija-flor"],
	"kabum": ["res://textures/GUI/weapons/50_back.png",
			"A cada 2 minutos, RASGA A TELA.",
			"Onça"],
	"rotation_circle": ["res://textures/GUI/weapons/2_back.png",
			"Invoca uma tartaruga que orbita ao redor do player.",
			"Tartaruga"],
	"boomerang_circle": ["res://textures/GUI/weapons/20_back.png",
			"Atira bananas-bumerangue.",
			"Mico"],
	"araraCircle": ["res://textures/GUI/weapons/10_back.png",
			"Araras voam sobre seus inimigos.",
			"Arara"],
}

# GUI
#@onready var lblLevel = get_node("%lbl_level")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var itemOptions = preload("res://utility/item_option.tscn")
@onready var sndLevelUp = get_node("%snd_levelup")
@onready var itemContainer = preload("res://player/GUI/item_container.tscn")

func _ready():
	%HealthBar.max_value = player_attributes.max_health
	%ExperienceBar.max_value = experience_needed
	%ExperienceBar.value = 0
	%AnimatedSprite2D.play("walking")
	load_weapon_scenes()
	level_up()

func load_weapon_scenes():
	var weapons_dir = DirAccess.open("res://weapons/scenes")
	if weapons_dir:
		weapons_dir.list_dir_begin()
		var file_name = weapons_dir.get_next()
		while file_name != "":
			if !weapons_dir.current_is_dir():
				var file_path = "res://weapons/scenes/" + file_name
				if file_path.ends_with(".tscn"):
					var scene = load(file_path)
					weapon_scenes.append(scene)
			file_name = weapons_dir.get_next()
	else:
		print("An error occurred when trying to access the weapons_dir path.")

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * player_attributes.speed
	move_and_slide()
	if Input.is_action_pressed("move_left"):
		%AnimatedSprite2D.scale.x = abs(%AnimatedSprite2D.scale.x)
	elif Input.is_action_pressed("move_right"):
		%AnimatedSprite2D.scale.x = - abs(%AnimatedSprite2D.scale.x)
	
	if !is_moving():
		%AnimatedSprite2D.play("idle")
	else:
		%AnimatedSprite2D.play("walking")
	
	#if velocity.length() > 0.0:
		#%HappyBoo.play_walk_animation()
	#else:
		#%HappyBoo.play_idle_animation()
	
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		var damage_taken = 0
		for mob in overlapping_mobs:
			damage_taken += mob.damage
		player_attributes.health -= damage_taken * delta
		%HealthBar.value = player_attributes.health
		player_attributes_changed.emit()
		
		# Reproduzir animação de dano
		%DamageAnimation.play("DamageFlash")
		
		if player_attributes.health <= 0.0:
			health_depleted.emit()

func add_weapon(weapon_scene: PackedScene) -> void:
	
	var weapon_name = weapon_scene.resource_path.get_file().get_basename()
	var new_weapon = weapon_scene.instantiate()
	weapons_inventory[weapon_name] = new_weapon
	call_deferred("_add_weapon", new_weapon)
	adjust_gui_collection(new_weapon)

func _add_weapon(weapon: Weapon):
	add_child(weapon)

func upgrade_weapons_inventory(weapon_scene: PackedScene) -> void:
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	levelPanel.visible = false
	levelPanel.position = Vector2(2472,72)
	get_tree().paused = false
	
	var weapon_name = weapon_scene.resource_path.get_file().get_basename()
	
	if weapons_inventory.has(weapon_name):
		weapons_inventory[weapon_name].level_up(1)
		return
	add_weapon(weapon_scene)

func has_weapon(weapon_scene: PackedScene) -> bool:
	
	for weapon in weapons_inventory:
		if weapon.name == weapon_scene.resource_name:
			return true
	return false
	

#func add_item(item: Item) -> void:
	#items_inventory.append(item)

func add_experience(amount: int) -> void:
	experience += amount
	if experience >= experience_needed:
		level_up()
	%ExperienceBar.value = experience

func add_health(amount: int) -> void:
	player_attributes.health = min(player_attributes.health + amount, player_attributes.max_health)
	%HealthBar.value = player_attributes.health

func level_up():
	sndLevelUp.play()
	#lblLevel.text = str("Level: ",experience_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel,"position",Vector2(560,50),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var optionsmax = 3
	var chosen_weapons = draw_weapon_or_item(optionsmax)
	if chosen_weapons.size() > 0:
		for weapon_scene in chosen_weapons:
			var option_choice = itemOptions.instantiate()
			option_choice.item_scene = weapon_scene
			upgradeOptions.add_child(option_choice)
				
		get_tree().paused = true
	
	player_attributes.level += 1
	experience -= experience_needed
	experience = max(experience, 0)
	experience_needed += int(experience_needed * 0.6)
	%ExperienceBar.max_value = experience_needed
	#draw_weapon_or_item()
	player_attributes_changed.emit()

func draw_weapon_or_item(amount : int = 3):
	var weapons_pool: Array[PackedScene] = []
	#var items_pool
		
	for weapon in weapon_scenes:
		if weapons_inventory.has(weapon.resource_name) && weapons_inventory[weapon.resource_name].reached_max_level():
			continue
		weapons_pool.append(weapon)
	
	weapons_pool.shuffle()
	var chosen_weapons = []
	var pool_size = weapons_pool.size()
	for i in amount:
		if i < pool_size:
			chosen_weapons.append(weapons_pool[i])

	return chosen_weapons

func adjust_gui_collection(item):
	
	await item.ready
	
	var new_weapon_container = itemContainer.instantiate()
	new_weapon_container.item = item
	new_weapon_container.icon_path = item.image
	new_weapon_container.update_texture()
	%CollectedWeapons.add_child(new_weapon_container)

func _on_player_attributes_changed() -> void:
	for weapon in weapons_inventory.values():
		weapon.update_player_attributes(player_attributes)

func is_moving():
	return Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down")
