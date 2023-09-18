@tool
class_name Board extends Node2D


# CONSTS _______________________________________________________________________
const WIDTH := 8
const HEIGHT := WIDTH
const CELL_SIZE := 32


# PRIVATE VARIABLES ____________________________________________________________
@onready var _tile_scene = preload("res://scenes/tile.tscn")
@onready var _grid: Dictionary = _initialize_grid()


# PUBLIC METHODS _______________________________________________________________
func contains(global_position:Vector2) -> bool:
	var grid_width = CELL_SIZE * WIDTH
	var grid_height = CELL_SIZE * HEIGHT
	var offset = floor(CELL_SIZE / 2)
	var rect = Rect2(
		self.global_position - Vector2(offset, offset), 
		Vector2(grid_width, grid_height)
	)
	return rect.has_point(global_position)


func get_snap_position(global_position: Vector2) -> Vector2:
	return (
		round(to_local(global_position) / CELL_SIZE) * CELL_SIZE +
		self.global_position
	)


func mark_valid_positions(global_positions) -> void:
	for global_position in global_positions:
		var cell: Cell = get_cell_at(global_position)
		if is_instance_valid(cell):
			cell.valid = true


func unmark_valid_positions() -> void:
	for cell in _grid.values():
		cell.valid = false


func is_position_valid(global_position: Vector2, only_clear_cells) -> bool:
	var cell = get_cell_at(global_position)
	if is_instance_valid(cell):
		if only_clear_cells:
			return cell.is_clear() and cell.valid
		return cell.is_clear()
	else:
		return false


func get_cell_at(global_position: Vector2) -> Cell:
	return _grid.get(global_to_grid_position(global_position))


func add_card(card: Card) -> void:
	var cell = get_cell_at(card.global_position)
	if is_instance_valid(cell): 
		cell.add_card(card)


func clear_position(global_position: Vector2) -> void:
	var cell = get_cell_at(global_position)
	if is_instance_valid(cell): 
		cell.clear()


func grid_position_to_local(grid_position: Vector2) -> Vector2:
	return grid_position * CELL_SIZE


func global_to_grid_position(global_position: Vector2) -> Vector2:
	return round(to_local(global_position) / CELL_SIZE)


func to_grid_position(local_position: Vector2) -> Vector2:
	return floor(local_position / CELL_SIZE)


# PRIVATE METHODS ______________________________________________________________
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
