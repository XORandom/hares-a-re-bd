extends Button

##
##
##


var last_mouse_pos: Vector2

var mouse_velocity: Vector2

var following_mouse: bool = false

var last_pos: Vector2

var velocity: Vector2

##
@onready var planet_anim: AnimatedSprite2D = $PlanetAnim
##
@onready var description: RichTextLabel = $Description

@onready var vircle: Control = $Vircle



#TODO чтобы двигать карточки мышкой
func follow_mouse(_delta: float) -> void:
	if not following_mouse: return
	var mouse_pos: Vector2 = get_global_mouse_position().floor()
	global_position = mouse_pos - (size/2.0)


func _on_mouse_entered() -> void:
	vircle.process_mode = Node.PROCESS_MODE_INHERIT
	planet_anim.play()

func _on_mouse_exited() -> void:
	vircle.process_mode = Node.PROCESS_MODE_DISABLED
	planet_anim.pause()



func _on_pressed() -> void:
	pass # Replace with function body.
