# Путеводные заметки
Сборник заметок, объясняющий (в первую очередь для меня самого),
почему я решил принять те или иные решения

## Управление
Надо понимать 2 термина:
	action (действие) - нажатие клавиши, мышки и т.д. игроком
	context (контекст) - то, как это действие будет интерпретировано

В мир добавляется контест с действиями и их интерпретацией
Это позволяет в зависимости от ситуации менять контекст действий игрока

Описание некоторых действий
бег (клавиши управления и удерживаемый Shift)
res://config/input_actions/action_2d_run.tres
шаг (клавиши управлений)
res://config/input_actions/action_2d_walk.tres
подкрадывание (клавиши упраления и удерживаемый control)
res://config/input_actions/action_2d_sneak.tres


```GSCript
@export var context_mode: GUIDEMappingContext = preload("uid://cflgfu33ylmjg")
```

## Направления вращения
`get_angle_to(get_global_mouse_position())`
			-1,5
-3 или 3	  @			0
			 1.5

`get_local_mouse_position().normalized()`
			 0,-1
-1,0		  @			1,0
			 0,1

То, что не надо в релизе
```GSCript
if not Engine.is_editor_hint():
```

## Карты нормалей
Для них используется
Texture `->` CanvasTexture

## Загрузка сцен и загрузочный экран
с коммитом `1dada4a025d4b540462dfdacd22b9e64763d75fb`
я добавил эффект плавления экрана и столкнулся с визуальным мерцанием на 1 кадр,
вызванным тем, что в этот кадр LoadingScreen
(res://autoloads/loading_screen/loading_screen.tscn)
не отображает себя по таймеру.

Решил поменять сам принцип загрузки
ТеперьLoadingScreen не отвечает за загрузку ресурсов
Это делает класс MySceneLoader, а LoadingScreen лишь появляется,
когда надо прикрыть долгую загрузку.
