extends Area2D

var RANGE = 600
var travelled_distance = 0
var damage = 0
var speed = 2
var stun_duration = 2.0

func launch():
	pass

func _physics_process(delta: float) -> void:
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	
	travelled_distance += speed * delta
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("stun"):
		body.stun(stun_duration)
