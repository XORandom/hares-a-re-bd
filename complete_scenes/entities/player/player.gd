class_name Player
extends BaseEntity

## Игрок
##
## Братец-кролик

## Управление для ходьбы
@export var walk_action: GUIDEAction = preload("uid://cfqddltghxpse")
## Управление для бега
@export var run_action: GUIDEAction = preload("uid://btj8l0x5cop8o")
## Управление для подкрадывания
@export var sneak_action: GUIDEAction = preload("uid://cb14wrl0wyswa")

## Вектор направления движения
@onready var input_direction: Vector2 = Vector2.ZERO
## Последнее направлени движения
@onready var last_direction: Vector2 = Vector2.ZERO
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

@onready var animated_sprite_2d: AnimatedSprite2D = $CharcterAnim/AnimatedSprite2D

func _process(delta: float) -> void:
	pass



func  on_damage_taken() -> void:
	pass

func _physics_process(delta: float) -> void:
	input_direction = walk_action.value_axis_2d.normalized()
	if input_direction != last_direction and input_direction != Vector2.ZERO:
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

	#position += walk_action.value_axis_2d.normalized() * speed * delta
	#position += run.value_axis_2d.normalized() * speed * delta
	position += input_direction * speed * delta
	#velocity = input_direction * speed * delta
	#move_and_slide()
	DebugPanel.show_debug_info([global_position], 0)


func _ready() -> void:
	walk_action.triggered.connect(on_walk_triggered)
	run_action.triggered.connect(on_run_triggered)
	sneak_action.triggered.connect(on_sneak_triggered)

##
func on_walk_triggered() -> void:
	DebugPanel.show_debug_info(["on_walk_triggered"], 1)
	if not walk.active:
		player_state_chart.send_event("walking")

##
func on_run_triggered() -> void:
	DebugPanel.show_debug_info(["on_run_triggered"], 1)
	if not run.active:
		player_state_chart.send_event("running")

##
func on_sneak_triggered() -> void:
	DebugPanel.show_debug_info(["on_sneak_triggered"], 1)
	if not sneak.active:
		player_state_chart.send_event("sneaking")


func _on_run_state_processing(delta: float) -> void:
	animated_sprite_2d.animation
	pass # Replace with function body.


func _on_walk_state_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_sneak_state_processing(delta: float) -> void:
	pass # Replace with function body.

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


func _on_attack_state_entered() -> void:
	animated_sprite_2d.play("attack_r")
	pass # Replace with function body.


func _on_paw_strike_state_entered() -> void:
	animated_sprite_2d.play("paw_strike_r")
	pass # Replace with function body.


func _on_collect_resources_state_entered() -> void:
	animated_sprite_2d.play("collect_resurses_r")
	pass # Replace with function body.
