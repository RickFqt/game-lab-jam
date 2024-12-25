extends Area2D

class_name Weapon

var attributes: Attributes = Attributes.new()
var player_attributes: PlayerAttributes = PlayerAttributes.new()
var level: int = 1

func level_up(level : int) -> void:
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

func update_player_attributes(p_att : PlayerAttributes) -> void:
	player_attributes = p_att
