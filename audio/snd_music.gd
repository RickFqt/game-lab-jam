extends Node2D



func _on_musica_inicio_finished() -> void:
	$musica_final.play()



func _on_musica_meio_finished() -> void:
	$musica_final.play()


func _on_musica_final_finished() -> void:
	$musica_meio.play()

func _on_musica_boss_level_1_finished() -> void:
	$musica_boss_level1.play()

func start_boss_level1() -> void:
	para_tudo()
	$musica_boss_level1.play()


func para_tudo():
	$musica_inicio.stop()
	$musica_meio.stop()
	$musica_final.stop()
	$musica_boss_level1.stop()
	
