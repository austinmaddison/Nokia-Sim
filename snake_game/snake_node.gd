class_name SnakeNode

extends Area2D

var direction: Vector2i = Vector2i.ZERO
var prev: SnakeNode = null
var next: SnakeNode = null

@onready var sprite: Texture2D = null:
	set(texture):
		sprite = texture
		$"Sprite2D".texture = sprite
