extends VBoxContainer

func _ready() -> void:
	$PointsPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.points).pad_zeros(6)])
	$LinesPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.lines).pad_zeros(2)])
	$LevelPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.level)])
	var _err = gl.connect("add_points", self, "add_points")
	_err = gl.connect("add_lines", self, "add_lines")
	_err = gl.connect("add_level", self, "add_level")

func add_points() -> void:
	$PointsPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.points).pad_zeros(6)])

func add_lines() -> void:
	$LinesPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.lines).pad_zeros(2)])

func add_level() -> void:
	$LevelPanel/RichTextLabel.bbcode_text = "[center]{0}[/center]".format([str(gl.level)])
