class_name SpeedBulletStrategy
extends BaseBulletStrategy

## Модуль, изменяющий скорость полета пули
##
##

## Добавляемая скорость
@export var apply_speed: int = 100

## Применение обновлений
func apply_upgrade(bullet: BulletBase)-> void:
	bullet.speed += apply_speed
