extends VBoxContainer

func _ready() -> void:
	$RichTextLabel.bbcode_text = str(gl.points).pad_zeros(6)
	var _err = gl.connect("add_points", self, "add_points")

func add_points() -> void:
	$RichTextLabel.bbcode_text = str(gl.points).pad_zeros(6)
