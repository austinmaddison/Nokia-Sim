extends Node3D

var tween

func _ready() -> void:
	tween = get_tree().create_tween()
	_show_pixels()
	tween.chain()
	_isolate_pixels()

func _show_pixels() -> void:
	#tween.set_trans(Tween.TRANS_CUBIC)
	#tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($substrate.get_active_material(0), "shader_parameter/cut", Vector4(0, 84, 48, 0), 2.0 ).set_trans(Tween.TRANS_CUBIC);

func _isolate_pixels() -> void:
	#tween.set_trans(Tween.TRANS_CUBIC)
	#tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($substrate.get_active_material(0), "shader_parameter/cut", Vector4(0, 84, 12, 11), 2.0 ).set_trans(Tween.TRANS_CUBIC);
		
