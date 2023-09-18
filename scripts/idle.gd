extends State

@onready var card: Card = owner


func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("click") and card.is_mouse_over:
		to("DRAG")
