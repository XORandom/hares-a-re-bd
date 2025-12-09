extends Node

## Менеджер времени
##
## Управляет течением времени в игре, временами года и суток
## Также позволяет переключать паузу в игре
## А также отслеживать время для реиграбельности
## Чтобы к примеру применять в разное время суток разные эффекты

#TODO пока время не сохраняется сохранять игровое время
#TODO добавить проверку времени из OS
#TODO добавить сохранение времени и расчёты, сколько прошло времени вне игры

## Скорость движка
var time_scale: float = 1.
## Скорость течения времени
var project_time_scale: float = 0.0166667 # 0.0166667
## Сколько минут сейчас в игре
var project_current_minute: float = 0.0
## Который час в игре
var project_current_hour: float = 0.0
## Который день в игре
var project_current_day: float = 0.0

func _ready() -> void:
	set_current_time()

func _process(delta: float) -> void:
	update_time(delta)

func _input(_event: InputEvent) -> void:
	pass


## Система управления временем
func update_time(delta: float) -> void:
	project_current_minute += delta * project_time_scale

	# После 60 минут начинается новый час
	if project_current_minute > 60.0:
		project_current_minute -= 60.0
		project_current_hour += 1.0

	# Через 24 часа новый день
	if project_current_hour >= 24.0:
		project_current_hour -= 24.0
		project_current_day += 1.0


## Установить текущее время (для часового пояса компьютера)
func set_current_time() -> void:
	var time: Dictionary = Time.get_time_dict_from_system()
	project_current_hour = time["hour"]
	project_current_minute = time["minute"]


## Установить конкретное время[br]
## Время передается в массиве с такой же структурой,
## как и у синглтона Time. [br]
## Это позволяет передавать в качестве параметра
## Time.get_time_dict_from_system()
func set_custom_time(_custom_time: Dictionary) -> void:
	project_current_hour = _custom_time["hour"]
	project_current_minute = _custom_time["minute"]



## Переключение паузы
func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused



## Позволяет останавливать игру на мгновенье. Hitstop
func frame_freeze(time_scale_parameter:float=0.1, duration:float=1.0) -> void:
	Engine.time_scale = time_scale_parameter
	await(get_tree().create_timer(duration * time_scale_parameter).timeout)
	Engine.time_scale = 1.0

#HACK
## Тоже самое, что и frame_freeze, чтобы не искать, как называется
func hitstop(time_scale_parameter:float=0.1, duration:float=1.0) -> void:
	frame_freeze(time_scale_parameter, duration)
