extends VBoxContainer

onready var timer: Timer = $TimePanel/LevelTimer
onready var battery_full: Texture = preload("res://assets/screen/battery_full.png")
onready var battery_empty: Texture = preload("res://assets/screen/battery_empty.png")
var current_battery: int = 0

func _process(_delta) -> void:
	$TimePanel/RichTextLabel.bbcode_text = str(round(timer.get_time_left()))

func _ready() -> void:
	var _err = gl.connect("add_level", self, "add_level")
	_err = gl.connect("restart_timer", self, "restart_timer")
	_err = timer.connect("timeout", self, "on_timer_timeout")
	$LevelPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.level)])
	for child in $BatteriesContainer.get_children():
		child.texture = battery_empty

func add_level() -> void:
	$LevelPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.level)])
	$BatteriesContainer.get_children()[current_battery].texture = battery_full
	current_battery += 1

func restart_timer(time: int) -> void:
	timer.stop()
	timer.wait_time = time
	timer.start()

func on_timer_timeout() -> void:
	gl.emit_signal("level_timeout")
