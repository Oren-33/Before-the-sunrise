extends TextureButton
var Decksize = INF






func _ready() -> void:
	rect_scale*=$'../../'.CardSize/rect_size



func _gui_input(event: InputEvent) -> void:                             #这里是测试用的抽卡函数
	if(Input.is_action_just_pressed("left_key")):
		if(Decksize>0):
			Decksize=$'../../'.draw_deck()
			if(Decksize==0):
				disabled = true
				
		
