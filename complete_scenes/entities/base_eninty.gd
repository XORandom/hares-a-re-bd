@abstract
class_name BaseEntity
extends CharacterBody2D


## Сигнал о получении урона, сущность вправе его игнорировать
## Принимает полученный урон и направление отбрасывания
signal take_damage(damage:float, knockback_direction: Vector2)

## скорость движения
@export var speed: float = 200.
## То, как объект будет выглядеть на карте
@export var map_icon: Texture2D
@export var hp: float = 100.0

@abstract
func on_damage_taken() -> void
