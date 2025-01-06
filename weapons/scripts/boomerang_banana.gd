extends Area2D

const RANGE = 200
var travelled_distance = 0
var pointing = 1
var damage = 1
var speed = 1
var rotation_speed = 4*PI

func _physics_process(delta: float) -> void:
	
	$Sprite2D.rotate(rotation_speed * delta)
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta * pointing
	
	travelled_distance += speed * delta * pointing
	if travelled_distance > RANGE:
		pointing = -1
	if travelled_distance <= 0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
