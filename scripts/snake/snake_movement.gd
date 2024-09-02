extends Area2D

@export var parent_viewport_name = "ScreenSubViewport"
@export var speed: float = 2

const block_size = 4  # 4x4 pixels
const border = Vector4(0, 84, 8, 48)

var time_elapsed = 1
var direction: Vector2 = Vector2.RIGHT
var wrap_border: Vector4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wrap_border = border + Vector4(1, -1, 1, -1) * (block_size/2 + 1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if Input.is_action_pressed('up'):
		direction = Vector2.UP
	if Input.is_action_pressed('down'):
		direction = Vector2.DOWN
	if Input.is_action_pressed('left'):
		direction = Vector2.LEFT
	if Input.is_action_pressed('right'):
		direction = Vector2.RIGHT
	
	if time_elapsed >= 1 * 1/speed:
		time_elapsed = 0
		position += direction * block_size
		position = _wrap_position(position)
	else:
		time_elapsed += delta



func _wrap_position(pos: Vector2) -> Vector2:
	var pos_new = pos
	
	# left
	if pos.x < wrap_border.x:
		pos_new.x = wrap_border.y - 1
	#right
	if pos.x > wrap_border.y:
		pos_new.x = wrap_border.x + 1
	
	# top
	if pos.y < wrap_border.z + 1:
		pos_new.y = wrap_border.w - block_size/2 + 1
	# bottom
	if pos.y > wrap_border.w - 1:
		pos_new.y = wrap_border.z + block_size/2 
		
	return pos_new
		
