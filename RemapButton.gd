extends Button

onready var remapper = $"../../.."

export var action_name : String

func _ready() -> void:
	text = remapper.get_event_as_string(InputMap.get_action_list(action_name)[0])

# When button is pressed...
func _pressed() -> void:
	if remapper.begin_rebind(action_name):
		text = "Enter action"
		remapper.connect("on_rebind_success",self,"_on_remap_complete",[],CONNECT_ONESHOT)

# When a new action has been successfuly bound
func _on_remap_complete(action, event):
	text = remapper.get_event_as_string(event)
