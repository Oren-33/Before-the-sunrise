extends MarginContainer
var Sprite_of_entity
var target_position
var state
var scale_of_sprite
var current_slot                                       #该变量用于标记目前在哪一个插槽，也用于一开始初始化的时候将自己的位置传给存储插槽地址的变量
var Card_Name

var Card_Slot_members                                   #用来引用卡牌卡槽的地址，用于在卡牌移动的时候进行判断
var Card_Slot_Empty
var Card_Slot
var Play_Space

var blood
var attack 
var defence

enum{
	selected
	unselected
	to_be_selected
	unbalanced
}

func _ready() -> void:
	$Entity_Sprite.texture = load(Sprite_of_entity)
	$Entity_Sprite.scale*=scale_of_sprite
	rect_position = target_position                #实验性代码，测试产生位置
	
	state = unselected
	add_to_group("Entities")                  #将自己加入实体分组内
	
	Card_Slot_members = $'../../'.Card_Slot_members
	Card_Slot_members[current_slot]=self.get_path()                                 #在初始化的时候将自己的位置放入Slot记录数组中去
		

func _input(event: InputEvent) -> void:
#	match state:
#		selected:
#			if event.is_action_pressed("right_key"):
#				state = unselected
#				print("cancel")
#				pass
#
#
#		unselected:
			pass
					
			
	
func recall_back(target_card):                                 #向呼唤自己的卡牌传回自己的地址
	if state == to_be_selected:
		self.get_path()
		get_node(target_card).check()
	pass


func _on_Hover_Checker_mouse_entered() -> void:
	state = to_be_selected



func _on_Hover_Checker_mouse_exited() -> void:
	state = unselected


func set_blood(blood):
	$Bars/Top_Bar/Name/CenterContainer/Blood.text = String(blood)


func end_of_turn():                                      #每个回合结束的时候执行的函数，通过调用End_of_turn节点库里的方法使节点移动,只需传递函数自己的位置以及名称即可
	var End_of_turn  =  $'../../End_of_turn_Darabase'
	End_of_turn.end_of_turn(Card_Name,self.get_path())

