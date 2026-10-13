extends CharacterBody3D

const SPEED = 4.0
@export var stamina_max := 100.0
var stamina := stamina_max

func _physics_process(delta):
	# Направление от клавиш в мировых осях (изометрия повернёт их визуально — ок)
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# Повернём направление на 45°, чтобы W двигал «вверх экрана» при изометрии
	var dir := input.rotated(-PI/4)
	var move := Vector3(dir.x, 0, dir.y) * SPEED

	if move.length() > 0 and stamina > 0:
		velocity.x = move.x
		velocity.z = move.z
		stamina -= delta * 5.0   # расход стамины при движении (GDD: бег тратит)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		stamina = min(stamina + delta * 10.0, stamina_max)  # реген

	move_and_slide()
