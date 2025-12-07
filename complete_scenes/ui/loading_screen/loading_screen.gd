extends Control

## Загрузочный экран для перехода от одной сцены к другой.
##
## Используется для загрузки тяжелых сцен.
## Не занимается сохранением состояний

## Массив изображений, случайно выбираемых для показа
@export var loading_images_array: MyImageArray
## Подсказки игроку
@export var game_tips_array: MyStringArray

## На этой текстуре будут отображаться изображений загрузочного экрана
@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer2/TextureRect
#TODO
#@onready var loading: Label = $MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/Loading
@onready var margin_container: MarginContainer = $MarginContainer
##
@onready var progress_number: Label = $MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/ProgressNumber
##
@onready var progress_bar: ProgressBar = $MarginContainer/VBoxContainer2/VBoxContainer/ProgressBar
##
@onready var timer: Timer = $Timer
## Подсказки
@onready var game_tips: RichTextLabel = %GameTips


func _ready() -> void:
#region случайных выбор изображений и подсказок
	texture_rect.texture = loading_images_array.loading_images_array.pick_random()
	game_tips.text = game_tips_array.game_tips_array.pick_random()

#endregion

	margin_container.visible = false
	# загружай ресурсы в фоновом режиме, пока текущая сцена работает
	if SceneManager.next_scene == "":
		scene_invalid(SceneManager.next_scene)
		return
	else:
		ResourceLoader.load_threaded_request(SceneManager.next_scene)
		if not ResourceLoader.exists(SceneManager.next_scene):
			scene_failed_to_load(SceneManager.next_scene)
			return
#region Можно удалить, только для проверки
## итератор для того, чтобы проверить работу анимации загрузки
var iter: float = 0
#endregion


func _process(_delta: float) -> void:
	if SceneManager.next_scene == "":
#region Заполнитель, можно удалить
		progress_bar.value = floor(clamp(_delta+iter, 0, 100))
		progress_number.text = str(floor(clamp(_delta+iter, 0, 100)))+"%"
		iter +=0.1
#endregion
	else:
		var progress: Array = []
		ResourceLoader.load_threaded_get_status(SceneManager.next_scene, progress)
		progress_bar.value = progress[0]*100
		progress_number.text = str(progress[0]*100)+"%"

		if progress[0] == 1: # полностью загружен
			var packed_scene: PackedScene = ResourceLoader.load_threaded_get(SceneManager.next_scene)
			get_tree().change_scene_to_packed(packed_scene)



## Если не удалось загрузить сцену
func scene_failed_to_load(scene_path: String) -> void:
	push_error("can't load next scene: '%s'" %[scene_path])
## Если сцена не существует или введены некорректные данные
func scene_invalid(scene_path: String) -> void:
	push_error("scene: '%s' is invalid" %[scene_path])


## Включаем видимость этой сцены, если игра загружается дольше
func _on_timer_timeout() -> void:
	margin_container.visible = true
