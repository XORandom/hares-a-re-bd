class_name Player
extends BaseEntity

## Игрок
##
## Братец-кролик

## Управление для ходьбы
@export var walk_action: GUIDEAction
## Управление для бега
@export var run_action: GUIDEAction
## Управление для подкрадывания
@export var sneak_action: GUIDEAction

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

func _process(_delta: float) -> void:
	input_direction = walk_action.value_axis_2d.normalized()
	if input_direction != last_direction and input_direction != Vector2.ZERO:
		last_direction = input_direction
	Globals.player_direction = get_local_mouse_position().normalized() if input_direction == Vector2.ZERO else last_direction

	velocity = input_direction * speed * 100 * _delta
	#print(velocity)
	move_and_slide()

func _ready() -> void:
	walk_action.triggered.connect(on_walk_triggered)
	run_action.triggered.connect(on_run_triggered)
	sneak_action.triggered.connect(on_sneak_triggered)


func on_walk_triggered() -> void:
	if not walk.active:
		player_state_chart.send_event("walking")


func on_run_triggered() -> void:
	if not run.active:
		player_state_chart.send_event("running")


func on_sneak_triggered() -> void:
	if not sneak.active:
		player_state_chart.send_event("sneaking")
