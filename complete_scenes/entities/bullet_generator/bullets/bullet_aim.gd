class_name BulletAim
extends BulletBase

## Цель для самонаведения
var target: BaseEntity = null
## Максимальная скорость поворота (в радианах за секунду)
var turn_speed: float = 2.0 * PI  # 360 градусов в секунду


func _physics_process(delta: float) -> void:
	#movement = Vector2.RIGHT.rotated(rotation) * speed * delta
	#global_position += movement
	#global_position += direction * speed * delta
	if target != null:
		# Направление к цели
		var to_target: Vector2 = (target.global_position - global_position).normalized()

		# Текущий угол направления пули
		var current_angle: float = direction.angle()

		# Угол к цели
		var target_angle: float = to_target.angle()

		# Разница углов (с учетом кратчайшего пути)
		var angle_diff: float = wrapf(target_angle - current_angle, -PI, PI)

		# Ограничение поворота за кадр
		var max_turn: float = turn_speed * delta
		var turn: float = clampf(angle_diff, -max_turn, max_turn)

		# Поворот направления
		direction = direction.rotated(turn)

	# Движение пули
	global_position += direction * speed * delta
