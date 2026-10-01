extends Node

## enums

## consts
const dragbox_min_size: int = 4 #area size, not pixels
## exports

## public vars

## private vars

## onready vars
@onready var obj_ui_dragbox: NinePatchRect = $NinePatchRect
## built-in override methods



func _ready() -> void:
	dragbox_hide()
	pass

func _process(delta: float) -> void:
	pass

## public methods
func select_object_by_aabb(object:MeshInstance3D, mouse_pos:Vector2, camera: Camera3D) -> bool:
	var object_AABB: AABB = object.global_transform * object.mesh.get_aabb()
	if object_AABB.intersects_ray(camera.project_ray_origin(mouse_pos), camera.project_ray_normal(mouse_pos)):
		return true
	return false

#func dragboxselect_objects(object_list:Array, dragbox_rect: Rect2) -> void:
#	for object:Node3D in (object_list as Array[Node3D]):
#		var position_in_2d: Vector2 = get_viewport().get_camera_3d().unproject_position(object.global_position)
#		if dragbox_rect.has_point(position_in_2d):
#			select_object(object)
#		else:
#			deselect_object(object)

func get_dragbox_selected_objects(selectable_list:Array,dragbox_rect:Rect2) -> Array[Node3D]:
	var selected_array:Array[Node3D] = []
	for object:Node3D in (selectable_list as Array[Node3D]):
		var position_in_2d: Vector2 = get_viewport().get_camera_3d().unproject_position(object.global_position)
		if dragbox_rect.has_point(position_in_2d):
			selected_array.append(object)
	return selected_array

func update_selection_rectangle(new_rect: Rect2) -> void:
	obj_ui_dragbox.position = new_rect.position
	obj_ui_dragbox.size = new_rect.size
	
	if new_rect.get_area() > dragbox_min_size:
		obj_ui_dragbox.show()

func select_array(array:Array[Node3D]) -> void:
	for object in array:
		select_object(object)

func deselect_array(array:Array[Node3D]) -> void:
	for object in array:
		deselect_object(object)

func dragbox_show() -> void:
	obj_ui_dragbox.show()
	
func dragbox_hide() -> void:
	obj_ui_dragbox.hide()

func select_object(object:Node) -> void:
	object.selected = true

func deselect_object(object:Node) -> void:
	object.selected = false

func toggleselect_object(object:Node) -> void:
	object.selected = !object.selected

## private methods
