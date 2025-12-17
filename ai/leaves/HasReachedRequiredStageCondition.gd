extends ConditionLeaf

@export var stage_required = 3

func tick(actor: Node, blackboard: Blackboard) -> int:
	var boss = actor as BossBase
	if not boss.player:
		return FAILURE
	if boss.stage < stage_required:
		return FAILURE
	return SUCCESS
