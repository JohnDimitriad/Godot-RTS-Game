extends Node

## enums

## consts
const type_rts_camera := preload("res://rts systems/rts_camera/main.gd")

## exports

## public vars
var mouse_dragbox_start_position: Vector2 = Vector2.ZERO
var mouse_dragbox_end_position: Vector2 = Vector2.ZERO
var show_dragbox:bool = false

## private vars

## onready vars
@onready var rts_camera:= $"../RTSCamera"
@onready var selection_manager:= $SelectionManager

## built-in override methods


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	camera_inputs(rts_camera,delta)
	selection_dragbox()

## public methods
func selection_dragbox() -> void:
	if Input.is_action_pressed("input_action_mouseclick_left"):
		if mouse_dragbox_start_position == Vector2.ZERO:
			mouse_dragbox_start_position = get_viewport().get_mouse_position()
			mouse_dragbox_end_position = mouse_dragbox_start_position
		
		mouse_dragbox_end_position = get_viewport().get_mouse_position()
		selection_manager.update_selection_rectangle(Rect2(mouse_dragbox_start_position, mouse_dragbox_end_position - mouse_dragbox_start_position))
		
	if Input.is_action_just_released("input_action_mouseclick_left"):
		mouse_dragbox_start_position = Vector2.ZERO
		mouse_dragbox_end_position = Vector2.ZERO
		selection_manager.dragbox_hide()

func camera_inputs(camera: type_rts_camera, delta:float) -> void:
	camera_pan(camera,delta)
	camera_move(camera,delta)
	camera_rotate(camera,delta)
	camera_zoom(camera,delta)

func camera_pan(camera: type_rts_camera, delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CONFINED:
		return
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var viewport_size: Vector2 =  get_viewport().get_visible_rect().size
	camera.camera_pan(mouse_pos,viewport_size,delta)

func camera_move(camera:type_rts_camera, delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("input_action_camera_forwards"): 
		direction.y = -1
	if Input.is_action_pressed("input_action_camera_backwards"): 
		direction.y = 1
	if Input.is_action_pressed("input_action_camera_leftwards"): 
		direction.x = -1
	if Input.is_action_pressed("input_action_camera_rightwards"): 
		direction.x = 1
	
	if direction == Vector2.ZERO:
		return # no movement
	camera.camera_move(direction,delta)

func camera_rotate(camera: type_rts_camera,delta: float) -> void:
	var direction: float = 0
	
	if Input.is_action_pressed("input_action_camera_rotate_right"):
		direction = -1
	if Input.is_action_pressed("input_action_camera_rotate_left"):
		direction = 1
		
	if !direction:
		return # no rotation
	camera.camera_rotate(direction,delta)

func camera_zoom(camera: type_rts_camera, delta:float) -> void:
	var direction: float = 0
	
	if (Input.is_action_just_released("input_action_camera_zoom_in") or Input.is_action_pressed("input_action_camera_zoom_in")):
		direction = -1
	if (Input.is_action_just_released("input_action_camera_zoom_out") or Input.is_action_pressed("input_action_camera_zoom_out")):
		direction = 1
		
	if !direction:
		return # no zoom
	camera.camera_zoom(direction,delta)

## private methods
