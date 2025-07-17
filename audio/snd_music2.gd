extends Node2D

var current = 1

func _ready() -> void:
	$second.volume_db = -80
	$third.volume_db = -80
	$fourth.volume_db = -80
	$first.play()
	$second.play()
	$third.play()
	$fourth.play()
	

func change_song():
	if current == 1:
		$first.volume_db = -80
		$second.volume_db = 0
	elif current == 2:
		$second.volume_db = -80
		$third.volume_db = 0
	elif current == 3:
		$third.volume_db = -80
		$fourth.volume_db = 0
	
	current += 1


func para_tudo():
	$first.stop()
	$second.stop()
	$third.stop()
	$fourth.stop()
	
