extends Node

var hold_time := 0.0
const HOLD_DURATION := 1.9
var label: Label

func _ready() -> void:
	create_countdown()
	add_reload_action()

func _process(delta: float) -> void:
	if Input.is_action_pressed("reload") and Util.get_player():
		hold_time += delta
		var remaining = HOLD_DURATION - hold_time
		label.text = "Resetting in %.1f..." % max(remaining, 0)
		
		if hold_time >= HOLD_DURATION:
			reload()
			clear()
	else:
		clear()

func clear() -> void:
	hold_time = 0.0
	if label:
		label.text = ""

func add_reload_action() -> void:
	var action_name = "reload"
	var key_event := InputEventKey.new()
	key_event.keycode = KEY_R
	
	# prevent dupes
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	
	InputMap.action_erase_events(action_name) # remove old
	InputMap.action_add_event(action_name, key_event)

func create_countdown() -> void:
	var font = load("res://fonts/impress-bt.ttf") as Font
	
	label = Label.new()
	
	# styling
	label.add_theme_color_override("font_color", Color.DARK_RED)
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", 28)
	
	# mimic timer settings
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.5))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	label.add_theme_constant_override("shadow_size", 6)
	
	# placement (below timer)
	label.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	label.offset_top = 28
	label.offset_left = 7
	
	label.text = ""
	add_child(label)
	label.show()


func reload() -> void:
	if SceneLoader and Util.get_player():
		Util.on_player_died()
		
		var lose_menu = get_node("/root/Util/LoseMenu/")
		if lose_menu:
			lose_menu.play_again()