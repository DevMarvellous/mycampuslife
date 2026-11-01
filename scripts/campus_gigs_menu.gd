class_name CampusGigsMenu
extends Control

## Interactive Side Hustles & Student Freelance Creative Agency.
## Allows students to earn honest income through creative talents:
## - Graphic Design Studio (flyers, posters, client rating & tip)
## - Silicon Lagoon Code Bug Bounty (debugging university portal scripts)
## - Cybercafe Handout Fast Printing (typing & binding past questions)
## - 100L Peer Tutoring Academy (teaching junior students for cash & CGPA boost)
## - Plus manual campus hustles (food delivery, laundry, repair)

signal gig_completed(gig_id: String, payout: int)
signal menu_closed

const CampusGigsData = preload("res://scripts/data/campus_gigs.gd")

var current_player: CharacterBody3D = null

@onready var modal_panel: PanelContainer = $ModalPanel if has_node("ModalPanel") else null
@onready var main_vbox: VBoxContainer = $ModalPanel/VBox if has_node("ModalPanel/VBox") else null
@onready var gigs_container: VBoxContainer = %GigsContainer if has_node("%GigsContainer") else null
@onready var close_btn: Button = %CloseBtn if has_node("%CloseBtn") else null
@onready var status_label: Label = %StatusLabel if has_node("%StatusLabel") else null

# Dynamic interactive studio container
var studio_box: VBoxContainer = null


func _ready() -> void:
	visible = false
	if close_btn:
		close_btn.pressed.connect(close_menu)
	_setup_studio_container()
	_populate_gigs()


func _setup_studio_container() -> void:
	if not modal_panel:
		return
	studio_box = VBoxContainer.new()
	studio_box.name = "StudioBox"
	studio_box.visible = false
	studio_box.add_theme_constant_override(&"separation", 10)
	modal_panel.add_child(studio_box)


func open_gigs(player: CharacterBody3D) -> void:
	current_player = player
	_close_studio_view()
	_populate_gigs()
	visible = true


func close_menu() -> void:
	visible = false
	current_player = null
	_close_studio_view()
	menu_closed.emit()


func _close_studio_view() -> void:
	if studio_box:
		studio_box.visible = false
		for c in studio_box.get_children():
			c.queue_free()
	if main_vbox:
		main_vbox.visible = true


func _populate_gigs() -> void:
	if not gigs_container:
		return

	for child in gigs_container.get_children():
		child.queue_free()

	var gigs = CampusGigsData.get_all_gigs()
	for g in gigs:
		var panel = PanelContainer.new()
		var p_style = StyleBoxFlat.new()
		p_style.bg_color = Color(0.09, 0.12, 0.17, 0.96)
		p_style.border_width_left = 1
		p_style.border_width_top = 1
		p_style.border_width_right = 1
		p_style.border_width_bottom = 1
		p_style.border_color = Color(0.2, 0.45, 0.65, 0.5) if not g.get("is_interactive", false) else Color(0.3, 0.85, 0.55, 0.8)
		p_style.corner_radius_top_left = 8
		p_style.corner_radius_top_right = 8
		p_style.corner_radius_bottom_right = 8
		p_style.corner_radius_bottom_left = 8
		p_style.content_margin_left = 14.0
		p_style.content_margin_right = 14.0
		p_style.content_margin_top = 10.0
		p_style.content_margin_bottom = 10.0
		panel.add_theme_stylebox_override(&"panel", p_style)

		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override(&"separation", 12)

		var icon_lbl = Label.new()
		icon_lbl.text = String(g.get("icon", "💼"))
		icon_lbl.add_theme_font_size_override(&"font_size", 28)
		hbox.add_child(icon_lbl)

		var info_vbox = VBoxContainer.new()
		info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info_vbox.add_theme_constant_override(&"separation", 2)

		var title_lbl = Label.new()
		title_lbl.text = String(g.get("title", "Gig"))
		title_lbl.add_theme_font_size_override(&"font_size", 15)
		title_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.88, 0.35))
		info_vbox.add_child(title_lbl)

		var desc_lbl = Label.new()
		desc_lbl.text = "%s  •  ⏱️ %dm  •  ⚡ -%d%%" % [String(g.get("location", "")), int(g.get("duration_minutes", 30)), int(g.get("energy_cost", 20))]
		desc_lbl.add_theme_font_size_override(&"font_size", 12)
		desc_lbl.add_theme_color_override(&"font_color", Color(0.75, 0.82, 0.9))
		info_vbox.add_child(desc_lbl)

		var detail_lbl = Label.new()
		detail_lbl.text = String(g.get("desc", ""))
		detail_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		detail_lbl.add_theme_font_size_override(&"font_size", 11)
		detail_lbl.add_theme_color_override(&"font_color", Color(0.65, 0.7, 0.75))
		info_vbox.add_child(detail_lbl)

		hbox.add_child(info_vbox)

		# Action Column
		var action_vbox = VBoxContainer.new()
		action_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		action_vbox.add_theme_constant_override(&"separation", 4)

		var pay_lbl = Label.new()
		pay_lbl.text = "+₦%s" % _format_number(int(g.get("payout", 1000)))
		pay_lbl.add_theme_font_size_override(&"font_size", 16)
		pay_lbl.add_theme_color_override(&"font_color", Color(0.3, 0.95, 0.45))
		pay_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		action_vbox.add_child(pay_lbl)

		var is_interactive: bool = bool(g.get("is_interactive", false))
		if is_interactive:
			var studio_btn = Button.new()
			studio_btn.text = "🎮 Studio Gig"
			studio_btn.custom_minimum_size = Vector2(104, 32)
			studio_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			studio_btn.add_theme_font_size_override(&"font_size", 12)
			studio_btn.add_theme_color_override(&"font_color", Color(1.0, 0.95, 0.4))
			studio_btn.pressed.connect(_open_interactive_studio.bind(g))
			action_vbox.add_child(studio_btn)

			var quick_btn = Button.new()
			quick_btn.text = "⚡ Quick"
			quick_btn.custom_minimum_size = Vector2(104, 26)
			quick_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			quick_btn.add_theme_font_size_override(&"font_size", 11)
			quick_btn.pressed.connect(_on_work_gig_pressed.bind(g, false))
			action_vbox.add_child(quick_btn)
		else:
			var work_btn = Button.new()
			work_btn.text = "Work Gig"
			work_btn.custom_minimum_size = Vector2(96, 36)
			work_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			work_btn.pressed.connect(_on_work_gig_pressed.bind(g, false))
			action_vbox.add_child(work_btn)

		hbox.add_child(action_vbox)
		panel.add_child(hbox)
		gigs_container.add_child(panel)


# ==============================================================================
# INTERACTIVE FREELANCE GIG STUDIO DISPATCHER
# ==============================================================================

func _open_interactive_studio(gig: Dictionary) -> void:
	if not current_player:
		return

	var needs: NeedsManager = current_player.get_node_or_null("NeedsManager") as NeedsManager
	if not needs:
		return

	var energy_req: float = float(gig.get("energy_cost", 20.0))
	if needs.energy < energy_req:
		if status_label:
			status_label.text = "⚠️ You are too tired (Need %d%% Energy)! Rest on your hostel bed." % int(energy_req)
			status_label.add_theme_color_override(&"font_color", Color(1.0, 0.4, 0.3))
		if SoundManager: SoundManager.play_alert()
		return

	var min_cgpa: float = float(gig.get("min_cgpa", 0.0))
	if min_cgpa > 0.0 and needs.cgpa < min_cgpa:
		if status_label:
			status_label.text = "⚠️ Requires at least %.2f CGPA (Current: %.2f)!" % [min_cgpa, needs.cgpa]
			status_label.add_theme_color_override(&"font_color", Color(1.0, 0.4, 0.3))
		if SoundManager: SoundManager.play_alert()
		return

	if SoundManager: SoundManager.play_click()

	if main_vbox:
		main_vbox.visible = false
	if studio_box:
		studio_box.visible = true
		for c in studio_box.get_children():
			c.queue_free()

	var gig_id: String = String(gig.get("id", ""))
	match gig_id:
		"graphic_design":
			_render_graphic_design_studio(gig)
		"code_bounty":
			_render_code_bounty_studio(gig)
		"handout_printing":
			_render_handout_printing_studio(gig)
		"peer_tutoring":
			_render_peer_tutoring_studio(gig)
		_:
			_render_generic_studio(gig)


# ------------------------------------------------------------------------------
# 1. GRAPHIC DESIGN STUDIO (SUB Design Agency)
# ------------------------------------------------------------------------------

func _render_graphic_design_studio(gig: Dictionary) -> void:
	var head_row := HBoxContainer.new()
	var back_btn := Button.new()
	back_btn.text = "⬅ Back"
	back_btn.pressed.connect(_close_studio_view)
	head_row.add_child(back_btn)

	var title_lbl := Label.new()
	title_lbl.text = "🎨 SUB GRAPHIC DESIGN STUDIO"
	title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_font_size_override(&"font_size", 16)
	title_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.88, 0.35))
	head_row.add_child(title_lbl)
	studio_box.add_child(head_row)

	var prompt_lbl := Label.new()
	prompt_lbl.text = "Client Order: Design the official publicity poster for the University Tech & Innovation Summit!"
	prompt_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	prompt_lbl.add_theme_font_size_override(&"font_size", 12)
	prompt_lbl.add_theme_color_override(&"font_color", Color(0.8, 0.9, 1.0))
	studio_box.add_child(prompt_lbl)

	# Live Poster Preview
	var preview_card := PanelContainer.new()
	preview_card.custom_minimum_size = Vector2(0, 140)
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color(0.06, 0.18, 0.12, 0.98)
	card_style.border_width_left = 3
	card_style.border_width_top = 3
	card_style.border_width_right = 3
	card_style.border_width_bottom = 3
	card_style.border_color = Color(1.0, 0.82, 0.24)
	card_style.corner_radius_top_left = 12
	card_style.corner_radius_top_right = 12
	card_style.corner_radius_bottom_right = 12
	card_style.corner_radius_bottom_left = 12
	card_style.content_margin_left = 16.0
	card_style.content_margin_right = 16.0
	card_style.content_margin_top = 14.0
	card_style.content_margin_bottom = 14.0
	preview_card.add_theme_stylebox_override(&"panel", card_style)

	var preview_vbox := VBoxContainer.new()
	preview_vbox.alignment = BoxContainer.ALIGNMENT_CENTER

	var p_headline := Label.new()
	p_headline.text = "CAMPUS TECH & AI SUMMIT 2026"
	p_headline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	p_headline.add_theme_font_size_override(&"font_size", 16)
	p_headline.add_theme_color_override(&"font_color", Color(1.0, 0.9, 0.4))
	preview_vbox.add_child(p_headline)

	var p_icon := Label.new()
	p_icon.text = "🚀"
	p_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	p_icon.add_theme_font_size_override(&"font_size", 38)
	preview_vbox.add_child(p_icon)

	var p_footer := Label.new()
	p_footer.text = "Hosted by Student Union Government • Free Admission"
	p_footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	p_footer.add_theme_font_size_override(&"font_size", 11)
	p_footer.add_theme_color_override(&"font_color", Color(0.85, 0.9, 0.95))
	preview_vbox.add_child(p_footer)

	preview_card.add_child(preview_vbox)
	studio_box.add_child(preview_card)

	# Design Customizer Controls
	var controls_box := VBoxContainer.new()
	controls_box.add_theme_constant_override(&"separation", 6)

	var theme_row := HBoxContainer.new()
	var theme_lbl := Label.new()
	theme_lbl.text = "Theme Palette:"
	theme_lbl.custom_minimum_size = Vector2(110, 0)
	theme_lbl.add_theme_font_size_override(&"font_size", 12)
	theme_row.add_child(theme_lbl)

	var t1_btn := Button.new()
	t1_btn.text = "🌿 Emerald & Gold"
	t1_btn.pressed.connect(func():
		card_style.bg_color = Color(0.06, 0.18, 0.12, 0.98)
		card_style.border_color = Color(1.0, 0.82, 0.24)
		if SoundManager: SoundManager.play_click()
	)
	theme_row.add_child(t1_btn)

	var t2_btn := Button.new()
	t2_btn.text = "⚡ Cyber Cyan"
	t2_btn.pressed.connect(func():
		card_style.bg_color = Color(0.04, 0.12, 0.22, 0.98)
		card_style.border_color = Color(0.2, 0.85, 1.0)
		if SoundManager: SoundManager.play_click()
	)
	theme_row.add_child(t2_btn)

	var t3_btn := Button.new()
	t3_btn.text = "🌅 Sunset Amber"
	t3_btn.pressed.connect(func():
		card_style.bg_color = Color(0.22, 0.08, 0.06, 0.98)
		card_style.border_color = Color(1.0, 0.65, 0.25)
		if SoundManager: SoundManager.play_click()
	)
	theme_row.add_child(t3_btn)
	controls_box.add_child(theme_row)

	var icon_row := HBoxContainer.new()
	var icon_lbl := Label.new()
	icon_lbl.text = "Hero Graphic:"
	icon_lbl.custom_minimum_size = Vector2(110, 0)
	icon_lbl.add_theme_font_size_override(&"font_size", 12)
	icon_row.add_child(icon_lbl)

	var i1_btn := Button.new()
	i1_btn.text = "🚀 Rocket"
	i1_btn.pressed.connect(func(): p_icon.text = "🚀"; if SoundManager: SoundManager.play_click())
	icon_row.add_child(i1_btn)

	var i2_btn := Button.new()
	i2_btn.text = "💡 Innovation"
	i2_btn.pressed.connect(func(): p_icon.text = "💡"; if SoundManager: SoundManager.play_click())
	icon_row.add_child(i2_btn)

	var i3_btn := Button.new()
	i3_btn.text = "🎓 Dean Shield"
	i3_btn.pressed.connect(func(): p_icon.text = "🎓"; if SoundManager: SoundManager.play_click())
	icon_row.add_child(i3_btn)

	var i4_btn := Button.new()
	i4_btn.text = "🕊️ Grace"
	i4_btn.pressed.connect(func(): p_icon.text = "🕊️"; if SoundManager: SoundManager.play_click())
	icon_row.add_child(i4_btn)
	controls_box.add_child(icon_row)

	studio_box.add_child(controls_box)

	# Submit Button
	var submit_btn := Button.new()
	submit_btn.text = "✨ Export Poster & Submit to Client (+₦2,500 + Tip)"
	submit_btn.custom_minimum_size = Vector2(0, 42)
	submit_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	submit_btn.add_theme_font_size_override(&"font_size", 13)
	submit_btn.pressed.connect(func():
		var bonus_tip: int = 800
		_complete_studio_gig(gig, bonus_tip, "⭐⭐⭐⭐⭐ 'Wicked design! The typography and color palette are world-class!' Client paid ₦2,500 + ₦800 design tip!")
	)
	studio_box.add_child(submit_btn)


# ------------------------------------------------------------------------------
# 2. SILICON LAGOON CODE BUG BOUNTY
# ------------------------------------------------------------------------------

func _render_code_bounty_studio(gig: Dictionary) -> void:
	var head_row := HBoxContainer.new()
	var back_btn := Button.new()
	back_btn.text = "⬅ Back"
	back_btn.pressed.connect(_close_studio_view)
	head_row.add_child(back_btn)

	var title_lbl := Label.new()
	title_lbl.text = "💻 SILICON LAGOON BUG BOUNTY"
	title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_font_size_override(&"font_size", 16)
	title_lbl.add_theme_color_override(&"font_color", Color(0.3, 0.95, 0.55))
	head_row.add_child(title_lbl)
	studio_box.add_child(head_row)

	var prompt_lbl := Label.new()
	prompt_lbl.text = "🚨 Critical Bug in University Student Portal: Find and patch the buggy line of code causing server crashes!"
	prompt_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	prompt_lbl.add_theme_font_size_override(&"font_size", 12)
	prompt_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.85, 0.4))
	studio_box.add_child(prompt_lbl)

	var code_card := PanelContainer.new()
	var code_style := StyleBoxFlat.new()
	code_style.bg_color = Color(0.04, 0.07, 0.10, 0.98)
	code_style.border_width_left = 2
	code_style.border_width_top = 2
	code_style.border_width_right = 2
	code_style.border_width_bottom = 2
	code_style.border_color = Color(0.2, 0.6, 0.85)
	code_style.corner_radius_top_left = 10
	code_style.corner_radius_top_right = 10
	code_style.corner_radius_bottom_right = 10
	code_style.corner_radius_bottom_left = 10
	code_style.content_margin_left = 14.0
	code_style.content_margin_right = 14.0
	code_style.content_margin_top = 10.0
	code_style.content_margin_bottom = 10.0
	code_card.add_theme_stylebox_override(&"panel", code_style)

	var code_vbox := VBoxContainer.new()
	code_vbox.add_theme_constant_override(&"separation", 6)

	var line0 := Label.new()
	line0.text = "# File: portal_exam_results.py (Line 42)"
	line0.add_theme_font_size_override(&"font_size", 11)
	line0.add_theme_color_override(&"font_color", Color(0.5, 0.65, 0.8))
	code_vbox.add_child(line0)

	var lines = [
		{"text": "1: def calculate_grade_points(units, grade_score):", "is_bug": false},
		{"text": "2:     total_weighted = units / 0  # ZeroDivision Error!", "is_bug": true},
		{"text": "3:     return total_weighted", "is_bug": false}
	]

	for item in lines:
		var line_btn := Button.new()
		line_btn.text = item["text"]
		line_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		line_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		line_btn.add_theme_font_size_override(&"font_size", 12)
		if item["is_bug"]:
			line_btn.pressed.connect(func():
				var bonus_bounty: int = 1000
				_complete_studio_gig(gig, bonus_bounty, "✅ BUG RESOLVED! Fixed ZeroDivisionError with safe fallback. Automated tests passed 100%! Payout: ₦3,500 + ₦1,000 bounty bonus!")
			)
		else:
			line_btn.pressed.connect(func():
				line_btn.add_theme_color_override(&"font_color", Color(1.0, 0.4, 0.4))
				if SoundManager: SoundManager.play_alert()
			)
		code_vbox.add_child(line_btn)

	code_card.add_child(code_vbox)
	studio_box.add_child(code_card)

	var hint_lbl := Label.new()
	hint_lbl.text = "💡 Click on the line containing the software bug to deploy the fix."
	hint_lbl.add_theme_font_size_override(&"font_size", 11)
	hint_lbl.add_theme_color_override(&"font_color", Color(0.7, 0.8, 0.9))
	studio_box.add_child(hint_lbl)


# ------------------------------------------------------------------------------
# 3. HANDOUT PRINTING & FAST TYPING HUSTLE
# ------------------------------------------------------------------------------

func _render_handout_printing_studio(gig: Dictionary) -> void:
	var head_row := HBoxContainer.new()
	var back_btn := Button.new()
	back_btn.text = "⬅ Back"
	back_btn.pressed.connect(_close_studio_view)
	head_row.add_child(back_btn)

	var title_lbl := Label.new()
	title_lbl.text = "🖨️ CYBERCAFE FAST PRINTING HUSTLE"
	title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_font_size_override(&"font_size", 16)
	title_lbl.add_theme_color_override(&"font_color", Color(0.4, 0.85, 1.0))
	head_row.add_child(title_lbl)
	studio_box.add_child(head_row)

	var prompt_lbl := Label.new()
	prompt_lbl.text = "Order: 30 Freshers need MTH 101 Past Questions printed, spiral-bound, and stamped before 8:00 AM test!"
	prompt_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	prompt_lbl.add_theme_font_size_override(&"font_size", 12)
	prompt_lbl.add_theme_color_override(&"font_color", Color(0.8, 0.9, 1.0))
	studio_box.add_child(prompt_lbl)

	var progress_bar := ProgressBar.new()
	progress_bar.max_value = 3.0
	progress_bar.value = 0.0
	progress_bar.custom_minimum_size = Vector2(0, 24)
	studio_box.add_child(progress_bar)

	var status_p_lbl := Label.new()
	status_p_lbl.text = "Step 1 of 3: Ready to format past questions document..."
	status_p_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_p_lbl.add_theme_font_size_override(&"font_size", 12)
	status_p_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.85, 0.35))
	studio_box.add_child(status_p_lbl)

	var step_btn := Button.new()
	step_btn.text = "⌨️ Step 1: Fast-Type Past Questions (40 WPM)"
	step_btn.custom_minimum_size = Vector2(0, 42)
	step_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	step_btn.add_theme_font_size_override(&"font_size", 13)

	var current_step: Array[int] = [1]
	step_btn.pressed.connect(func():
		if SoundManager: SoundManager.play_click()
		if current_step[0] == 1:
			progress_bar.value = 1.0
			status_p_lbl.text = "Step 2 of 3: Typing complete! Now send to high-speed laser printer..."
			step_btn.text = "🖨️ Step 2: High-Speed Duplex Laser Print"
			current_step[0] = 2
		elif current_step[0] == 2:
			progress_bar.value = 2.0
			status_p_lbl.text = "Step 3 of 3: 30 copies printed! Now spiral bind and apply departmental seal..."
			step_btn.text = "📑 Step 3: Spiral Bind & Stamp Faculty Seal"
			current_step[0] = 3
		elif current_step[0] == 3:
			progress_bar.value = 3.0
			var bonus_tip: int = 500
			_complete_studio_gig(gig, bonus_tip, "✅ 30 Handouts Bound & Delivered! Freshers paid ₦1,800 + ₦500 express collation fee!")
	)
	studio_box.add_child(step_btn)


# ------------------------------------------------------------------------------
# 4. 100L FRESHERS PEER TUTORING ACADEMY
# ------------------------------------------------------------------------------

func _render_peer_tutoring_studio(gig: Dictionary) -> void:
	var head_row := HBoxContainer.new()
	var back_btn := Button.new()
	back_btn.text = "⬅ Back"
	back_btn.pressed.connect(_close_studio_view)
	head_row.add_child(back_btn)

	var title_lbl := Label.new()
	title_lbl.text = "📚 100L FRESHERS PEER TUTORING"
	title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_font_size_override(&"font_size", 16)
	title_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.85, 0.25))
	head_row.add_child(title_lbl)
	studio_box.add_child(head_row)

	var prompt_lbl := Label.new()
	prompt_lbl.text = "Junior 100L Fresher asks: 'Senior, in Python, which data structure stores unique items without duplicates?'"
	prompt_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	prompt_lbl.add_theme_font_size_override(&"font_size", 12)
	prompt_lbl.add_theme_color_override(&"font_color", Color(0.85, 0.95, 1.0))
	studio_box.add_child(prompt_lbl)

	var answers = [
		{"text": "A) List (mutable, allows duplicates)", "correct": false},
		{"text": "B) Set (unordered collection of unique elements)", "correct": true},
		{"text": "C) Dictionary (stores key-value pairs)", "correct": false}
	]

	for ans in answers:
		var a_btn := Button.new()
		a_btn.text = ans["text"]
		a_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		a_btn.custom_minimum_size = Vector2(0, 36)
		a_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		a_btn.add_theme_font_size_override(&"font_size", 12)
		if ans["correct"]:
			a_btn.pressed.connect(func():
				var bonus_tip: int = 700
				if current_player:
					var needs: NeedsManager = current_player.get_node_or_null("NeedsManager") as NeedsManager
					if needs:
						needs.modify_cgpa(0.08)
				_complete_studio_gig(gig, bonus_tip, "🎓 Correct! Fresher: 'Aha! Sets only allow unique values! Thank you Senior!' Payout: ₦2,000 + ₦700 tutoring bonus + 0.08 CGPA!")
			)
		else:
			a_btn.pressed.connect(func():
				a_btn.add_theme_color_override(&"font_color", Color(1.0, 0.4, 0.4))
				if SoundManager: SoundManager.play_alert()
			)
		studio_box.add_child(a_btn)


# ------------------------------------------------------------------------------
# GENERIC FALLBACK
# ------------------------------------------------------------------------------

func _render_generic_studio(gig: Dictionary) -> void:
	_complete_studio_gig(gig, 0, "Gig complete!")


# ==============================================================================
# COMPLETION HANDLER
# ==============================================================================

func _complete_studio_gig(gig: Dictionary, bonus_tip: int, feedback_msg: String) -> void:
	if not current_player:
		return
	var needs: NeedsManager = current_player.get_node_or_null("NeedsManager") as NeedsManager
	if not needs:
		return

	var base_pay: int = int(gig.get("payout", 2000))
	var total_payout: int = base_pay + bonus_tip
	var energy_req: float = float(gig.get("energy_cost", 20.0))
	var duration: int = int(gig.get("duration_minutes", 30))

	needs.modify_energy(-energy_req)
	needs.modify_money(total_payout)
	needs.modify_faith(15.0)
	StudentProfile.money = needs.money
	StudentProfile.save_to_disk()

	if SupabaseClient:
		SupabaseClient.sync_profile_to_cloud(StudentProfile.get_profile_data())

	TimeSystem.advance_minutes(duration)

	if SoundManager:
		SoundManager.play_cheer()
		SoundManager.play_coin()

	if current_player.has_method("display_notification"):
		current_player.display_notification(feedback_msg)

	if current_player.has_method("play_celebrate_animation"):
		current_player.play_celebrate_animation("💼 GIG PAID! +₦%s" % _format_number(total_payout))

	PropBuilder3D.advance_quest_if_matching(7, current_player)

	_close_studio_view()

	if status_label:
		status_label.text = feedback_msg
		status_label.add_theme_color_override(&"font_color", Color(0.3, 0.98, 0.5))

	gig_completed.emit(gig.get("id", ""), total_payout)


func _on_work_gig_pressed(gig: Dictionary, _is_interactive: bool = false) -> void:
	if not current_player:
		return
	var needs: NeedsManager = current_player.get_node_or_null("NeedsManager") as NeedsManager
	if not needs:
		return

	var energy_req: float = float(gig.get("energy_cost", 20.0))
	if needs.energy < energy_req:
		if status_label:
			status_label.text = "⚠️ You are too tired to work (Need %d%% Energy)! Rest on your hostel bed." % int(energy_req)
			status_label.add_theme_color_override(&"font_color", Color(1.0, 0.4, 0.3))
		if SoundManager:
			SoundManager.play_alert()
		return

	var min_cgpa: float = float(gig.get("min_cgpa", 0.0))
	if min_cgpa > 0.0 and needs.cgpa < min_cgpa:
		if status_label:
			status_label.text = "⚠️ Requires at least %.2f CGPA (Current: %.2f)!" % [min_cgpa, needs.cgpa]
			status_label.add_theme_color_override(&"font_color", Color(1.0, 0.4, 0.3))
		if SoundManager:
			SoundManager.play_alert()
		return

	var payout: int = int(gig.get("payout", 2000))
	var duration: int = int(gig.get("duration_minutes", 30))
	needs.modify_energy(-energy_req)
	needs.modify_money(payout)
	StudentProfile.money = needs.money
	StudentProfile.save_to_disk()
	if SupabaseClient:
		SupabaseClient.sync_profile_to_cloud(StudentProfile.get_profile_data())
	TimeSystem.advance_minutes(duration)

	if gig.get("id") == "math_tutoring" or gig.get("id") == "peer_tutoring":
		needs.modify_cgpa(0.06)

	if SoundManager:
		SoundManager.play_coin()

	if current_player.has_method("display_notification"):
		current_player.display_notification("Gig Done: %s! +₦%s earned!" % [gig.get("title"), _format_number(payout)])

	if current_player.has_method("play_celebrate_animation"):
		current_player.play_celebrate_animation("💼 GIG PAID! +₦%s" % _format_number(payout))

	PropBuilder3D.advance_quest_if_matching(7, current_player)

	if status_label:
		status_label.text = "✓ Finished %s! Credited +₦%s to your wallet." % [gig.get("title"), _format_number(payout)]
		status_label.add_theme_color_override(&"font_color", Color(0.3, 0.95, 0.5))

	gig_completed.emit(gig.get("id", ""), payout)


func _format_number(n: int) -> String:
	var s: String = str(n)
	var idx: int = s.length() - 3
	while idx > 0:
		s = s.insert(idx, ",")
		idx -= 3
	return s
