extends Node2D


var Entities = []                                                 #存储着所有实体

func _ready() -> void:
	pass # Replace with function body.


func Get_child_entities():                                        #每当要往Entities下面添加新的实体的时候都要调用该函数
	Entities = get_children()
func check():
	pass
