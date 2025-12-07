extends Control


## Путь к ледяному миру
@export_file("*.tscn") var ice_level_path : String = "uid://b2ptp60qptf3r"
@export_file("*.tscn") var water_level_path : String = "uid://b2ptp60qptf3r"
@export_file("*.tscn") var jungle_level_path : String = "uid://b2ptp60qptf3r"



@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2



func  _ready() -> void:
	animated_sprite_2d.play("default")
	animated_sprite_2d_2.play("default")
	animated_sprite_2d_2.set_frame_and_progress(2, 0.)


func _on_planet_card_jungle_pressed() -> void:
	SceneManager.call_deferred("change_scene", jungle_level_path)
	pass # Replace with function body.


func _on_planet_card_water_pressed() -> void:
	SceneManager.call_deferred("change_scene", water_level_path)
	pass # Replace with function body.


func _on_planet_card_ice_pressed() -> void:
	SceneManager.call_deferred("change_scene", ice_level_path)
	pass # Replace with function body.
