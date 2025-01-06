extends TextureRect


var item = null
var icon_path = null
func _ready():
	set_size(Vector2(110, 110))
	if item != null:
		$ItemTexture.texture = item.image

func update_texture():
	$ItemTexture.texture = icon_path
