class_name ConvocationCeremonyDialog
extends Control

## Grand Convocation Ceremony & Degree Conferment Dialog.
## Celebrates the student's graduation before the University Senate & Chancellor,
## confers degree honors based on final CGPA, awards academic gifts,
## and connects to the high-resolution WhatsApp shareable Degree Certificate badge.

signal degree_conferred(honors_title: String, gift_amount: int)
signal dialog_closed

var current_player: CharacterBody3D = null
var current_cert_data: Dictionary = {}

var title_lbl: Label = null
var citation_lbl: Label = null
var honors_banner_lbl: Label = null
var share_btn: Button = null
var dance_btn: Button = null
var cap_btn: Button = null
var close_btn: Button = null


func _ready() -> void:
	name = "ConvocationCeremonyDialog"
	visible = false
	_build_ui()


func _build_ui() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	# 1. Dark Backdrop
	var backdrop = ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.04, 0.06, 0.10, 0.82)
	add_child(backdrop)

	# 2. Center Card
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(580, 560)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.14, 0.12, 0.98) # Deep Senate Emerald & Velvet
	style.border_color = Color(0.92, 0.72, 0.18, 1.0) # Senate Gold
	style.set_border_width_all(2)
	style.set_corner_radius_all(14)
	style.content_margin_left = 22
	style.content_margin_top = 20
	style.content_margin_right = 22
	style.content_margin_bottom = 20
	panel.add_theme_stylebox_override(&"panel", style)
	center.add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override(&"separation", 12)
	panel.add_child(vbox)

	# Header HBox
	var header_hbox = HBoxContainer.new()
	vbox.add_child(header_hbox)

	var title_vbox = VBoxContainer.new()
	title_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_hbox.add_child(title_vbox)

	title_lbl = Label.new()
	title_lbl.text = "🎓 GRAND CONVOCATION & DEGREE CONFERMENT"
	title_lbl.add_theme_font_size_override(&"font_size", 16)
	title_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.85, 0.25))
	title_vbox.add_child(title_lbl)

	var sub_lbl = Label.new()
	sub_lbl.text = "Senate Ceremonial Dais • Federal University of My Campus Life"
	sub_lbl.add_theme_font_size_override(&"font_size", 12)
	sub_lbl.add_theme_color_override(&"font_color", Color(0.4, 0.85, 0.6))
	title_vbox.add_child(sub_lbl)

	close_btn = Button.new()
	close_btn.text = "✕"
	close_btn.custom_minimum_size = Vector2(38, 38)
	close_btn.pressed.connect(close_dialog)
	header_hbox.add_child(close_btn)

	vbox.add_child(HSeparator.new())

	# Chancellor's Citation Card
	var cit_panel = PanelContainer.new()
	var cp_style = StyleBoxFlat.new()
	cp_style.bg_color = Color(0.12, 0.18, 0.16, 0.95)
	cp_style.set_corner_radius_all(10)
	cp_style.content_margin_left = 16
	cp_style.content_margin_top = 12
	cp_style.content_margin_right = 16
	cp_style.content_margin_bottom = 12
	cit_panel.add_theme_stylebox_override(&"panel", cp_style)
	vbox.add_child(cit_panel)

	var cit_vbox = VBoxContainer.new()
	cit_vbox.add_theme_constant_override(&"separation", 6)
	cit_panel.add_child(cit_vbox)

	var dais_heading = Label.new()
	dais_heading.text = "📜 OFFICIAL SENATE DEGREE CITATION"
	dais_heading.add_theme_font_size_override(&"font_size", 12)
	dais_heading.add_theme_color_override(&"font_color", Color(0.85, 0.72, 0.35))
	cit_vbox.add_child(dais_heading)

	citation_lbl = Label.new()
	citation_lbl.text = "Chancellor Prof. Oloyede raises the academic mace..."
	citation_lbl.add_theme_font_size_override(&"font_size", 14)
	citation_lbl.add_theme_color_override(&"font_color", Color(0.95, 0.96, 0.98))
	citation_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cit_vbox.add_child(citation_lbl)

	# Honors Pill Banner
	honors_banner_lbl = Label.new()
	honors_banner_lbl.text = "🌟 FIRST CLASS HONOURS"
	honors_banner_lbl.add_theme_font_size_override(&"font_size", 15)
	honors_banner_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.9, 0.3))
	honors_banner_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(honors_banner_lbl)

	# Action Buttons
	share_btn = Button.new()
	share_btn.text = "📲 SHARE DEGREE TO WHATSAPP / SAVE CERTIFICATE"
	share_btn.custom_minimum_size = Vector2(0, 48)
	share_btn.add_theme_font_size_override(&"font_size", 14)
	share_btn.pressed.connect(_on_share_degree_pressed)
	vbox.add_child(share_btn)

	var dance_hbox = HBoxContainer.new()
	dance_hbox.add_theme_constant_override(&"separation", 10)
	vbox.add_child(dance_hbox)

	dance_btn = Button.new()
	dance_btn.text = "🕺 Celebrate Graduate Dance"
	dance_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dance_btn.custom_minimum_size = Vector2(0, 42)
	dance_btn.pressed.connect(_on_dance_pressed)
	dance_hbox.add_child(dance_btn)

	cap_btn = Button.new()
	cap_btn.text = "🎓 Toss Mortarboard Cap"
	cap_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cap_btn.custom_minimum_size = Vector2(0, 42)
	cap_btn.pressed.connect(_on_cap_toss_pressed)
	dance_hbox.add_child(cap_btn)


func open_ceremony(player: CharacterBody3D) -> void:
	current_player = player
	visible = true

	var needs: NeedsManager = player.get_node_or_null("NeedsManager") as NeedsManager if player else null
	var cgpa: float = needs.cgpa if needs else 3.50
	const ProfileStore = preload("res://scripts/data/student_profile.gd")
	var student_name: String = ProfileStore.student_name if not ProfileStore.student_name.is_empty() else "Distinguished Graduate"
	var dept_name: String = ProfileStore.admitted_department if not ProfileStore.admitted_department.is_empty() else "Computer Science"
	var matric_no: String = ProfileStore.matric_no if not ProfileStore.matric_no.is_empty() else "FUCL/2026/042"
	var faculty_name: String = ProfileStore.admitted_faculty if not ProfileStore.admitted_faculty.is_empty() else "Faculty of Sciences"

	var honors_title: String = "Bachelor of Science"
	var gift_cash: int = 15000

	if cgpa >= 4.50:
		honors_title = "First Class Honours with Chancellor's Senate Gold Medal"
		gift_cash = 35000
	elif cgpa >= 3.50:
		honors_title = "Second Class Honours (Upper Division)"
		gift_cash = 20000
	elif cgpa >= 2.40:
		honors_title = "Second Class Honours (Lower Division)"
		gift_cash = 12000
	else:
		honors_title = "Third Class Division"
		gift_cash = 8000

	ProfileStore.degree_awarded = "%s (%s)" % [dept_name, honors_title]
	ProfileStore.save_to_disk()

	if needs:
		needs.modify_money(gift_cash)
		needs.modify_faith(50.0)
		needs.modify_energy(30.0)

	current_cert_data = {
		"name": student_name,
		"matric_no": matric_no,
		"department": dept_name,
		"faculty": faculty_name,
		"cgpa": cgpa,
		"honors": honors_title,
		"date": "November 2026"
	}

	if citation_lbl:
		citation_lbl.text = """Chancellor Prof. Oloyede raises the academic mace and proclaims:
"By the authority of the University Senate, having found you worthy in character and learning, I confer upon %s the degree of Bachelor of Science in %s (%s)!"

Vice-Chancellor Prof. Okonjo shakes your hand warmly:
"Hearty congratulations! You have brought immense honor to your family and university! Receive this ₦%s Senate Convocation Grant!"
""" % [student_name.to_upper(), dept_name, honors_title, _format_number(gift_cash)]

	if honors_banner_lbl:
		honors_banner_lbl.text = "🏆 %s • CGPA: %.2f / 5.00" % [honors_title.to_upper(), cgpa]

	if SoundManager:
		SoundManager.play_cheer()

	degree_conferred.emit(honors_title, gift_cash)


func _on_share_degree_pressed() -> void:
	if SoundManager:
		SoundManager.play_click()

	if OS.has_feature("web"):
		var json_str: String = JSON.stringify(current_cert_data)
		JavaScriptBridge.eval("if(window.openDegreeCertificateShareModal) window.openDegreeCertificateShareModal(" + json_str + ");")
	else:
		var summary_text: String = "🎓 CONVOCATION CITATION: %s has graduated with %s in %s (CGPA: %.2f)!" % [
			current_cert_data.get("name", "Student"),
			current_cert_data.get("honors", "Degree"),
			current_cert_data.get("department", "Department"),
			float(current_cert_data.get("cgpa", 4.50))
		]
		DisplayServer.clipboard_set(summary_text)
		if current_player and current_player.has_method("display_notification"):
			current_player.display_notification("📋 Degree citation copied to clipboard!")


func _on_dance_pressed() -> void:
	if current_player and current_player.has_method("play_graduation_dance_animation"):
		current_player.play_graduation_dance_animation()
	elif current_player and current_player.has_method("play_celebrate_animation"):
		current_player.play_celebrate_animation("🎓 FIRST CLASS GRADUATE!")


func _on_cap_toss_pressed() -> void:
	if SoundManager:
		SoundManager.play_cheer()
	if current_player and current_player.has_method("display_notification"):
		current_player.display_notification("🎓🎉 CAP TOSS! You launch your cap high into the Great Hall arena lights! Crowd roars with standing ovation! Faith +25!")
	var needs = current_player.get_node_or_null("NeedsManager") as NeedsManager if current_player else null
	if needs:
		needs.modify_faith(25.0)


func close_dialog() -> void:
	visible = false
	current_player = null
	dialog_closed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close_dialog()
		get_viewport().set_input_as_handled()


func _format_number(n: int) -> String:
	var s: String = str(n)
	var idx: int = s.length() - 3
	while idx > 0:
		s = s.insert(idx, ",")
		idx -= 3
	return s
