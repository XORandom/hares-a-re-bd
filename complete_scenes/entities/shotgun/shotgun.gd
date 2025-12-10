extends Node2D


@onready var muzzle: Marker2D = $Muzzle
@onready var polygon_2d: Polygon2D = $Polygon2D


func _physics_process(delta: float) -> void:
	#DebugPanel.show_debug_info(["rotation", rotation], 7)
	#DebugPanel.show_debug_info(["rotation_degrees", rotation_degrees], 8)
	look_at(get_global_mouse_position())
