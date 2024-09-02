extends Node3D

var tween: Tween
var is_isolate_pixels = false
var width = 84
var height = 48

@onready var materials: Array[Material]

func _ready() -> void:
	for child in $".".get_children():
		print(child)
		materials.append(child.get_active_material(0))
	
	tween = get_tree().create_tween()
	
	_hide_substrate()
	_show_substrate()

func _input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		print(event)
		match event.instrument:
			20:
				tween = get_tree().create_tween()
				is_isolate_pixels = !is_isolate_pixels
				if(is_isolate_pixels): 
					_isolate_line(height/2 + 1) 
				else: 
					_show_pixels()
				#tween.free()


func _hide_substrate() -> void:
		var material : Material = $substrate.get_active_material(0)
		material.set_shader_parameter("cut", Vector4(84/2, 84/2, 48/2, 48/2))

func _show_substrate() -> void:
	#tween.set_trans(Tween.TRANS_CUBIC)
	#tween.set_ease(Tween.EASE_OUT)
	tween.tween_interval(2.0)
	tween.tween_property($substrate.get_active_material(0), "shader_parameter/cut", Vector4(0, width, height/2-1, height/2), 0.1 );
	tween.tween_property($substrate.get_active_material(0), "shader_parameter/cut", Vector4(0, width, 0, height), 1.0 );
	
func _show_pixels() -> void:
	for mat in materials:
		print(mat)
		tween.tween_property(mat, "shader_parameter/cut", Vector4(0, width, 0, height), 0.5 );
		tween.parallel()		
		

func _isolate_line(line: int) -> void:
	var region = Vector4(0, width, line-1, line)
	for mat in materials:
		tween.tween_property(mat, "shader_parameter/cut", region, 0.5 );
		tween.parallel()		
