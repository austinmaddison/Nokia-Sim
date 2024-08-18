extends Node

var knobs_value: Array[int]
var knobs_delta: Array[float]
var knobs_start = 16
var knobs_number = 8

signal knob_change(knobs_delta)

func _ready():
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	
	knobs_value.resize(knobs_number)
	knobs_value.fill(0)
	
	knobs_delta.resize(knobs_number)
	knobs_delta.fill(0.0)

func _input(input_event):
	if input_event is InputEventMIDI:
		#_print_midi_info(input_event)
		_update_midi_input(input_event)
	
func _process(delta: float) -> void:
	_update_knob_delta(delta)

func _update_knob_delta(delta: float) -> void:
	
	var is_changed = false 
	for i in range(knobs_value.size()):
		knobs_delta[i] = knobs_value[i] / delta
		is_changed = is_changed or knobs_value[i] != 0
		
		# Reset
		knobs_value[i] = 0

	if is_changed:
		knob_change.emit(knobs_delta)
	#print_debug(delta)
	#print_debug(knobs_delta)


func _is_knob(midi_event) -> bool:
	return midi_event.controller_number >= knobs_start and midi_event.controller_number < (knobs_start + knobs_value.size())

func _update_midi_input(midi_event):
	#print(midi_event)
	if _is_knob(midi_event):
		knobs_value[midi_event.controller_number - knobs_start] += 1 if midi_event.controller_value == 1 else -1
		#print("knob changed")
	#print_debug(knobs_value)

func _print_midi_info(midi_event):
	print(midi_event)
	print("Channel ", midi_event.channel)
	print("Message ", midi_event.message)
	print("Pitch ", midi_event.pitch)
	print("Velocity ", midi_event.velocity)
	print("Instrument ", midi_event.instrument)
	print("Pressure ", midi_event.pressure)
	print("Controller number: ", midi_event.controller_number)
	print("Controller value: ", midi_event.controller_value)
