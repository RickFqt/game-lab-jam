extends Area2D

var value: int = 10  # Valor da moeda em experiência
var is_attracted: bool = false
var player_target: Node2D = null
var attraction_speed: float = 210.0
var flag = true

func _ready():
	add_to_group("experience_coins")  # Adiciona ao grupo para fácil acesso
	if player_target:
		connect_to_player()
	if value < 10:
		%Sprite2D.texture = load("res://textures/Gem_green.png")
	elif value < 50:
		%Sprite2D.texture = load("res://textures/Gem_blue.png")
	else:
		%Sprite2D.texture = load("res://textures/Gem_red.png")

func connect_to_player():
	player_target.player_attributes_changed.connect(_on_player_attributes_changed)
	_on_player_attributes_changed()

func _on_player_attributes_changed():
	# Atualiza o tamanho da área de coleta
	var new_radius = player_target.player_attributes.collect_range
	$CollectArea.shape.radius = new_radius

func _process(delta: float):
	if player_target and flag:
		
		if is_attracted:
			var direction = (player_target.global_position - global_position).normalized()
			position += direction * attraction_speed * delta

		# Se estiver perto o suficiente, adiciona experiência e remove a moeda
		if global_position.distance_to(player_target.global_position) < 15.0:
			flag = false
			%Sprite2D.visible = false
			player_target.add_experience(value)
			%snd_pickup.play()

func start_attraction(player: Node2D):
	is_attracted = true
	player_target = player


func _on_body_entered(body: Node2D) -> void:
	# Verifica se o player entrou na área
	if body == player_target:
		is_attracted = true


func _on_snd_pickup_finished() -> void:
	queue_free()
