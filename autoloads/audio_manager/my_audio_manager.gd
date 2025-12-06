extends Node

## Управление музыкой, в том числе фоновой
##
## Продолжает играть при переключении сцен
## Устанавливает ограничения на громкость звуковых эффектов

## Настройки звуковых эффектов
@export var sfx_settings: Array
## Настрйоки музыки
@export var music_settings: Array
## Настроки звуков (интерфейса, к примеру)
@export var sound_settings: Array

@onready var audio_stream_player_bg: AudioStreamPlayer = $AudioStreamPlayerBG


func play_music() -> void:
	audio_stream_player_bg.play()

#TODO сделать
# Создает точесный звук
## Управляет громкостью звуков
## Для того, чтобы звуки отдельных мобов не накладывались многократно
func create_audio_at_location_2d(location: Vector2) -> void:
	## Создаем новый точечный звук
	var new_audio_2d: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	add_child(new_audio_2d)

	# Указываем координаты звука
	new_audio_2d.position = location
	#TODO сделать настройки
	#new_audio_2d.stream
	#new_audio_2d.volume_db
	#new_audio_2d.pitch_scale

	new_audio_2d.play()
