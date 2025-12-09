class_name BulletBase
extends Area2D

## Базовый класс для всех пуль
##
## Пули персонажа, пули турелей, пули врагов
## Характеристики изменяются благодаря modullar_upgrades
## Для этого любая сущность должна стрелять пулями через bullet_generator



## Наносимый урон
var damage: float = 1.
## Направление движения
var direction: Vector2 = Vector2.RIGHT
## Скорость полёта пули
var speed: float = 1.
## Вектор движения (в отличии от направления, не единичный)[br]
## Его длина зависит от скорости
var movement: Vector2 = Vector2.RIGHT


func _ready() -> void:
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	movement = Vector2.RIGHT.rotated(rotation) * speed * delta
	global_position += movement
	#global_position += direction * speed * delta

## Поведение при попадании во что-то
func _on_body_entered(_body: Node2D) -> void:
	destroy()

## При покидании экрана запускается таймер,
## по истечении которого снаряд уничтожается
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	## Таймер, определяющий продолжительность жизни пули после покидания экрана
	await get_tree().create_timer(2.0).timeout
	destroy()

## Функция поведения при уничтожении
func destroy() -> void:
	queue_free()
