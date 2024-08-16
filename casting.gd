extends Node3D

@export var collision_point_mesh: Mesh
@export var collision_point_mesh_radius: float = 0.05
@export var angle: float = 180
@export var rays: float
@export var target_length: float = 1000.0

var raycasts: Array[RayCast3D]
var collision_points: Array[MeshInstance3D]
var lines: Array
@export var color: Color

func _ready():

	var material := ORMMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	var step = angle/rays
	var theta_0 = 270
	for theta in range(theta_0 - angle/2, theta_0 + angle/2 + step, step):
		
		# rays
		print(theta)
		var ray = RayCast3D.new()
		ray.target_position = Vector3(cos(deg_to_rad(theta)), sin(deg_to_rad(theta)), 0.0) * target_length
		raycasts.append(ray)
		add_child(ray)
		
		# points
		var collision_point = MeshInstance3D.new()
		collision_point.scale_object_local(Vector3.ONE * collision_point_mesh_radius) 
		collision_point.mesh = collision_point_mesh
		collision_point.material_override = material
		collision_point.visible = false
		
		collision_points.append(collision_point)
		add_child(collision_point)
		
		# lines
		var line = MeshInstance3D.new()
		var line_imm = ImmediateMesh.new()

		line.mesh = line_imm
		line.material_override= material
		line.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		
		line_imm.surface_begin(Mesh.PRIMITIVE_LINES, material)
		line_imm.surface_add_vertex(Vector3.ZERO)
		line_imm.surface_add_vertex(ray.target_position)
		line_imm.surface_end()
		add_child(line)
		
		lines.append(line)
		
func _update_line(line: MeshInstance3D, p: Vector3) -> void:
		var line_imm = line.mesh as ImmediateMesh
		line_imm.clear_surfaces()
		line_imm.surface_begin(Mesh.PRIMITIVE_LINES)
		line_imm.surface_add_vertex(Vector3.ZERO)
		line_imm.surface_add_vertex(p)
		line_imm.surface_end()
	
func _physics_process(delta: float) -> void:
	for i in raycasts.size():
		
		var ray = raycasts[i]
		var collision_point = collision_points[i]
		var line = lines[i]
		
		if !ray.is_colliding():
			collision_point.visible = false
			_update_line(line, ray.target_position)
			continue; 
		
		# update collisions point pos
		var cp = to_local(ray.get_collision_point())
		collision_point.position = cp
		collision_point.visible = true
		
		# update delete and create new line
		_update_line(line, cp)
	
		
		
		
		

	
