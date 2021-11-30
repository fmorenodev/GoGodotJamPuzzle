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
	spawn_block()
	new_level()

func new_level() -> void:
	for i in 20:
		spawn_passive_block(randi() % 3)
	gl.emit_signal("set_battery_max_value", gl.levels[gl.level - 1]["size"])
	gl.emit_signal("restart_timer", gl.levels[gl.level - 1]["time"])

func spawn_block() -> void:
	current_shape = Single_Shape.instance()
	$PuzzleScreen/Exterior/ShapeZone.add_child(current_shape)
	current_shape.position = gl.starting_position
	current_shape.get_child(0).sprite.frame = 3
	yield(get_tree().create_timer(0.20), "timeout")
	current_shape.get_child(0).add_polarity(gl.POLARITY.NEGATIVE)
	active_block = true

func spawn_passive_block(polarity: int) -> void:
	var new_shape = Single_Shape.instance()
	$PuzzleScreen/Exterior/ShapeZone.add_child(new_shape)
	new_shape.get_child(0).add_polarity(polarity)
	new_shape.position = get_random_pos()
	gl.passive_blocks.append(new_shape.get_child(0))
	gl.passive_positions.append(new_shape.position)

func _on_level_completed() -> void:
	gl.add_points(1000)
	current_shape = null
	gl.passive_positions.clear()
	gl.passive_blocks.clear()
	$ClearPopup.show()
	gl.emit_signal("play_sound", gl.SFX.CLEAR)
	yield(get_tree().create_timer(2), "timeout")
	$ClearPopup.hide()
	gl.add_level()
	new_level()

func get_random_pos() -> Vector2:
	return Vector2(round(rand_range(0, gl.columns - 1)) * gl.block_size, round(rand_range(0, gl.rows - 1)) * gl.block_size)

func _on_level_timeout() -> void:
	gl.restart_game()

func move(direction: Vector2) -> void:
	if active_block:
		current_shape.move(direction)

func _input(event: InputEvent) -> void:
	if current_shape:
		if event.is_action_pressed("ui_right", true):
			move(Vector2.RIGHT)
		if event.is_action_pressed("ui_left", true):
			move(Vector2.LEFT)
		if event.is_action_pressed("ui_down", true):
			move(Vector2.DOWN)
		if event.is_action_pressed("ui_up", true):
			move(Vector2.UP)
		if event.is_action_pressed("ui_accept"):
			current_shape.deact_shape()
			spawn_block()
		if event.is_action_pressed("ui_cancel"):
			if gl.paused:
				gl.emit_signal("play_timer", true)
				$PopupPanel.hide()
			else:
				gl.emit_signal("play_timer", false)
				$PopupPanel.show()
			gl.paused = !gl.paused

func _on_set_active_block(value: bool) -> void:
	active_block = value

func play_music(value: bool) -> void:
	var _err = $MusicPlayer.play() if value else $MusicPlayer.stop()
