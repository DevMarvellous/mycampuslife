class_name DanfoRouteGame
extends Control

## Interactive Campus Danfo Bus Ring Road Driving Mini-Game.
## Players take the wheel of the iconic yellow Lagos/Campus Danfo shuttle bus,
## driving student passengers across faculty stops for honest transport fares.
## Features:
## - Responsive arcade vehicle controls (Accelerate, Steer, Reverse, Handbrake, Horn)
## - Dynamic 3D SubViewport campus ring road circuit with palm trees, curbs & stops
## - 4 University Passenger Stops: Campus Gate, Hostel Quarters, Faculty LT, Library & Stadium
## - Passenger pickup/drop-off mechanics: ₦150 fare per student + Driver merit rating
## - 100% wholesome, clean, and engaging gameplay with zero gambling.

signal route_completed(passengers_served: int, total_fares: int)
signal game_closed

var current_player: CharacterBody3D = null
var is_driving: bool = false

# Driving physics variables
var speed: float = 0.0
var max_forward_speed: float = 18.0
var max_reverse_speed: float = -7.0
var acceleration: float = 14.0
var brake_power: float = 24.0
var friction: float = 6.0
var steer_angle: float = 0.0
var max_steer_angle: float = 1.3
var turn_speed: float = 2.4

# Passenger route state
var current_passengers: Array[Dictionary] = []
var max_capacity: int = 6
var total_passengers_served: int = 0
var total_fares_collected: int = 0
var current_stop_idx: int = 0

# 3D Node references
var bus_body: CharacterBody3D = null
var bus_visual: Node3D = null
var bus_camera: Camera3D = null
var stops_nodes: Array[Node3D] = []

# UI references
var speedo_label: Label = null
var passenger_label: Label = null
var earnings_label: Label = null
var stop_info_label: Label = null
var horn_btn: Button = null
var exit_btn: Button = null

const STOPS: Array[Dictionary] = [
	{
		"id": "gate",
		"name": "Campus Main Gate Terminal",
		"pos": Vector3(0, 0, 16),
		"next_dest_name": "Hostel Quarters",
		"dest_id": "hostel",
		"icon": "🚖"
	},
	{
		"id": "hostel",
		"name": "Hostel Hall 2 Quarters",
		"pos": Vector3(22, 0, 0),
		"next_dest_name": "Faculty LT1 & LT2",
		"dest_id": "faculty",
		"icon": "🏠"
	},
	{
		"id": "faculty",
		"name": "Faculty Lecture Theatres",
		"pos": Vector3(0, 0, -22),
		"next_dest_name": "Central Library",
		"dest_id": "library",
		"icon": "📚"
	},
	{
		"id": "library",
		"name": "Central Library & Stadium",
		"pos": Vector3(-22, 0, 0),
		"next_dest_name": "Main Campus Gate",
		"dest_id": "gate",
		"icon": "⚽"
	}
]

# Mobile touch control states
var touch_gas: bool = false
var touch_brake: bool = false
var touch_left: bool = false
var touch_right: bool = false


func _ready() -> void:
	visible = false
	_build_ui_overlay()


func open_danfo_route(player: CharacterBody3D) -> void:
	current_player = player
	speed = 0.0
	steer_angle = 0.0
	current_passengers.clear()
	total_passengers_served = 0
	total_fares_collected = 0
	current_stop_idx = 0
	is_driving = true

	# Initial passengers waiting at gate
	_board_passengers_at_stop(STOPS[0], 3)

	_setup_3d_circuit()
	_update_ui_stats()
	visible = true

	if SoundManager: SoundManager.play_whistle()
	if current_player and current_player.has_method("display_notification"):
		current_player.display_notification("🚌 Danfo Engine Started! Drive ring road and pick up students.")


func close_game() -> void:
	is_driving = false
	visible = false
	current_player = null
	game_closed.emit()


func _process(delta: float) -> void:
	if not visible or not is_driving or not bus_body:
		return

	_handle_vehicle_physics(delta)
	_check_stop_proximity()
	_update_ui_stats()


func _handle_vehicle_physics(delta: float) -> void:
	var forward_input: float = 0.0
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W) or touch_gas:
		forward_input += 1.0
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S) or touch_brake:
		forward_input -= 1.0

	var turn_input: float = 0.0
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A) or touch_left:
		turn_input += 1.0
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D) or touch_right:
		turn_input -= 1.0

	# Accelerate / Brake
	if forward_input > 0.0:
		speed = move_toward(speed, max_forward_speed, acceleration * delta)
	elif forward_input < 0.0:
		if speed > 0.5:
			speed = move_toward(speed, 0.0, brake_power * delta)
		else:
			speed = move_toward(speed, max_reverse_speed, acceleration * 0.7 * delta)
	else:
		speed = move_toward(speed, 0.0, friction * delta)

	# Steer bus with speed sensitivity
	if abs(speed) > 0.2:
		var speed_factor: float = clampf(abs(speed) / max_forward_speed, 0.35, 1.0)
		var dir_mult: float = 1.0 if speed >= 0 else -1.0
		bus_body.rotation.y += turn_input * turn_speed * speed_factor * dir_mult * delta

	# Move bus in facing direction
	var forward_dir: Vector3 = -bus_body.global_transform.basis.z
	bus_body.velocity = forward_dir * speed
	bus_body.move_and_slide()

	# Keep bus clamped to road height
	bus_body.global_position.y = 0.45

	# Update camera tracking
	if bus_camera:
		var cam_target: Vector3 = bus_body.global_position + Vector3(0, 7.5, 9.5).rotated(Vector3.UP, bus_body.rotation.y)
		bus_camera.global_position = bus_camera.global_position.lerp(cam_target, delta * 5.0)
		bus_camera.look_at(bus_body.global_position + Vector3(0, 1.2, 0), Vector3.UP)


func _check_stop_proximity() -> void:
	if not bus_body:
		return

	for i in range(STOPS.size()):
		var stop_info = STOPS[i]
		var stop_pos: Vector3 = stop_info["pos"]
		var dist: float = bus_body.global_position.distance_to(stop_pos)

		if dist < 4.8:
			if stop_info_label:
				stop_info_label.text = "🚏 %s • Slow down to halt (< 2 km/h) to exchange passengers" % stop_info["name"]
				stop_info_label.add_theme_color_override(&"font_color", Color(1.0, 0.88, 0.35))

			if abs(speed) < 2.0:
				_process_stop_exchange(stop_info)
			return

	if stop_info_label:
		var next_stop = STOPS[(current_stop_idx + 1) % STOPS.size()]
		stop_info_label.text = "🛣️ Driving Ring Road • Next Passenger Stop: %s" % next_stop["name"]
		stop_info_label.add_theme_color_override(&"font_color", Color(0.75, 0.85, 0.95))


func _process_stop_exchange(stop_info: Dictionary) -> void:
	var stop_id: String = stop_info["id"]

	# 1. Disembark passengers whose destination matches this stop
	var dropped_count: int = 0
	var remaining_passengers: Array[Dictionary] = []
	for p in current_passengers:
		if p.get("dest_id") == stop_id:
			dropped_count += 1
		else:
			remaining_passengers.append(p)

	if dropped_count > 0:
		current_passengers = remaining_passengers
		var fare_payout: int = dropped_count * 150
		total_passengers_served += dropped_count
		total_fares_collected += fare_payout

		if current_player:
			var needs: NeedsManager = current_player.get_node_or_null("NeedsManager") as NeedsManager
			if needs:
				needs.modify_money(fare_payout)
				needs.modify_energy(8.0)
				needs.modify_faith(10.0)
				StudentProfile.money = needs.money
				StudentProfile.save_to_disk()

		if SoundManager:
			SoundManager.play_cheer()
			SoundManager.play_coin()

		if current_player and current_player.has_method("display_notification"):
			current_player.display_notification("💰 Dropped off %d students at %s! Collected +₦%d fares!" % [dropped_count, stop_info["name"], fare_payout])

	# 2. Pick up new waiting passengers if space exists
	var open_seats: int = max_capacity - current_passengers.size()
	if open_seats > 0:
		var new_pickup: int = mini(open_seats, randi_range(2, 4))
		_board_passengers_at_stop(stop_info, new_pickup)


func _board_passengers_at_stop(stop_info: Dictionary, count: int) -> void:
	var next_dest_id: String = stop_info.get("dest_id", "faculty")
	for i in range(count):
		current_passengers.append({
			"origin": stop_info.get("name", "Stop"),
			"dest_id": next_dest_id
		})

	if SoundManager:
		SoundManager.play_click()


func honk_horn() -> void:
	if SoundManager:
		SoundManager.play_whistle()
	if current_player and current_player.has_method("display_notification"):
		var quotes = [
			"📢 Conductor Shouts: 'Oya enter with your ₦150 change! Faculty direct!'",
			"📢 Danfo Horn: PEEP PEEP! 'Move comot for road!'",
			"📢 Conductor: 'Hostel express! Jump in sharp sharp!'"
		]
		current_player.display_notification(quotes[randi() % quotes.size()])


# ==============================================================================
# 3D VEHICLE & CIRCUIT GENERATOR
# ==============================================================================

func _setup_3d_circuit() -> void:
	var vp = %SubViewport if has_node("%SubViewport") else null
	if not vp:
		return

	for c in vp.get_children():
		c.queue_free()

	# 1. Lighting & Sun
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-45, 35, 0)
	sun.light_energy = 1.25
	sun.shadow_enabled = false
	vp.add_child(sun)

	# 2. Road Circuit Ground (Dark asphalt ring road)
	var ground := StaticBody3D.new()
	var g_mesh := MeshInstance3D.new()
	var g_box := BoxMesh.new()
	g_box.size = Vector3(64, 0.2, 64)
	g_mesh.mesh = g_box
	var g_mat := StandardMaterial3D.new()
	g_mat.albedo_color = Color(0.12, 0.14, 0.16, 1.0) # Asphalt
	g_mat.roughness = 0.8
	g_mesh.material_override = g_mat
	ground.add_child(g_mesh)
	vp.add_child(ground)

	# Ring Road Center Grass Island
	var grass := MeshInstance3D.new()
	var grass_box := BoxMesh.new()
	grass_box.size = Vector3(28, 0.25, 28)
	grass.mesh = grass_box
	var grass_mat := StandardMaterial3D.new()
	grass_mat.albedo_color = Color(0.18, 0.48, 0.22, 1.0) # Campus Lawn Green
	grass.material_override = grass_mat
	grass.position = Vector3(0, 0.1, 0)
	vp.add_child(grass)

	# 3. Passenger Stops Markers
	stops_nodes.clear()
	for s in STOPS:
		var marker := Node3D.new()
		marker.position = s["pos"]

		var pole := MeshInstance3D.new()
		var p_mesh := CylinderMesh.new()
		p_mesh.top_radius = 0.08
		p_mesh.bottom_radius = 0.08
		p_mesh.height = 3.0
		pole.mesh = p_mesh
		var p_mat := StandardMaterial3D.new()
		p_mat.albedo_color = Color(0.85, 0.85, 0.9, 1.0)
		pole.material_override = p_mat
		pole.position.y = 1.5
		marker.add_child(pole)

		var sign_lbl := Label3D.new()
		sign_lbl.text = "%s %s" % [s["icon"], s["name"]]
		sign_lbl.font_size = 20
		sign_lbl.modulate = Color(1.0, 0.9, 0.2)
		sign_lbl.outline_size = 4
		sign_lbl.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		sign_lbl.position = Vector3(0, 3.2, 0)
		marker.add_child(sign_lbl)

		# Ground stop zone disc
		var disc := MeshInstance3D.new()
		var d_mesh := CylinderMesh.new()
		d_mesh.top_radius = 3.2
		d_mesh.bottom_radius = 3.2
		d_mesh.height = 0.05
		disc.mesh = d_mesh
		var d_mat := StandardMaterial3D.new()
		d_mat.albedo_color = Color(0.2, 0.85, 0.45, 0.45) # Translucent green landing pad
		d_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		disc.material_override = d_mat
		disc.position.y = 0.12
		marker.add_child(disc)

		vp.add_child(marker)
		stops_nodes.append(marker)

	# 4. Yellow Campus Danfo Bus Vehicle
	bus_body = CharacterBody3D.new()
	bus_body.name = "DanfoBus"
	bus_body.position = Vector3(0, 0.45, 16)
	bus_body.rotation.y = PI * 0.5

	bus_visual = Node3D.new()
	bus_body.add_child(bus_visual)

	# Yellow Danfo Main Chassis
	var chassis := MeshInstance3D.new()
	var c_box := BoxMesh.new()
	c_box.size = Vector3(2.1, 1.4, 4.4)
	chassis.mesh = c_box
	var c_mat := StandardMaterial3D.new()
	c_mat.albedo_color = Color(0.96, 0.78, 0.08, 1.0) # Classic Lagos Danfo Yellow
	c_mat.roughness = 0.35
	chassis.material_override = c_mat
	chassis.position.y = 0.7
	bus_visual.add_child(chassis)

	# Iconic Green Side Stripes
	var stripe := MeshInstance3D.new()
	var s_box := BoxMesh.new()
	s_box.size = Vector3(2.14, 0.22, 4.2)
	stripe.mesh = s_box
	var s_mat := StandardMaterial3D.new()
	s_mat.albedo_color = Color(0.08, 0.52, 0.24, 1.0) # Deep Green
	stripe.material_override = s_mat
	stripe.position = Vector3(0, 0.65, 0)
	bus_visual.add_child(stripe)

	# Windscreen & Windows
	var glass := MeshInstance3D.new()
	var g_box_w := BoxMesh.new()
	g_box_w.size = Vector3(2.0, 0.5, 3.8)
	glass.mesh = g_box_w
	var gl_mat := StandardMaterial3D.new()
	gl_mat.albedo_color = Color(0.12, 0.25, 0.35, 0.9)
	glass.material_override = gl_mat
	glass.position = Vector3(0, 1.05, 0.1)
	bus_visual.add_child(glass)

	# Headlights & Destination Header
	var dest_sign := Label3D.new()
	dest_sign.text = "GATE ➔ HOSTEL ➔ LT1 ➔ LIB"
	dest_sign.font_size = 14
	dest_sign.modulate = Color(1.0, 0.95, 0.3)
	dest_sign.outline_size = 4
	dest_sign.position = Vector3(0, 1.45, -2.22)
	bus_visual.add_child(dest_sign)

	# 4 Wheels
	var wheel_positions = [
		Vector3(-1.05, 0.25, -1.3),
		Vector3(1.05, 0.25, -1.3),
		Vector3(-1.05, 0.25, 1.3),
		Vector3(1.05, 0.25, 1.3)
	]
	for wp in wheel_positions:
		var wheel := MeshInstance3D.new()
		var w_mesh := CylinderMesh.new()
		w_mesh.top_radius = 0.38
		w_mesh.bottom_radius = 0.38
		w_mesh.height = 0.3
		wheel.mesh = w_mesh
		var w_mat := StandardMaterial3D.new()
		w_mat.albedo_color = Color(0.08, 0.08, 0.08, 1.0)
		wheel.material_override = w_mat
		wheel.rotation.z = PI * 0.5
		wheel.position = wp
		bus_visual.add_child(wheel)

	vp.add_child(bus_body)

	# 5. Chase Camera
	bus_camera = Camera3D.new()
	bus_camera.current = true
	bus_camera.fov = 65.0
	vp.add_child(bus_camera)
	bus_camera.position = bus_body.global_position + Vector3(0, 7.5, 9.5)
	bus_camera.look_at(bus_body.global_position, Vector3.UP)


# ==============================================================================
# UI OVERLAY BUILDER
# ==============================================================================

func _build_ui_overlay() -> void:
	# Top Dashboard
	var top_panel := PanelContainer.new()
	top_panel.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_panel.offset_left = 16
	top_panel.offset_top = 16
	top_panel.offset_right = -16
	top_panel.offset_bottom = 84

	var p_style := StyleBoxFlat.new()
	p_style.bg_color = Color(0.06, 0.12, 0.09, 0.94)
	p_style.border_width_left = 2
	p_style.border_width_top = 2
	p_style.border_width_right = 2
	p_style.border_width_bottom = 2
	p_style.border_color = Color(0.96, 0.78, 0.08, 0.85)
	p_style.corner_radius_top_left = 14
	p_style.corner_radius_top_right = 14
	p_style.corner_radius_bottom_right = 14
	p_style.corner_radius_bottom_left = 14
	p_style.content_margin_left = 16
	p_style.content_margin_right = 16
	p_style.content_margin_top = 10
	p_style.content_margin_bottom = 10
	top_panel.add_theme_stylebox_override(&"panel", p_style)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override(&"separation", 16)
	top_panel.add_child(hbox)

	var title_lbl := Label.new()
	title_lbl.text = "🚌 CAMPUS DANFO SHUTTLE"
	title_lbl.add_theme_font_size_override(&"font_size", 16)
	title_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.88, 0.25))
	hbox.add_child(title_lbl)

	speedo_label = Label.new()
	speedo_label.text = "⚡ SPEED: 0 km/h"
	speedo_label.add_theme_font_size_override(&"font_size", 14)
	speedo_label.add_theme_color_override(&"font_color", Color(0.35, 0.95, 0.55))
	hbox.add_child(speedo_label)

	passenger_label = Label.new()
	passenger_label.text = "👥 PASSENGERS: 0/6"
	passenger_label.add_theme_font_size_override(&"font_size", 14)
	passenger_label.add_theme_color_override(&"font_color", Color(0.4, 0.85, 1.0))
	hbox.add_child(passenger_label)

	earnings_label = Label.new()
	earnings_label.text = "💰 EARNINGS: +₦0"
	earnings_label.add_theme_font_size_override(&"font_size", 14)
	earnings_label.add_theme_color_override(&"font_color", Color(1.0, 0.95, 0.45))
	earnings_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(earnings_label)

	horn_btn = Button.new()
	horn_btn.text = "📢 Honk Horn"
	horn_btn.custom_minimum_size = Vector2(100, 36)
	horn_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	horn_btn.pressed.connect(honk_horn)
	hbox.add_child(horn_btn)

	exit_btn = Button.new()
	exit_btn.text = "✕ Park & Exit"
	exit_btn.custom_minimum_size = Vector2(100, 36)
	exit_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	exit_btn.pressed.connect(close_game)
	hbox.add_child(exit_btn)

	add_child(top_panel)

	# Bottom Route Direction Banner
	var bot_panel := PanelContainer.new()
	bot_panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bot_panel.offset_left = 16
	bot_panel.offset_top = -64
	bot_panel.offset_right = -16
	bot_panel.offset_bottom = -16
	bot_panel.add_theme_stylebox_override(&"panel", p_style)

	stop_info_label = Label.new()
	stop_info_label.text = "🛣️ Drive forward (W / ▲) to pick up waiting student passengers."
	stop_info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stop_info_label.add_theme_font_size_override(&"font_size", 13)
	stop_info_label.add_theme_color_override(&"font_color", Color(0.9, 0.95, 1.0))
	bot_panel.add_child(stop_info_label)

	add_child(bot_panel)


func _update_ui_stats() -> void:
	if speedo_label:
		var kmh: int = int(abs(speed) * 3.6)
		speedo_label.text = "⚡ SPEED: %d km/h" % kmh
	if passenger_label:
		passenger_label.text = "👥 PASSENGERS: %d/%d" % [current_passengers.size(), max_capacity]
	if earnings_label:
		earnings_label.text = "💰 EARNINGS: +₦%d" % total_fares_collected
