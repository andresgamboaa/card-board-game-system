class_name Cell extends Node2D

var content:
	set(value):
		if is_instance_valid(value) and value.global_position == global_position:
			content = value
		else:
			content = null

func add_card(card: Card):
	content = card

func clear():
	content = null

func is_clear() -> bool:
	return content == null
