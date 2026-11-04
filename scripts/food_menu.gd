class_name FoodMenu
extends Control

## Interactive Nigerian Cafeteria / Buka Food Menu & Lunch Shift Mini-Game.
## Allows students to buy dine-in/takeaway dishes and work fast-paced canteen shifts serving coursemates.

signal meal_purchased(item_name: String, cost: int, hunger_boost: float, energy_boost: float)
signal shift_completed(total_earned: int)
signal menu_closed

## --- EDITABLE FOOD CATALOG ---
@export var menu_items: Array[Dictionary] = [
	{
		"name": "Jollof Rice & Fried Chicken",
		"desc": "[Mama Cashout] Smoky party jollof with spicy drumstick.",
		"cost": 1200,
		"hunger": 65.0,
		"energy": 15.0,
		"time_minutes": 20
	},
	{
		"name": "Amala Lafun, Ewedu & Goat Meat",
		"desc": "[Iya Basira] Steaming piping-hot black amala with tender goat meat.",
		"cost": 1100,
		"hunger": 80.0,
		"energy": 12.0,
		"time_minutes": 22
	},
	{
		"name": "Indomie with Suya Beef & Eggs",
		"desc": "[Mallam Danladi] Spicy stir-fried noodles with grilled suya slices.",
		"cost": 850,
		"hunger": 55.0,
		"energy": 14.0,
		"time_minutes": 15
	},
	{
		"name": "Pounded Yam & Egusi Soup",
		"desc": "[Iya Basira] Heavy pounded yam with rich melon egusi & fish.",
		"cost": 1500,
		"hunger": 85.0,
		"energy": 5.0,
		"time_minutes": 25
	},
	{
		"name": "Hot Meat Pie & Chilled Zobo",
		"desc": "[Mama Cashout] Quick snack between 9am and 2pm lectures.",
		"cost": 450,
		"hunger": 25.0,
		"energy": 5.0,
		"time_minutes": 10
	},
	{
		"name": "Pure Water & Cabin Biscuit",
		"desc": "[Campus Kiosk] The legendary 'Sapa Special' emergency kit.",
		"cost": 100,
		"hunger": 10.0,
		"energy": 2.0,
		"time_minutes": 5
	},
	{
		"name": "Roasted Boli & Groundnuts",
		"desc": "[Iya Boli] Charcoal roasted sweet plantain with crunchy groundnuts.",
		"cost": 500,
		"hunger": 40.0,
		"energy": 20.0,
		"time_minutes": 15
	},
	{
		"name": "Fried Yam (Dundun) & Pepper Sauce",
		"desc": "[Iya Boli] Crispy golden yam slices with spicy peppered sauce.",
		"cost": 650,
		"hunger": 45.0,
		"energy": 22.0,
		"time_minutes": 15
	}
]

# Buffet components for Lunch Shift mini-game
const CARBS: Array[Dictionary] = [
	{"id": "jollof", "name": "Smoky Party Jollof", "icon": "🍚"},
	{"id": "white_rice", "name": "White Rice & Stew", "icon": "🍚"},
	{"id": "pounded_yam", "name": "Pounded Yam", "icon": "🍠"},
	{"id": "amala", "name": "Steaming Amala", "icon": "🍲"}
]

const PROTEINS: Array[Dictionary] = [
	{"id": "chicken", "name": "Fried Drumstick Chicken", "icon": "🍗"},
	{"id": "goat_meat", "name": "Tender Goat Meat", "icon": "🍖"},
	{"id": "fish", "name": "Grilled Tilapia Fish", "icon": "🐟"},
	{"id": "egg_suya", "name": "Boiled Egg & Suya", "icon": "🥚"}
]

const SIDES: Array[Dictionary] = [
	{"id": "dodo", "name": "Fried Sweet Plantain (Dodo)", "icon": "🍌"},
	{"id": "egusi", "name": "Melon Egusi Soup", "icon": "🥣"},
	{"id": "moi_moi", "name": "Steamed Moi-Moi", "icon": "🫔"},
	{"id": "salad", "name": "Canteen Fresh Salad", "icon": "🥗"}
]

const CUSTOMERS: Array[Dictionary] = [
	{
		"name": "Femi (200L Engineering)",
		"intro": "\"Senior man, please fast! I have 2 PM circuit theory lecture! Serve me:\"",
		"carb": "jollof", "protein": "chicken", "side": "dodo"
	},
	{
		"name": "Zainab (300L Pharmacy)",
		"intro": "\"Good afternoon! Heavy hunger from biochemistry lab! Please give me:\"",
		"carb": "pounded_yam", "protein": "goat_meat", "side": "egusi"
	},
	{
		"name": "Kelechi (100L Computer Science)",
		"intro": "\"Mallam, fresh combo please! Coding marathon all night! I need:\"",
		"carb": "jollof", "protein": "fish", "side": "moi_moi"
	},
	{
		"name": "Blessing (400L Law Finalist)",
		"intro": "\"Coursemate, make it plenty pepper sauce! Fast lunch before moot court:\"",
		"carb": "white_rice", "protein": "chicken", "side": "dodo"
	},
	{
		"name": "Tobi (Student Union Senate PRO)",
		"intro": "\"Comrade, solid nourishment required for senate consultation! Dish me:\"",
		"carb": "amala", "protein": "goat_meat", "side": "egusi"
	}
]

@onready var items_container: VBoxContainer = %ItemsContainer
@onready var wallet_label: Label = %WalletLabel
@onready var close_button: Button = %CloseButton

var current_player: CharacterBody3D = null

# UI Navigation & Shift containers
var menu_scroll: ScrollContainer = null
var tab_bar: HBoxContainer = null
var menu_tab_btn: Button = null
var shift_tab_btn: Button = null
var shift_box: VBoxContainer = null

# Shift state
var is_in_shift: bool = false
var shift_round: int = 0
var max_shift_rounds: int = 4
var shift_tips: int = 0
var base_shift_wage: int = 1500
var current_customer_order: Dictionary = {}
var current_plate: Dictionary = {"carb": "", "protein": "", "side": ""}
var patience_timer: float = 14.0
var max_patience: float = 14.0
var shift_active: bool = false

# Shift UI widgets
var shift_status_lbl: Label = null
var patience_bar: ProgressBar = null
var customer_name_lbl: Label = null
var customer_quote_lbl: Label = null
var order_badge_box: HBoxContainer = null
var plate_summary_lbl: Label = null
var feedback_lbl: Label = null
var serve_btn: Button = null
var clear_btn: Button = null
var carb_buttons: Dictionary = {}
var protein_buttons: Dictionary = {}
var side_buttons: Dictionary = {}
var results_panel: PanelContainer = null
var results_lbl: Label = null


func _ready() -> void:
	visible = false
	if close_button:
		close_button.pressed.connect(close_menu)

	if items_container:
		menu_scroll = items_container.get_parent() as ScrollContainer
		var vbox = menu_scroll.get_parent() as VBoxContainer
		if vbox:
			_setup_tabs_and_shift(vbox)


func _setup_tabs_and_shift(parent_vbox: VBoxContainer) -> void:
	# 1. Navigation Tab Bar (Placed right above menu scroll)
	tab_bar = HBoxContainer.new()
	tab_bar.add_theme_constant_override(&"separation", 10)
	var scroll_idx = menu_scroll.get_index()
	parent_vbox.add_child(tab_bar)
	parent_vbox.move_child(tab_bar, scroll_idx)

	menu_tab_btn = Button.new()
	menu_tab_btn.text = "🍽️ Canteen Menu"
	menu_tab_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu_tab_btn.custom_minimum_size = Vector2(0, 38)
	menu_tab_btn.pressed.connect(func(): _switch_mode(false))
	tab_bar.add_child(menu_tab_btn)

	shift_tab_btn = Button.new()
	shift_tab_btn.text = "🍳 Work Lunch Rush Shift (Earn ₦2,000+)"
	shift_tab_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shift_tab_btn.custom_minimum_size = Vector2(0, 38)
	shift_tab_btn.pressed.connect(func(): _switch_mode(true))
	tab_bar.add_child(shift_tab_btn)

	# 2. Shift Container (Placed under tab bar)
	shift_box = VBoxContainer.new()
	shift_box.visible = false
	shift_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	shift_box.add_theme_constant_override(&"separation", 10)
	parent_vbox.add_child(shift_box)
	parent_vbox.move_child(shift_box, scroll_idx + 1)

	_build_shift_ui()


func _build_shift_ui() -> void:
	# Shift Dashboard Header
	var dash_panel = PanelContainer.new()
	var d_style = StyleBoxFlat.new()
	d_style.bg_color = Color(0.12, 0.15, 0.20, 0.95)
	d_style.set_corner_radius_all(8)
	d_style.content_margin_left = 12
	d_style.content_margin_top = 8
	d_style.content_margin_right = 12
	d_style.content_margin_bottom = 8
	dash_panel.add_theme_stylebox_override(&"panel", d_style)
	shift_box.add_child(dash_panel)

	var dash_vbox = VBoxContainer.new()
	dash_vbox.add_theme_constant_override(&"separation", 4)
	dash_panel.add_child(dash_vbox)

	var h_dash = HBoxContainer.new()
	dash_vbox.add_child(h_dash)

	var title = Label.new()
	title.text = "🍳 MAMA CASHOUT 1:00 PM LUNCH RUSH"
	title.add_theme_font_size_override(&"font_size", 14)
	title.add_theme_color_override(&"font_color", Color(1.0, 0.8, 0.2))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h_dash.add_child(title)

	shift_status_lbl = Label.new()
	shift_status_lbl.text = "Order 1 of 4 • Tips: ₦0"
	shift_status_lbl.add_theme_font_size_override(&"font_size", 13)
	shift_status_lbl.add_theme_color_override(&"font_color", Color(0.3, 0.9, 0.5))
	h_dash.add_child(shift_status_lbl)

	patience_bar = ProgressBar.new()
	patience_bar.max_value = 100.0
	patience_bar.value = 100.0
	patience_bar.custom_minimum_size = Vector2(0, 14)
	patience_bar.show_percentage = false
	dash_vbox.add_child(patience_bar)

	# Customer Speech Bubble
	var cust_panel = PanelContainer.new()
	var c_style = StyleBoxFlat.new()
	c_style.bg_color = Color(0.16, 0.20, 0.27, 0.95)
	c_style.set_corner_radius_all(10)
	c_style.content_margin_left = 14
	c_style.content_margin_top = 10
	c_style.content_margin_right = 14
	c_style.content_margin_bottom = 10
	cust_panel.add_theme_stylebox_override(&"panel", c_style)
	shift_box.add_child(cust_panel)

	var cust_vbox = VBoxContainer.new()
	cust_vbox.add_theme_constant_override(&"separation", 4)
	cust_panel.add_child(cust_vbox)

	customer_name_lbl = Label.new()
	customer_name_lbl.text = "Customer: Femi (200L Engineering)"
	customer_name_lbl.add_theme_font_size_override(&"font_size", 14)
	customer_name_lbl.add_theme_color_override(&"font_color", Color(0.4, 0.8, 1.0))
	cust_vbox.add_child(customer_name_lbl)

	customer_quote_lbl = Label.new()
	customer_quote_lbl.text = "\"Senior man, please fast! I have 2 PM circuit lecture!\""
	customer_quote_lbl.add_theme_font_size_override(&"font_size", 13)
	customer_quote_lbl.add_theme_color_override(&"font_color", Color(0.9, 0.92, 0.96))
	customer_quote_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cust_vbox.add_child(customer_quote_lbl)

	order_badge_box = HBoxContainer.new()
	order_badge_box.add_theme_constant_override(&"separation", 8)
	cust_vbox.add_child(order_badge_box)

	feedback_lbl = Label.new()
	feedback_lbl.text = ""
	feedback_lbl.add_theme_font_size_override(&"font_size", 13)
	feedback_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.85, 0.2))
	cust_vbox.add_child(feedback_lbl)

	# Hot Serving Counter / Buffet Trays
	var buffet_lbl = Label.new()
	buffet_lbl.text = "HOT SERVING COUNTER (Select 1 Carb + 1 Protein + 1 Side):"
	buffet_lbl.add_theme_font_size_override(&"font_size", 12)
	buffet_lbl.add_theme_color_override(&"font_color", Color(0.7, 0.8, 0.9))
	shift_box.add_child(buffet_lbl)

	# 1. Carbs Tray
	var carbs_hbox = HBoxContainer.new()
	carbs_hbox.add_theme_constant_override(&"separation", 6)
	shift_box.add_child(carbs_hbox)
	for item in CARBS:
		var btn = Button.new()
		btn.text = "%s %s" % [item["icon"], item["name"]]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size = Vector2(0, 36)
		btn.add_theme_font_size_override(&"font_size", 12)
		btn.pressed.connect(func(): _select_food_item("carb", item["id"]))
		carbs_hbox.add_child(btn)
		carb_buttons[item["id"]] = btn

	# 2. Proteins Tray
	var prot_hbox = HBoxContainer.new()
	prot_hbox.add_theme_constant_override(&"separation", 6)
	shift_box.add_child(prot_hbox)
	for item in PROTEINS:
		var btn = Button.new()
		btn.text = "%s %s" % [item["icon"], item["name"]]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size = Vector2(0, 36)
		btn.add_theme_font_size_override(&"font_size", 12)
		btn.pressed.connect(func(): _select_food_item("protein", item["id"]))
		prot_hbox.add_child(btn)
		protein_buttons[item["id"]] = btn

	# 3. Sides Tray
	var side_hbox = HBoxContainer.new()
	side_hbox.add_theme_constant_override(&"separation", 6)
	shift_box.add_child(side_hbox)
	for item in SIDES:
		var btn = Button.new()
		btn.text = "%s %s" % [item["icon"], item["name"]]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size = Vector2(0, 36)
		btn.add_theme_font_size_override(&"font_size", 12)
		btn.pressed.connect(func(): _select_food_item("side", item["id"]))
		side_hbox.add_child(btn)
		side_buttons[item["id"]] = btn

	# Assembled Plate Preview & Actions
	var plate_panel = PanelContainer.new()
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = Color(0.1, 0.12, 0.16, 0.95)
	p_style.set_corner_radius_all(8)
	p_style.content_margin_left = 12
	p_style.content_margin_top = 8
	p_style.content_margin_right = 12
	p_style.content_margin_bottom = 8
	plate_panel.add_theme_stylebox_override(&"panel", p_style)
	shift_box.add_child(plate_panel)

	var plate_vbox = VBoxContainer.new()
	plate_vbox.add_theme_constant_override(&"separation", 6)
	plate_panel.add_child(plate_vbox)

	plate_summary_lbl = Label.new()
	plate_summary_lbl.text = "Plate: [Carb: None] + [Protein: None] + [Side: None]"
	plate_summary_lbl.add_theme_font_size_override(&"font_size", 13)
	plate_summary_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.9, 0.5))
	plate_vbox.add_child(plate_summary_lbl)

	var act_hbox = HBoxContainer.new()
	act_hbox.add_theme_constant_override(&"separation", 10)
	plate_vbox.add_child(act_hbox)

	clear_btn = Button.new()
	clear_btn.text = "↺ Clear Plate"
	clear_btn.custom_minimum_size = Vector2(120, 40)
	clear_btn.pressed.connect(_clear_current_plate)
	act_hbox.add_child(clear_btn)

	serve_btn = Button.new()
	serve_btn.text = "🍽️ SERVE PLATE TO CUSTOMER"
	serve_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	serve_btn.custom_minimum_size = Vector2(0, 40)
	serve_btn.add_theme_font_size_override(&"font_size", 14)
	serve_btn.pressed.connect(_on_serve_plate)
	act_hbox.add_child(serve_btn)

	# Shift Completion Panel (Hidden until finish)
	results_panel = PanelContainer.new()
	var r_style = StyleBoxFlat.new()
	r_style.bg_color = Color(0.08, 0.16, 0.12, 0.98)
	r_style.set_corner_radius_all(12)
	r_style.content_margin_left = 18
	r_style.content_margin_top = 16
	r_style.content_margin_right = 18
	r_style.content_margin_bottom = 16
	results_panel.add_theme_stylebox_override(&"panel", r_style)
	results_panel.visible = false
	shift_box.add_child(results_panel)

	var r_vbox = VBoxContainer.new()
	r_vbox.add_theme_constant_override(&"separation", 10)
	results_panel.add_child(r_vbox)

	var r_title = Label.new()
	r_title.text = "🎉 LUNCH SHIFT COMPLETED!"
	r_title.add_theme_font_size_override(&"font_size", 18)
	r_title.add_theme_color_override(&"font_color", Color(1.0, 0.85, 0.2))
	r_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	r_vbox.add_child(r_title)

	results_lbl = Label.new()
	results_lbl.text = ""
	results_lbl.add_theme_font_size_override(&"font_size", 14)
	results_lbl.add_theme_color_override(&"font_color", Color(0.9, 0.95, 0.92))
	results_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	r_vbox.add_child(results_lbl)

	var return_btn = Button.new()
	return_btn.text = "⏎ Return to Canteen Menu"
	return_btn.custom_minimum_size = Vector2(0, 44)
	return_btn.pressed.connect(func(): _switch_mode(false))
	r_vbox.add_child(return_btn)


func _process(delta: float) -> void:
	if shift_active and patience_bar:
		patience_timer -= delta
		patience_bar.value = maxf(0.0, (patience_timer / max_patience) * 100.0)
		if patience_timer <= 0.0:
			_on_patience_expired()


func _switch_mode(to_shift: bool) -> void:
	is_in_shift = to_shift
	if menu_scroll:
		menu_scroll.visible = not to_shift
	if shift_box:
		shift_box.visible = to_shift

	if menu_tab_btn:
		menu_tab_btn.disabled = not to_shift
	if shift_tab_btn:
		shift_tab_btn.disabled = to_shift

	if to_shift:
		start_lunch_shift()
	else:
		shift_active = false
		if results_panel:
			results_panel.visible = false
		_populate_items()


func start_lunch_shift() -> void:
	shift_round = 0
	shift_tips = 0
	shift_active = true
	if results_panel:
		results_panel.visible = false
	_next_customer_order()


func _next_customer_order() -> void:
	shift_round += 1
	if shift_round > max_shift_rounds:
		_finish_shift()
		return

	_clear_current_plate()
	patience_timer = max_patience
	if feedback_lbl:
		feedback_lbl.text = ""

	var pool = CUSTOMERS.duplicate()
	pool.shuffle()
	current_customer_order = pool[0]

	if shift_status_lbl:
		shift_status_lbl.text = "Order %d of %d • Tips: ₦%s" % [shift_round, max_shift_rounds, _format_number(shift_tips)]

	if customer_name_lbl:
		customer_name_lbl.text = "Customer: %s" % current_customer_order["name"]

	if customer_quote_lbl:
		customer_quote_lbl.text = current_customer_order["intro"]

	# Render Order Badges
	if order_badge_box:
		for c in order_badge_box.get_children():
			c.queue_free()

		var carb_item = _find_dish(CARBS, current_customer_order["carb"])
		var prot_item = _find_dish(PROTEINS, current_customer_order["protein"])
		var side_item = _find_dish(SIDES, current_customer_order["side"])

		_add_badge(order_badge_box, "%s %s" % [carb_item.get("icon", ""), carb_item.get("name", "")], Color(0.9, 0.7, 0.2))
		_add_badge(order_badge_box, "%s %s" % [prot_item.get("icon", ""), prot_item.get("name", "")], Color(0.9, 0.4, 0.3))
		_add_badge(order_badge_box, "%s %s" % [side_item.get("icon", ""), side_item.get("name", "")], Color(0.3, 0.8, 0.5))


func _add_badge(parent: HBoxContainer, text: String, color: Color) -> void:
	var badge = Label.new()
	badge.text = "[ %s ]" % text
	badge.add_theme_font_size_override(&"font_size", 12)
	badge.add_theme_color_override(&"font_color", color)
	parent.add_child(badge)


func _find_dish(catalog: Array[Dictionary], dish_id: String) -> Dictionary:
	for d in catalog:
		if d["id"] == dish_id:
			return d
	return {}


func _select_food_item(cat: String, dish_id: String) -> void:
	if not shift_active:
		return
	current_plate[cat] = dish_id
	if SoundManager:
		SoundManager.play_click()
	_update_plate_display()


func _clear_current_plate() -> void:
	current_plate = {"carb": "", "protein": "", "side": ""}
	_update_plate_display()


func _update_plate_display() -> void:
	var carb_item = _find_dish(CARBS, current_plate["carb"])
	var prot_item = _find_dish(PROTEINS, current_plate["protein"])
	var side_item = _find_dish(SIDES, current_plate["side"])

	var c_txt = carb_item.get("name", "None")
	var p_txt = prot_item.get("name", "None")
	var s_txt = side_item.get("name", "None")

	if plate_summary_lbl:
		plate_summary_lbl.text = "Plate: [%s] + [%s] + [%s]" % [c_txt, p_txt, s_txt]


func _on_serve_plate() -> void:
	if not shift_active:
		return

	var matches: int = 0
	if current_plate["carb"] == current_customer_order["carb"]:
		matches += 1
	if current_plate["protein"] == current_customer_order["protein"]:
		matches += 1
	if current_plate["side"] == current_customer_order["side"]:
		matches += 1

	var tip: int = 0
	var remark: String = ""

	if matches == 3:
		tip = 650
		remark = "🌟 'Oshey! Correct combination! You sabi work! Take ₦650 tip!'"
		if SoundManager:
			SoundManager.play_cheer()
			SoundManager.play_coin()
	elif matches >= 1:
		tip = 350
		remark = "👍 'Nice one! Almost exact! Take ₦350 tip!'"
		if SoundManager:
			SoundManager.play_coin()
	else:
		tip = 150
		remark = "😅 'Coursemate, this isn't my order, but hunger is catching me. ₦150!'"

	shift_tips += tip
	_show_feedback(remark, tip)


func _on_patience_expired() -> void:
	var tip = 200
	shift_tips += tip
	var remark = "⏰ 'Ah, time is up! Let me rush to class with this! Take ₦200!'"
	if SoundManager:
		SoundManager.play_coin()
	_show_feedback(remark, tip)


func _show_feedback(remark: String, tip: int) -> void:
	shift_active = false
	if feedback_lbl:
		feedback_lbl.text = "%s (+₦%d Tip)" % [remark, tip]

	if shift_status_lbl:
		shift_status_lbl.text = "Order %d of %d • Tips: ₦%s" % [shift_round, max_shift_rounds, _format_number(shift_tips)]

	# Delay 1.4s then advance
	get_tree().create_timer(1.4).timeout.connect(func():
		shift_active = true
		_next_customer_order()
	)


func _finish_shift() -> void:
	shift_active = false
	var total_earned = base_shift_wage + shift_tips

	if current_player:
		var needs = current_player.get_node_or_null("NeedsManager") as NeedsManager
		if needs:
			needs.modify_money(total_earned)
			needs.modify_hunger(45.0)
			needs.modify_energy(15.0)
			needs.modify_faith(20.0)

		const ProfileStore = preload("res://scripts/data/student_profile.gd")
		ProfileStore.money = needs.money if needs else 0
		ProfileStore.save_to_disk()

		TimeSystem.advance_minutes(20)

	if SoundManager:
		SoundManager.play_cheer()

	if results_panel and results_lbl:
		results_lbl.text = """Mama Cashout beams proudly:
'Oshey my pikin! You rescued me during this 1:00 PM rush hour! All the engineering and pharmacy students got hot food on time! God bless your hustle!'

📊 Shift Earnings Breakdown:
• Base Canteen Wage: ₦%s
• Student Customer Tips: ₦%s
• Total Payout: ₦%s
• Free Canteen Meal: +45%% Hunger filled, +15 Energy, +20 Faith!""" % [
			_format_number(base_shift_wage),
			_format_number(shift_tips),
			_format_number(total_earned)
		]
		results_panel.visible = true

	shift_completed.emit(total_earned)


func open_menu(player: CharacterBody3D) -> void:
	current_player = player
	visible = true
	_switch_mode(false)


func close_menu() -> void:
	visible = false
	shift_active = false
	current_player = null
	menu_closed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close_menu()
		get_viewport().set_input_as_handled()


func _populate_items() -> void:
	for child: Node in items_container.get_children():
		child.queue_free()

	if not current_player:
		return

	var needs: NeedsManager = current_player.get_node_or_null("NeedsManager") as NeedsManager
	var player_money: int = needs.money if needs else 0

	if wallet_label:
		wallet_label.text = "Your Wallet: ₦%s" % _format_number(player_money)

	for item: Dictionary in menu_items:
		var card: PanelContainer = _create_food_card(item, player_money)
		items_container.add_child(card)


func _create_food_card(item: Dictionary, player_money: int) -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.14, 0.17, 0.22, 0.95)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_right = 10
	style.corner_radius_bottom_left = 10
	style.content_margin_left = 16
	style.content_margin_top = 12
	style.content_margin_right = 16
	style.content_margin_bottom = 12
	panel.add_theme_stylebox_override(&"panel", style)

	var hbox: HBoxContainer = HBoxContainer.new()
	hbox.add_theme_constant_override(&"separation", 14)
	panel.add_child(hbox)

	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override(&"separation", 4)
	hbox.add_child(vbox)

	var title_lbl: Label = Label.new()
	title_lbl.text = String(item["name"])
	title_lbl.add_theme_font_size_override(&"font_size", 17)
	title_lbl.add_theme_color_override(&"font_color", Color(1.0, 0.9, 0.4))
	vbox.add_child(title_lbl)

	var desc_lbl: Label = Label.new()
	desc_lbl.text = "%s  •  (+%d Hunger, +%d Energy)" % [String(item["desc"]), int(item["hunger"]), int(item["energy"])]
	desc_lbl.add_theme_font_size_override(&"font_size", 13)
	desc_lbl.add_theme_color_override(&"font_color", Color(0.85, 0.88, 0.94))
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(desc_lbl)

	var btn_vbox: VBoxContainer = VBoxContainer.new()
	btn_vbox.add_theme_constant_override(&"separation", 8)
	hbox.add_child(btn_vbox)

	var cost: int = int(item["cost"])
	var takeaway_cost: int = cost + 100

	var dine_btn: Button = Button.new()
	dine_btn.text = "🍽️ Dine Here ₦%s" % _format_number(cost)
	dine_btn.custom_minimum_size = Vector2(150, 48)
	dine_btn.add_theme_font_size_override(&"font_size", 14)
	if player_money < cost:
		dine_btn.disabled = true
		dine_btn.text = "₦%s (Can't Afford)" % _format_number(cost)
	else:
		dine_btn.pressed.connect(_on_buy_pressed.bind(item))
	btn_vbox.add_child(dine_btn)

	var takeaway_btn: Button = Button.new()
	takeaway_btn.text = "🥡 Takeaway ₦%s" % _format_number(takeaway_cost)
	takeaway_btn.custom_minimum_size = Vector2(150, 48)
	takeaway_btn.add_theme_font_size_override(&"font_size", 14)
	if player_money < takeaway_cost:
		takeaway_btn.disabled = true
		takeaway_btn.text = "🥡 ₦%s (Can't Afford)" % _format_number(takeaway_cost)
	else:
		takeaway_btn.pressed.connect(_on_takeaway_pressed.bind(item))
	btn_vbox.add_child(takeaway_btn)

	return panel


func _on_buy_pressed(item: Dictionary) -> void:
	if not current_player:
		return

	var needs: NeedsManager = current_player.get_node_or_null("NeedsManager") as NeedsManager
	if not needs:
		return

	var cost: int = int(item["cost"])
	if needs.modify_money(-cost):
		const PropBuilder = preload("res://scripts/data/prop_builder_3d.gd")
		PropBuilder.complete_semester_task(4)
		needs.modify_hunger(float(item["hunger"]))
		needs.modify_energy(float(item["energy"]))
		TimeSystem.advance_minutes(int(item["time_minutes"]))

		if current_player.has_method("play_eating_animation"):
			current_player.play_eating_animation()

		if current_player.has_method("display_notification"):
			current_player.display_notification("Dined on %s! Paid ₦%s." % [String(item["name"]), _format_number(cost)])

		if SoundManager:
			SoundManager.play_coin()

		_populate_items()
		meal_purchased.emit(String(item["name"]), cost, float(item["hunger"]), float(item["energy"]))


func _on_takeaway_pressed(item: Dictionary) -> void:
	if not current_player:
		return

	var needs: NeedsManager = current_player.get_node_or_null("NeedsManager") as NeedsManager
	if not needs:
		return

	var cost: int = int(item["cost"])
	var total_cost: int = cost + 100

	if needs.modify_money(-total_cost):
		TimeSystem.advance_minutes(5)

		const ProfileStore = preload("res://scripts/data/student_profile.gd")
		var item_id: String = "takeaway_" + String(item["name"]).to_lower().replace(" ", "_").replace("&", "and")
		var takeaway_item: Dictionary = {
			"id": item_id,
			"name": "Takeaway: %s" % String(item["name"]),
			"type": "food",
			"hunger": float(item["hunger"]),
			"energy": float(item["energy"]),
			"desc": "Sealed warm takeaway food pack. Eat anywhere or store in hostel fridge.",
			"count": 1
		}
		ProfileStore.add_backpack_item(takeaway_item)

		if current_player.has_method("display_notification"):
			current_player.display_notification("🥡 Packed %s (+₦100 pack)! Added to backpack." % String(item["name"]))

		if SoundManager:
			SoundManager.play_coin()

		_populate_items()
		meal_purchased.emit(String(item["name"]), total_cost, float(item["hunger"]), float(item["energy"]))


func _format_number(n: int) -> String:
	var s: String = str(n)
	var idx: int = s.length() - 3
	while idx > 0:
		s = s.insert(idx, ",")
		idx -= 3
	return s
