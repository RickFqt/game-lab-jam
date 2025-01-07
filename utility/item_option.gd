extends ColorRect

var mouse_over = false
var item_scene = null
@onready var player = get_tree().get_first_node_in_group("player")
@onready var lblName = $lbl_name
@onready var lblDescription = $lbl_description
@onready var lblLevel = $lbl_level
@onready var itemIcon = $ColorRect/ItemIcon

signal selected_upgrade(upgrade)

func _ready() -> void:
	connect("selected_upgrade", Callable(player, "upgrade_weapons_inventory"))
	
	if item_scene != null:
		var weapon_name = item_scene.resource_path.get_file().get_basename()
		if player.weapons_inventory.has(weapon_name):
			var weapon : Weapon = player.weapons_inventory[weapon_name]
			itemIcon.texture = weapon.image
			lblDescription.text = weapon.descriptions[weapon.level - 1]
			lblName.text = weapon.weapon_name
			lblLevel.text = "Level: " + str(weapon.level + 1)
		else:
			itemIcon.texture = load(player.weapons_image_path[weapon_name][0])
			lblDescription.text = player.weapons_image_path[weapon_name][1]
			lblName.text = player.weapons_image_path[weapon_name][2]
	#connect("selected_upgrade", Callable(player, "draw_weapon_or_item"))
	#var item = item_scene.instantiate()
	#print(item.description)
	#itemIcon.texture = item.image

func _input(event):
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item_scene)

func _on_mouse_entered() -> void:
	mouse_over = true


func _on_mouse_exited() -> void:
	mouse_over = false
