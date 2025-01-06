extends Node2D


func play_walk():
	%AnimationPlayer.play("walk")

func change_to_boss():
	%SlimeFace.texture
	%SlimeFace.texture = load("res://characters/slime/slime_hurt_eyes.png")

func play_hurt():
	%AnimationPlayer.play("hurt")
	%AnimationPlayer.queue("walk")
