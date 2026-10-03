extends MeshInstance3D

## enums

## consts
const movement_speed: float = 12.0

## exports

## public vars
var selected:bool = false:
	set(new_value):
		selected = new_value
		if selected:
			obj_selection_sprite.show()
		else:
			obj_selection_sprite.hide()
	get():
		return selected

var path:PackedVector3Array = []

## private vars
var _current_path_index:int
var _move_to_path:bool = false

## onready vars
@onready var obj_selection_sprite: Sprite3D = $CircleSelection
@onready var obj_selection_aabb: MeshInstance3D = $SelectionAABB

## built-in override methods


func _ready() -> void:
	_startup()
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if _move_to_path:
		follow_path(delta)

## public methods
func new_path(where_to: Vector3) -> void:
	where_to.y = 0
	
	const ri:float = 2 #randomize movement
	where_to.x += randf_range(-ri,ri)
	where_to.z += randf_range(-ri,ri)
	
	path = NavigationServer3D.map_get_path(get_world_3d().get_navigation_map(), global_position, where_to, true)
	
	_current_path_index = 0
	_move_to_path = true
	
	Globals.create_debug_sphere_at(self, where_to, 3.0, Color(0.7,0,0))
	
	for point:Vector3 in path:
		Globals.create_debug_sphere_at(self, where_to, 1.5, Color(0,0.8,0.8))

func follow_path(delta:float) -> void:
	if path.size() == 0:
		_move_to_path = false
		return
	
	var next_path_point: Vector3 = path [_current_path_index]
	next_path_point.y = 0
	var direction_to_next_point: Vector3 = (next_path_point - global_position).normalized()
	Globals.create_debug_sphere_at(self, global_position, 1, Color(0,0.4,0))
	global_position += (direction_to_next_point * movement_speed) * delta
	if global_position != next_path_point:
		look_at(next_path_point)
	
	if global_position.distance_squared_to(next_path_point) < 1:
		_current_path_index += 1
		Globals.create_debug_sphere_at(self, next_path_point, 2.0, Color(0,0,0.7))
		
		if _current_path_index >= path.size():
			path.clear()

## private methods
func _startup() -> void:
	selected = false
	
	#obj_selection_aabb.show()
	#obj_selection_aabb.mesh = BoxMesh.new()
	
	#var selection_aabb: AABB = global_transform * mesh.get_aabb()
	#var aabb_center: Vector3 = selection_aabb.position + selection_aabb.size * 0.5
	
	#obj_selection_aabb.mesh.size = selection_aabb.size
	#obj_selection_aabb.position = aabb_center
	obj_selection_aabb.queue_free()
