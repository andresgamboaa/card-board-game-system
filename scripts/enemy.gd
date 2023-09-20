class_name Enemy extends Node2D


# Properties ___________________________________________________________________
@export var life := 2:
	set(value):
		life = value

@export var animation_duration := 0.5


# Publid methods _______________________________________________________________
func take_damage(damage: int) -> int:
	life -= damage
	if life <= 0:
		queue_free()
	return life


func snap_to(position) -> Signal:
	return create_tween().tween_property(
		self, 
		"global_position",
		Global.board.get_snap_position(position),
		animation_duration
	).finished
