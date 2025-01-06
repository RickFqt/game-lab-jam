extends Area2D

func _on_body_entered(body: Node2D) -> void:
	
	if body.has_method("draw_weapon_or_item"):
		var weapons = body.draw_weapon_or_item(1)
		if weapons:
			body.upgrade_weapons_inventory(weapons[0])
		queue_free()
		
