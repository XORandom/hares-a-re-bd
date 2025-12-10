class_name ParticleBulletStrategy
extends BaseBulletStrategy

## Модуль добавляющий частицы к пуле
##
##

## Сцена с частицами
@export var particle_scene: PackedScene
## Слой на котором будут частицы
@export var particles_z_layer: int = 0

## Применение обновлений
func apply_upgrade(bullet: BulletBase) -> void:
	var spawned_particles: Node2D = particle_scene.instantiate()
	## Эффект добавляется как дочерний элемент к пуле
	bullet.add_child(spawned_particles)
	spawned_particles.global_position = bullet.global_position
	spawned_particles.global_rotation = bullet.global_rotation
	spawned_particles.z_index = particles_z_layer
