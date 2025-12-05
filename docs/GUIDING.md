## Путеводные заметки
Сборник заметок, объясняющий (в первую очередь для меня самого),
почему я решил принять те или иные решения

## Направления вращения
`get_angle_to(get_global_mouse_position())`
			-1,5
-3 или 3	  @			0
			 1.5

`get_local_mouse_position().normalized()`
			 0,-1
-1,0		  @			1,0
			 0,1

То, что не надо в релизе
```GSCript
if not Engine.is_editor_hint():
```