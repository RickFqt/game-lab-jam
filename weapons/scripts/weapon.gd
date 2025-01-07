extends Area2D

class_name Weapon

signal player_attributes_changed
var attributes: Attributes = Attributes.new()
var player_attributes: PlayerAttributes = PlayerAttributes.new()
var level: int = 1
var image = preload("res://textures/enemy/giant_amoeba_new.png")
var descriptions : Array = []
var weapon_name : String = "Default"

func level_up(_amount : int) -> void:
	pass

func calculate_area() -> float:
	return attributes.base_area * player_attributes.area_mult

func calculate_damage() -> float:
	return attributes.base_damage * player_attributes.damage_mult

func calculate_cooldown() -> float:
	return attributes.base_cooldown * player_attributes.cooldown_mult

func calculate_speed() -> float:
	return attributes.base_speed * player_attributes.speed_mult

func calculate_duration() -> float:
	return attributes.base_duration * player_attributes.duration_mult

func calculate_projectiles() -> int:
	return attributes.n_projectiles + player_attributes.n_projectiles

func update_player_attributes(p_att : PlayerAttributes) -> void:
	player_attributes = p_att
	player_attributes_changed.emit()
	

func reached_max_level() -> bool:
	return attributes.max_level <= attributes.level
