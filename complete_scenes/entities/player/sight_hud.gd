extends Node2D

## Эффективный ррадиус атаки
##
##

## Максимальное рассояние, на которое отходит прицел дробовика
## на разных уровнях радиус различается
@export var shotgun_radius: float = 500.
## Круг отладки (невидим в игре
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

## Сам прицел
@onready var marker_2d: Marker2D = $Marker2D
@onready var muzzle: Sprite2D = $Muzzle

func _ready() -> void:
	collision_shape_2d.shape.radius = shotgun_radius

func _physics_process(_delta: float) -> void:
	marker_2d.position = calculate_shotgun_radius_vector()

func calculate_shotgun_radius_vector() -> Vector2:
	var event_position: Vector2 = get_local_mouse_position()
	##
	var center: Vector2 = position
	##
	var delta: Vector2 = event_position - center
	#DebugPanel.show_debug_info(["center", center], 3)
	#DebugPanel.show_debug_info(["event_position", event_position], 5)
	#DebugPanel.show_debug_info(["delta", delta], 4)

	if delta.length() <= shotgun_radius:
		return event_position
	else:
		var direction: Vector2 = delta.normalized()
		return center + direction * shotgun_radius
