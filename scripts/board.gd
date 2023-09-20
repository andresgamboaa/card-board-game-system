@tool
class_name Board extends Node2D


# CONSTS _______________________________________________________________________
const WIDTH := 8
const HEIGHT := WIDTH
const TILE_SIZE := 32


# PRIVATE VARIABLES ____________________________________________________________
@onready var _tile_scene = preload("res://scenes/tile.tscn")
@onready var _grid: Dictionary = _initialize_grid()


# PUBLIC METHODS _______________________________________________________________

func get_snap_position(global_position: Vector2) -> Vector2:
	return (
		round(to_local(global_position) / TILE_SIZE) * TILE_SIZE +
		self.global_position
	)


func mark_valid_positions(global_positions) -> void:
	for global_position in global_positions:
		var tile: Tile = get_tile_at(global_position)
		if is_instance_valid(tile):
			tile.valid = true


func unmark_valid_positions() -> void:
	for tile in _grid.values():
		tile.valid = false


func is_position_valid(global_position: Vector2, only_clear_tiles) -> bool:
	var tile = get_tile_at(global_position)
	if is_instance_valid(tile):
		if only_clear_tiles:
			return tile.is_clear() and tile.valid
		return tile.is_clear()
	else:
		return false


func get_tiles() -> Array:
	return _grid.values()


func get_tile_at(global_position: Vector2) -> Tile:
	return _grid.get(global_to_grid_position(global_position))


func add_card(card: Card) -> void:
	var tile = get_tile_at(card.global_position)
	if is_instance_valid(tile): 
		tile.add_card(card)


func clear_position(global_position: Vector2) -> void:
	var tile = get_tile_at(global_position)
	if is_instance_valid(tile): 
		tile.clear()


func grid_position_to_local(grid_position: Vector2) -> Vector2:
	return grid_position * TILE_SIZE


func global_to_grid_position(global_position: Vector2) -> Vector2:
	return round(to_local(global_position) / TILE_SIZE)


func to_grid_position(local_position: Vector2) -> Vector2:
	return floor(local_position / TILE_SIZE)


# PRIVATE METHODS ______________________________________________________________
func _initialize_grid() -> Dictionary:
	var grid: Dictionary
	
	for x in WIDTH:
		for y in HEIGHT:
			var tile: Node2D = _tile_scene.instantiate()
			tile.position.x = TILE_SIZE * x
			tile.position.y = TILE_SIZE * y
			grid[to_grid_position(tile.position)] = tile
			add_child(tile)
	
	return grid

func _ready():
	Global.board = self
