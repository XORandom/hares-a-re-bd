extends Node

## Реализует функционал добавления объекта в пул
##
## Для большого количества повторно используемых врагов. [br]
## Каждый раз когда мы создаем и уничтожаем врага, нет смысла высвобождать ресурсы [br]
## Лучше убрать объект в пул и когда он снова понадобится,
## то просто вернуть из пула.[br]
## Это также полезно для снарядов.
## [br][br]
## Это скрипт автозагрузки,
## поэтому создавать его класс или экземпляры не надо.


## Сцена, которую надо добавить в пул
@export var scene: PackedScene

var object_pool: Array[Node2D] = []

## Добавляем объекты в пул
func add_to_pull(object: Node2D) -> void:
	object_pool.append(object)
	object.set_process(false)
	object.set_physics_process(false)
	object.hide()


## Берем объекы из пула[br]
## Полезно для пуль или большого количества повторяющихся сцен
func pull_from_pull() -> Node2D:
	var object: Node2D
	# Если в пуле нет объектов, создаем
	if object_pool.is_empty():
		object = scene.instantiate()
	else:
		object = object_pool.pop_front()
	# Возвращает объект к жизни
	object.set_process(true)
	object.set_physics_process(true)
	object.show()
	return object
