class_name DamageBulletStrategy
extends BaseBulletStrategy

## Модуль изменяющий урон пули
##
##

## Добавляемый урон пуле
@export var apply_damage: int = 5

## Применение обновлений
func apply_upgrade(bullet: BulletBase)-> void:
	bullet.damage += apply_damage
