extends Node2D
func  _input(event: InputEvent) -> void:
	$ScreenSubViewport.push_input(event)
