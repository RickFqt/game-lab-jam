extends StaticBody2D

var health = 1
const CAJU_SPAWN_CHANCE = 30 # 30% de chance de spawnar caju ao cortar um mato
var flag = true

@onready var player = get_node("/root/Game/Player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func take_damage(damage: int):
	if flag == true:
		
		health = max(health - damage, 0)
		
		if health == 0:
			flag = false
			$Sprite2D.visible = false
			$CollisionShape2D.call_deferred("set","disabled",true)
			if randi()%100 <= CAJU_SPAWN_CHANCE:
				spawn_caju()
			$snd_corta.play()
			
	
		
func _spawn_caju(caju):
	get_parent().add_child(caju)
	
func spawn_caju():
	var caju = preload("res://collectables/scenes/caju.tscn").instantiate()
	caju.global_position = global_position
	caju.player_target = player
	#caju.connect_to_player()
	call_deferred("_spawn_caju", caju)
	


func _on_snd_corta_finished() -> void:
	queue_free()
