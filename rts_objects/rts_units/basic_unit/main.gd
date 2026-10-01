extends Node

## enums

## consts

## exports

## public vars
var selected:bool = false:
	set(new_value):
		selected = new_value
		if selected:
			selection_sprite.show()
		else:
			selection_sprite.hide()
	get():
		return selected

## private vars

## onready vars
@onready var selection_sprite: Sprite3D = $CircleSelection

## built-in override methods


func _ready() -> void:
	selected = false
	pass

func _process(delta: float) -> void:
	pass

## public methods

## private methods
