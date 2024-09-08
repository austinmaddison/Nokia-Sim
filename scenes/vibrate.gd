extends Camera3D

@export var position_strength: Vector3 = Vector3.ZERO
@export var position_frequency: Vector3 = Vector3.ONE
@export var position_seed: Vector3
@export var position_noise: FastNoiseLite 

@export var rotation_strength: Vector3 = Vector3.ZERO
@export var rotation_frequency: Vector3 = Vector3.ONE
@export var rotation_seed: Vector3
@export var rotation_noise: FastNoiseLite 

@onready var _root_position = position
@onready var _root_rotation = rotation_degrees

var _time = 0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	position_seed = Vector3(randf(), randf(), randf()) * 1000.0
	rotation_seed = Vector3(randf(), randf(), randf()) * 1000.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time += delta
	
	var position_noise_sample = Vector3(position_noise.get_noise_2d(_time * position_frequency.x, position_seed.x), position_noise.get_noise_2d(_time * position_frequency.y, position_seed.y), position_noise.get_noise_2d(_time * position_frequency.z, position_seed.z)) 
	var rotation_noise_sample = Vector3(rotation_noise.get_noise_2d(_time * rotation_frequency.x, rotation_seed.x), rotation_noise.get_noise_2d(_time * rotation_frequency.y, rotation_seed.y), rotation_noise.get_noise_2d(_time * rotation_frequency.z, rotation_seed.z)) 

	position = _root_position + position_noise_sample * position_strength
	rotation = _root_rotation + rotation_noise_sample * rotation_strength
	
