extends Node2D


onready var	Card_Slot_members = $'../'.Card_Slot_members
onready var	Card_Slot_Empty=  $'../'.Card_Slot_Empty
onready var	Card_Slot = $'../'.Card_Slot


#这里是回合结束函数库，所有回合结束时实体类会调用的函数都在这里


func end_of_turn(Card_Name,Card_Path):                   #用于对卡牌的数值进行改动, 目前在回合结束的时候卡牌向前移动，需要增加回合结束时对前方的实体进行操作的函数
	match Card_Name:
		"Ram":
			var Card = get_node(Card_Path)
			if (Card.current_slot<Card_Slot_Empty.size()-1):
				if Card_Slot_Empty[Card.current_slot+1] :
					Card.rect_position = Card_Slot[Card.current_slot+1].rect_position+Vector2(10,-50)
					$'../'.Card_Slot_Empty[Card.current_slot] = true
					$'../'.Card_Slot_Empty[Card.current_slot+1] = false
					$'../'.Card_Slot_members[Card.current_slot] = null
					$'../'.Card_Slot_members[Card.current_slot+1] = Card_Path 
					Card.current_slot = Card.current_slot+1

					
	
