extends Node3D

@export var speed = .5
@export var strength = .5
@export var rot_x = false
@export var rot_y = false

var time = 0;

@onready var x = $".".global_rotation_degrees.x
@onready var y = $".".global_rotation_degrees.y

func _process(delta: float) -> void:
	time += delta
	
	if rot_x:
		x = 90. +  strength * cos(speed * time) * 45
	
	if rot_y:
		y = strength * sin(speed * time) * 120
		
	$".".global_rotation_degrees = Vector3(x, y, 0.)
