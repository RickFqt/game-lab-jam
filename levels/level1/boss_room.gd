extends Node2D
@onready var boss = get_node("/root/Game/BossRoom/BeijaFlor")

func _ready():
	%Camera2D.make_current()
	boss.damaged.connect(_on_boss_damaged)
	boss.died.connect(_on_boss_died)
	%HealthBar.max_value = boss.max_health
	%HealthBar.value = boss.max_health
	$FlowersWin.visible = false;
	print(get_tree_string_pretty()) 
	pass

func _on_boss_damaged():
	%HealthBar.value = boss.health
func _on_boss_died():
	$FlowersWin.visible = true;
	for f in $FlowersWin.get_children():
		f.get_child(0).play("default");
