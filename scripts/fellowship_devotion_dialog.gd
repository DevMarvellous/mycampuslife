class_name FellowshipDevotionDialog
extends Control

## Interactive Campus Christian Fellowship Scripture Sword Drill & Daily Devotional.
## Allows students to study inspiring scriptures, test biblical knowledge on wisdom & diligence,
## and earn peace of mind, Faith boosts (+50 Faith), and alumni fellowship love offerings.

signal devotion_completed(faith_gain: float, offering_awarded: int)
signal dialog_closed

var current_player: CharacterBody3D = null

# State
var current_round: int = 0
var max_rounds: int = 4
var correct_answers: int = 0
var total_offering: int = 0
var current_question: Dictionary = {}
var current_shuffled_correct: int = 0
var is_round_active: bool = false

# UI references
var round_lbl: Label = null
var scripture_ref_lbl: Label = null
var question_lbl: Label = null
var feedback_lbl: Label = null
var option_buttons: Array[Button] = []
var summary_panel: PanelContainer = null
var summary_lbl: Label = null

const SCRIPTURE_BANK: Array[Dictionary] = [
	{
		"ref": "Proverbs 3:5-6",
		"theme": "Wisdom & Trust",
		"verse": "\"Trust in the LORD with all thine heart; and lean not unto thine own...\"",
		"options": ["Understanding", "Imagination", "Strength", "Ambition"],
		"correct": 0,
		"exhortation": "God directs the paths of students who acknowledge Him in all their studies!"
	},
	{
		"ref": "Philippians 4:13",
		"theme": "Academic Strength & Fortitude",
		"verse": "\"I can do all things through Christ which...\"",
		"options": ["Strengtheneth me", "Comforteth me", "Enlighteneth me", "Guide me"],
		"correct": 0,
		"exhortation": "No semester exam or project is too difficult when Christ supplies your strength!"
	},
	{
		"ref": "Colossians 3:23",
		"theme": "Excellence in Campus Work",
		"verse": "\"And whatsoever ye do, do it heartily, as to the Lord, and not unto...\"",
		"options": ["Men", "Professors", "Rulers", "Kings"],
		"correct": 0,
		"exhortation": "Study and complete coursework with excellence as service unto God!"
	},
	{
		"ref": "James 1:5",
		"theme": "Divine Wisdom for Difficult Courses",
		"verse": "\"If any of you lack wisdom, let him ask of God, that giveth to all men liberally, and...\"",
		"options": ["Upbraideth not", "Delayeth not", "Chastiseth not", "Judgeth not"],
		"correct": 0,
		"exhortation": "God gives supernatural wisdom for mathematics, science, law, and arts without reproaching!"
	},
	{
		"ref": "Galatians 5:22-23",
		"theme": "Christian Conduct on Campus",
		"verse": "\"Which of the following is listed first among the Fruit of the Spirit?\"",
		"options": ["Love", "Patience", "Knowledge", "Zeal"],
		"correct": 0,
		"exhortation": "Love is the foundation of fellowship and peace in the university community!"
	},
	{
		"ref": "Psalm 23:1",
		"theme": "Peace of Mind & Provision",
		"verse": "\"The LORD is my shepherd; I shall not...\"",
		"options": ["Want", "Fear", "Stumble", "Perish"],
		"correct": 0,
		"exhortation": "The Lord provides for school fees, feeding, textbooks, and daily student needs!"
	},
	{
		"ref": "Proverbs 16:3",
		"theme": "Academic Planning",
		"verse": "\"Commit thy works unto the LORD, and thy thoughts shall be...\"",
		"options": ["Established", "Multiplied", "Protected", "Sanctified"],
		"correct": 0,
		"exhortation": "Commit your semester timetable and study hours to God for established success!"
	},
	{
		"ref": "Matthew 5:14",
		"theme": "Christian Identity & Light",
		"verse": "\"Ye are the light of the world. A city that is set on an hill cannot be...\"",
		"options": ["Hid", "Destroyed", "Overcome", "Forgotten"],
		"correct": 0,
		"exhortation": "Shine as godly examples of honesty, moral purity, and academic brilliance!"
	},
	{
		"ref": "Romans 8:28",
		"theme": "Hope & Providence",
		"verse": "\"And we know that all things work together for good to them that...\"",
		"options": ["Love God", "Work hard", "Seek wisdom", "Dwell in peace"],
		"correct": 0,
		"exhortation": "Even challenging academic moments work together for your ultimate growth and promotion!"
	},
	{
		"ref": "2 Timothy 1:7",
		"theme": "Overcoming Exam Anxiety",
		"verse": "\"For God hath not given us the spirit of fear; but of power, and of love, and of...\"",
		"options": ["A sound mind", "Great wealth", "Long life", "High victory"],
		"correct": 0,
		"exhortation": "Cast out exam fear and walk into the lecture hall with calm, godly confidence!"
	},
	{
		"ref": "Isaiah 40:31",
		"theme": "Renewal of Energy",
		"verse": "\"They that wait upon the LORD shall renew their strength; they shall mount up with wings as...\"",
		"options": ["Eagles", "Doves", "Lions", "Cherubim"],
		"correct": 0,
		"exhortation": "Waiting on the Lord clears burnout, exhaustion, and fatigue during exam week!"
	},
	{
		"ref": "Joshua 1:9",
		"theme": "Courage for Freshers & Finalists",
		"verse": "\"Have not I commanded thee? Be strong and of a good courage; be not afraid, neither be thou dismayed: for...\"",
		"options": ["The LORD thy God is with thee", "The victory is already won", "Angels surround thy way", "Thy reward is great"],
		"correct": 0,
		"exhortation": "Wherever you go across campus, the presence of the Almighty walks with you!"
	}
]


func _ready() -> void:
	name = "FellowshipDevotionDialog"
	visible = false
	_build_ui()


func _build_ui() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	# 1. Dark Backdrop
	var backdrop = ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.04, 0.06, 0.10, 0.75)
	add_child(backdrop)

	# 2. Center Card
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(560, 560)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.09, 0.13, 0.18, 0.98)
	style.border_color = Color(0.3, 0.7, 0.9, 1.0) # Celestial Cyan / Deep Gold
	style.set_border_width_all(2)
	style.set_corner_radius_all(14)
	style.content_margin_left = 22
	style.content_margin_top = 18
	style.content_margin_right = 22
	style.content_margin_bottom = 20
	panel.add_theme_stylebox_override(&"panel", style)
	center.add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override(&"separation", 10)
	panel.add_child(vbox)

	# Header HBox
	var header_hbox = HBoxContainer.new()
	vbox.add_child(header_hbox)

	var title_vbox = VBoxContainer.new()
	title_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_hbox.add_child(title_vbox)

	var title = Label.new()
	title.text = "✝️ CAMPUS CHRISTIAN FELLOWSHIP"
	title.add_theme_font_size_override(&"font_size", 17)
	title.add_theme_color_override(&"font_color", Color(1.0, 0.85, 0.3))
	title_vbox.add_child(title)

	var sub_title = Label.new()
	sub_title.text = "Daily Devotional & Scripture Sword Drill • Psalm 119:105"
	sub_title.add_theme_font_size_override(&"font_size", 12)
	sub_title.add_theme_color_override(&"font_color", Color(0.6, 0.85, 0.95))
	title_vbox.add_child(sub_title)

	var close_btn = Button.new()
	close_btn.text = "✕"
	close_btn.custom_minimum_size = Vector2(40, 40)
	close_btn.pressed.connect(close_dialog)
	header_hbox.add_child(close_btn)

	vbox.add_child(HSeparator.new())

	# Status / Progress Banner
	var stat_hbox = HBoxContainer.new()
	vbox.add_child(stat_hbox)

	round_lbl = Label.new()
	round_lbl.text = "Scripture 1 of 4 • Offering: ₦0"
	round_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	round_lbl.add_theme_font_size_override(&"font_size", 13)
	round_lbl.add_theme_color_override(&"font_color", Color(0.3, 0.9, 0.5))
	stat_hbox.add_child(round_lbl)

	scripture_ref_lbl = Label.new()
	scripture_ref_lbl.text = "📖 Proverbs 3:5-6"
	scripture_ref_lbl.add_theme_font_size_override(&"font_size", 13)
	scripture_ref_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.9, 0.4))
	stat_hbox.add_child(scripture_ref_lbl)

	# Scripture Verse Card
	var verse_panel = PanelContainer.new()
	var vp_style = StyleBoxFlat.new()
	vp_style.bg_color = Color(0.14, 0.18, 0.25, 0.95)
	vp_style.set_corner_radius_all(10)
	vp_style.content_margin_left = 16
	vp_style.content_margin_top = 14
	vp_style.content_margin_right = 16
	vp_style.content_margin_bottom = 14
	verse_panel.add_theme_stylebox_override(&"panel", vp_style)
	vbox.add_child(verse_panel)

	question_lbl = Label.new()
	question_lbl.text = "\"Trust in the LORD with all thine heart; and lean not unto thine own...\""
	question_lbl.add_theme_font_size_override(&"font_size", 15)
	question_lbl.add_theme_color_override(&"font_color", Color(0.96, 0.97, 1.0))
	question_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	verse_panel.add_child(question_lbl)

	feedback_lbl = Label.new()
	feedback_lbl.text = ""
	feedback_lbl.add_theme_font_size_override(&"font_size", 13)
	feedback_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.85, 0.2))
	feedback_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(feedback_lbl)

	# 4 Options Buttons Grid
	var opt_grid = GridContainer.new()
	opt_grid.columns = 2
	opt_grid.add_theme_constant_override(&"h_separation", 10)
	opt_grid.add_theme_constant_override(&"v_separation", 10)
	vbox.add_child(opt_grid)

	option_buttons.clear()
	for i in range(4):
		var btn = Button.new()
		btn.text = "Option %d" % (i + 1)
		btn.custom_minimum_size = Vector2(250, 48)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.add_theme_font_size_override(&"font_size", 14)
		btn.pressed.connect(func(): _on_option_selected(i))
		opt_grid.add_child(btn)
		option_buttons.append(btn)

	# Devotional Summary Panel (Hidden initially)
	summary_panel = PanelContainer.new()
	var s_style = StyleBoxFlat.new()
	s_style.bg_color = Color(0.08, 0.17, 0.14, 0.98)
	s_style.set_corner_radius_all(12)
	s_style.content_margin_left = 18
	s_style.content_margin_top = 16
	s_style.content_margin_right = 18
	s_style.content_margin_bottom = 16
	summary_panel.add_theme_stylebox_override(&"panel", s_style)
	summary_panel.visible = false
	vbox.add_child(summary_panel)

	var s_vbox = VBoxContainer.new()
	s_vbox.add_theme_constant_override(&"separation", 10)
	summary_panel.add_child(s_vbox)

	var s_title = Label.new()
	s_title.text = "🌟 DEVOTIONAL VICTORY & FELLOWSHIP BLESSINGS"
	s_title.add_theme_font_size_override(&"font_size", 17)
	s_title.add_theme_color_override(&"font_color", Color(1.0, 0.85, 0.2))
	s_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	s_vbox.add_child(s_title)

	summary_lbl = Label.new()
	summary_lbl.text = ""
	summary_lbl.add_theme_font_size_override(&"font_size", 13)
	summary_lbl.add_theme_color_override(&"font_color", Color(0.9, 0.95, 0.92))
	summary_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	s_vbox.add_child(summary_lbl)

	var ret_btn = Button.new()
	ret_btn.text = "⏎ Return to Chapel Altar"
	ret_btn.custom_minimum_size = Vector2(0, 42)
	ret_btn.pressed.connect(close_dialog)
	s_vbox.add_child(ret_btn)


func open_devotion(player: CharacterBody3D) -> void:
	current_player = player
	visible = true
	current_round = 0
	correct_answers = 0
	total_offering = 0
	if summary_panel:
		summary_panel.visible = false
	_next_scripture_round()


func close_dialog() -> void:
	visible = false
	is_round_active = false
	current_player = null
	dialog_closed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close_dialog()
		get_viewport().set_input_as_handled()


func _next_scripture_round() -> void:
	current_round += 1
	if current_round > max_rounds:
		_finish_devotion()
		return

	is_round_active = true
	if feedback_lbl:
		feedback_lbl.text = ""

	var pool = SCRIPTURE_BANK.duplicate()
	pool.shuffle()
	current_question = pool[0].duplicate(true)

	if round_lbl:
		round_lbl.text = "Scripture %d of %d • Love Offering: ₦%d" % [current_round, max_rounds, total_offering]

	if scripture_ref_lbl:
		scripture_ref_lbl.text = "📖 %s (%s)" % [current_question["ref"], current_question.get("theme", "Faith")]

	if question_lbl:
		question_lbl.text = current_question["verse"]

	# Shuffle options while tracking correct text
	var correct_text: String = current_question["options"][current_question["correct"]]
	var shuffled_opts: Array = current_question["options"].duplicate()
	shuffled_opts.shuffle()
	current_shuffled_correct = shuffled_opts.find(correct_text)

	for i in range(option_buttons.size()):
		var btn = option_buttons[i]
		if i < shuffled_opts.size():
			btn.visible = true
			btn.disabled = false
			btn.text = shuffled_opts[i]
		else:
			btn.visible = false


func _on_option_selected(idx: int) -> void:
	if not is_round_active:
		return

	is_round_active = false
	for btn in option_buttons:
		btn.disabled = true

	if idx == current_shuffled_correct:
		correct_answers += 1
		total_offering += 350
		if feedback_lbl:
			feedback_lbl.text = "✅ 'Amen! %s' (+₦350 Love Offering)" % current_question.get("exhortation", "Praise God!")
		if SoundManager:
			SoundManager.play_cheer()
			SoundManager.play_coin()
	else:
		if feedback_lbl:
			var correct_ans = current_question["options"][current_question["correct"]]
			feedback_lbl.text = "📖 'Keep studying! The answer is: %s.' — %s" % [correct_ans, current_question.get("exhortation", "")]
		if SoundManager:
			SoundManager.play_click()

	if round_lbl:
		round_lbl.text = "Scripture %d of %d • Love Offering: ₦%d" % [current_round, max_rounds, total_offering]

	# Delay 1.8s then proceed
	get_tree().create_timer(1.8).timeout.connect(func():
		_next_scripture_round()
	)


func _finish_devotion() -> void:
	is_round_active = false
	var base_grant: int = 500
	var total_award: int = base_grant + total_offering
	var faith_gain: float = 50.0

	if current_player:
		var needs = current_player.get_node_or_null("NeedsManager") as NeedsManager
		if needs:
			needs.modify_faith(faith_gain)
			needs.modify_energy(25.0)
			needs.modify_money(total_award)

		const ProfileStore = preload("res://scripts/data/student_profile.gd")
		ProfileStore.money = needs.money if needs else 0
		ProfileStore.save_to_disk()

		TimeSystem.advance_minutes(20)

		if current_player.has_method("play_pray_animation"):
			current_player.play_pray_animation()

	if SoundManager:
		SoundManager.play_cheer()

	if summary_panel and summary_lbl:
		summary_lbl.text = """Chapel Fellowship Pastor & Elders smile warmly:
'Hallelujah! "Thy word have I hid in mine heart, that I might not sin against thee." (Psalm 119:11).
You have demonstrated deep grounding in God's holy word and academic integrity.'

🕊️ Fellowship Grace & Blessings:
• Biblical Questions Mastered: %d of %d
• Alumni Fellowship Academic Grant: ₦%d
• Total Love Offering Awarded: ₦%d
• Spiritual Impartation: +%.0f Faith Points, +25 Energy, Peace of Mind (Fatigue 0%%)!""" % [
			correct_answers,
			max_rounds,
			base_grant,
			total_award,
			faith_gain
		]
		summary_panel.visible = true

	devotion_completed.emit(faith_gain, total_award)
