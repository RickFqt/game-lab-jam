extends ActionLeaf


var current_tween: Tween

func before_run(actor: Node, blackboard: Blackboard):
	var boss = actor as BossBase
	perform_dash(boss)

func tick(actor: Node, blackboard: Blackboard) -> int:
	var boss = actor as BossBase
	
	if current_tween and current_tween.is_valid() and current_tween.is_running():
		return RUNNING
		
	# Se 'current_tween' não é nulo, mas não está rodando, significa que acabou.
	if current_tween:
		current_tween = null # Limpa a referência
		return SUCCESS
	
	perform_dash(boss)
	return RUNNING

func calculate_corners_if_needed(boss : BossBase):
	if boss.calculated_corners: return
	var global_pos = boss.global_position
	var room_x = boss.room_x
	var room_y = boss.room_y
	var top_left = global_pos
	var top_right = global_pos + Vector2(room_x, 0)
	var bottom_right = global_pos + Vector2(room_x, room_y)
	var bottom_left = global_pos + Vector2(0, room_y)
	boss.corners = [top_left, top_right, bottom_right, bottom_left]
	boss.calculated_corners = true

func perform_dash(boss : BossBase):
	calculate_corners_if_needed(boss)
	
	var idx = randi() % boss.corners.size()
	var target = boss.corners[idx]
	
	# Evita ir para onde já está
	if boss.global_position.distance_to(target) < 10.0:
		target = boss.corners[(idx + 1) % boss.corners.size()]

	# Marcamos que o dash começou
	current_tween = create_tween()
	var target_rotation = boss.rotation + deg_to_rad(360)
	current_tween.tween_property(boss, "rotation", target_rotation, 0.7)
	current_tween.tween_property(boss, "global_position", target, 0.5)
