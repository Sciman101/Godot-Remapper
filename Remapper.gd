extends Node

# Emitted when we successfully rebind an event
signal on_rebind_success(action,event)

# Define which types of actions we can rebind to
export var allow_keyboard : bool = true
export var allow_joypad : bool = true
export var allow_mouse_button : bool = true

var action_to_rebind := ""


func _ready() -> void:
	# Disable input processing
	set_process_input(false)


# Listen for actions to rebind
func _input(event:InputEvent) -> void:
	if action_to_rebind != "":
		# Check if this is a valid action
		var allow = (event is InputEventKey and allow_keyboard) or \
					(allow_joypad and (event is InputEventJoypadButton or event is InputEventJoypadMotion)) or \
					(allow_mouse_button and event is InputEventMouseButton)
		if allow:
			# Clear existing events and add new ones
			InputMap.action_erase_events(action_to_rebind)
			InputMap.action_add_event(action_to_rebind,event)
			emit_signal("on_rebind_success",action_to_rebind,event)
			# Clear target action
			action_to_rebind = ""
			set_process_input(false)


# Reset all inputs to their default
func reset_inputs() -> void:
	InputMap.load_from_globals()
	# Do this to reset button labels. Probably a more efficient way to do it
	get_tree().reload_current_scene()


# Call to start listening for a new action to rebind
# Returns true if we were able to start rebinding
func begin_rebind(action_name:String) -> bool:
	if action_to_rebind == "":
		# Make sure the action actually exists
		if InputMap.has_action(action_name):
			action_to_rebind = action_name
			set_process_input(true)
			return true
	return false


# Convert an inputevent to a human-readable string representing it
static func get_event_as_string(event:InputEvent) -> String:
	if event is InputEventKey:
		return OS.get_scancode_string(event.scancode)
	elif event is InputEventMouseButton:
		match event.button_index:
			1: return "LMB"
			2: return "RMB"
			3: return "MMB"
			_: return "Mouse Button " + str(event.button_index)
	elif event is InputEventJoypadButton:
		return Input.get_joy_button_string(event.button_index)
	elif event is InputEventJoypadMotion:
		return Input.get_joy_axis_string(event.axis) + ("+" if event.axis_value > 0 else "-")
	
	return "Unknown"
