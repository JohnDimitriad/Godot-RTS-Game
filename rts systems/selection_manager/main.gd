extends Node

## enums

## consts
const dragbox_min_size: int = 4 #area size, not pixels
## exports

## public vars

## private vars

## onready vars
@onready var ui_dragbox: NinePatchRect = $NinePatchRect
## built-in override methods



func _ready() -> void:
	dragbox_hide()
	pass

func _process(delta: float) -> void:
	pass

## public methods
func dragbox_select_objects(object_list:Array, dragbox_rect: Rect2) -> void:
	for object:Node3D in (object_list as Array[Node3D]):
		var position_in_2d: Vector2 = get_viewport().get_camera_3d().unproject_position(object.global_position)
		if dragbox_rect.has_point(position_in_2d):
			_select_object(object)
		else:
			_deselect_object(object)

func update_selection_rectangle(new_rect: Rect2) -> void:
	ui_dragbox.position = new_rect.position
	ui_dragbox.size = new_rect.size
	
	if new_rect.get_area() > dragbox_min_size:
		ui_dragbox.show()
		
func dragbox_show() -> void:
	ui_dragbox.show()
	
func dragbox_hide() -> void:
	ui_dragbox.hide()

## private methods
func _select_object(object:Node) -> void:
	object.selected = true

func _deselect_object(object:Node) -> void:
	object.selected = false

func _toggle_select_object(object:Node) -> void:
	object.selected = !object.selected
