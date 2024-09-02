extends Node3D

@onready var rays = $OrbitRayPivot/CastRays
@onready var pivot = $OrbitRayPivot

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
	
	var rotation_delta = Vector3(knobs_delta[4], 0, knobs_delta[6]) * _orbit_speed
	pivot.rotation_degrees = pivot.rotation_degrees + rotation_delta
	
	var position_delta = Vector3(0, 0, knobs_delta[7] * _zoom_speed) 
	rays.position = rays.position + position_delta


func _input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		print(event)
		match event.instrument:
			22:
				$".".visible = !$".".visible
				


	
