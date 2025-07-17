extends Node2D

@onready var player = get_node("/root/Game/Player")
@onready var mico = get_node("/root/Game/Mico")
var opened = false
var has_mico = false

signal mico_found

func _ready() -> void:
	mico_found.connect(Callable(mico, "_on_mico_found"))

func open():
	opened = true
	$AnimatedSprite2D.play("open")
	await $AnimatedSprite2D.animation_finished
	if has_mico:
		has_mico = false
		mico_found.emit()

func close():
	opened = false
	$AnimatedSprite2D.play("close")



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player and !opened:
		open()
