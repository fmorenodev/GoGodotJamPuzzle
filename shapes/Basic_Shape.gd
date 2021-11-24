extends Node2D

class_name Basic_Shape

var rotation_position: int = 1
var is_fixed: bool = false
var rotation_matrix: Array = []
var create_position: Vector2 = Vector2.ZERO
var shape_color: Color

func draw_shape() -> void:
	var i = 0
	for child in get_children():
		child.position = rotation_matrix[rotation_position][i]
		child.modulate = shape_color
		i += 1

func rotate_shape() -> void:
	if not is_fixed:
		var can_rotate = true
		var child_pos = 0
		for child in get_children():
			if can_rotate:
				can_rotate = child.can_rotate(rotation_matrix[rotation_position][child_pos])
			child_pos += 1
		if can_rotate:
			var j = 0
			for child in get_children():
				child.position = rotation_matrix[rotation_position][j]
				j += 1
			rotation_position = rotation_position + 1 if rotation_position < 3 else 0

func deact_shape() -> void:
	if position == create_position:
		var _err = get_tree().reload_current_scene()
	for child in get_children():
		child.deact_block()

func move_left() -> void:
	if not is_fixed:
		for child in get_children():
			if not child.can_move_left():
				return
		position.x -= gl.block_size

func move_right() -> void:
	if not is_fixed:
		for child in get_children():
			if not child.can_move_right():
				return
		position.x += gl.block_size

func move_down() -> void:
	if not create_position:
		create_position = position
	if not is_fixed:
		for child in get_children():
			if not child.can_move_down():
				if create_position == position:
					gl.restart_game()
				is_fixed = true
				return
		position.y += gl.block_size
