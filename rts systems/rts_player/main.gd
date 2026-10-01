extends Node

## enums

## consts
const type_hint_rts_camera: Script = preload("../rts_camera/main.gd")
const type_hint_selection_manager: Script = preload("../selection_manager/main.gd")

## exports

## public vars

## private vars
var _mouse_dragbox_start_position: Vector2 = Vector2.ZERO
var _mouse_dragbox_end_position: Vector2 = Vector2.ZERO
var _player_selection:Array[Node3D] = []

## onready vars
@onready var obj_rts_camera: type_hint_rts_camera = $"../RTSCamera"
@onready var obj_selection_manager: type_hint_selection_manager = $SelectionManager
@onready var obj_units_nodetree: Node = $"../Units"

## built-in override methods


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	_camera_inputs(obj_rts_camera,delta)
	update_selection_dragbox()

## public methods
func update_player_selection(new_obj_selection:Array[Node3D]) -> void:
	obj_selection_manager.deselect_array(_player_selection)
	_player_selection = new_obj_selection
	obj_selection_manager.select_array(_player_selection)

func update_selection_dragbox() -> void:
	if Input.is_action_pressed("input_action_mouseclick_left"):
		if _mouse_dragbox_start_position == Vector2.ZERO:
			_mouse_dragbox_start_position = get_viewport().get_mouse_position()
			_mouse_dragbox_end_position = _mouse_dragbox_start_position
		
		_mouse_dragbox_end_position = get_viewport().get_mouse_position()
		obj_selection_manager.update_selection_rectangle(Rect2(_mouse_dragbox_start_position, _mouse_dragbox_end_position - _mouse_dragbox_start_position).abs())
		
	if Input.is_action_just_released("input_action_mouseclick_left"):
		var dragbox_rectangle: Rect2 = Rect2(_mouse_dragbox_start_position, _mouse_dragbox_end_position - _mouse_dragbox_start_position).abs()
		if dragbox_rectangle.get_area() > obj_selection_manager.dragbox_min_size: #dragbox selection
			update_player_selection(obj_selection_manager.get_dragbox_selected_objects(obj_units_nodetree.get_children(),dragbox_rectangle))
		
		else: #single click selection
			update_player_selection([])
			for object: Node3D in obj_units_nodetree.get_children():
				if obj_selection_manager.select_object_by_aabb(object,get_viewport().get_mouse_position(),get_viewport().get_camera_3d()):
					update_player_selection([object])
					break
		
		_mouse_dragbox_start_position = Vector2.ZERO
		_mouse_dragbox_end_position = Vector2.ZERO
		obj_selection_manager.dragbox_hide()

## private methods
func _camera_inputs(camera: type_hint_rts_camera, delta:float) -> void:
	_camera_pan(camera,delta)
	_camera_move(camera,delta)
	_camera_rotate(camera,delta)
	_camera_zoom(camera,delta)

func _camera_pan(camera: type_hint_rts_camera, delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CONFINED:
		return
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var viewport_size: Vector2 =  get_viewport().get_visible_rect().size
	camera.camera_pan(mouse_pos,viewport_size,delta)

func _camera_move(camera:type_hint_rts_camera, delta: float) -> void:
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

func _camera_rotate(camera: type_hint_rts_camera,delta: float) -> void:
	var direction: float = 0
	
	if Input.is_action_pressed("input_action_camera_rotate_right"):
		direction = -1
	if Input.is_action_pressed("input_action_camera_rotate_left"):
		direction = 1
		
	if !direction:
		return # no rotation
	camera.camera_rotate(direction,delta)

func _camera_zoom(camera: type_hint_rts_camera, delta:float) -> void:
	var direction: float = 0
	
	if (Input.is_action_just_released("input_action_camera_zoom_in") or Input.is_action_pressed("input_action_camera_zoom_in")):
		direction = -1
	if (Input.is_action_just_released("input_action_camera_zoom_out") or Input.is_action_pressed("input_action_camera_zoom_out")):
		direction = 1
		
	if !direction:
		return # no zoom
	camera.camera_zoom(direction,delta)
