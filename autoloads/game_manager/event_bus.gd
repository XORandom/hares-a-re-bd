extends Node

## Шина событий
##
## Подключить сигнал
## [codeblock]
## EventBus.connect("Имя_сигнала", метод_обработки)
## [/codeblock]
## Отправить сигнал
## [codeblock]
## EventBus.Имя_сигнала.emit()
## [/codeblock]

## Когда день в игре сменился на следующий
## Например перемотка времени или возвращение в определенный день
## [br][br]
## [b]Отправитель:[/b] TimeManager, или кто угодно
## [br][br]
## [b]Получатель:[/b] TimeManager
signal day_changed(new_day)

## Когда время в игре изменяется (не скорость игры)
## [br][br]
## [b]Отправитель:[/b]
## [br][br]
## [b]Получатель:[/b]
signal time_changed(new_time: float)

## В мире появилась определенная сущность
## [br][br]
## [b]Отправитель:[/b] TimeManager
## [br][br]
## [b]Получатель:[/b] TimeManager
signal entity_spawned(BaseEntity) #TODO создать класс данных, описывающих сущности EntitySpawnDate

## Вызывается, когда умирает важный персонаж, например игрок.
signal CHARACTER_DIED(character: Node2D)


## Нужен для обновления направления игрока в пространстве (up, down, left, right)
## [br][br]
## [b]Отправитель:[/b] State PlayerStateChart (Attack, Sneak, Idle ...)
## [br][br]
## [b]Получатель:[/b]  res://complete_scenes/entities/player/player.tscn
signal player_change_direction(tree_node: String)

## Вызывается, когда здоровье игрока изменилось.
## [br][br]
## [b]Отправитель:[/b] модуль получения урона #TODO сделать срочно
## [br][br]
## [b]Получатель:[/b] player_hud
signal PLAYER_HEALTH_UPDATED(health: float)
signal PLAYER_HEALTH_Damage(damage: float)
 	#Подаем сигнал об изменении здоровья
	#EventBus.emit_signal("PLAYER_HEALTH_UPDATED", new_health)


## Сообщает, что в сцене есть world environment, а значит можно включить тени
## [br][br]
signal world_environment_applied()
