extends ProgressBar

## Полоса здоровья
##
## Игрока, врагов, боссов[br]
## Не знает о характеристиках, здоровье и т.д.[br]
## Отображает только указанное здоровье и максимальное здоровье,
## которое этому узлу передали


@export var initial_health: float = 100.:
	get:
		return initial_health
	set(new_value):
		initial_health = new_value

## Показанное здоровье
var health: float = 0. : set = _set_health

## Полоса, показывающая нанесенный урон
@onready var damage_bar: ProgressBar = $DamageBar

## Таймер, отмеряющий, сколько времени
## будут показаны повреждения на полоске здоровья
@onready var timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


@onready var label_anim: LabelAnim = $LabelAnim


func _ready() -> void:
	init_health(initial_health)
	label_anim.text = str(initial_health)

## Сеттер переменной здоровья
func _set_health(new_health: float) -> void:
	## Функция, которая будет вызываться каждый раз, когда мы хотим изменить переменную health
	var prev_health: float = health
	# Нельзя установить здоровье выше максимального
	health = min(max_value, new_health)
	value = health
	label_anim.text = str(health)
	if health <=0.:
		queue_free()

	if health < prev_health: # Если был нанесен урон
		timer.start()
	else:
		damage_bar.value = health

## Начальные значения всех показателей
func init_health(_health: float) -> void:
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

## По истечению таймера полоса повреждения
## сравняется с полосой здоровья
func _on_timer_timeout() -> void:
	damage_bar.value = health
