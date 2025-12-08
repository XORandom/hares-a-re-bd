extends Control


## Путь к ледяному миру
@export_file("*.tscn") var ice_level_path : String = "uid://b2ptp60qptf3r"
@export_file("*.tscn") var water_level_path : String = "uid://dgn5o863h2noa"
@export_file("*.tscn") var jungle_level_path : String = "uid://4fmnr3wtbm7s"



func  _ready() -> void:
	pass


func _on_planet_card_jungle_pressed() -> void:
	SceneManager.call_deferred("change_scene", jungle_level_path)
	pass # Replace with function body.


func _on_planet_card_water_pressed() -> void:
	SceneManager.call_deferred("change_scene", water_level_path)
	pass # Replace with function body.


func _on_planet_card_ice_pressed() -> void:
	SceneManager.call_deferred("change_scene", ice_level_path)
	pass # Replace with function body.
