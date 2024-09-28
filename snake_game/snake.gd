class_name Snake extends Node2D

signal toggle_pause_update
signal update_once
signal ate_food

@export var snake_node_scene: PackedScene
@export var start_length: int = 5 
@export var tail_direction: Vector2 = Vector2.LEFT

@export var speed: float = 0.5:
	set(new_speed):
		speed = new_speed

const snake_node_size = 4  # 4px
const border = Vector4(0, 84, 8, 48)

var head : Area2D
var tail : Area2D

var direction: Vector2 = tail_direction * -1
var queued_direction = direction
var update_timer: Timer
@export var wrap_border: Vector4 = Vector4(1+1, 9-2, 83-1, 33) # left, top, right, bottom

var is_infront_food = false
var is_full: bool = false

func _ready() -> void:
	toggle_pause_update.connect(func(): update_timer.paused = !update_timer.paused)
	update_once.connect(_update)
	
	update_timer = Timer.new()
	add_sibling.call_deferred(update_timer)
	update_timer.autostart = true
	update_timer.timeout.connect(_update)
	_update_speed(speed)
	
	_create_snake()
	

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_0):
		toggle_pause_update.emit()
	if Input.is_key_pressed(KEY_1):
		update_once.emit()


func _update_speed(speed):
	update_timer.wait_time = 1/speed

func _create_snake():
	head = snake_node_scene.instantiate()
	head.name = "Head"
	head.direction = direction
	
	_recursivley_create_snake_helper(head, start_length)
	_recursivley_update_nodes_sprite_helper(head)
	_recursivley_update_add_scene(head)
	
func _recursivley_create_snake_helper(node, n: int):
	if n <= 0:
		node.name = "Tail"
		tail = node
		return
	
	node.next = snake_node_scene.instantiate()
	node.next.name = "Body%d" % (start_length-n)
	node.next.prev = node
	node.next.position = node.position + tail_direction * snake_node_size
	node.next.direction = direction
	_recursivley_create_snake_helper(node.next, n-1)

func _update():
	_update_direction()
	_recursivley_update_nodes()

func _update_direction():
	if(queued_direction != direction * -1):
		direction = queued_direction
	
func _recursivley_update_nodes():
	_recursivley_update_nodes_position_helper(head)
	var new_pos = head.global_position + direction * snake_node_size
	head.global_position = _wrap_position(head.global_position + direction * snake_node_size)
	print("POS:", head.position)
	head.direction = direction
	_recursivley_update_nodes_sprite_helper(tail)

func _recursivley_update_nodes_position_helper(node):
	if node.next == null:
		return
	_recursivley_update_nodes_position_helper(node.next)
	node.next.position = node.position 
	node.next.direction = node.direction

func _recursivley_update_nodes_sprite_helper(node):
	if node == null: 
		return
	node.sprite = _get_sprite(node)
	_recursivley_update_nodes_sprite_helper(node.prev)

func _recursivley_update_add_scene(node):
	if node == null: 
		return
	add_child(node)
	_recursivley_update_add_scene(node.next)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('up'): 	 queued_direction = Vector2.UP 
	if event.is_action_pressed('down'):  queued_direction = Vector2.DOWN
	if event.is_action_pressed('left'):  queued_direction = Vector2.LEFT
	if event.is_action_pressed('right'): queued_direction = Vector2.RIGHT
	
func _wrap_position(pos: Vector2) -> Vector2:
	var pos_new = pos
	var x_start = wrap_border.x
	var x_end = wrap_border.z
	var y_start = wrap_border.y
	var y_end = wrap_border.w
	
	# left
	if pos.x < x_start:
		pos_new.x = x_end - 1
	#right
	if pos.x >= x_end:
		pos_new.x = x_start
	# top
	if pos.y < y_start + 2:
		pos_new.y = y_end - 4
	# bottom
	if pos.y >= y_end - 1:
		pos_new.y = y_start + 4
		
	return pos_new
	

func _get_sprite(node):
	if node.prev == null: # is head
		if is_infront_food:
			match node.direction:
				Vector2i.LEFT:	return load("res://snake_game/snake/headopenl.png")
				Vector2i.RIGHT:	return load("res://snake_game/snake/headopenr.png")
				Vector2i.UP:	return load("res://snake_game/snake/headopenu.png")
				Vector2i.DOWN:	return load("res://snake_game/snake/headopend.png")
		else:
			match node.direction:
				Vector2i.LEFT:	return load("res://snake_game/snake/headl.png")
				Vector2i.RIGHT:	return load("res://snake_game/snake/headr.png")
				Vector2i.UP:	return load("res://snake_game/snake/headu.png")
				Vector2i.DOWN:	return load("res://snake_game/snake/headd.png")
		return
	
	if node.next == null: # is tail
		match node.prev.direction:
			Vector2i.LEFT: 	return load("res://snake_game/snake/taill.png")
			Vector2i.RIGHT: return load("res://snake_game/snake/tailr.png")
			Vector2i.UP: 	return load("res://snake_game/snake/tailu.png")
			Vector2i.DOWN: 	return load("res://snake_game/snake/taild.png")
		return
	
	if node.direction == node.prev.direction: # is body 
		if is_full:
			match node.direction:
				Vector2i.LEFT: 	return load("res://snake_game/snake/bodyfulll.png")
				Vector2i.RIGHT: return load("res://snake_game/snake/bodyfullr.png")
				Vector2i.UP: 	return load("res://snake_game/snake/bodyfullu.png")
				Vector2i.DOWN: 	return load("res://snake_game/snake/bodyfulld.png")
		else:
			match node.direction:
				Vector2i.LEFT: 	return load("res://snake_game/snake/bodyl.png")
				Vector2i.RIGHT: return load("res://snake_game/snake/bodyr.png")
				Vector2i.UP: 	return load("res://snake_game/snake/bodyu.png")
				Vector2i.DOWN: 	return load("res://snake_game/snake/bodyd.png")
		return
	
	if is_full: # is turn
		match node.direction:
			Vector2i.LEFT: 	
				match node.prev.direction:
					Vector2i.UP: 	return load("res://snake_game/snake/turnfull2.png")
					Vector2i.DOWN: 	return load("res://snake_game/snake/turnfull0.png")	
			Vector2i.RIGHT: 
				match node.prev.direction:
					Vector2i.UP: 	return load("res://snake_game/snake/turnfull3.png")
					Vector2i.DOWN: 	return load("res://snake_game/snake/turnfull1.png")	
					
			Vector2i.UP: 	
				match node.prev.direction:
					Vector2i.LEFT: 	return load("res://snake_game/snake/turnfull1.png")
					Vector2i.RIGHT: return load("res://snake_game/snake/turnfull0.png")
					
			Vector2i.DOWN: 	
				match node.prev.direction:
					Vector2i.LEFT: 	return load("res://snake_game/snake/turnfull3.png")
					Vector2i.RIGHT: return load("res://snake_game/snake/turnfull2.png")
	else:
		match node.direction:
			Vector2i.LEFT: 	
				match node.prev.direction:
					Vector2i.UP: 	return load("res://snake_game/snake/turn2.png")
					Vector2i.DOWN: 	return load("res://snake_game/snake/turn0.png")	
			Vector2i.RIGHT: 
				match node.prev.direction:
					Vector2i.UP: 	return load("res://snake_game/snake/turn3.png")
					Vector2i.DOWN: 	return load("res://snake_game/snake/turn1.png")	
					
			Vector2i.UP: 	
				match node.prev.direction:
					Vector2i.LEFT: 	return load("res://snake_game/snake/turn1.png")
					Vector2i.RIGHT: return load("res://snake_game/snake/turn0.png")
					
			Vector2i.DOWN: 	
				match node.prev.direction:
					Vector2i.LEFT: 	return load("res://snake_game/snake/turn3.png")
					Vector2i.RIGHT: return load("res://snake_game/snake/turn2.png")
			
