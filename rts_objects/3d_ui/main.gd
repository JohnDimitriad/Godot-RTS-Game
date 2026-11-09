extends RefCounted

## enums

## consts
const sprite_circle: PackedScene = preload ("res://rts_objects/node_components/sprite3d_circle_selection.tscn")

## exports

## public vars

## private vars

## onready vars (use obj_ for node references)

## built-in override methods

## public methods
static func create_expanding_circle(obj_caller: Node, where:Vector3) -> void:
	var circle_obj: Sprite3D = sprite_circle.instantiate()
	circle_obj.position = where + Vector3 (0,0.05,0) #this puts the object above the ground in the Y axis
	obj_caller.get_tree().root.add_child(circle_obj)
	_scale_expand_fade_out(circle_obj,Vector3(2,1,2),0.2)

## private methods
static func _scale_expand_fade_out(obj_to_expand:Node3D, expand_to:Vector3, duration: float) -> void:
	obj_to_expand.get_tree().create_tween().tween_property(obj_to_expand, "scale", expand_to, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	obj_to_expand.get_tree().create_timer(duration).timeout.connect(
		func() -> void: obj_to_expand.queue_free())
