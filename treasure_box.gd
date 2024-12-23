extends Area2D

var gun_scene = preload("res://gun.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_weapon"):
		body.add_weapon(gun_scene)
	queue_free()
