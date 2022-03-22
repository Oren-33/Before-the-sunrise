extends Node2D



#这里是攻击类函数库，所有攻击类函数所调用的方法都在这里




func card_data_modify(method,target_entity):                   #用于对卡牌的数值进行改动
	match method:
		"common_attack":
			target_entity.set_blood(10)
			
	
