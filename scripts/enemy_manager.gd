extends Node2D

@export var enemy_scene: PackedScene

func _ready():
	spawn_enemies(3)


func spawn_enemies(number: int) -> void:
	var cells = Global.board.get_cells() as Array[Cell]
	
	for i in range(number):
		var cell = cells[randi_range(0, len(cells)-1)]
		var enemy = enemy_scene.instantiate() as Enemy
		add_child(enemy)
		await enemy.snap_to(cell.global_position)
		cell.add_card(enemy)
