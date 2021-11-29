extends Node2D

class_name Basic_Shape

var is_fixed: bool = false
var create_position: Vector2 = Vector2.ZERO
var shape_color: Color

func deact_shape() -> void:
	gl.emit_signal("set_active_block", false)
	for child in get_children():
		child.deact_block()

func move(dir: Vector2) -> void:
	if not is_fixed:
		for child in get_children():
			if not child.can_move(dir):
				return
		for child in get_children():
			child.join(dir)
		gl.emit_signal("play_sound", gl.SFX.MOVE)
		position += dir * gl.block_size
