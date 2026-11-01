class_name PenaltyMiniGame
extends Control

## Interactive 3D Stadium Penalty Shootout Mini-Game for the Dean's Cup.
## Players select tactical strike corners, adjust shot power, and battle the Faculty
## Goalkeeper across authentic tournament rounds with zero gambling/wagering.

signal penalty_taken(corner: String, power: float, stake: int, is_goal: bool, payout: int)
signal dialog_closed

var current_player: CharacterBody3D = null
var selected_corner: String = "top_left"
var tournament_mode: String = "5_shot" # "5_shot", "final_3", "sudden_death"
var selected_stake: int = 0
var power: float = 60.0
var is_charging: bool = true
var charge_dir: float = 1.0
var is_striking: bool = false

# Tournament progress
var current_shot: int = 1
var max_shots: int = 5
var goals_scored: int = 0
var tournament_won: bool = false

# UI references
@onready var status_label: Label = %StatusLabel if has_node("%StatusLabel") else null
@onready var power_bar: ProgressBar = %PowerBar if has_node("%PowerBar") else null
@onready var strike_btn: Button = %StrikeBtn if has_node("%StrikeBtn") else null
@onready var exit_btn: Button = %ExitBtn if has_node("%ExitBtn") else null
@onready var stake_info_label: Label = %StakeInfoLabel if has_node("%StakeInfoLabel") else null

# Corner buttons
@onready var btn_tl: Button = %BtnTopLeft if has_node("%BtnTopLeft") else null
@onready var btn_tr: Button = %BtnTopRight if has_node("%BtnTopRight") else null
@onready var btn_roof: Button = %BtnRoof if has_node("%BtnRoof") else null
@onready var btn_bl: Button = %BtnBottomLeft if has_node("%BtnBottomLeft") else null
@onready var btn_br: Button = %BtnBottomRight if has_node("%BtnBottomRight") else null
@onready var btn_panenka: Button = %BtnPanenka if has_node("%BtnPanenka") else null

# Mode buttons (previously stake buttons, repurposed safely for tournament modes)
@onready var btn_stake_0: Button = %BtnStake0 if has_node("%BtnStake0") else null
@onready var btn_stake_500: Button = %BtnStake500 if has_node("%BtnStake500") else null
@onready var btn_stake_1500: Button = %BtnStake1500 if has_node("%BtnStake1500") else null


func _ready() -> void:
	visible = false
	_bind_buttons()
	_update_corner_buttons_visuals()
	_update_mode_buttons_visuals()


func _bind_buttons() -> void:
	if btn_tl: btn_tl.pressed.connect(func(): _select_corner("top_left"))
	if btn_roof: btn_roof.pressed.connect(func(): _select_corner("roof_center"))
	if btn_tr: btn_tr.pressed.connect(func(): _select_corner("top_right"))
	if btn_bl: btn_bl.pressed.connect(func(): _select_corner("bottom_left"))
	if btn_panenka: btn_panenka.pressed.connect(func(): _select_corner("panenka_center"))
	if btn_br: btn_br.pressed.connect(func(): _select_corner("bottom_right"))

	if btn_stake_0:
		btn_stake_0.text = "🏆 5-Shot Dean's Cup"
		btn_stake_0.pressed.connect(func(): _select_mode("5_shot", 5))
	if btn_stake_500:
		btn_stake_500.text = "🥇 3-Shot Final"
		btn_stake_500.pressed.connect(func(): _select_mode("final_3", 3))
	if btn_stake_1500:
		btn_stake_1500.text = "⚡ Golden Boot"
		btn_stake_1500.pressed.connect(func(): _select_mode("sudden_death", 1))

	if strike_btn: strike_btn.pressed.connect(strike)
	if exit_btn: exit_btn.pressed.connect(close_dialog)


func _process(delta: float) -> void:
	if not visible or is_striking:
		return

	# Oscillate shot power meter
	if is_charging:
		power += charge_dir * delta * 85.0
		if power >= 100.0:
			power = 100.0
			charge_dir = -1.0
		elif power <= 20.0:
			power = 20.0
			charge_dir = 1.0

		if power_bar:
			power_bar.value = power


func open_penalty(player: CharacterBody3D) -> void:
	current_player = player
	is_striking = false
	is_charging = true
	power = 60.0
	charge_dir = 1.0
	current_shot = 1
	goals_scored = 0
	tournament_won = false

	if status_label:
		status_label.text = "⚽ Shot %d/%d • Goals: %d • Aim for corners & time power!" % [current_shot, max_shots, goals_scored]
		status_label.add_theme_color_override(&"font_color", Color(0.35, 0.95, 0.65))

	_update_corner_buttons_visuals()
	_update_mode_buttons_visuals()
	visible = true


func close_dialog() -> void:
	visible = false
	current_player = null
	dialog_closed.emit()


func _select_corner(corner: String) -> void:
	selected_corner = corner
	_update_corner_buttons_visuals()
	if SoundManager: SoundManager.play_click()


func _select_stake(stake: int) -> void:
	selected_stake = stake
	if stake == 0:
		_select_mode("5_shot", 5)
	elif stake == 500:
		_select_mode("final_3", 3)
	else:
		_select_mode("sudden_death", 1)


func _select_mode(mode: String, shots: int) -> void:
	tournament_mode = mode
	max_shots = shots
	current_shot = 1
	goals_scored = 0
	_update_mode_buttons_visuals()
	if SoundManager: SoundManager.play_click()
	if status_label:
		status_label.text = "Mode Selected: %s (%d shots)! Aim corner and shoot!" % [mode.replace("_", " ").to_upper(), max_shots]


func _update_corner_buttons_visuals() -> void:
	var buttons = {
		"top_left": btn_tl,
		"roof_center": btn_roof,
		"top_right": btn_tr,
		"bottom_left": btn_bl,
		"panenka_center": btn_panenka,
		"bottom_right": btn_br
	}
	for key in buttons.keys():
		var btn: Button = buttons[key]
		if btn:
			if key == selected_corner:
				btn.add_theme_color_override(&"font_color", Color(1.0, 0.9, 0.2))
				btn.text = "★ " + _get_corner_label(key)
			else:
				btn.remove_theme_color_override(&"font_color")
				btn.text = _get_corner_label(key)


func _get_corner_label(corner: String) -> String:
	match corner:
		"top_left": return "↖ Top Bins (Left)"
		"roof_center": return "⬆ Roof Power (Center)"
		"top_right": return "↗ Postage Stamp (Right)"
		"bottom_left": return "↙ Low Driver (Left)"
		"panenka_center": return "⬇ Panenka Chip"
		"bottom_right": return "↘ Inside Post (Right)"
		_: return corner


func _update_mode_buttons_visuals() -> void:
	if btn_stake_0:
		btn_stake_0.add_theme_color_override(&"font_color", Color(0.3, 0.95, 0.55) if tournament_mode == "5_shot" else Color(0.8, 0.8, 0.8))
	if btn_stake_500:
		btn_stake_500.add_theme_color_override(&"font_color", Color(1.0, 0.85, 0.2) if tournament_mode == "final_3" else Color(0.8, 0.8, 0.8))
	if btn_stake_1500:
		btn_stake_1500.add_theme_color_override(&"font_color", Color(0.4, 0.85, 1.0) if tournament_mode == "sudden_death" else Color(0.8, 0.8, 0.8))

	if stake_info_label:
		stake_info_label.text = "🏆 Pure Athletic Tournament • Zero Gambling • Dean's Cup Gold Trophy & Grant on Victory!"


func strike() -> void:
	if is_striking:
		return

	is_striking = true
	is_charging = false

	TimeSystem.advance_minutes(5)

	if current_player and current_player.has_method("play_penalty_kick_animation"):
		current_player.play_penalty_kick_animation()
	if SoundManager:
		SoundManager.play_whistle()

	var shot_power = power
	var target_corner = selected_corner

	var dive_options = ["top_left", "roof_center", "top_right", "bottom_left", "panenka_center", "bottom_right"]
	var gk_dive = dive_options[randi() % dive_options.size()]

	var is_goal: bool = false
	var outcome_msg: String = ""
	var payout: int = 0

	if shot_power > 92.0:
		is_goal = false
		outcome_msg = "💨 OVER THE CROSSBAR! Shot was %.0f%% power — sailed over stadium fence!" % shot_power
		if SoundManager: SoundManager.play_alert()
	elif shot_power < 30.0:
		is_goal = false
		outcome_msg = "🧤 WEAK SHOT! Scuffed at %.0f%% power. Goalkeeper easily caught it." % shot_power
		if SoundManager: SoundManager.play_alert()
	elif gk_dive == target_corner:
		is_goal = false
		outcome_msg = "🧤 DIVE SAVE! Keeper dived to %s and pushed it wide!" % _get_corner_label(target_corner)
		if SoundManager: SoundManager.play_alert()
	else:
		is_goal = true
		goals_scored += 1
		payout = 800
		outcome_msg = "⚽ GOOOAAAL! Curled cleanly into %s! (Shot %d/%d • Goals: %d)" % [
			_get_corner_label(target_corner),
			current_shot,
			max_shots,
			goals_scored
		]
		if SoundManager:
			SoundManager.play_cheer()
			SoundManager.play_coin()

	# Process tournament completion
	var is_final_shot: bool = (current_shot >= max_shots)

	if current_player:
		var needs: NeedsManager = current_player.get_node_or_null("NeedsManager") as NeedsManager
		if needs:
			if is_goal:
				needs.modify_money(payout)
				needs.modify_faith(15.0)
				needs.modify_energy(15.0)
			else:
				needs.modify_energy(5.0)

			if is_final_shot:
				var min_goals_to_win = 3 if max_shots == 5 else (2 if max_shots == 3 else 1)
				if goals_scored >= min_goals_to_win:
					tournament_won = true
					var grand_prize: int = 3500
					needs.modify_money(grand_prize)
					needs.modify_faith(30.0)
					needs.modify_energy(30.0)
					outcome_msg = "🏆 DEAN'S CUP CHAMPIONS! Scored %d/%d goals! Awarded Dean's Athletic Grant (+₦%d) & Gold Cup!" % [goals_scored, max_shots, grand_prize]
					if SoundManager: SoundManager.play_cheer()
					if current_player.has_method("play_celebrate_animation"):
						current_player.play_celebrate_animation("🏆 DEAN'S CUP WINNER! +₦%d" % grand_prize)

		if is_goal and not is_final_shot and current_player.has_method("play_celebrate_animation"):
			current_player.play_celebrate_animation("⚽ GOAL! +₦%d" % payout)

		PropBuilder3D.advance_quest_if_matching(5, current_player)

	if status_label:
		status_label.text = outcome_msg
		status_label.add_theme_color_override(&"font_color", Color(0.3, 0.98, 0.5) if is_goal else Color(1.0, 0.7, 0.3))

	penalty_taken.emit(target_corner, shot_power, 0, is_goal, payout)

	current_shot += 1
	if current_shot > max_shots:
		# Reset for next session
		current_shot = 1
		goals_scored = 0

	get_tree().create_timer(1.8).timeout.connect(func():
		is_striking = false
		is_charging = true
	)
