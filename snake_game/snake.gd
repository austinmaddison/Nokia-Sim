class_name Snake extends Node2D

@export var snake_node_scene: PackedScene
@export var start_length: int = 5 
@export var tail_direction: Vector2 = Vector2.LEFT

@export var speed: float = 2:
	set(new_speed):
		speed = new_speed


const snake_node_size = 4  # 4px
const border = Vector4(0, 84, 8, 48)

var head
var tail

var direction: Vector2 = tail_direction * -1
var queued_direction = direction
var update_timer: Timer
var wrap_border: Vector4

var is_infront_food = false
var is_full: bool = false

func _ready() -> void:
	update_timer = Timer.new()
	add_sibling.call_deferred(update_timer)
	update_timer.autostart = true
	update_timer.timeout.connect(_update)
	_update_speed(speed)
	
	_create_snake()

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
	head.position += direction * snake_node_size
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
	
	## left
	#if pos.x < wrap_border.x:
		#pos_new.x = wrap_border.y - 1
	##right
	#if pos.x > wrap_border.y:
		#pos_new.x = wrap_border.x + 1
	#
	## top
	#if pos.y < wrap_border.z + 1:
		#pos_new.y = wrap_border.w - snake_node_size/2 + 1
	## bottom
	#if pos.y > wrap_border.w - 1:
		#pos_new.y = wrap_border.z + snake_node_size/2 
		
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
			
