extends VBoxContainer

onready var meter = $MarginContainer/MarginContainer/TextureProgress

func _ready() -> void:
	$ParticlesPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.levels[gl.level - 1]["size"])])
	$PointsPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.points).pad_zeros(6)])
	var _err = gl.connect("set_points", self, "set_points")
	_err = gl.connect("set_battery_max_value", self, "set_battery_max_value")
	_err = gl.connect("set_blocks_left", self, "set_blocks_left")

func set_points() -> void:
	$PointsPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.points).pad_zeros(6)])

func set_battery_max_value(max_value: int) -> void:
	meter.value = 0
	meter.max_value = max_value

func set_blocks_left(blocks_left: int) -> void:
	$ParticlesPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(blocks_left)])
	meter.value = meter.max_value - blocks_left
