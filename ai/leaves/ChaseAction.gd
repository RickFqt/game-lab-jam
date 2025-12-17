extends ActionLeaf

var timer: float = 0.0
@export var duration: float = 3.0 

func before_run(actor: Node, blackboard: Blackboard):
	timer = 0.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	var boss = actor as BossBase
	
	timer += get_physics_process_delta_time()
	
	if not boss.player: return FAILURE
	var dir = (boss.player.global_position - boss.global_position).normalized()
	boss.velocity = dir * boss.speed
	boss.move_and_slide()
	
	if timer >= duration:
		timer = 0.0
		return SUCCESS # Terminou a perseguição
		
	return RUNNING # Continua perseguindo
