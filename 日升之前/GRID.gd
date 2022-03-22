extends TileMap
class_name Grid

onready var grid_size = Vector2(6, 6)
onready var start_position = Vector2(10,10)
const STEP = 16

var grid: Array
export var line_color: Color
export var line_thickness: int = 1
onready var test = preload("res://Cards/Database/Cards_Database.gd")
onready var CardInfo = test.DATA[test.get("beacon")]


func init_grid():
	grid = []
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
			
func _ready():
	init_grid()		
	print(CardInfo)



func _draw():
	for x in range(grid_size.x+1):
		var start_point: Vector2 = Vector2(x * cell_size.x+start_position.x*STEP , start_position.y*STEP)
		var end_point: Vector2 = Vector2(x * cell_size.x+start_position.x*STEP, grid_size.y * cell_size.y+start_position.y*STEP)
		draw_line(start_point, end_point, line_color, line_thickness)
		
	for y in range(grid_size.y+1):
		var start_point: Vector2 = Vector2(start_position.x*STEP, y * cell_size.y+start_position.y*STEP)
		var end_point: Vector2 = Vector2(grid_size.x * cell_size.x+start_position.x*STEP, y * cell_size.y+start_position.y*STEP)
		draw_line(start_point, end_point, line_color, line_thickness)
