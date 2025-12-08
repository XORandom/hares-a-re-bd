extends Node2D

## Создание ветра с помощью частиц

##
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gpu_particles_2d.emitting = true
