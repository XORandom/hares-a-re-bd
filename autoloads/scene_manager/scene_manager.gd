extends Node

## Управляет переключением сцен
##
## Для управления загрузкой различных сцен. И выбора, показывать ли загрузочный экран или нет


## загрузочный экран
var __loading_screen: PackedScene = preload("uid://bijcjwcldnokn")

var next_scene: String = ""

## Текущая сцена, в которой происходят события,
## нужна, чтобы понимать, куда помещаются предметы
var current_world: Node


## Смена сцены, вместо того, чтобы сразу загружать следующую сцену, загружаем экран загрузки
func change_scene_preload(__new_scene: String) -> int:
	# Если мы в этой же сцене, то никуда не идём
	if __new_scene == get_tree().current_scene.scene_file_path:
		push_warning('you already in this scene')
		return -1
	else:
		next_scene = __new_scene
		get_tree().change_scene_to_packed(__loading_screen)
		return 0


## Если перед этим проигрывается анимация tween
## для мгновенного перехода по сигналу её завершения
func change_scene_after_tween(__new_scene: String) -> int:
	# Если мы в этой же сцене, то никуда не идём
	if __new_scene == get_tree().current_scene.scene_file_path:
		push_warning('you already in this scene')
		return -1
	else:
		next_scene = __new_scene
		ResourceLoader.load_threaded_request(next_scene)
		if not ResourceLoader.exists(next_scene):
			scene_failed_to_load(next_scene)
			return -1
		return 0

#TODO сделать через использование MySceneLoader
## Переход по умолчанию
func change_scene(__new_scene: String) -> int:
	# Если мы в этой же сцене, то никуда не идём
	if __new_scene == get_tree().current_scene.scene_file_path:
		push_warning('you already in this scene')
		return -1
	else:
		get_tree().change_scene_to_file(__new_scene)
		return 0


## Для обычного прямого перехода
func change_scene_simple(__new_scene: String) -> int:
	# Если мы в этой же сцене, то никуда не идём
	if __new_scene == get_tree().current_scene.scene_file_path:
		push_warning('you already in this scene')
		return -1
	else:
		get_tree().change_scene_to_file(__new_scene)
		return 0

func change_scene_instant() -> void:
		var progress: Array = []
		ResourceLoader.load_threaded_get_status(next_scene, progress)
		if progress[0] == 1: # полностью загружен
			var packed_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene)
			get_tree().change_scene_to_packed(packed_scene)

## Если не удалось загрузить сцену
func scene_failed_to_load(scene_path: String) -> void:
	push_error("can't load next scene: '%s'" %[scene_path])
