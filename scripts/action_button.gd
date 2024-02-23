extends Button

@export var action : String = "ui_up"

const keymap_path = "./keymap.txt"
var keymaps: Dictionary

func _ready() -> void:
	set_process_unhandled_key_input(false)
	toggled.connect(_on_toggled)
	text = "%s" % OS.get_keycode_string(InputMap.action_get_events(action)[0].keycode)
	load_data()


func _on_toggled(toggled_on: bool) -> void:
	set_process_unhandled_key_input(toggled_on)
	if toggled_on:
		text = ".."
	else:
		text = "%s" % OS.get_keycode_string(InputMap.action_get_events(action)[0].keycode)
		

func _unhandled_key_input(event: InputEvent) -> void:
	button_pressed = false
	InputMap.action_get_events(action)[0].keycode = event.keycode
	text = "%s" % OS.get_keycode_string(event.keycode)
	set_process_unhandled_key_input(false)
	
	if FileAccess.file_exists(keymap_path):
		var file = FileAccess.open(keymap_path, FileAccess.READ)
		keymaps = file.get_var(true) as Dictionary
		file.close()
	
	keymaps[action] = event
	save_data()

func save_data() -> void:
	var file = FileAccess.open(keymap_path, FileAccess.WRITE)
	file.store_var(keymaps,true)
	file.close()

func load_data() -> void:
	if not FileAccess.file_exists(keymap_path):
		return
	
	var file = FileAccess.open(keymap_path, FileAccess.READ)
	var temp_keymaps = file.get_var(true) as Dictionary
	file.close()
	
	for element in temp_keymaps:
		if element == action:
			InputMap.action_get_events(element)[0].keycode = temp_keymaps[element].keycode
			text = "%s" % OS.get_keycode_string(temp_keymaps[element].keycode)
