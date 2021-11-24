extends Basic_Shape

class_name S_Shape

func _ready() -> void:
	rotation_matrix = [
		[Vector2(-gl.block_size, 0), Vector2(0, 0), Vector2(0, -gl.block_size), Vector2(gl.block_size, -gl.block_size)],
		[Vector2(0, -gl.block_size), Vector2(0, 0), Vector2(gl.block_size, 0), Vector2(gl.block_size, gl.block_size)],
		[Vector2(-gl.block_size, 0), Vector2(0, 0), Vector2(0, -gl.block_size), Vector2(gl.block_size, -gl.block_size)],
		[Vector2(0, -gl.block_size), Vector2(0, 0), Vector2(gl.block_size, 0), Vector2(gl.block_size, gl.block_size)]]
	draw_shape()
	
	$Block.position = Vector2(-gl.block_size, 0)
	$Block3.position = Vector2(0, -gl.block_size)
	$Block4.position = Vector2(gl.block_size, -gl.block_size)

func _init() -> void:
	shape_color = Color.yellow
