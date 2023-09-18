extends State

@onready var card: Card = owner

func enter():
	card.z_index = 100
	
	if card._is_on_board:
		card.board.mark_valid_positions(card.move_positions.map(
			func(pos): return card.to_global(pos) as Vector2
		))
	
	card._dragging_offset = get_viewport().get_mouse_position() - card.position


func physics_update(_delta) -> void:
	card.position = get_viewport().get_mouse_position() - card._dragging_offset
	
	if Input.is_action_just_released("click"): 
		release()


func release():
	if card.board.is_position_valid(card.position, card._is_on_board):
		await play_snap_animation()
		card._is_on_board = true
		card.board.add_card(card)
		card.board.clear_position(card._last_valid_pos)
		card._last_valid_pos = card.position
		card.z_index = 0
		state_machine.transition_to("IDLE")
	else:
		await play_snap_animation()
		card.z_index = 0
		state_machine.transition_to_prev_state()


func exit():
	card.board.unmark_valid_positions()


func play_snap_animation():
	return create_tween().tween_property(
		card, 
		"position",
		card.board.get_snap_position(card.position),
		card.ANIMATION_DURATION
	).finished
