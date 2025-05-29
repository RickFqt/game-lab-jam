extends CharacterBody2D

@export var health = 30
@export var damage = 5
@export var speed = 100.0
@export var stage = 1

@onready var player = get_node("/root/Game/Player")

func _ready() -> void:
	damage *= 2
	$AnimationPlayer.play("walk")

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
	else:
		$snd_hit.play()
