extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var boss = actor as BossBase
	perform_shoot(boss)
	return SUCCESS

func perform_shoot(boss : BossBase):
	if not boss.player: return
	var direction = (boss.player.global_position - boss.global_position).normalized()
	spawn_projectile(direction, boss)

func spawn_projectile(dir: Vector2, boss : BossBase):
	var p = preload("res://enemy/bullets/bulletenemy.tscn").instantiate()
	p.global_position = boss.global_position
	p.damage = boss.bullet_damage
	p.speed = boss.bullet_speed
	p.rotation = dir.angle()
	p.RANGE = 1200
	get_tree().current_scene.add_child(p)
