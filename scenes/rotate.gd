extends Node3D

@export var speed = .5
var time = 0;

func _process(delta: float) -> void:
	time += delta
	$".".global_rotation_degrees = Vector3(90. + speed * cos(time) * 45, speed * sin(time) * 45, 0.)
