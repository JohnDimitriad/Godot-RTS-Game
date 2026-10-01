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
func update_selection_rectangle(new_rect: Rect2) -> void:
	new_rect = new_rect.abs()
	ui_dragbox.position = new_rect.position
	ui_dragbox.size = new_rect.size
	
	if new_rect.get_area() > dragbox_min_size:
		ui_dragbox.show()
		
func dragbox_show() -> void:
	ui_dragbox.show()
	
func dragbox_hide() -> void:
	ui_dragbox.hide()

## private methods
