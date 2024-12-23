extends CharacterBody2D

signal health_depleted

var health = 100.0

var weapons_inventory : Array = []
var items_inventory : Array = []

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		if health <= 0.0:
			health_depleted.emit()

func add_weapon(weapon_scene: PackedScene) -> void:
	weapons_inventory.append(weapon_scene.instantiate())
	call_deferred("_add_weapon", weapons_inventory[-1])

func _add_weapon(weapon: Weapon):
	add_child(weapon)
	

#func add_item(item: Item) -> void:
	#items_inventory.append(item)
