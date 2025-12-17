extends BossBase
class_name BeijaFlorBoss

# Variáveis de configuração (Blackboard)
@export var bullet_damage = damage
@export var bullet_speed = 6 * speed
@export var chase_duration := 3.0

# Cooldowns dinâmicos (controlados pela dificuldade)
var current_shoot_cooldown := 2.0
var current_dash_cooldown := 5.0
var current_chase_cooldown := 10.0

# Dados de Espaço
var room_x = 640
var room_y = 300
var corners : Array
var calculated_corners := false

func _ready():
	super._ready()
	# Removemos os connects de timers aqui. A BT controlará o tempo.
	player.add_health(player.player_attributes.max_health)
	adapt_behavior() # Define os valores iniciais

func adapt_behavior():
	match stage:
		1:
			current_shoot_cooldown = 2.0
			current_dash_cooldown = 5.0
		2:
			current_shoot_cooldown = 1.5
			current_dash_cooldown = 4.0
		3:
			current_shoot_cooldown = 1.0
			current_dash_cooldown = 3.0
