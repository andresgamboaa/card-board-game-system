extends Node2D

@export var enemy_scene: PackedScene

func _ready():
	spawn_enemies(3)


func spawn_enemies(number: int) -> void:
	var tiles = Global.board.get_tiles() as Array[Tile]
	
	for i in range(number):
		var tile = tiles[randi_range(0, len(tiles)-1)]
		var enemy = enemy_scene.instantiate() as Enemy
		add_child(enemy)
		await enemy.snap_to(tile.global_position)
		tile.add_card(enemy)
