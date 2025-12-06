extends Control

## Загрузочный экран для перехода от одной сцены к другой.
## Используется для загрузки тяжелых сцен.
## Не занимается сохранением состояний

@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer2/TextureRect
@onready var loading: Label = $MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/Loading
@onready var progress_number: Label = $MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/ProgressNumber
@onready var progress_bar: ProgressBar = $MarginContainer/VBoxContainer2/VBoxContainer/ProgressBar
@onready var timer: Timer = $Timer
@onready var game_tips: RichTextLabel = %GameTips


func _ready() -> void:
	visible = false
	# загружай ресурсы в фоновом режиме, пока текущая сцена работает
	if SceneManager.next_scene == "":
		scene_invalid(SceneManager.next_scene)
		return
	else:
		ResourceLoader.load_threaded_request(SceneManager.next_scene)
		if not ResourceLoader.exists(SceneManager.next_scene):
			scene_failed_to_load(SceneManager.next_scene)
			return
## Можно удалить, только для проверки
var iter: float = 0


func _process(_delta: float) -> void:
	if SceneManager.next_scene == "":
		# --Заполнитель, можно удалить--
		progress_bar.value = floor(clamp(_delta+iter, 0, 100))
		progress_number.text = str(floor(clamp(_delta+iter, 0, 100)))+"%"
		iter +=0.1
		# ------------------------------
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
## Если сцена загрузилась нормально
func scene_finished_loading(_scene_path: String) -> void:
	pass

## Включаем видимость этой сцены, если игра загружается дольше
func _on_timer_timeout() -> void:
	visible = true
