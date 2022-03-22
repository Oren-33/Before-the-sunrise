extends Node






func check_permission(method,i):                    #
	match method:
		"main_character":
			if  not $'../'.Card_Slot_Empty[i]:
				return true
	

