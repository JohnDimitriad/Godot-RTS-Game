extends Node

## enums

## consts

## exports

## public vars

## private vars

## onready vars (use obj_ for node references)

## built-in override methods


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

## public methods
func create_debug_sphere_at(node_caller:Node, at_pos:Vector3, time:float, color: Color) -> void:
	#create newmesh3d and set its mesh
	
	var sphere: MeshInstance3D = MeshInstance3D.new()
	var _debug_sphere_mesh: SphereMesh = SphereMesh.new()
	(_debug_sphere_mesh as SphereMesh).rings = 1
	(_debug_sphere_mesh as SphereMesh).radial_segments = 1
	(_debug_sphere_mesh as SphereMesh).radius = 0.2
	(_debug_sphere_mesh as SphereMesh).height = 0.3
	
	sphere.mesh = _debug_sphere_mesh
	sphere.scale *= time #scale based on time so that its eventually removed
	
	#material
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	#assign material to sphere
	sphere.set_surface_override_material(0, material)
	sphere.position = at_pos
	node_caller.get_tree().root.add_child(sphere)
	node_caller.get_tree().create_timer(time).timeout.connect(func()->void: sphere.queue_free())
## private methods
