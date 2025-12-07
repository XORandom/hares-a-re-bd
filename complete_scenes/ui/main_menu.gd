extends Control


## Куда игрок должен переходить, после нажатия кнопки играть
@export_file("*.tscn") var game_scene_path : String = "uid://dkar06pst402u"

@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer


func _on_start_pressed() -> void:
	await get_tree().create_timer(1).timeout
	var tween: Tween = create_tween()
	tween.tween_property(sub_viewport_container.get_material(), "shader_parameter/movement", 1., 1.0)
	#HACK это грязный метод. Я сначала начинаю загрузку уровня, но не перехожу

	SceneManager.change_scene_after_tween(game_scene_path)
	await tween.finished
	#HACK а после уже перехожу
	SceneManager.call_deferred("change_scene_instant")
	# Проблема в том, что я не вижу разницы в их работе
	#SceneManager.call_deferred("change_scene", game_scene_path)

func _on_settings_pressed() -> void:
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()
