extends State

@onready var card: Card = owner

func enter():
	card.z_index = 100
	
	if card.is_on_board:
		card.board.mark_valid_positions(card.move_positions.map(
			func(pos): return card.to_global(pos) as Vector2
		))
	
	card.dragging_offset = get_viewport().get_mouse_position() - card.position


func physics_update(_delta) -> void:
	card.position = get_viewport().get_mouse_position() - card.dragging_offset
	
	if Input.is_action_just_released("click"): 
		release()


func release():
	if card.board.is_position_valid(card.position, card.is_on_board):
		await snap_to(card.position)
		card.is_on_board = true
		card.board.add_card(card)
		card.board.clear_position(card.last_valid_pos)
		card.last_valid_pos = card.position
		card.z_index = 0
		to("IDLE")
	else:
		await snap_to(card.last_valid_pos)
		card.z_index = 0
		go_back()


func exit():
	card.board.unmark_valid_positions()


func snap_to(position) -> Signal:
	return create_tween().tween_property(
		card, 
		"position",
		card.board.get_snap_position(position),
		card.ANIMATION_DURATION
	).finished
