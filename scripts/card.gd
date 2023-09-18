class_name Card extends Area2D


@export var board: Board

# CONSTS _______________________________________________________________________
var ANIMATION_DURATION = 0.08


# PRIVATE VARIABLES ____________________________________________________________
@onready var moves := $Moves
@onready var last_valid_pos := position

var is_dragging := false
var is_mouse_over := false
var is_on_board := false
var dragging_offset := Vector2.ZERO
var move_positions: Array[Vector2]


# SIGNAL HANDLERS_______________________________________________________________
func _on_mouse_entered() -> void: is_mouse_over = true
func _on_mouse_exited() -> void: is_mouse_over = false
