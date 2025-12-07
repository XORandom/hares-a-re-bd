extends Control




@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2



func  _ready() -> void:
	animated_sprite_2d.play("default")
	animated_sprite_2d_2.play("default")
	animated_sprite_2d_2.set_frame_and_progress(2, 0.)


func _on_planet_card_jungle_pressed() -> void:
	pass # Replace with function body.


func _on_planet_card_water_pressed() -> void:
	pass # Replace with function body.


func _on_planet_card_ice_pressed() -> void:
	pass # Replace with function body.
