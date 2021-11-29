extends VBoxContainer

onready var timer: Timer = $TimePanel/LevelTimer
onready var full_battery: Texture = preload("res://assets/screen/full_battery.png")
onready var empty_battery: Texture = preload("res://assets/screen/empty_battery.png")
var current_battery: int = 0

func _process(_delta) -> void:
	$TimePanel/RichTextLabel.bbcode_text = str(round(timer.get_time_left()))

func _ready() -> void:
	var _err = gl.connect("add_level", self, "add_level")
	_err = gl.connect("restart_timer", self, "restart_timer")
	_err = timer.connect("timeout", self, "on_timer_timeout")
	$LevelPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.level)])
	for child in $BatteriesContainer.get_children():
		child.texture = empty_battery

func add_level() -> void:
	$LevelPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.level)])
	$BatteriesContainer.get_children()[current_battery].texture = full_battery

func restart_timer(time: int) -> void:
	timer.stop()
	timer.wait_time = time
	timer.start()

func on_timer_timeout() -> void:
	gl.emit_signal("level_timeout")
