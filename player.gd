extends CharacterBody2D

signal health_depleted
signal player_attributes_changed

var player_attributes : PlayerAttributes = PlayerAttributes.new()
var experience: int = 0
var experience_needed: int = 100

var weapons_inventory : Dictionary = {}
var items_inventory : Array = []

func _ready():
	%HealthBar.max_value = player_attributes.health
	%ExperienceBar.max_value = experience_needed
	%ExperienceBar.value = 0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * player_attributes.speed
	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		player_attributes.health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%HealthBar.value = player_attributes.health
		player_attributes_changed.emit()
		if player_attributes.health <= 0.0:
			health_depleted.emit()

func add_weapon(weapon_scene: PackedScene, weapon_name: String) -> void:
	var new_weapon = weapon_scene.instantiate()
	weapons_inventory[weapon_name] = new_weapon
	call_deferred("_add_weapon", new_weapon)

func _add_weapon(weapon: Weapon):
	add_child(weapon)

func upgrade_weapons_inventory(weapon_scene: PackedScene) -> void:
	var weapon_name = weapon_scene.resource_path.get_file().get_basename()
	
	if weapons_inventory.has(weapon_name):
		weapons_inventory[weapon_name].level_up(1)
		return
	
	add_weapon(weapon_scene, weapon_name)

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

func level_up():
	player_attributes.level += 1
	experience -= experience_needed
	experience_needed += int(experience_needed * 0.2)
	%ExperienceBar.max_value = experience_needed
	player_attributes_changed.emit()

func _on_player_attributes_changed() -> void:
	for weapon in weapons_inventory.values():
		weapon.update_player_attributes(player_attributes)
