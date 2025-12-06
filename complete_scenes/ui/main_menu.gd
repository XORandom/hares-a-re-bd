extends Control


## Куда игрок должен переходить, после нажатия кнопки играть
@export_file("*.tscn") var game_scene_path : String = ""


func _on_start_pressed() -> void:
	SceneManager.call_deferred("change_scene", game_scene_path)
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
