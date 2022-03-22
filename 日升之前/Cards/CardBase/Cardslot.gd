extends MarginContainer
var number


func _ready() -> void:
	$Sprite.scale *= rect_size/$Sprite.texture.get_size()
	
	pass

