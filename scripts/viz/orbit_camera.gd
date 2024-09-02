extends Node3D

@onready var camera = $OrbitCameraPivot/Camera
@onready var pivot = $OrbitCameraPivot

@export var zoom_speed = 1
@export var orbit_speed = 1

var _zoom_speed :
	get: return zoom_speed * 0.1
	set(val): zoom_speed = val 

var _orbit_speed :
	get: return orbit_speed * 0.1
	set(val): orbit_speed = val 

func _ready() -> void:
	MidiController.knob_change.connect(_on_knob_changed)
	zoom_speed *= 0.001	
	orbit_speed *= 0.01	

func _on_knob_changed(knobs_delta):
	
	var rotation_delta = Vector3(knobs_delta[0], knobs_delta[1], 0) * _orbit_speed
	pivot.rotation_degrees = pivot.rotation_degrees + rotation_delta
	
	var position_delta = Vector3(0, 0, knobs_delta[2] * _zoom_speed) 
	camera.position = camera.position + position_delta
	
	
