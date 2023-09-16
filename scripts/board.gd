@tool
class_name Board extends Node2D

# CONSTS________________________________________________________________________
const WIDTH := 8
const HEIGHT := WIDTH
const CELL_SIZE := 32

@onready var _tile_scene = preload("res://scenes/tile.tscn")
@onready var _grid: Dictionary = _initialize_grid()


func contains(global_position:Vector2) -> bool:
	var grid_width = CELL_SIZE * WIDTH
	var grid_height = CELL_SIZE * HEIGHT
	var offset = floor(CELL_SIZE / 2)
	var rect = Rect2(self.global_position - Vector2(offset, offset), Vector2(grid_width, grid_height))
	return rect.has_point(global_position)


func get_snap_position(global_position: Vector2) -> Vector2:
	return round(to_local(global_position) / CELL_SIZE) * CELL_SIZE + self.global_position


func is_position_valid(global_position: Vector2) -> bool:
	if contains(global_position):
		var cell: Cell = _grid[global_to_grid_position(global_position)]
		return cell.is_clear()
	return false


func get_cell_from(grid_position: Vector2) -> Vector2:
	return _grid[grid_position]


func add_card(card: Card) -> void:
	if contains(card.position):
		var cell: Cell = _grid[global_to_grid_position(card.position)]
		cell.add_card(card)


func clear_position(global_position) -> void:
	if contains(global_position):
		var cell: Cell = _grid[global_to_grid_position(global_position)]
		cell.clear()


func grid_position_to_world(grid_position: Vector2) -> Vector2:
	return grid_position * CELL_SIZE


func global_to_grid_position(global_position: Vector2) -> Vector2:
	return round(to_local(global_position) / CELL_SIZE)


func to_grid_position(local_position: Vector2) -> Vector2:
	return floor(local_position / CELL_SIZE)


func _initialize_grid() -> Dictionary:
	var grid: Dictionary
	
	for x in WIDTH:
		for y in HEIGHT:
			var cell: Node2D = _tile_scene.instantiate()
			cell.position.x = CELL_SIZE * x
			cell.position.y = CELL_SIZE * y
			grid[to_grid_position(cell.position)] = cell
			add_child(cell)
	
	return grid
