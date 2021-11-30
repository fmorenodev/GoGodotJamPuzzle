extends Node

signal spawn_block
signal set_points
signal add_level
signal set_blocks_left
signal level_timeout
signal level_completed
signal restart_timer(time)
signal play_timer(value)
signal set_active_block(value)
signal set_battery_max_value(max_value)
signal play_sound(sfx)

# game params
var block_size: int = 32
var rows: int = 15
var columns: int = 20
var game_area: Vector2 = Vector2((columns - 1) * block_size, (rows - 1) * block_size)
var starting_position: Vector2 = Vector2((columns - 1) / 2 * block_size, block_size)
enum POLARITY {POSITIVE, NEGATIVE, NEUTRAL}
enum SFX {MOVE, JOIN, REPEL, CLEAR, GAME_OVER}

var paused: bool = false
var passive_positions: Array = []
var passive_blocks: Array = []
var points: int = 0
var level: int = 1
var levels: Array = [{"size": 10, "time": 60}, {"size": 10, "time": 50}, {"size": 10, "time": 40},
	{"size": 15, "time": 40}, {"size": 15, "time": 30}, {"size": 10, "time": 20}, {"size": 15, "time": 20}]
var particles: Array = [{"pos": 10, "neg": 5, "neu": 0}, {"pos": 7, "neg": 8, "neu": 0},
	{"pos": 5, "neg": 5, "neu": 5}, {"pos": 7, "neg": 8, "neu": 5}, {"pos": 6, "neg": 10, "neu": 8},
	{"pos": 5, "neg": 5, "neu": 10}, {"pos": 10, "neg": 7, "neu": 10}]

func add_points(added_points: int) -> void:
	points += added_points
	emit_signal("set_points")

func add_level() -> void:
	level += 1
	emit_signal("add_level")

func restart_game() -> void:
	passive_positions.clear()
	passive_blocks.clear()
	points = 0
	level = 1
	paused = false
	emit_signal("restart_timer", levels[level]["time"])
	var _err = get_tree().reload_current_scene()
