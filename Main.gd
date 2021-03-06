extends Node2D

onready var Single_Shape = preload("res://shapes/Single_Shape.tscn")

var shapes = []
var shapes_color = []
var current_shape
var active_block = false

func _ready() -> void:
	var _err = gl.connect("set_active_block", self, "_on_set_active_block")
	_err = gl.connect("spawn_block", self, "spawn_block")
	_err = gl.connect("level_completed", self, "_on_level_completed")
	_err = gl.connect("level_timeout", self, "_on_level_timeout")
	gl.emit_signal("set_battery_max_value", gl.levels[gl.level - 1]["size"])
	randomize()
	new_level()
	if gl.tutorial:
		$PopupPanel.show()
		gl.emit_signal("play_timer", false)
		gl.tutorial = false

func new_level() -> void:
	for p in gl.particles[gl.level - 1]["pos"]:
		spawn_passive_block(gl.POLARITY.POSITIVE)
	for p in gl.particles[gl.level - 1]["neg"]:
		spawn_passive_block(gl.POLARITY.NEGATIVE)
	for p in gl.particles[gl.level - 1]["neu"]:
		spawn_passive_block(gl.POLARITY.NEUTRAL)
	gl.emit_signal("set_battery_max_value", gl.levels[gl.level - 1]["size"])
	gl.emit_signal("set_blocks_left", gl.levels[gl.level - 1]["size"] - 1)
	spawn_block()
	gl.emit_signal("restart_timer", gl.levels[gl.level - 1]["time"])
	get_tree().get_root().set_disable_input(false)
	gl.emit_signal("play_timer", true)

func spawn_block() -> void:
	current_shape = Single_Shape.instance()
	$PuzzleScreen/Exterior/ShapeZone.add_child(current_shape)
	if gl.passive_positions.has(gl.starting_position):
		gl.starting_position = get_random_pos()
	current_shape.position = gl.starting_position
	current_shape.get_child(0).sprite.frame = 3
	get_tree().get_root().set_disable_input(true)
	gl.emit_signal("play_sound", gl.SFX.SPAWN)
	yield(get_tree().create_timer(0.7), "timeout")
	current_shape.get_child(0).add_polarity(gl.POLARITY.NEGATIVE)
	get_tree().get_root().set_disable_input(false)
	active_block = true

func spawn_passive_block(polarity: int) -> void:
	var new_shape = Single_Shape.instance()
	$PuzzleScreen/Exterior/ShapeZone.add_child(new_shape)
	new_shape.get_child(0).add_polarity(polarity)
	new_shape.position = get_random_pos()
	gl.passive_blocks.append(new_shape.get_child(0))
	gl.passive_positions.append(new_shape.position)

func _on_level_completed() -> void:
	gl.add_points(1000 * gl.level + round(int($RightPanel/SideScreen/TimePanel/RichTextLabel.bbcode_text)) * 20)
	get_tree().get_root().set_disable_input(true)
	$ClearPopup.show()
	gl.emit_signal("play_sound", gl.SFX.CLEAR)
	gl.emit_signal("play_timer", false)
	yield(get_tree().create_timer(2), "timeout")
	$ClearPopup.hide()
	current_shape.queue_free()
	gl.passive_positions.clear()
	for block in gl.passive_blocks:
		block.get_parent().queue_free()
	gl.passive_blocks.clear()
	gl.add_level()
	new_level()

func get_random_pos() -> Vector2:
	var pos = Vector2(round(rand_range(0, gl.columns - 1)) * gl.block_size, round(rand_range(0, gl.rows - 1)) * gl.block_size)
	if gl.passive_positions.has(pos) or pos == gl.starting_position or is_adjacent(pos):
		return get_random_pos()
	else:
		return pos

func is_adjacent(pos: Vector2) -> bool:
	var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	for dir in directions:
		if gl.passive_positions.has(pos + (dir * gl.block_size)):
			return true
	return false

func _on_level_timeout() -> void:
	$GameOverPopup.show()
	get_tree().get_root().set_disable_input(true)
	gl.emit_signal("play_timer", false)
	gl.emit_signal("play_sound", gl.SFX.GAME_OVER)
	yield(get_tree().create_timer(2), "timeout")
	$GameOverPopup.hide()
	gl.restart_game()

func move(direction: Vector2) -> void:
	if active_block:
		current_shape.move(direction)

func _input(event: InputEvent) -> void:
	if current_shape:
		if !gl.movement_disabled:
			if event.is_action_pressed("ui_right", true):
				move(Vector2.RIGHT)
			if event.is_action_pressed("ui_left", true):
				move(Vector2.LEFT)
			if event.is_action_pressed("ui_down", true):
				move(Vector2.DOWN)
			if event.is_action_pressed("ui_up", true):
				move(Vector2.UP)
			if event.is_action_pressed("ui_accept"):
				current_shape.drop_shape()
				spawn_block()
		if event.is_action_pressed("ui_cancel"):
			if gl.paused:
				gl.emit_signal("play_timer", true)
				$PopupPanel.hide()
			else:
				gl.emit_signal("play_timer", false)
				$PopupPanel.show()

func _on_set_active_block(value: bool) -> void:
	active_block = value
