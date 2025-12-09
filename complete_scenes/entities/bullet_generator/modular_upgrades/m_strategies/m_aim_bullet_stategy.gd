class_name AimBulletStrategy
extends BaseBulletStrategy

## Модуль изменяющий урон пули
##
##

#TODO сделать модуль

## Добавляемый урон пуле
@export var aim_module_scene: PackedScene = preload("uid://c3datcrbyww8n")

## Применение обновлений
func apply_upgrade(bullet: BulletBase)-> void:
	var aim_module: Node2D = aim_module_scene.instantiate()
	bullet.add_child(aim_module)
