#extends Area2D
#
#@export var speed: float = 2
#
#const block_size = 4  # 4x4 pixels
#const border = Vector4(0, 84, 8, 48)
#
#var time_elapsed = 1
#var direction: Vector2 = Vector2.RIGHT
#@export var wrap_border: Vector4 = Vector4(1+1, 9-2, 83-1, 47-2) # left, top, right, bottom
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#wrap_border = border + Vector4(1, -1, 1, -1) * (block_size/2 + 1)
	#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#
	#if time_elapsed >= 1 * 1/speed:
		#time_elapsed = 0
		#position += direction * block_size
		#position = _wrap_position(position)
	#else:
		#time_elapsed += delta
#
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed('up'):
		#direction = Vector2.UP
	#if event.is_action_pressed('down'):
		#direction = Vector2.DOWN
	#if event.is_action_pressed('left'):
		#direction = Vector2.LEFT
	#if event.is_action_pressed('right'):
		#direction = Vector2.RIGHT
	#
