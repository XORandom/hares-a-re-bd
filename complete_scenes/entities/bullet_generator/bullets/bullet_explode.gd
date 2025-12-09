extends BulletBase

## Взрывная пуля
##
## Пролетая мимо, запоминает всех,
## кто входит и выходит в зону ее атаки[br]
## При взрыве задевает всех, кто в этой зоне остался


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

## Взорвался ли снаряд
var was_explode := false
## Список пораженных обьектов
var exploded_list: Array[Node2D] = []




func explode() -> void:

	was_explode = true
	sprite_2d.visible = false
	animated_sprite_2d.show()
	animated_sprite_2d.play("explosion")
	for body: Node2D in exploded_list:
		body.call_deferred("_on_get_hit", damage*0.2)


func _on_splash_area_body_entered(body: Node2D) -> void:
	exploded_list.append(body)


func _on_splash_area_body_exited(body: Node2D) -> void:
	exploded_list.remove_at(exploded_list.find(body))


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	#if body is Crate:
		#body.call_deferred("_on_get_hit", damage*0.8)
	#explode()
	pass
