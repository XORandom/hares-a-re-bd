extends Node2D

## Модуль туррели, автоматически нацеливающейся на
## заданные группы

## Скорость вращения башни
@export var rotation_speed: float = PI/3
## Скорость перезарядки
@export var reload_time: float = 1.0
#TODO сделать на основе групп
## Белый список целей, которые турель будет игнорировать
@export var white_list: Array[String]
#TODO можно сделать турель нейтральной, за исключением черного списка
## Черный список целей, которые турель будет атаковать
## те, кто её атаковал или избранные цели
@export var black_list: Array[String]

@onready var animation_player: AnimationPlayer = $AnimationPlayer

#TODO подумать, как это по-умному реализовать
## Ограничения поворота слева
#@export_range(-180, 0, 1.) var clamp_rotation_ledt:
## Ограничения поворота справа
#@export_range(0, 180, 1.) var clamp_rotation_right:

## Спрайт оружия
@onready var gun_sprite: AnimatedSprite2D = $GunSprite
## Спайт самой турели
@onready var base_sprite: AnimatedSprite2D = $BaseSprite
## Луч, засекающий цель
@onready var ray_cast_2d: RayCast2D = $RayCast2D

## Модуль отвечающий за стрельбу
@onready var bullet_generator: BulletGenerator = %BulletGenerator

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

## Список целей турели, к примеру игрок
var target_list: Array[Node2D] = []
## Текущая активная цель
var current_target: Node2D = null


func _ready() -> void:
	# Подключаемся к таймеру BulletGenerator
	bullet_generator.reload_timer.connect("timeout", _on_reload_timer_timeout)
	bullet_generator.reload_timer.wait_time = reload_time


func _physics_process(delta: float) -> void:
	# Обновляем текущую цель
	update_current_target()

	if current_target != null:
		var angle_to_target: float = global_position.direction_to(current_target.global_position).angle()
		# TODO это одно и тоже, надо посмотреть, что более производительно
		#var angle_to_target2: float = Vector2(target_list.global_position - global_position).angle()

		#if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider().is_in_group("Player"):
			#gun_sprite.rotation = angle_to_target
			### Добавим более плавное вращение, когда башня не мгновенно поворачивается к цели, а с определенной скоростью
			##print(lerp_angle(global_rotation, angle_to_target, .2))
		# --- лучший вариант ---
		var angle: float = lerp_angle(gun_sprite.global_rotation, angle_to_target, 1.)
		## На сколько турель перемещается в одном кадре.
		var angle_delta: float = rotation_speed * delta
		angle = clamp(angle, gun_sprite.global_rotation-angle_delta, gun_sprite.global_rotation+angle_delta)
		ray_cast_2d.global_rotation = angle
		gun_sprite.global_rotation = angle

		#TODO сделать систему свой-чужой
		## Для того, чтобы цель обнаруживалась, надо чтобы у нее одновреммено
		## был правильный Collision layer, который может обнаруживаться raycast
		## И группа, с которой сравнивается список допустимых целей
		if ray_cast_2d.is_colliding():
			if ray_cast_2d.get_collider() == current_target:
				if bullet_generator.reload_timer.is_stopped():
					shoot()

## Обновление текущей цели - выбор ближайшей из доступных
func update_current_target() -> void:
	if target_list.is_empty():
		current_target = null
		return

	# Находим ближайшую цель
	var closest_target: Node2D = null
	var min_distance: float = INF
	for target: Node2D in target_list:
		if is_instance_valid(target):  # Проверяем, существует ли цель
			var distance: float = global_position.distance_squared_to(target.global_position)
			if distance < min_distance:
				min_distance = distance
				closest_target = target
	current_target = closest_target
	# Очищаем список от недействительных целей
	target_list = target_list.filter(func(t: Node2D)-> bool: return is_instance_valid(t))



## Фунция стрельбы из пушки
func shoot() -> void:
	audio_stream_player_2d.play()
	gun_sprite.play("shot")
	animation_player.play("shot")
	bullet_generator.shot()
	ray_cast_2d.enabled = false


## Функция поиска цели
func find_target(n_target: Node2D = null) -> Node2D:
	if n_target == null or !is_instance_valid(n_target):
		return null
	if n_target.is_in_group("Player"):
		#print("Player ",n_target)
		pass
	if n_target.is_in_group("Enemy"):
		#print("Enemy ",n_target)
		pass
	if n_target.is_in_group("Turrets"):
		#print("Ally ",n_target)
		pass
	return n_target

## Перезарядка завершена
func _on_reload_timer_timeout() -> void:
	ray_cast_2d.enabled = true

## В зону обнаружения попал объект
## Позволяет проверить цель
## И, к примеру не атаковать дружественные обхекта
## Проверка с помощью принадлежности к группе
func _on_aggro_zone_body_entered(body: Node2D) -> void:
	# Проверяем список целей
	for group: StringName in body.get_groups():
		if group in white_list:
			print("цель в белом списке", body)
			return
	# Делаю это в 2 цикла, поскольку надо сначала проверить весь белый список,
	# а уже потом смотреть черный
	for group: StringName in body.get_groups():
		if group in black_list:
			print("цель в черном списке", body)
			#target_list.append(find_target(body))
			var validated_target:Node2D = find_target(body)
			if validated_target and not target_list.has(validated_target):
				target_list.append(validated_target)

## Объект покинул зону обнаружения
func _on_aggro_zone_body_exited(body: Node2D) -> void:
	# Удаляем из списка целей
	if body in target_list:
		target_list.remove_at(target_list.find(body))
		if body == current_target:
			current_target = null  # Сброс текущей цели для немедленного переключения
