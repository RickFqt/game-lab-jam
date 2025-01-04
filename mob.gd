extends CharacterBody2D

var health = 30
var damage = 5
var speed = 100.0
var is_boss: bool = false

@onready var player = get_node("/root/Game/Player")

func _ready() -> void:
	%Slime.play_walk()

func change_to_boss() -> void:
	is_boss = true
	#%Slime.modulate = Color8(10,17,32,255)

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()

func take_damage(damage: int):
	health -= damage
	if health < 0:
		health = 0
	%Slime.play_hurt()
	
	if health == 0:
		queue_free()
		
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		smoke.scale = scale
		if is_boss:
			spawn_treasure_box()
		else:
			spawn_exp_shard()

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
