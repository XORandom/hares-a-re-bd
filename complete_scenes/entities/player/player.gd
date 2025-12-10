class_name Player
extends BaseEntity

## Игрок
##
## Братец-кролик

## Это выстрел из дробовика (только полсе состояние прицеливания
@export var action_2d_attack: GUIDEAction = preload("uid://cdxjy5y8av6s3")
## Это прицеливание
@export var action_2d_attack_aiming: GUIDEAction = preload("uid://ceprtv2da5m4e")
##
@export var action_2d_attack_fluffy_ball: GUIDEAction = preload("uid://vvijfq34br47")
##
@export var action_2d_bunny_hop: GUIDEAction = preload("uid://cqh8gjbglemp3")
##
@export var action_2d_collect_resources: GUIDEAction = preload("uid://dkq4hk7p00vwh")
##
@export var action_2d_interact: GUIDEAction = preload("uid://dywvxybxq6wic")
##
@export var action_2d_leap: GUIDEAction = preload("uid://dtau516cvw114")
##
@export var action_2d_paw_strike: GUIDEAction = preload("uid://pcgn6iwjwpka")
##
@export var action_emotion_wheel: GUIDEAction = preload("uid://bjlqm18uk8rbo")
## Управление для бега
@export var run_action: GUIDEAction = preload("uid://btj8l0x5cop8o")
## Управление для подкрадывания
@export var sneak_action: GUIDEAction = preload("uid://cb14wrl0wyswa")
## Управление для ходьбы
@export var walk_action: GUIDEAction = preload("uid://cfqddltghxpse")


## Вектор направления движения
@onready var input_direction: Vector2 = Vector2.ZERO
## Последнее направлени движения
@onready var last_direction: Vector2 = Vector2.ZERO

#region FSM и состояния

## Конечный автомат игрока
@onready var player_state_chart: StateChart = $PlayerStateChart

## Состояние бега
@onready var run: AtomicState = $PlayerStateChart/Root/PlayerBehaviour/Run
## Состояние ходьбы
@onready var walk: AtomicState  = $PlayerStateChart/Root/PlayerBehaviour/Walk
## Состояние подкрадывания
@onready var sneak: AtomicState  = $PlayerStateChart/Root/PlayerBehaviour/Sneak
## Состояние отдыха
@onready var idle: AtomicState  = $PlayerStateChart/Root/PlayerBehaviour/Idle
## Состояние Получение урона и стан от этого
@onready var stunned: AtomicState = $PlayerStateChart/Root/PlayerBehaviour/Stunned
## Состояние Смерть персонажа
@onready var death: AtomicState = $PlayerStateChart/Root/PlayerBehaviour/Death
## Состояние Прицеливание
@onready var aim: AtomicState = $PlayerStateChart/Root/PlayerBehaviour/Aim
## Состояние Удар лапкой
@onready var paw_strike: AtomicState = $PlayerStateChart/Root/PlayerBehaviour/PawStrike
## Состояние Сбор ресурсов
@onready var collect_resources: AtomicState = $PlayerStateChart/Root/PlayerBehaviour/CollectResources
## Состояние Выстрел (action_2d_attack)
@onready var shot: AtomicState = $PlayerStateChart/Root/PlayerBehaviour/Shot
## Состояние Атака пушистым шаром
@onready var fluffy_ball: AtomicState = $PlayerStateChart/Root/PlayerBehaviour/FluffyBall
## Состояние Прыжок
@onready var bunny_hop: AtomicState = $PlayerStateChart/Root/PlayerBehaviour/BunnyHop
## Состояние взаимодействия
@onready var interact: AtomicState = $PlayerStateChart/Root/PlayerBehaviour/Interact

#endregion

@onready var animation_player: AnimationPlayer = $CharcterAnim/AnimationPlayer

@onready var animated_sprite_2d: AnimatedSprite2D = $CharcterAnim/AnimatedSprite2D

func _ready() -> void:
	walk_action.triggered.connect(on_walk_triggered)
	run_action.triggered.connect(on_run_triggered)
	sneak_action.triggered.connect(on_sneak_triggered)
	action_2d_attack.triggered.connect(on_action_2d_attack)
	action_2d_attack_aiming.triggered.connect(on_action_2d_attack_aiming)
	action_2d_attack_fluffy_ball.triggered.connect(on_action_2d_attack_fluffy_ball)
	action_2d_bunny_hop.triggered.connect(on_action_2d_bunny_hop)
	action_2d_collect_resources.triggered.connect(on_action_2d_collect_resources)
	action_2d_interact.triggered.connect(on_action_2d_interact)
	action_2d_leap.triggered.connect(on_action_2d_leap)
	action_2d_paw_strike.triggered.connect(on_action_2d_paw_strike)
	action_emotion_wheel.triggered.connect(on_action_emotion_wheel)

	action_2d_attack.ongoing.connect(_update_action_2d_attack)
	action_2d_attack_aiming.ongoing.connect(_update_action_2d_attack_aiming)
	action_2d_attack_fluffy_ball.ongoing.connect(_update_action_2d_attack_fluffy_ball)
	action_2d_bunny_hop.ongoing.connect(_update_action_2d_bunny_hop)
	action_2d_collect_resources.ongoing.connect(_update_action_2d_collect_resources)
	action_2d_leap.ongoing.connect(_update_action_2d_leap)
	action_2d_paw_strike.ongoing.connect(_update_action_2d_paw_strike)


#region Сигналы от действий
## Сигнал конечному автомату о переходе в состояние ходьбы
func on_walk_triggered() -> void:
	DebugPanel.show_debug_info(["on_walk_triggered"], 1)
	if not walk.active:
		player_state_chart.send_event("walking")

## Сигнал конечному автомату о переходе в состояние бега
func on_run_triggered() -> void:
	DebugPanel.show_debug_info(["on_run_triggered"], 1)
	if not run.active:
		player_state_chart.send_event("running")

## Сигнал конечному автомату о переходе в состояние подкрадывания
func on_sneak_triggered() -> void:
	DebugPanel.show_debug_info(["on_sneak_triggered"], 1)
	if not sneak.active:
		player_state_chart.send_event("sneaking")

## Сигнал конечному автомату о переходе в состояние прицеливания
func on_action_2d_attack_aiming() -> void:
	DebugPanel.show_debug_info(["aiming"], 1)
	if not aim.active:
		player_state_chart.send_event("aiming")

## Сигнал конечному автомату о переходе в состояние выстрела из дробовика
## Сработает только если предыдущее состояние прицеливание
func on_action_2d_attack() -> void:
	DebugPanel.show_debug_info(["shot"], 1)
	if not shot.active:
		player_state_chart.send_event("shot")


## Прыжок с атакой пушистым шаром
func on_action_2d_attack_fluffy_ball() -> void:
	DebugPanel.show_debug_info(["on_action_2d_attack_fluffy_ball"], 1)
	if not fluffy_ball.active:
		player_state_chart.send_event("fluffy_ball")

## Прыжок с разгоном
func on_action_2d_bunny_hop() -> void:
	DebugPanel.show_debug_info(["on_action_2d_bunny_hop"], 1)
	if not bunny_hop.active:
		player_state_chart.send_event("bunny_hop")
## Сбор ресурсов
func on_action_2d_collect_resources() -> void:
	DebugPanel.show_debug_info(["on_action_2d_collect_resources"], 1)
	if not collect_resources.active:
		player_state_chart.send_event("collect")
## Взаимодействие
func on_action_2d_interact() -> void:
	DebugPanel.show_debug_info(["on_action_2d_interact"], 1)
	if not interact.active:
		player_state_chart.send_event("interact")
## Прыжок
func on_action_2d_leap() -> void:
	DebugPanel.show_debug_info(["on_action_2d_leap"], 1)
	#FIXME пока прыжок и баннихот это одно и тоже
	if not bunny_hop.active:
		player_state_chart.send_event("bunny_hop")
## Удар лапкой
func on_action_2d_paw_strike() -> void:
	DebugPanel.show_debug_info(["on_action_2d_paw_strike"], 1)
	if not paw_strike.active:
		player_state_chart.send_event("paw_strike")
## Колесо эмоций
func on_action_emotion_wheel() -> void:
	DebugPanel.show_debug_info(["on_action_emotion_wheel"], 1)
	#TODO если будет
#endregion

func  on_damage_taken() -> void:
	player_state_chart.send_event("stunned")
	pass

func _physics_process(_delta: float) -> void:
	Globals.player_coords = position
	input_direction = walk_action.value_axis_2d.normalized()
	if velocity == Vector2.ZERO:
		player_state_chart.send_event("idle")
	DebugPanel.show_debug_info(["velocity ",
		velocity,
		], 7)
	if input_direction != last_direction or input_direction == Vector2.ZERO:
		last_direction = input_direction
	Globals.player_direction = get_local_mouse_position().normalized() if input_direction == Vector2.ZERO else last_direction
	##player_direction к примеру
	##			 0,-1
	##	-1,0	 @			1,0
	##			 0,1
	animated_sprite_2d.flip_h = Globals.player_direction.x<0
	DebugPanel.show_debug_info(["player_direction",
		Globals.player_direction,
		Globals.player_direction.x>0
		], 11)

	#position += walk_action.value_axis_2d.normalized() * speed * _delta
	#position += run.value_axis_2d.normalized() * speed * _delta
	#position += input_direction * speed * _delta
	velocity = input_direction * speed
	move_and_slide()
	DebugPanel.show_debug_info([global_position], 0)



#region Сигналы с конечного автомата
## Делаем здесь, а не в on_run_triggered,
## потому что конечный автомат также проверяет необходимость
## и возможность перехода в состояние, в отличии от ввода
func _on_run_state_entered() -> void:
	speed = speed_max
	animated_sprite_2d.play("run_r")
	pass # Replace with function body.

## Сигнал от конечного автомата (FSM PlayerStateChart)
func _on_walk_state_entered() -> void:
	speed = speed_normal
	animated_sprite_2d.play("walk_r")
	pass # Replace with function body.

## Сигнал от конечного автомата (FSM PlayerStateChart)
func _on_sneak_state_entered() -> void:
	speed = speed_min
	animated_sprite_2d.play("sneak_r")
	pass # Replace with function body.

## Сигнал от конечного автомата (FSM PlayerStateChart)
func _on_idle_state_entered() -> void:
	speed = speed_normal
	animated_sprite_2d.play("idle_r")
	pass # Replace with function body.

## Сигнал от конечного автомата (FSM PlayerStateChart)
func _on_stunned_state_entered() -> void:
	speed = 0
	animated_sprite_2d.play("wound_r")
	pass # Replace with function body.


func _on_death_state_entered() -> void:
	animated_sprite_2d.play("death_r")
	await animated_sprite_2d.animation_finished
	EventBus.CHARACTER_DIED.emit()


func _on_aim_state_entered() -> void:
	animated_sprite_2d.play("aim_r")
	pass # Replace with function body.


func _on_paw_strike_state_entered() -> void:
	animated_sprite_2d.play("paw_strike_r")
	pass # Replace with function body.


func _on_collect_resources_state_entered() -> void:
	animated_sprite_2d.play("collect_resurses_r")
	pass # Replace with function body.


func _on_shot_state_entered() -> void:
	animated_sprite_2d.play("attack_r")

	if animated_sprite_2d.flip_h:
		animation_player.play("attack_left")
	else:
		animation_player.play("attack_right")
	pass # Replace with function body.


func _on_fluffy_ball_state_entered() -> void:
	animated_sprite_2d.play("flaffy_boll_r")
	pass # Replace with function body.


func _on_bunny_hop_state_entered() -> void:
	animated_sprite_2d.play("jump_r")
	pass # Replace with function body.


func _on_interact_state_entered() -> void:
	animated_sprite_2d.play("collect_resurses_r")
	pass # Replace with function body.
#endregion


func _update_action_2d_attack() -> void:
	DebugPanel.show_debug_info(["_update_action_2d_attack"], 12)

func _update_action_2d_attack_fluffy_ball() -> void:
	DebugPanel.show_debug_info(["_update_action_2d_attack_fluffy_ball"], 12)

func _update_action_2d_attack_aiming() -> void:
	DebugPanel.show_debug_info(["_update_action_2d_attack_aiming"], 12)

func _update_action_2d_bunny_hop() -> void:
	DebugPanel.show_debug_info(["_update_action_2d_bunny_hop"], 12)

func _update_action_2d_collect_resources() -> void:
	DebugPanel.show_debug_info(["_update_action_2d_collect_resources"], 12)

func _update_action_2d_leap() -> void:
	DebugPanel.show_debug_info(["_update_action_2d_leap"], 12)

func _update_action_2d_paw_strike() -> void:
	DebugPanel.show_debug_info(["_update_action_2d_paw_strike"], 12)
