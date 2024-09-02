extends Node3D

@export var speed = 1.0

func _process(delta: float) -> void:
	$".".rotate_y(1.0 * delta)
