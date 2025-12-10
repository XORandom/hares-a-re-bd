@abstract
class_name BaseEntity
extends CharacterBody2D


## Сигнал о получении урона, сущность вправе его игнорировать
## Принимает полученный урон и направление отбрасывания
signal take_damage(damage:float, knockback_direction: Vector2)

## текущая скорость
@export var speed: float = 300.:
	get:
		return speed
	set(value):
		speed = value
## максимальная скорость, к примеру бега
@export var speed_max: float = 600.:
	get:
		return speed_max
	set(value):
		push_error("Это значение не надо менять")
		speed_max = value
## скорость минимальная скорость перемещения (для подкрадывания)
@export var speed_min: float = 100.:
	get:
		return speed_min
	set(value):
		push_error("Это значение не надо менять")
		speed_min = value
## нормальная скорость перемещения, например для ходьбы
@export var speed_normal: float = 300.:
	get:
		return speed_normal
	set(value):
		push_error("Это значение не надо менять")
		speed_normal = value

## То, как объект будет выглядеть на карте
@export var map_icon: Texture2D
## Уровень здоровья
@export var hp: float = 100.0

@abstract
func on_damage_taken(damage: float) -> void
