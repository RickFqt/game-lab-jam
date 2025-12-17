extends Decorator
class_name VariableCooldown

# No editor, você escreve o nome da variável: "current_shoot_cooldown" ou "current_dash_cooldown"
@export var cooldown_type: String = "current_shoot_cooldown"

var last_execution_time: float = -10000.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	var current_time = Time.get_ticks_msec() / 1000.0
	
	var dynamic_wait_time = actor.get(cooldown_type)
	
	if current_time - last_execution_time < dynamic_wait_time:
		return FAILURE

	var result = get_child(0).tick(actor, blackboard)
	if result == SUCCESS:
		last_execution_time = current_time
	
	return result
