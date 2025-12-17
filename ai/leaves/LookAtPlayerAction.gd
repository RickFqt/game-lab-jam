extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var boss = actor as BossBase 
	update_animation_facing(boss)
	return RUNNING

func update_animation_facing(boss : BossBase):
	if not boss.player: return
	boss.look_at(boss.player.position)
	var sprite = boss.get_node("AnimatedSprite2D")
	if boss.global_position.x < boss.player.position.x:
		sprite.scale.y = 0.25
	else:
		sprite.scale.y = -0.25
