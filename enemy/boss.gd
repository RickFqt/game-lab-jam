extends CharacterBody2D

class_name BossBase

@export var max_health = 3000
@export var damage = 5
@export var speed = 100.0

var health: int
var stage: int = 1
@onready var player = get_node("/root/Game/Player")

signal damaged

func _ready() -> void:
	health = max_health
	initialize()

func initialize():
	pass

func take_damage(damage: int):
	health -= damage
	#para testes
	#healt -= 100
	if health < 0:
		health = 0
	
	if health == 0:
		die()
	else:
		$snd_hit.play()
		if health <= max_health * 0.66 and stage == 1:
			change_stage(2)
		elif health <= max_health * 0.33 and stage == 2:
			change_stage(3)
	print("chefão tomou")
	print(health)
	emit_signal("damaged")

func change_stage(new_stage: int):
	stage = new_stage
	adapt_behavior(stage)
	
func adapt_behavior(new_stage : int):
	pass

func die():
	queue_free()
