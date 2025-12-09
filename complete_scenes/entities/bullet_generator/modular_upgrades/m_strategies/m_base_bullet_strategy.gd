@abstract
class_name BaseBulletStrategy
extends Resource

## Модуль для создания улучшения для пуль.
## Потом подобный способ можно применить и к другим способностям

## Как будет выглядеть улучшение
@export var upgrade_texture: Texture2D
## Описание улучшения
@export_multiline var upgrade_description: String

## Применение обновлений
@abstract
func apply_upgrade(bullet: BulletBase) -> void
