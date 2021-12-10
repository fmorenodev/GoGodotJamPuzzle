extends Node2D

onready var movement_sfx = preload("res://assets/sounds/Particle_Movement.ogg")
onready var join_sfx = preload("res://assets/sounds/Particles_Join.ogg")
onready var repel_sfx = preload("res://assets/sounds/Particles_Repel.ogg")
onready var clear_sfx = preload("res://assets/sounds/Level_Clear.ogg")
onready var game_over_sfx = preload("res://assets/sounds/Game_Over.ogg")

onready var sfx_player_1 = $SFXPlayer
onready var sfx_player_2 = $SFXPlayer2
onready var music_player = $MusicPlayer

func _ready() -> void:
	var _err = gl.connect("play_sound", self, "play_sound")

func play_sound(sfx: int) -> void:
	match sfx:
		gl.SFX.MOVE:
			sfx_player_1.stream = movement_sfx
			sfx_player_1.play()
		gl.SFX.JOIN:
			sfx_player_2.stream = join_sfx
			sfx_player_2.play()
		gl.SFX.REPEL:
			sfx_player_2.stream = repel_sfx
			sfx_player_2.play()
		gl.SFX.CLEAR:
			sfx_player_2.stream = clear_sfx
			sfx_player_2.play()
		gl.SFX.GAME_OVER:
			music_player.stop()
			sfx_player_2.stream = game_over_sfx
			sfx_player_2.play()

func play_music(value: bool) -> void:
	var _err = $MusicPlayer.play() if value else $MusicPlayer.stop()
