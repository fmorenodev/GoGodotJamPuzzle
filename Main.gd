extends Node2D

onready var I_Shape = preload("res://shapes/I_Shape.tscn")
onready var J_Shape = preload("res://shapes/J_Shape.tscn")
onready var L_Shape = preload("res://shapes/L_Shape.tscn")
onready var O_Shape = preload("res://shapes/O_Shape.tscn")
onready var S_Shape = preload("res://shapes/S_Shape.tscn")
onready var T_Shape = preload("res://shapes/T_Shape.tscn")
onready var Z_Shape = preload("res://shapes/Z_Shape.tscn")

var shapes = []
var current_shape
var active_block = false
var num: int = -1
var next_num: int = 0

func _ready() -> void:
	var _err = gl.connect("set_active_block", self, "_on_set_active_block")
	_err = $Timer.connect("timeout", self, "_on_Timer_timeout")
	shapes = [I_Shape, J_Shape, T_Shape, L_Shape, O_Shape, Z_Shape, S_Shape]
	$Timer.wait_time = gl.tick_time
	randomize()

func _on_Timer_timeout() -> void:
	$Timer.wait_time = gl.tick_time
	if not active_block:
		num = randi() % 7 if num == -1 else next_num
		next_num = randi() % 7
		current_shape = shapes[num].instance()
		$PuzzleScreen/Background/ShapeZone.add_child(current_shape)
		$PanelContainer/MiddleScreen/NextShapePanel/Control/Sprite.frame = next_num
		current_shape.position = gl.starting_position
		active_block = true
	else:
		move_down()

func move_left() -> void:
	if active_block:
		current_shape.move_left()

func move_right() -> void:
	if active_block:
		current_shape.move_right()

func move_down() -> void:
	if active_block:
		current_shape.move_down()

func hard_drop() -> void:
	while active_block:
		current_shape.move_down()

func _input(event: InputEvent) -> void:
	if current_shape:
		if event.is_action_pressed("ui_right", true):
			move_right()
		if event.is_action_pressed("ui_left", true):
			move_left()
		if event.is_action_pressed("ui_down", true):
			move_down()
		if event.is_action_pressed("ui_up", true):
			current_shape.rotate_shape()
		if event.is_action_pressed("ui_accept"):
			hard_drop()

func _on_set_active_block(value: bool) -> void:
	active_block = value
