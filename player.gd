extends CharacterBody3D

const SPEED = 4.0
@export var stamina_max := 100.0
var stamina := stamina_max

@onready var camera: Camera3D = get_viewport().get_camera_3d()

@onready var hitbox: Area3D = $Hitbox
var attack_cooldown := 0.0

const LIGHT_COST := 15.0
const HEAVY_COST := 30.0
const LIGHT_DMG := 8.0
const HEAVY_DMG := 20.0

# Точка на земле (y=0), куда смотрит курсор
func _cursor_ground_point() -> Vector3:
	var mouse := get_viewport().get_mouse_position()
	var origin := camera.project_ray_origin(mouse)
	var dir := camera.project_ray_normal(mouse)
	var plane := Plane(Vector3.UP, 0.0)   # земля y=0
	var hit = plane.intersects_ray(origin, dir)
	return hit if hit != null else global_position
	
func _attack(dmg: float, cost: float):
	if stamina < cost:
		print("Not enough stamina")
		return
	stamina -= cost
	attack_cooldown = 0.5
	hitbox.monitoring = true
	await get_tree().create_timer(0.12).timeout   # окно удара 120 мс
	for body in hitbox.get_overlapping_bodies():
		if body.has_method("take_hit"):
			body.take_hit(dmg)
	hitbox.monitoring = false

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
	
	attack_cooldown = max(attack_cooldown - delta, 0.0)
	if attack_cooldown == 0.0:
		if Input.is_action_just_pressed("attack_light"):
			_attack(LIGHT_DMG, LIGHT_COST)
		elif Input.is_action_just_pressed("attack_heavy"):
			_attack(HEAVY_DMG, HEAVY_COST)

	move_and_slide()
