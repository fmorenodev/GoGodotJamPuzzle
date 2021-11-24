extends Node

signal deact_shape
signal add_points
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

func deact_shape() -> void:
	emit_signal("deact_shape")

func add_points() -> void:
	points += 100
	if points % 100 == 0 and tick_time > .3:
		tick_time -= -.1
	emit_signal("add_points")

func restart_game() -> void:
	tick_time = 1
	points = 0
	deact_positions.clear()
	deact_blocks.clear()
	var _err = get_tree().reload_current_scene()
