extends CharacterBody2D

@export var health = 30
@export var damage = 5
@export var speed = 100.0
@export var is_boss: bool = false
@export var experience: int = 1

@onready var player = get_node("/root/Game/Player")

func _ready() -> void:
	$AnimationPlayer.play("walk")

func change_to_boss() -> void:
	is_boss = true
	damage *= 3
	health *= 10
	#%Slime.change_to_boss()
	#%Slime.modulate = Color8(10,17,32,255)

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	
	if direction.x > 0.1:
		$Sprite2D.flip_h = true
	elif direction.x < -0.1:
		$Sprite2D.flip_h = false

func take_damage(damage: int):
	health -= damage
	if health < 0:
		health = 0
	
	if health == 0:
		queue_free()
		
		const SMOKE_SCENE = preload("res://enemy/explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		smoke.scale = scale
		if is_boss:
			spawn_treasure_box()
		else:
			spawn_exp_shard()
	else:
		$snd_hit.play()

func spawn_exp_shard():
	var exp_shard = preload("res://collectables/scenes/exp_shard.tscn").instantiate()
	exp_shard.global_position = global_position
	exp_shard.player_target = player
	#exp_shard.connect_to_player()
	call_deferred("_spawn_exp_shard", exp_shard)

func spawn_treasure_box():
	var treasure_box = preload("res://collectables/scenes/treasure_box.tscn").instantiate()
	treasure_box.global_position = global_position
	call_deferred("_spawn_treasure_box", treasure_box)

func _spawn_treasure_box(treasure_box):
	get_parent().add_child(treasure_box)

func _spawn_exp_shard(exp_shard):
	get_parent().add_child(exp_shard)
