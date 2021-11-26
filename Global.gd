extends Node

signal spawn_block
signal add_points
signal add_lines
signal add_level
signal set_active_block(value)

# game params
var block_size: int = 40
var rows: int = 16
var columns: int = 10
var game_area: Vector2 = Vector2((columns - 1) * block_size, (rows - 1) * block_size)
var starting_position: Vector2 = Vector2((columns - 1) / 2 * block_size, block_size)

var deact_positions: Array = []
var deact_blocks: Array = []
var points: int = 0
var tick_time: float = 1
var level: int = 1
var lines: int = 0
var combo_lines: int = 0
var levels: PoolIntArray = [2000, 5000, 10000, 20000, 40000, 100000, 2000000]

func add_points(added_points: int) -> void:
	points += added_points
	if points > levels[0] and tick_time > .3:
		level += 1
		emit_signal("add_level")
		levels.remove(0)
		tick_time -= -.1
	emit_signal("add_points")

func add_lines() -> void:
	if combo_lines != 0:
		lines += combo_lines
		var base_points = 0
		if combo_lines == 1:
			base_points = 100
		elif combo_lines == 2:
			base_points = 300
		elif combo_lines == 3:
			base_points = 500
		elif combo_lines == 4:
			base_points = 800
		emit_signal("add_lines")
		add_points(base_points * level)

func restart_game() -> void:
	deact_positions.clear()
	deact_blocks.clear()
	tick_time = 1
	points = 0
	lines = 0
	level = 1
	combo_lines = 0
	levels = [2000, 5000, 10000, 20000, 40000, 100000, 2000000]
	var _err = get_tree().reload_current_scene()
