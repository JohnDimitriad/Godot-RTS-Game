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
@onready var obj_camera_3d: Camera3D = $Camera3D

## built-in override methods

func _ready() -> void:
	_setup_camera(obj_camera_3d)

func _process(delta: float) -> void:
	_apply_movement_velocity()
	_apply_zoom_velocity()

## public methods
func camera_pan(mouse_pos:Vector2,viewport_size:Vector2,delta: float) -> void:
	if mouse_pos.x < camera_pan_margin: 
		cam_movement_velocity.x = -1 * delta
	if mouse_pos.y < camera_pan_margin:
		cam_movement_velocity.z = -1 * delta
	if mouse_pos.x > viewport_size.x - camera_pan_margin:
		cam_movement_velocity.x = 1 * delta
	if mouse_pos.y > viewport_size.y - camera_pan_margin:
		cam_movement_velocity.z = 1 * delta

func camera_move(direction:Vector2,delta: float) -> void:
	cam_movement_velocity.z = direction.y * delta
	cam_movement_velocity.x = direction.x * delta

func camera_rotate(direction:float,delta: float) -> void:
	global_rotation.y += (camera_rotation_speed * delta) * direction

func camera_zoom(direction:float, delta:float) -> void:
	cam_zoom_velocity += ((camera_zoom_speed * 100) * delta) * direction

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
			obj_camera_3d.position.z,
			camera_zoom_range.x,camera_zoom_range.y,
			camera_move_speed.x,camera_move_speed.y)
		translate_object_local(cam_movement_velocity * camera_zoom_speed)
		cam_movement_velocity = Vector3.ZERO

func _apply_zoom_velocity(cam: Camera3D = obj_camera_3d) -> void:
	if cam_zoom_velocity != 0:
		var calculated_zoom: float = cam.position.z + cam_zoom_velocity
		if (calculated_zoom > camera_zoom_range.x) and (calculated_zoom < camera_zoom_range.y):
			cam.translate_object_local(Vector3(0,0,cam_zoom_velocity))
	cam_zoom_velocity = 0
