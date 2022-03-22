extends MarginContainer

#从数据库中加载卡片的各项数据以及读取卡片的sprite
onready var cards_database = preload("res://Cards/Database/Cards_Database.gd")
var Card_name = "Ram"                                                         #一张卡牌的标识符，控制一张卡牌的所有属性
onready var Card_info = cards_database.DATA[cards_database.get(Card_name)]
onready var Card_img = str("res://Assets/Cards/",Card_info[0],"/",Card_name,".png")
onready var Entity = preload("res://Entities/Template/Template_allies.tscn")
onready var Method_of_check = Card_info[1]                                   #判断卡牌是否符合释放的要求
onready var Method_od_modify = Card_info[4]                                  #卡牌对另一实体进行操作时所调用的函数
onready var Card_type = Card_info[0]
onready var Card_cost = Card_info[7]
var start_position = 0
var target_position = 0
var start_rotation = 0
var target_rotation = 0
var target_slot = null

onready var Orig_scale = rect_scale


var t = 0
var setup = true
var start_scale = Vector2()
var Card_position = Vector2()           #用来存储卡牌在手中应该处于的位置
var Zoom_In_Size = 2                    #卡牌变换的空间
var Reorgansie_Neighbours = true		#重新组织隔壁的卡牌，让他们移动到正确的位置
var Card_Number=  0
var NumberCardsHand = 0
var Card_rotation = 0
var CARD_SELECTED = true #这个常量代表的意思是反过来的，true时代表该卡牌还未被选中E

enum{
	InHand
	InPlay
	InMouse
	FocusInHand
	MoveDrawnCardToHand
	ReOrganizeHand
	Standby
}

var state = InHand
var old_state = INF
var Movingto_Inplay = false

func _input(event: InputEvent) -> void:
	match state:                                             #下面是选中卡牌的代码，目前是拖拽
		InMouse,InPlay,FocusInHand:
			if event.is_action_pressed("left_key"):
				if CARD_SELECTED:
					old_state = state
					state =  InMouse
					setup = true 
					CARD_SELECTED = false
	match state	:                        
		InMouse:
			if Card_type == "Units":
				if event.is_action_released("left_key"):               #卡牌选中这里着重注意，如何重置old_state
					if not CARD_SELECTED:
						if old_state ==FocusInHand:
							
							var Cardslots = $'../../CardSlots' 
							var Card_Slot_Empty = $'../../'.Card_Slot_Empty
							var Card_Slot_members = $'../../'.Card_Slot_members
							var Play_Space = $'../../'
							
							for i in range(Cardslots.get_child_count()):
								if Card_Slot_Empty[i]:
									var Card_Slot_Pos = Cardslots.get_child(i).rect_position
									var Card_Slot_Size = Cardslots.get_child(i).rect_size
									var mouse_pos = $'../../CardSlots'.get_child(i).get_local_mouse_position() #判定是否拖到框里了
									if mouse_pos.x <Card_Slot_Size.x and mouse_pos.x>=0 and mouse_pos.y <Card_Slot_Size.y and mouse_pos.y>=0 :
										if Play_Space.check_cost(Card_cost):                   #检测费用是否足够释放卡牌
											Card_Slot_Empty[i] = false                         #用于把卡槽的插入状态重置
											target_slot= i
											setup = true
											Movingto_Inplay=true
											target_position = Card_Slot_Pos+Vector2(10,-50)                    #这里因为slot形状大小与CARD不相同，所以要重写
											state = InPlay
											CARD_SELECTED = true
											break
							if state != InPlay:
								setup = true
								target_position = Card_position
								state = old_state
								CARD_SELECTED = true
			if	Card_type == "Skills":                                  #这里是技能的判断机制
				if event.is_action_released("left_key"):               #卡牌选中这里着重注意，如何重置old_state
					if not CARD_SELECTED:
						if old_state ==FocusInHand:
							
							var Cardslots = $'../../CardSlots' 
							var Card_Slot_Empty = $'../../'.Card_Slot_Empty
							var Play_Space = $'../../'
							
							for i in range(Cardslots.get_child_count()):
								var Card_Slot_Pos = Cardslots.get_child(i).rect_position
								var Card_Slot_Size = Cardslots.get_child(i).rect_size
								var mouse_pos = $'../../CardSlots'.get_child(i).get_local_mouse_position() #判定是否拖到框里了
								var Card_Release_Database =$'../../Card_Release_Database'
								if mouse_pos.x <Card_Slot_Size.x and mouse_pos.x>=0 and mouse_pos.y <Card_Slot_Size.y and mouse_pos.y>=0:									
									if Card_Release_Database.check_permission(Method_of_check,i):                                            #这里调用函数库对是否能够释放进行判断
										if Play_Space.check_cost(Card_cost):                                     #检测费用是否足够释放卡牌
											target_slot= i                                                       #将对象slot的位置记下来，后面直接通过函数对其进行调用
											setup = true
											Movingto_Inplay=true
											target_position = Card_Slot_Pos
											state = InPlay
											CARD_SELECTED = true
											break
							if state != InPlay:
								setup = true
								target_position = Card_position
								state = old_state
								CARD_SELECTED = true                   
										
														
							
				



func _ready() -> void:
	#测试卡片的数据是否已经从数据库中读出
	rect_pivot_offset=rect_size/2
	$Card.texture = load(Card_img)
	#用于设置保证卡牌的图片与边框大小与CardBase设置的大小一致
	var Card_size = rect_size
	$Border.scale *= Card_size/$Border.texture.get_size()/5
	$Card.scale *= Card_size/$Card.texture.get_size()/5
	$CardBack.scale *= Card_size/$Card.texture.get_size()/5
	#设置卡片上各栏目显示的数据
	$Bars/Top_Bar/Name/CenterContainer/Name.text = Card_name


func _physics_process(delta: float) -> void:
	match state:
		Standby:                                                                #该状态是卡牌在后场等候的时候的状态
			Set_up()
			start_position = 0
			target_position = 0
			start_rotation = 0
			target_rotation = 0
			target_slot = null	
			
		InHand:
			pass
		InPlay:
			#当卡片移到游戏中去的时候调用的状态
			if Movingto_Inplay:
				if setup:
					Set_up()
				if t<= 1:
					rect_position = start_position.linear_interpolate(target_position,t) #线性插值，用于卡片的移动
					rect_rotation = start_rotation*(1-t)+target_rotation*t
					rect_scale = start_scale*(1-t)+Orig_scale*t	
					t+=delta*10 #卡片移动的速度
			
				else:
					rect_position = target_position
					rect_rotation = target_rotation
					Movingto_Inplay = false
					
					#1 这里的是对于类型为Units的卡牌所执行的实体化代码
					if Card_type == "Units" :
						var new_Entity= Entity.instance()        #这里是将自身的数据传送给游戏的实体类的代码，所以必须在释放前执行
						new_Entity.Sprite_of_entity=Card_img
						new_Entity.rect_scale = rect_scale
						new_Entity.scale_of_sprite = $Card.scale/2
						new_Entity.current_slot = target_slot
						new_Entity.target_position =rect_position                  #用于把sprite放置到合适的位置上
						new_Entity.Card_Name= Card_name
						
						new_Entity.attack = Card_info[1]
						new_Entity.defence = Card_info[2]
						new_Entity.blood = Card_info[3]
						
						
						
						$'../../Entities'.add_child(new_Entity)
						$'../../Entities'.Get_child_entities()
					  
						var parent_node = get_parent()
						#从场景移除
						parent_node.remove_child(self)         #这里没有立即释放掉本节点，而是在运行完以后再释放的.这里不用self就不行					
						parent_node.get_parent().ReOganize_all_cards()
						
						
							 
						queue_free()                       #移入下一个场景
					#1
					
					#2这里是对类型为Skills的卡牌所执行的释放代码
					if Card_type =="Skills":
						var Card_Slot_members = $'../../'.Card_Slot_members
						var target_entity = get_node(Card_Slot_members[target_slot])
						var Card_Attack_Darabase =$'../../Card_Attack_Darabase'                             #这里也是通过一个函数库来对目标卡牌进行操纵的
						Card_Attack_Darabase.card_data_modify(Method_od_modify,target_entity)
						
						var parent_node = get_parent()
						var Discard_pile =$'../../Discard_pile'
						parent_node.remove_child(self)
						Discard_pile.add_child(self)
						state=Standby                                                                       #转换为待机状态
						visible = false
		
						  
						parent_node.get_parent().ReOganize_all_cards()

					#2	
					
					
			
		InMouse:                              #选中卡牌时候的状态
			if setup:
				Set_up()
			if t<= 1:
				rect_position = start_position.linear_interpolate(get_global_mouse_position()-$'../../'.CardSize,t) #线性插值，用于卡片的移动
				rect_rotation = start_rotation*(1-t)+target_rotation*t
				rect_scale = start_scale*(1-t)+Orig_scale*t	
				t+=delta*4 #卡片移动的速度
		
		
			else:
				rect_position = get_global_mouse_position()-$'../../'.CardSize
				rect_rotation = 0
			
		FocusInHand:
			if setup:
				Set_up()
			if t<= 1:
				rect_position = start_position.linear_interpolate(target_position,t)
				rect_rotation = start_rotation*(1-t)+target_rotation*t
				rect_scale = start_scale*(1-t)+Orig_scale*t*2
				t+=delta*4     #卡片变换大小的速度
				if Reorgansie_Neighbours:
					Reorgansie_Neighbours = false
					NumberCardsHand = $'../../'.NumberCardsHand - 1                  #母节点的计数从0开始
					if Card_Number-1>=0:
						Move_neighbour_card(Card_Number-1,true,1)                    #ture代表左边
					if Card_Number-2>=0:
						Move_neighbour_card(Card_Number-2,true,0.25)    
					if Card_Number+1<=NumberCardsHand:
						Move_neighbour_card(Card_Number+1,false,1)    
					if Card_Number+2<=NumberCardsHand:
						Move_neighbour_card(Card_Number+2,false,0.25)    
			else:
				rect_position = target_position
				rect_rotation = target_rotation
				rect_scale=Orig_scale*2                    
		MoveDrawnCardToHand: #卡牌从桌面上到手里
			
			if t<= 1:
				rect_position = start_position.linear_interpolate(target_position,t) #线性插值，用于卡片的移动
				rect_rotation = start_rotation*(1-t)+target_rotation*t
				rect_scale.x= Orig_scale.x*abs(2*t-1)
				
				if $CardBack.visible:
					if t>=0.5:
						$CardBack.visible= false	
				t+=delta*4 #卡片移动的速度
		
			else:
				rect_position = target_position
				rect_rotation = target_rotation
				rect_scale = Orig_scale
				t=0
				state = InHand
		ReOrganizeHand:
			if setup:
				Set_up()
			
			if t<= 1:
				rect_position = start_position.linear_interpolate(target_position,t)
				rect_rotation = start_rotation*(1-t)+target_rotation*t
				rect_scale = start_scale*(1-t)+Orig_scale*t
				t+=delta*4     #卡片移动的速度
			else:
				rect_position = target_position
				rect_rotation = target_rotation
				rect_scale=Orig_scale
				t=0
				state = InHand
				
func Set_up():
	start_position = rect_position
	start_rotation = rect_rotation
	start_scale    = rect_scale
	t=0
	setup = false
	


func _on_Focus_mouse_entered() -> void:
	match state:
		InHand,ReOrganizeHand:
			setup = true
			target_rotation = 0
			target_position = Card_position
			target_position.y = get_viewport_rect().size.y-$'../../'.CardSize.y*Zoom_In_Size
			state = FocusInHand


func _on_Focus_mouse_exited() -> void:
		match state:
			FocusInHand:
				setup = true
				target_position = Card_position
				target_rotation = Card_rotation
				for Card in $'../'.get_children():
					#重置所有卡牌的组织邻居标记和参数
					Card.reset()
					Card.Reorgansie_Neighbours = true	
				state = ReOrganizeHand
				
			
func Move_neighbour_card(Card_num,direction,spreadfactor):
	var Neighbour_Card = $'../'.get_child(Card_num)
	if direction:
		Neighbour_Card.target_position = Neighbour_Card.Card_position - spreadfactor*Vector2(65,0)
	else:
		Neighbour_Card.target_position = Neighbour_Card.Card_position + spreadfactor*Vector2(65,0)
	Neighbour_Card.setup  = true	
	Neighbour_Card.state  = ReOrganizeHand
	
					
func reset():
	# reset函数，用于重置组织邻居以后的卡牌参数
	target_position = Card_position
	setup  = true	
	state  = ReOrganizeHand


