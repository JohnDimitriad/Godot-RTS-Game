extends MeshInstance3D

## enums

## consts

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

## private vars

## onready vars
@onready var obj_selection_sprite: Sprite3D = $CircleSelection
@onready var obj_selection_aabb: MeshInstance3D = $SelectionAABB

## built-in override methods


func _ready() -> void:
	_startup()
	pass

func _process(delta: float) -> void:
	pass

## public methods

## private methods
func _startup() -> void:
	selected = false
	
	#obj_selection_aabb.mesh = BoxMesh.new()
	
	#var selection_aabb: AABB = global_transform * mesh.get_aabb()
	#var aabb_center: Vector3 = selection_aabb.position + selection_aabb.size * 0.5
	
	#obj_selection_aabb.mesh.size = selection_aabb.size
	#obj_selection_aabb.position = aabb_center
	obj_selection_aabb.queue_free()
