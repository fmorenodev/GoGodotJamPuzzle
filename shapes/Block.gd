extends Node2D

var is_active: bool = false
var polarity: int = gl.POLARITY.NEGATIVE
onready var sprite = $Sprite
var to_join = []

func _ready() -> void:
	is_active = true

func add_polarity(pol: int) -> void:
	polarity = pol
	match polarity:
		gl.POLARITY.NEGATIVE:
			sprite.frame = 2
		gl.POLARITY.NEUTRAL:
			sprite.frame = 1
		gl.POLARITY.POSITIVE:
			sprite.frame = 0

func is_available(direction: Vector2) -> bool:
	var result = !gl.passive_positions.has(get_parent().position + position + (direction * gl.block_size))
	return result

func is_repelled(direction: Vector2) -> bool:
	var new_pos = get_parent().position + position
	var lateral_directions = [Vector2.LEFT, Vector2.RIGHT] if direction.x == 0 else [Vector2.UP, Vector2.DOWN]

	var possible_indexes = [gl.passive_positions.find(new_pos + (direction * gl.block_size * 2)),
		gl.passive_positions.find(new_pos + ((direction + lateral_directions[0]) * gl.block_size)),
		gl.passive_positions.find(new_pos + ((direction + lateral_directions[1]) * gl.block_size))]
	
	for i in possible_indexes:
		if i != -1:
			var block = gl.passive_blocks[i]
			if (polarity == gl.POLARITY.NEGATIVE and block.polarity == gl.POLARITY.NEGATIVE) or \
				(polarity == gl.POLARITY.POSITIVE and block.polarity == gl.POLARITY.POSITIVE):
				gl.emit_signal("play_sound", gl.SFX.REPEL)
				return true
	
	for i in possible_indexes:
		if i != -1:
			var block = gl.passive_blocks[i]
			if (polarity == gl.POLARITY.NEGATIVE and block.polarity == gl.POLARITY.POSITIVE) or \
				(polarity == gl.POLARITY.POSITIVE and block.polarity == gl.POLARITY.NEGATIVE):
				to_join.append(block)
	return false

func join(direction: Vector2) -> void:
	if to_join == []: return
	for block in to_join:
		if gl.passive_blocks.has(block):
			gl.passive_blocks.erase(block)
			gl.passive_positions.erase(block.get_parent().position + block.position)
			var this_pos_x = get_parent().position.x + position.x + (direction.x * gl.block_size)
			var this_pos_y = get_parent().position.y + position.y + (direction.y * gl.block_size)
			if block.get_parent().position.x + block.position.x > this_pos_x: # right
				adjust_position(block, Vector2(position.x + gl.block_size, position.y))
			elif block.get_parent().position.x + block.position.x < this_pos_x: # left
				adjust_position(block, Vector2(position.x - gl.block_size, position.y))
			elif block.get_parent().position.y + block.position.y > this_pos_y: # down
				adjust_position(block, Vector2(position.x, position.y + gl.block_size))
			elif block.get_parent().position.y + block.position.y < this_pos_y: # up
				adjust_position(block, Vector2(position.x, position.y - gl.block_size))
	to_join = []
	gl.emit_signal("play_sound", gl.SFX.JOIN)
	var blocks_left = gl.levels[gl.level - 1]["size"] - get_parent().get_child_count()
	blocks_left = blocks_left if blocks_left >= 0 else 0
	gl.emit_signal("set_blocks_left", blocks_left)
	if get_parent().get_child_count() >= gl.levels[gl.level - 1]["size"]:
		gl.emit_signal("level_completed")

func adjust_position(block: Node, new_pos: Vector2) -> void:
	block.get_parent().remove_child(block)
	get_parent().add_child(block)
	block.position = new_pos

func drop_block() -> void:
	if is_active:
		get_parent().is_fixed = true
		is_active = false
		gl.passive_positions.append(get_parent().position + position)
		gl.passive_blocks.append(self)

func can_move(direction: Vector2) -> bool:
	if is_available(direction) and !is_off_screen(get_parent().position + position + (direction * gl.block_size)):
		return !is_repelled(direction)
	return false

func is_off_screen(pos: Vector2) -> bool:
	var result = pos.x > gl.game_area.x or pos.y > gl.game_area.y or pos.x < 0 or pos.y < 0
	return result

func destroy_block() -> void:
	queue_free()
