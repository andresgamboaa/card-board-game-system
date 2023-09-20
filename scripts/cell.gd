class_name Tile extends Node2D

var content:
	set(value):
		if is_instance_valid(value) and value.global_position == global_position:
			content = value
		else:
			content = null


var valid: bool:
	set(value):
		valid = value
		$ValidSprite.visible = valid


func add_card(card: Node2D):
	content = card


func clear():
	content = null


func is_clear() -> bool:
	return content == null
