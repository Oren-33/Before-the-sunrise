


enum {beacon,Ram,attack}


const DATA={
	beacon:
		["Units",3,3,3,0,0,0,1],
	Ram:
		["Units",3,4,3,0,0,0,1],                                                                     # 3 , 4 , 3分别代表攻击，防御，血量     最后的1代表该卡牌的费用
	attack:
		["Skills","main_character",1,4,"common_attack","single",3,1]                            #maincharacter 代表该卡是否可以释放的判断函数 1，4代表释放的距离是1到4格。single是卡牌的攻击范围。common_attack 代表释放时调用的函数，3是释放时的参数    最后的1代表该卡牌的费用
}



func _ready() -> void:
	pass
#	print(DATA.get(beacon))

