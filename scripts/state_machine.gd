# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state)

var states: Dictionary = {}
@export var initial_state : State
@onready var state: State = initial_state
var prev_state


func _ready() -> void:
	await owner.ready
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
	if state:
		state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	if state: state.handle_input(event)


func _process(delta: float) -> void:
	if state: state.update(delta)


func _physics_process(delta: float) -> void:
	if state: state.physics_update(delta)


# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func to(target_state_name: String) -> void:
	# Safety check, you could use an assert() here to report an error if the state name is incorrect.
	# We don't use an assert here to help with code reuse. If you reuse a state in different state machines
	# but you don't want them all, they won't be able to transition to states that aren't in the scene tree.

	if not has_node(target_state_name):
		return
	
	#print("-> " + target_state_name)
	state.exit()
	prev_state = state
	state = get_node(target_state_name)
	state.enter()


func to_previous():
	state.exit()
	var aux = state
	#print("-> " + prev_state.name)
	state = prev_state
	prev_state = aux
	state.enter()
