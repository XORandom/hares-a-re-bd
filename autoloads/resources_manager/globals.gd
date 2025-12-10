extends Node


## Глобальные переменные, функции
##
## Сохранение и загрузка


var vin: bool = false

## Количество очков,на которые будет покупать игрок турели
var score: int = 0:
	get:
		print("кто-то считывает значение количества очков")
		return score
	set(value):
		# Проверяем на отрицательные значения
		EventBus.game_score_is_negative.emit()

		score = value
## Пользовательские настройки: громкость музыки, звука; язык
#var user_prefs:
#var save:

var player_can_move: bool = true

## Число кадров с секунду
const FPS: float = 60.
## Генератор случайных чисел
var rng: RandomNumberGenerator = RandomNumberGenerator.new()


## Последнее ненулевое направление игрока, может считываться ловушками и врагами
static var player_direction: Vector2

## Шина звуков
@onready var SFX_BUS_ID:int = AudioServer.get_bus_index("SFX")
## Шина музыки
@onready var MUSIC_BUS_ID:int = AudioServer.get_bus_index("Music")

func _ready() -> void:
	EventBus.CHARACTER_DIED.connect(game_over)
	pass


## Удаление узлов
func orphan_nodes(node: Node) -> void:
	if node != null and node.get_parent() != null:
		node.get_parent().remove_child(node)


func game_over() -> void:
	SceneManager.change_scene("uid://bxvpx0511unt")
	return
