extends CharacterBody2D

var health = 30

@onready var player = get_node("/root/Game/Player")

func _ready() -> void:
	%Slime.play_walk()

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300.0
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
		spawn_exp_shard()

func spawn_exp_shard():
	var exp_shard = preload("res://collectables/scenes/exp_shard.tscn").instantiate()
	exp_shard.global_position = global_position
	exp_shard.player_target = player
	#exp_shard.connect_to_player()
	call_deferred("_spawn_exp_shard", exp_shard)

func _spawn_exp_shard(exp_shard):
	get_parent().add_child(exp_shard)
