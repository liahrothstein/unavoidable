extends CharacterBody3D

const SPEED = 4.0
@export var stamina_max := 100.0
var stamina := stamina_max

@onready var camera: Camera3D = get_viewport().get_camera_3d()

# Точка на земле (y=0), куда смотрит курсор
func _cursor_ground_point() -> Vector3:
	var mouse := get_viewport().get_mouse_position()
	var origin := camera.project_ray_origin(mouse)
	var dir := camera.project_ray_normal(mouse)
	var plane := Plane(Vector3.UP, 0.0)   # земля y=0
	var hit = plane.intersects_ray(origin, dir)
	return hit if hit != null else global_position

func _physics_process(delta):
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var dir := input.rotated(-PI/4)
	var move := Vector3(dir.x, 0, dir.y) * SPEED

	if move.length() > 0 and stamina > 0:
		velocity.x = move.x
		velocity.z = move.z
		stamina -= delta * 5.0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		stamina = min(stamina + delta * 10.0, stamina_max)

	# ПОВОРОТ К КУРСОРУ (главная добавка)
	var target := _cursor_ground_point()
	var look := target - global_position
	look.y = 0
	if look.length() > 0.1:
		global_rotation.y = atan2(look.x, look.z)

	move_and_slide()
