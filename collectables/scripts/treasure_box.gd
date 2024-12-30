extends Area2D

func _on_body_entered(body: Node2D) -> void:
	
	if body.has_method("draw_weapon_or_item"):
		body.draw_weapon_or_item()
		queue_free()
		
