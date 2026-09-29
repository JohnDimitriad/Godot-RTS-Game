extends Node

## enums

## consts

## exports

## public vars

## private vars

## onready vars

## built-in override methods


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_released("input_action_esc"): #exit viewport to close game
		get_viewport().set_input_as_handled()
		if Input.mouse_mode == Input.MOUSE_MODE_CONFINED: #if the game is confined to viewport then esc allows me to edit it in editor
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else: #otherwise pressing esc again closes the game
			get_tree().quit()
		
	if (Input.is_action_just_released("input_action_enter") or Input.is_action_just_released("input_action_mouseclick_left")):
		get_viewport().set_input_as_handled() #comment here because above line is full, press enter/mb1 to refocus
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _process(delta: float) -> void:
	pass

## public methods

## private methods
