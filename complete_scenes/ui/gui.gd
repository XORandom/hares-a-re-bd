extends CanvasLayer

@export var lives: int = 5
@export var ammo: int = 13

@onready var life_h_box_container: HBoxContainer = $Control/Жизни/LifeHBoxContainer
@onready var ammo_h_box_container: HBoxContainer = $Control/Патроны/AmmoHBoxContainer

const LASER_TURRET = preload("uid://c4pk3fb211evf")
const BASE_TURRET = preload("uid://b5scy887qcf2e")


@export var LIFE: PackedScene = preload("uid://cl85lalhxqw5o")

func _ready() -> void:
	EventBus.player_health_updated.connect(add_hp)
	remove_child_lives()

func remove_child_lives() -> void:
	for child: Node in life_h_box_container.get_children():
		child.queue_free()

func remove_ammo() -> void:
	for child: Node in life_h_box_container.get_children():
		child.queue_free()

func add_hp(hp_count: int) -> void:
	remove_child_lives()
	var new_life = LIFE.instantiate()
	hp_count = clamp(hp_count, hp_count, lives)
	for hp: int in hp_count:
		life_h_box_container.add_child(new_life)


func add_ammo(ammo_count: int) -> void:
	remove_ammo()
	var new_life = LIFE.instantiate()
	ammo_count = clamp(ammo_count, ammo_count, ammo)
	for amm: int in ammo:
		life_h_box_container.add_child(new_life)


func _on_button_pressed() -> void:
	var lt = LASER_TURRET.instantiate()
	get_tree().root.add_child(lt)


func _on_button_2_pressed() -> void:
	var at = BASE_TURRET.instantiate()
	get_tree().root.add_child(at)
	pass # Replace with function body.
