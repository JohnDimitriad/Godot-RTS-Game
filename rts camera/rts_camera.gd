extends Node3D

## enums

## consts
const camera_pan_margin: float = 5.0 #pixels to trigger pan on screen edge
const camera_rotation_speed: float = 1.0
const camera_zoom_speed: float = 4.0
const camera_zoom_range: Vector2 = Vector2(50,250)
const camera_move_speed: Vector2 = Vector2(40,100)
	
## exports

## public vars
var cam_movement_velocity: Vector3 = Vector3.ZERO
var cam_zoom_velocity: float = 0.0
## private vars

## onready vars
@onready var camera_3d: Camera3D = $Camera3D

## built-in override methods



func _ready() -> void:
	_setup_camera(camera_3d)
	pass

func _process(delta: float) -> void:
	camera_pan(delta)
	camera_move(delta)
	camera_rotate(delta)
	camera_zoom(delta)
	_apply_movement_velocity()
	_apply_zoom_velocity()
	pass

## public methods
func camera_pan(delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CONFINED:
		return
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var viewport_size: Vector2 =  get_viewport().get_visible_rect().size
	if mouse_pos.x < camera_pan_margin: 
		cam_movement_velocity.x = -1 * delta
	if mouse_pos.y < camera_pan_margin:
		cam_movement_velocity.z = -1 * delta
	if mouse_pos.x > viewport_size.x - camera_pan_margin:
		cam_movement_velocity.x = 1 * delta
	if mouse_pos.y > viewport_size.y - camera_pan_margin:
		cam_movement_velocity.z = 1 * delta

func camera_move(delta: float) -> void:
	if Input.is_action_pressed("input_action_camera_forwards"):
		cam_movement_velocity.z = -1 * delta
	if Input.is_action_pressed("input_action_camera_backwards"):
		cam_movement_velocity.z = 1 * delta
	if Input.is_action_pressed("input_action_camera_leftwards"):
		cam_movement_velocity.x = -1 * delta
	if Input.is_action_pressed("input_action_camera_rightwards"):
		cam_movement_velocity.x = 1 * delta

func camera_rotate(delta: float) -> void:
	if Input.is_action_pressed("input_action_camera_rotate_right"):
		global_rotation.y += camera_rotation_speed * delta
	if Input.is_action_pressed("input_action_camera_rotate_left"):
		global_rotation.y -= camera_rotation_speed * delta

func camera_zoom(delta:float) -> void:
	if (Input.is_action_just_released("input_action_camera_zoom_in") or Input.is_action_pressed("input_action_camera_zoom_in")):
		cam_zoom_velocity -= (camera_zoom_speed * 100) * delta
	if (Input.is_action_just_released("input_action_camera_zoom_out") or Input.is_action_pressed("input_action_camera_zoom_out")):
		cam_zoom_velocity += (camera_zoom_speed * 100) * delta

## private methods
func _setup_camera(cam: Camera3D) -> void:
	cam.fov = 10.0
	cam.position.y = 3.0
	cam.rotation.x = deg_to_rad(-30)
	rotation.y = deg_to_rad(-45)
	cam.translate_object_local(Vector3(0,0,100))

func _apply_movement_velocity() -> void:
	if cam_movement_velocity != Vector3.ZERO:
		var camera_zoom_speed: float = remap(
			camera_3d.position.z,
			camera_zoom_range.x,camera_zoom_range.y,
			camera_move_speed.x,camera_move_speed.y)
		translate_object_local(cam_movement_velocity * camera_zoom_speed)
		cam_movement_velocity = Vector3.ZERO

func _apply_zoom_velocity(cam: Camera3D = camera_3d) -> void:
	if cam_zoom_velocity != 0:
		var calculated_zoom: float = cam.position.z + cam_zoom_velocity
		if (calculated_zoom > camera_zoom_range.x) and (calculated_zoom < camera_zoom_range.y):
			cam.translate_object_local(Vector3(0,0,cam_zoom_velocity))
	cam_zoom_velocity = 0
