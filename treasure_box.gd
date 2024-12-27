extends Area2D

var gun_scene = preload("res://weapons/scenes/gun.tscn")
var scenes: Array[PackedScene] = [gun_scene]

func _on_body_entered(body: Node2D) -> void:
	
	if body.has_method("upgrade_weapons_inventory"):
		var chosen_weapon = scenes[randi() % scenes.size()]
		body.upgrade_weapons_inventory(chosen_weapon)
		queue_free()
		
