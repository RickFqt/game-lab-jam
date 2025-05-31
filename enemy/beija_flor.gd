extends BossBase

enum State { IDLE, SHOOT, DASH, CHASE }

var state: State = State.IDLE
var shoot_timer: Timer
var dash_timer: Timer
var chase_timer: Timer

var corner_index := 0  # de 0 a 3
#0 - canto superior esquerdo
#1 - canto superior direito
#2 - canto inferior direito
#3 - canto inferior esquerdo
var room_x = 30
var room_y = 30
var corners : Array

func _ready():
	super._ready()
	shoot_timer = $ShootTimer
	dash_timer = $DashTimer
	chase_timer = $ChaseTimer
	shoot_timer.timeout.connect(_on_shoot_timeout)
	dash_timer.timeout.connect(_on_dash_timeout)
	chase_timer.timeout.connect(_on_chase_timeout)
	calculate_corners()
	start_phase()

func calculate_corners():
	var top_left = position
	var top_right = position + Vector2(room_x, 0)
	var bottom_right = position + Vector2(room_x, room_y)
	var bottom_left = position + Vector2(0, room_y)
	corners = [top_left, top_right, bottom_right, bottom_left]

func start_phase():
	match stage:
		1:
			shoot_timer.start(2.0)
			dash_timer.start(5.0)
		2:
			shoot_timer.start(1.2)
			dash_timer.start(3.5)
		3:
			shoot_timer.start(1.0)
			dash_timer.start(3.0)
			chase_timer.start(7.0)

func make_attack():
	# Dispara projétil em direção ao jogador
	if not player: return
	var direction = (player.global_position - global_position).normalized()
	#TODO: Ajeitar o spawn projectile
	#spawn_projectile(direction)

func spawn_projectile(dir: Vector2):
	var p = preload("res://weapons/aux_scenes/bullet.tscn").instantiate()
	p.global_position = global_position
	#p.direction = dir
	get_tree().current_scene.add_child(p)

func _on_shoot_timeout():
	make_attack()
	shoot_timer.start()  # reinicia com o mesmo tempo

func _on_dash_timeout():
	dash_to_random_corner()
	dash_timer.start()

func _on_chase_timeout():
	if stage == 3:
		state = State.CHASE
		# Dura 3 segundos, por exemplo
		await get_tree().create_timer(3.0).timeout
		state = State.IDLE
		chase_timer.start()

#TODO: Ajeitar os corners
func dash_to_random_corner():
	var target = corners[randi() % corners.size()]
	var duration = 0.5
	var tween = create_tween()
	tween.tween_property(self, "global_position", target, duration)

func _physics_process(delta):
	if state == State.CHASE and player:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
		move_and_slide()
