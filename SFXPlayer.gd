extends AudioStreamPlayer

onready var movement_sfx = preload("res://assets/sounds/Particle_Movement.ogg")
onready var join_sfx = preload("res://assets/sounds/Particles_Join.ogg")
onready var repel_sfx = preload("res://assets/sounds/Particles_Repel.ogg")
onready var clear_sfx = preload("res://assets/sounds/Level_Clear.ogg")
onready var game_over_sfx = preload("res://assets/sounds/Game_Over.ogg")

func _ready() -> void:
	var _err = gl.connect("play_sound", self, "play_sound")

func play_sound(sfx: int) -> void:
	match sfx:
		gl.SFX.MOVE:
			stream = movement_sfx
		gl.SFX.JOIN:
			stream = join_sfx
		gl.SFX.REPEL:
			stream = repel_sfx
		gl.SFX.CLEAR:
			stream = clear_sfx
		gl.SFX.GAME_OVER:
			stream = game_over_sfx
	play()
