extends CanvasLayer

@export var lives: int = 5

@onready var life_h_box_container: HBoxContainer = $Control/Жизни/LifeHBoxContainer
@onready var ammo_h_box_container: HBoxContainer = $Control/Патроны/AmmoHBoxContainer


@export var LIFE: PackedScene = preload("uid://cl85lalhxqw5o")

func _ready() -> void:
	EventBus.player_health_updated.connect(add_hp)
	remove_child_lives()

func remove_child_lives() -> void:
	for child: Node in life_h_box_container.get_children():
		child.queue_free()


func add_hp(hp_count: int) -> void:
	var new_life = LIFE.instantiate()
	for hp: int in hp_count:
		life_h_box_container.add_child(new_life)
