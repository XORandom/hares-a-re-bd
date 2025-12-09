class_name BulletGenerator
extends Node2D

## Создает снаряды с заданными параметрами
##
##

## Тип стрельбы
enum BULLET_TYPES {
	GUN,
	SHOTGUN,
	AIM,
	LASER,
}

## Сцена снаряда
#@export var BULLET: PackedScene
@export var BULLET: PackedScene = preload("uid://d2dkt4bwqumgy")
@export var BULLET_AIM: PackedScene = preload("uid://q6cmkt1540n3")


# TODO если повысит прроизводиетльность, сделать потом сравнение не строк, а битов
@export var chosen_type: BULLET_TYPES = BULLET_TYPES.GUN
## Улучшения для пуль
@export var upgrades: Array[BaseBulletStrategy] = []
## Разброс снарядов в градусах
@export_range(0.0, 40., 0.1) var spread_degrees: float = 0.0
## Скорость перезарядки
@export_range(0.01, 10., 0.01,"or_greater") var recharge_time: float = 1.

## Таймер перезарядки
var reload_timer: Timer
## Готов ли к стрельбе
var can_shoot: bool = true

func _ready() -> void:
	# Создаем таймер перезарядки
	reload_timer = Timer.new()
	add_child(reload_timer)
	reload_timer.one_shot = true
	reload_timer.wait_time = recharge_time
	reload_timer.connect("timeout", _on_timer_timeout)


func _physics_process(_delta: float) -> void:
	#look_at(get_global_mouse_position())
	pass

## Применяем улучшения к существущей пуле
func apply_all_upgrades(_bullet:BulletBase) -> void:
	if upgrades.is_empty():
		return
	for strategy:BaseBulletStrategy in upgrades:
		strategy.apply_upgrade(_bullet)

## Для стрельбы одиночными пулями
func launc_single_bullet(spread_rad:float=0.0) -> void:
	## Экземпляр пули
	var bullet: BulletBase = BULLET.instantiate()
	bullet.global_position = global_position
	## Основное направление пули
	var base_direction: Vector2 = Vector2.from_angle(global_rotation)
	# Применяем случайный разброс, если он задан
	if spread_rad > 0.:
		var deviation_angle: float = randf_range(-spread_rad, spread_rad)
		base_direction = base_direction.rotated(deviation_angle)

	bullet.direction = base_direction


	#get_tree().get_root().add_child(bullet)
	# Снаряды должны существовать в сцене
	get_tree().current_scene.add_child(bullet)
	apply_all_upgrades(bullet)


## Для стрельбы одиночными пулями
func launc_single_bullet_aim(spread_rad:float=0.0, use_homing: bool = false) -> void:
	## Экземпляр пули
	var bullet: BulletAim = BULLET_AIM.instantiate()
	bullet.global_position = global_position
	## Основное направление пули
	var base_direction: Vector2 = Vector2.from_angle(global_rotation)
	# Применяем случайный разброс, если он задан
	if spread_rad > 0.:
		var deviation_angle: float = randf_range(-spread_rad, spread_rad)
		base_direction = base_direction.rotated(deviation_angle)

	bullet.direction = base_direction


	if use_homing:
		bullet.target = find_nearest_enemy()  # Укажите цель
	#get_tree().get_root().add_child(bullet)
	# Снаряды должны существовать в сцене
	get_tree().current_scene.add_child(bullet)
	apply_all_upgrades(bullet)

## Для стрельбы дробовик-like
func launc_multiple_bullets(spread_rad:float=0.0) -> void:
	for i:int in range(5):
		launc_single_bullet(spread_rad)


## Функция атаки
func shot() -> void:
	if chosen_type == BULLET_TYPES.GUN:
		launc_single_bullet(deg_to_rad(spread_degrees))
	if chosen_type == BULLET_TYPES.SHOTGUN:
		launc_multiple_bullets(deg_to_rad(spread_degrees))
	if chosen_type == BULLET_TYPES.AIM:
		launc_single_bullet_aim(deg_to_rad(spread_degrees), true)
	can_shoot = false
	reload_timer.start()



##
func _on_timer_timeout() -> void:
	#print("готов к стрельбе")
	can_shoot = true


## Поиск ближайшего врага
## Система самонаведения
func find_nearest_enemy() -> BaseEntity:
	var enemies: Array = get_tree().get_nodes_in_group("Player")  # Враги в группе "enemies"
	if enemies.is_empty():
		return null

	var nearest: Node2D = enemies[0]
	var min_distance: float = global_position.distance_to(nearest.global_position)
	for enemy: Node2D in enemies:
		var distance: float = global_position.distance_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			nearest = enemy
	printerr(nearest)
	return nearest
