extends Node
class_name State

## Base class for all state machine states
## States handle specific behaviors and determine when to transition to other states

## Reference to the entity (Mask) that owns this state
var entity: Node = null

## Reference to the state machine managing this state
var state_machine: Node = null

## Called when entering this state
func enter() -> void:
	pass

## Called when exiting this state
func exit() -> void:
	pass

## Called every physics frame while in this state
## Should return the name of the next state, or empty string to stay in current state
func update(_delta: float) -> String:
	return ""

## Called to get the name of this state (for debugging)
func get_state_name() -> String:
	return name
