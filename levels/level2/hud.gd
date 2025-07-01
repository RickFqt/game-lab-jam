extends CanvasLayer

@onready var timer_node = get_node("/root/Game/BossTimer")
@onready var label = $TimerLabel

func _process(delta):
	var time_left = timer_node.time_left
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	label.text = "%02d:%02d" % [minutes, seconds]
