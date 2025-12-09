extends Area2D



@onready var pickup_sound: AudioStreamPlayer2D = $PickupSound
@onready var sprite_2d: Sprite2D = $Sprite2D

func _on_body_entered(_body: Node2D) -> void:

	# таким образом объекты не маячат, пока звук их подбора проигрывается
	sprite_2d.visible = false
	Globals.score += 100

	if pickup_sound.finished:
		pickup_sound.play()
	await pickup_sound.finished
	queue_free()
