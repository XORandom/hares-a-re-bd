extends BaseEntity
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var motion = Vector2()

func _ready() -> void:
	pass

func on_damage_taken(damage) -> void:
	queue_free()





func _physics_process(delta):

	position += (Globals.player_coords - position)/50
	#look_at(Globals.player_coords)

	move_and_collide(motion)
