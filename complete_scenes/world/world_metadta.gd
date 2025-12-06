class_name WorldMetadata
extends Node

## Данные о мире
##
## Должны быть в каждом мире,
## устанавливают необходимые параметры управления (G.U.I.D.E.),

## Какой режим привязки клавиш использовать
@export var context_mode: GUIDEMappingContext = preload("uid://cflgfu33ylmjg")


func _ready() -> void:
	# Надо, чтобы мир при загрузке добавлял себя (для спавна предемтов
	SceneManager.current_world = owner
	# И свою систему управления
	printerr(context_mode)
	GUIDE.enable_mapping_context(context_mode)
