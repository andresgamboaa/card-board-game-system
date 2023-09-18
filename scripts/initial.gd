extends State

@onready var card: Card = owner

func enter() -> void:
	if card.move_positions.size() > 0: return
	
	for move in card.moves.get_children():
		card.move_positions.append(move.position)
	card.moves.queue_free()


func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and card.is_mouse_over:
		state_machine.transition_to("DRAG")
