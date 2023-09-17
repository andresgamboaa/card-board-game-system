class_name Card extends Area2D


@export var board: Board

# CONSTS _______________________________________________________________________
var ANIMATION_DURATION = 0.08


# PRIVATE VARIABLES ____________________________________________________________
@onready 
var _last_valid_pos := position
var _is_dragging := false
var _is_mouse_over := false
var _is_on_board := false
var _dragging_offset := Vector2.ZERO
var _moves: Array[Vector2]


func _ready():
	for tile in $Moves.get_children():
		_moves.append(tile.position)
	$Moves.queue_free()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and _is_mouse_over:
		_start_dragging()
	elif Input.is_action_just_released("click") and _is_dragging:
		_release()
	if _is_dragging: _drag()


# ACTIONS ______________________________________________________________________
func _start_dragging() -> void:
	z_index = 100
	
	if _is_on_board:
		board.mark_valid_positions(_moves.map(
			func(pos): return to_global(pos) as Vector2
		))
	
	_dragging_offset = get_viewport().get_mouse_position() - position
	_is_dragging = true


func _drag() -> void:
	position = get_viewport().get_mouse_position() - _dragging_offset


func _release():
	_is_dragging = false
	
	if board.is_position_valid(position, _is_on_board):
		await create_tween().tween_property(
			self, 
			"position",
			board.get_snap_position(position),
			ANIMATION_DURATION
		).finished
		
		_is_on_board = true
		board.unmark_valid_positions()
		board.add_card(self)
		board.clear_position(_last_valid_pos)
		_last_valid_pos = position
		z_index = 0
	else:
		await create_tween().tween_property(
			self, 
			"position",
			board.get_snap_position(_last_valid_pos),
			ANIMATION_DURATION
		).finished
		
		board.unmark_valid_positions()
		z_index = 0


# SIGNAL HANDLERS_______________________________________________________________
func _on_mouse_entered() -> void: _is_mouse_over = true
func _on_mouse_exited() -> void: _is_mouse_over = false
