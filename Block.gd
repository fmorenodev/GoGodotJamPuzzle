extends Node2D

var is_active: bool = false

func _ready() -> void:
	is_active = true
	var _err = gl.connect("deact_shape", self, "deact_block")

func deact_block() -> void:
	if is_active:
		get_parent().is_fixed = true
		is_active = false
		gl.emit_signal("set_active_block", false)
		gl.deact_positions.append(get_parent().position + position)
		gl.deact_blocks.append(self)
		gl.deact_shape()
		check_full_line()

func can_rotate(direction: Vector2) -> bool:
	var new_pos = Vector2(get_parent().position.x + direction.x, get_parent().position.y + direction.y)
	if gl.deact_positions.has(new_pos) or is_off_screen(new_pos):
		return false
	else:
		return true

func is_off_screen(position: Vector2) -> bool:
	if position.x < 0 or \
	position.y < 0 or \
	position.x >= get_parent().get_parent().get_rect().size.x or \
	position.y >= get_parent().get_parent().get_rect().size.y:
		return true
	else:
		return false

func can_move_down() -> bool:
	if gl.deact_positions.has(Vector2(get_parent().position.x + position.x, get_parent().position.y + position.y + gl.block_size)) \
	or get_parent().position.y + position.y == gl.game_area.y:
		deact_block()
		return false
	else:
		return true

func can_move_left() -> bool:
	if get_parent().position.x + position.x == 0 or \
	(gl.deact_positions.has(Vector2(get_parent().position.x + position.x - gl.block_size, get_parent().position.y + position.y))) or not is_active:
		return false
	else:
		return true

func can_move_right() -> bool:
	if get_parent().position.x + position.x == gl.game_area.x or \
	(gl.deact_positions.has(Vector2(get_parent().position.x + position.x + gl.block_size, get_parent().position.y + position.y))) or not is_active:
		return false
	else:
		return true

func check_full_line() -> void:
	var count = 0
	var to_remove = []
	var to_shift = []
	var current_block
	print(gl.deact_positions)
	print(gl.deact_blocks)
	for i in gl.deact_positions.size():
		current_block = gl.deact_positions[i]
		if current_block.y == get_parent().position.y + position.y: # in the line
			to_remove.append(i)
			count += 1
	if count == 10:
		destroy_line(to_remove)
		for i in gl.deact_positions.size():
			current_block = gl.deact_positions[i]
			if current_block.y < get_parent().position.y + position.y: # above the line
				to_shift.append(i)
		shift_blocks(to_shift)

func destroy_line(positions: Array) -> void:
	gl.add_points() # modify scoring system
	for i in range(positions.size() - 1, -1, -1):
		gl.deact_positions.remove(positions[i])
		gl.deact_blocks[positions[i]].destroy_block()
		gl.deact_blocks.remove(positions[i])

func shift_blocks(blocks) -> void:
	for i in blocks:
		gl.deact_positions[i].y += gl.block_size
		gl.deact_blocks[i].position.y += gl.block_size

func destroy_block() -> void:
	queue_free()
