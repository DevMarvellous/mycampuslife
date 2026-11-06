extends Node

## Manages room transitions across campus hubs without loading entire world at once.
## Includes cinematic Danfo / Keke Napep driving transition animation for seamless campus travel.

signal room_changing(from_room: StringName, to_room: StringName)
signal room_loaded(room_name: StringName)

const TransitScreenScene = preload("res://scenes/transit_screen.tscn")
var transit_screen_instance: TransitScreen = null

const ROOM_PATHS: Dictionary = {
	&"admission": "res://scenes/admission_screen.tscn",
	&"courtyard": "res://scenes/main.tscn",
	&"hostel": "res://scenes/rooms/hostel_room.tscn",
	&"lecture": "res://scenes/rooms/lecture_hall.tscn",
	&"class": "res://scenes/rooms/lecture_hall.tscn",
	&"class2": "res://scenes/rooms/lecture_theatre_2.tscn",
	&"library": "res://scenes/rooms/library_hall.tscn",
	&"mama_put": "res://scenes/rooms/mama_put.tscn",
	&"buka": "res://scenes/rooms/mama_put.tscn",
	&"mall": "res://scenes/rooms/campus_mall.tscn",
	&"bistro": "res://scenes/rooms/campus_mall.tscn",
	&"stadium": "res://scenes/rooms/football_stadium.tscn",
	&"chapel": "res://scenes/rooms/chapel_hall.tscn",
	&"sub": "res://scenes/rooms/sub_building.tscn",
	&"market": "res://scenes/rooms/sub_building.tscn",
	&"garden": "res://scenes/rooms/campus_garden.tscn",
	&"salon": "res://scenes/rooms/barbing_salon.tscn",
	&"gate": "res://scenes/rooms/campus_gate.tscn",
	&"senate": "res://scenes/rooms/senate_building.tscn",
	&"convocation": "res://scenes/rooms/convocation_hall.tscn",
	&"tech_hub": "res://scenes/rooms/tech_hub.tscn"
}

const ROOM_NAMES: Dictionary = {
	&"admission": "Admissions Portal",
	&"courtyard": "Main Campus Quad & Courtyard",
	&"hostel": "Student Hostel (Hall 2 / Moremi)",
	&"lecture": "Faculty Lecture Theatre 1",
	&"class": "Faculty Lecture Theatre 1",
	&"class2": "Faculty Lecture Theatre 2",
	&"library": "Central University Library",
	&"mama_put": "Mama Put Food Canteen",
	&"buka": "Mama Put Food Canteen",
	&"mall": "Madam Kikelomo Campus Mall",
	&"bistro": "Madam Kikelomo Campus Mall",
	&"stadium": "Sports Stadium & Arena",
	&"chapel": "University Chapel Hall",
	&"sub": "Student Union Building (SUB)",
	&"market": "Student Union Building (SUB)",
	&"garden": "Campus Botanical Garden & Park",
	&"salon": "Executive Barber & Hair Salon",
	&"gate": "Main Campus Security Gate",
	&"senate": "Senate Administrative Building",
	&"convocation": "Great Hall of Convocation & Alumni Arena",
	&"tech_hub": "Silicon Lagoon Tech Hub & Wellness Clinic"
}

var current_room: StringName = &"admission"
var is_transitioning: bool = false
var _sanitize_timer: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if TransitScreenScene:
		transit_screen_instance = TransitScreenScene.instantiate() as TransitScreen
		add_child(transit_screen_instance)
	get_tree().node_added.connect(_on_node_added_clean_text)
	call_deferred("_sanitize_entire_tree")


func _process(delta: float) -> void:
	_sanitize_timer += delta
	if _sanitize_timer >= 1.20:
		_sanitize_timer = 0.0
		_sanitize_entire_tree()


static func _is_unsupported_codepoint(cp: int) -> bool:
	if cp >= 0x1F000 or cp == 0xFE0F or cp == 0x200D:
		return true
	if cp >= 0x2B00 and cp <= 0x2BFF:
		return true
	if cp >= 0x2300 and cp <= 0x23FF:
		return true
	if cp >= 0x2190 and cp <= 0x2193:
		return true
	if cp >= 0x2600 and cp <= 0x27BF:
		if cp == 0x2713 or cp == 0x2714 or cp == 0x2715 or cp == 0x2716 or cp == 0x2605 or cp == 0x2606 or cp == 0x2665 or cp == 0x266A or cp == 0x266B or cp == 0x2794:
			return false
		return true
	return false


## Replaces unsupported multi-color emojis (U+1F000..U+1FAFF) and Dingbats that render as missing-glyph
## tofu boxes (□) in Godot WebAssembly's built-in OpenSans font with 100%-supported symbols.
static func clean_godot_text(raw: String) -> String:
	if raw.is_empty():
		return raw
	var has_unsupported: bool = false
	for i in range(raw.length()):
		if _is_unsupported_codepoint(raw.unicode_at(i)):
			has_unsupported = true
			break
	if not has_unsupported:
		return raw

	var out: String = ""
	var prev_space: bool = false
	for i in range(raw.length()):
		var cp: int = raw.unicode_at(i)
		if cp == 0xFE0F or cp == 0x200D:
			continue
		if _is_unsupported_codepoint(cp):
			# Map key semantic emojis & arrows to crisp built-in symbols
			var rep: String = ""
			match cp:
				# Academic, Honours, Medals, Awards, Tech & High Status
				0x1F393, 0x1F3C6, 0x1F451, 0x1F48E, 0x26A1, 0x1F525, 0x2728, 0x2B50, 0x1F947, 0x1F31F, 0x1F396, 0x1F389, 0x1F381, 0x2726: rep = "★"
				# Direction, Shuttles, Roads, Targets & Pins
				0x1F4CD, 0x1F3AF, 0x1F68C, 0x1F695, 0x1F690, 0x1F696, 0x1F68F, 0x1F680, 0x1F6E3, 0x27A1, 0x2192, 0x1F4CC: rep = "➔"
				0x2B06, 0x2191: rep = "▲"
				0x2B07, 0x2193, 0x1F447: rep = "▼"
				0x2B05, 0x2190: rep = "◀"
				# Devices, Cards, Books, Documents & Study Material
				0x1F4F1, 0x1F4BB, 0x1F3E6, 0x1F4B3, 0x1F4DA, 0x1F4D6, 0x1F4D8, 0x1F4DD, 0x1F4CB, 0x1F4C4, 0x1F4DC, 0x1F4D1, 0x1F4CA, 0x1F4C5, 0x1F4C8, 0x1F5A5, 0x1F5A8, 0x1FAAA, 0x1F4BC, 0x1F4E6: rep = "■"
				# Circles, Indicators, Clock, Chat, Balls, Sparks & Sports
				0x1F7E2, 0x1F534, 0x1F7E1, 0x1F4AC, 0x23F0, 0x23F1, 0x23F3, 0x231B, 0x1F552, 0x26BD, 0x1F3B1, 0x1F4A1, 0x1F4A7, 0x1F4A4, 0x1F504, 0x1F4A8: rep = "●"
				# Buildings, Campus Landmarks, Nature, Food & Furniture
				0x1F3DB, 0x1F3EB, 0x1F3E0, 0x1F3E5, 0x1F3EA, 0x26EA, 0x271D, 0x1F54A, 0x1F33F, 0x1F333, 0x1F343, 0x1F372, 0x1F373, 0x1F37D, 0x1F371, 0x1F357, 0x1F356, 0x1F41F, 0x1F35A, 0x1F360, 0x1F963, 0x1F969, 0x1F35C, 0x1F35E, 0x1F956, 0x1F961, 0x1F95A, 0x1FAD4, 0x1F957, 0x1F34C, 0x1F964, 0x1F9C3, 0x2615, 0x1F9CA, 0x1F6CF, 0x1F6CB, 0x1FA91: rep = "◆"
				# Warnings, Alerts & Sirens
				0x26A0, 0x1F6A8, 0x1F198: rep = "!"
				# Checks & Success
				0x2705: rep = "✓"
				# Crosses, Errors & Exits
				0x274C, 0x2716, 0x2717: rep = "✕"
			if not rep.is_empty():
				out += rep
				prev_space = false
			continue
		var ch: String = raw[i]
		if ch == " " and prev_space:
			continue
		prev_space = (ch == " ")
		out += ch
	return out.strip_edges() if out.begins_with(" ") else out


func _on_node_added_clean_text(node: Node) -> void:
	_clean_single_node(node)
	if node is Control:
		var ctrl := node as Control
		if not ctrl.visibility_changed.is_connected(_on_control_visibility_changed.bind(ctrl)):
			ctrl.visibility_changed.connect(_on_control_visibility_changed.bind(ctrl))


func _on_control_visibility_changed(ctrl: Control) -> void:
	if is_instance_valid(ctrl) and ctrl.visible:
		_clean_node_recursive(ctrl)


func _sanitize_entire_tree() -> void:
	var root: Node = get_tree().current_scene
	if root:
		_clean_node_recursive(root)


func _clean_node_recursive(node: Node) -> void:
	if node is CanvasItem and not (node as CanvasItem).visible:
		return
	if node is CanvasLayer and not (node as CanvasLayer).visible:
		return
	_clean_single_node(node)
	if (node is MeshInstance3D or node is CollisionShape3D) and node.get_child_count() == 0:
		return
	for child in node.get_children():
		_clean_node_recursive(child)


func _clean_single_node(node: Node) -> void:
	if node is Label:
		var lbl := node as Label
		var cleaned := clean_godot_text(lbl.text)
		if cleaned != lbl.text:
			lbl.text = cleaned
	elif node is Button:
		var btn := node as Button
		var cleaned := clean_godot_text(btn.text)
		if cleaned != btn.text:
			btn.text = cleaned
		if btn is OptionButton:
			var opt := btn as OptionButton
			for idx in range(opt.item_count):
				var it_txt := opt.get_item_text(idx)
				var it_clean := clean_godot_text(it_txt)
				if it_clean != it_txt:
					opt.set_item_text(idx, it_clean)
	elif node is RichTextLabel:
		var rtl := node as RichTextLabel
		var cleaned := clean_godot_text(rtl.text)
		if cleaned != rtl.text:
			rtl.text = cleaned
	elif node is Label3D:
		var l3d := node as Label3D
		var cleaned := clean_godot_text(l3d.text)
		if cleaned != l3d.text:
			l3d.text = cleaned


func change_room(target_room: StringName, play_drive: bool = true) -> void:
	if not ROOM_PATHS.has(target_room):
		return

	var target_path: String = ROOM_PATHS[target_room]
	if current_room == target_room and get_tree().current_scene and get_tree().current_scene.scene_file_path == target_path:
		return

	var dest_name: String = ROOM_NAMES.get(target_room, String(target_room).capitalize())
	change_room_to_path(target_path, dest_name, target_room, play_drive)


func change_room_to_path(target_path: String, dest_name: String = "", target_room_id: StringName = &"", play_drive: bool = true) -> void:
	if is_transitioning:
		return

	# Deduce name if empty
	if dest_name.is_empty():
		for r_id in ROOM_PATHS.keys():
			if ROOM_PATHS[r_id] == target_path:
				dest_name = ROOM_NAMES.get(r_id, String(r_id).capitalize())
				if target_room_id == &"":
					target_room_id = r_id
				break
	if dest_name.is_empty():
		dest_name = "Campus Zone"

	is_transitioning = true
	var prev_room: StringName = current_room
	if target_room_id != &"":
		room_changing.emit(prev_room, target_room_id)

	if play_drive and is_instance_valid(transit_screen_instance):
		transit_screen_instance.play_drive_transition(
			dest_name,
			target_path,
			func() -> void:
				var err: Error = get_tree().change_scene_to_file(target_path)
				if err == OK:
					if target_room_id != &"":
						current_room = target_room_id
					room_loaded.emit(current_room)
				else:
					push_error("Failed to load room scene: %s (Error %d)" % [target_path, err])
		)
		await transit_screen_instance.transit_finished
		is_transitioning = false
	else:
		var err: Error = get_tree().change_scene_to_file(target_path)
		if err == OK:
			if target_room_id != &"":
				current_room = target_room_id
			room_loaded.emit(current_room)
		else:
			push_error("Failed to load room scene: %s (Error %d)" % [target_path, err])
		is_transitioning = false
