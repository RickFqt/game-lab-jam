extends CharacterBody2D

@export var speed: float = 80.0
var direction: Vector2 = Vector2.ZERO
var lifespan: float = 6.0 # Tempo que o clone dura

func _ready():
	$Timer.wait_time = lifespan
	$Timer.start()

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()

func _on_Timer_timeout():
	queue_free()
