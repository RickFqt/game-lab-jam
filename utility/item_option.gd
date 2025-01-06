extends ColorRect

var mouse_over = false
var item_scene = null
@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade)

func _ready() -> void:
	connect("selected_upgrade", Callable(player, "upgrade_weapons_inventory"))
	#connect("selected_upgrade", Callable(player, "draw_weapon_or_item"))

func _input(event):
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item_scene)

func _on_mouse_entered() -> void:
	mouse_over = true


func _on_mouse_exited() -> void:
	mouse_over = false
