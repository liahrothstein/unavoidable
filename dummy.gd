extends StaticBody3D

var hp := 30.0

func take_hit(dmg: float):
	hp -= dmg
	print("Dummy HP: ", hp, " (hit)")
	var mesh: MeshInstance3D = $MeshInstance3D
	var mat: StandardMaterial3D
	if mesh.material_override:
		mat = mesh.material_override
	else:
		mat = StandardMaterial3D.new()
		mesh.material_override = mat
	mat.albedo_color = Color(1.0, 0.1, 0.1)          # яркий красный
	print("flash ON")
	await get_tree().create_timer(0.3).timeout       # 0.3 — заметно глазу
	print("flash OFF")
	mat.albedo_color = Color(0.6, 0.6, 0.65)
	if hp <= 0:
		print("Dummy destroyed")
		queue_free()
