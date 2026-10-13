extends Camera3D

@export var target_path: NodePath
@export var offset := Vector3(6.0, 8.0, 6.0)   # ваша изометрия (крутите)

func _ready():
	# Наводимся сразу при старте, чтобы не было «прыжка»
	_snap()

func _process(_delta):
	_follow()

func _snap():
	var target := get_node_or_null(target_path) as Node3D
	if target == null: return
	global_position = target.global_position + offset
	look_at(target.global_position + Vector3(0, 1, 0), Vector3.UP)

func _follow():
	var target := get_node_or_null(target_path) as Node3D
	if target == null: return
	var desired := target.global_position + offset
	global_position = global_position.lerp(desired, 0.15)   # сглаживание
	look_at(target.global_position + Vector3(0, 1, 0), Vector3.UP)
