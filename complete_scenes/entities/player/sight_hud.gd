extends Node2D

## Эффективный ррадиус атаки
##
##

## Максимальное рассояние, на которое отходит прицел дробовика
## на разных уровнях радиус различается
@export var shotgun_radius: float = 500.
## Список врагов в зоне попадания
var target_list: Array[BaseEntity] = []

## Наносимый урон
var damage: float = 1.

## Круг отладки (невидим в игре
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
## Область попадания пули
@onready var bullet_area: Area2D = $Marker2D/BulletArea
## Сам прицел
@onready var marker_2d: Marker2D = $Marker2D
@onready var muzzle: Sprite2D = $Marker2D/Muzzle

func _ready() -> void:
	# Не смотря на предупреждение, ошибки тут нет
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

## Вызывается игроком или animation player
func shot() -> void:
	for body: BaseEntity in target_list:
		body.call_deferred("on_damage_taken", damage)



func _on_bullet_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		target_list.append(body)


func _on_bullet_area_body_exited(body: Node2D) -> void:
	target_list.remove_at(target_list.find(body))
