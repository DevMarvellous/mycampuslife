class_name TechHubRoom
extends "res://scripts/base_room.gd"

## Silicon Lagoon Tech Hub & Campus Wellness Clinic (Room 16) Controller.
## Modern Nigerian campus innovation lab + student medical & mental wellness bay:
## - Tech Bro Segun (Software Lead & Hackathon Mentor), Nurse Amaka (Campus Clinic Officer)
## - Coding & Hackathon Workstation, AI Research Lab Desk, VR Esports Pod, Wellness Rest Bay
## - Dual rotating ceiling fans & emergency medical recovery if a student passes out

@onready var ceiling_fan_1: MeshInstance3D = get_node_or_null("HubFixtures/CeilingFan1") as MeshInstance3D
@onready var ceiling_fan_2: MeshInstance3D = get_node_or_null("HubFixtures/CeilingFan2") as MeshInstance3D
@onready var clinic_dispenser: CampusObject3D = get_node_or_null("WorldObjects/ClinicPharmacyDispenser") as CampusObject3D
@onready var segun_npc: NPC3D = get_node_or_null("NPCs/TechBroSegun") as NPC3D
@onready var ai_robotics_lab: CampusObject3D = get_node_or_null("WorldObjects/AIRoboticsLab") as CampusObject3D


func _ready() -> void:
	room_name = "Silicon Lagoon Tech Hub & Wellness Clinic"
	room_id = &"tech_hub"
	super._ready()

	if ceiling_fan_1:
		active_ceiling_fans.append(ceiling_fan_1)
	if ceiling_fan_2:
		active_ceiling_fans.append(ceiling_fan_2)
	if clinic_dispenser:
		clinic_dispenser.interacted.connect(_on_clinic_dispenser_interacted)
	if segun_npc:
		segun_npc.dialogue_requested.connect(_on_segun_dialogue_requested)
	if ai_robotics_lab:
		ai_robotics_lab.interacted.connect(_on_ai_robotics_lab_interacted)


func _on_segun_dialogue_requested(_npc: NPC3D, pl: CharacterBody3D) -> void:
	if not pl:
		return
	var needs: NeedsManager = pl.get_node_or_null("NeedsManager") as NeedsManager
	var ideas: Array[String] = [
		"Hostel Solar Inverter Automation",
		"Campus Danfo Live Route Tracker",
		"E-Library Past Questions AI Revision",
		"Mama Put Queue Smart Ticket App"
	]
	var chosen_idea: String = ideas[randi() % ideas.size()]
	if needs and needs.energy >= 15.0:
		needs.modify_energy(-12.0)
		needs.modify_money(4500)
		needs.modify_cgpa(0.05)
		needs.modify_faith(10.0)
		TimeSystem.advance_minutes(30)
		if SoundManager:
			SoundManager.play_cheer()
		if pl.has_method("play_celebrate_animation"):
			pl.play_celebrate_animation("★ HACKATHON PITCH WON!")
		if pl.has_method("display_notification"):
			pl.display_notification("★ TECH BRO SEGUN MENTORSHIP: Pitched '%s'! Tech Hub Innovation Grant (+₦4,500, +0.05 CGPA, +10 Faith)!" % chosen_idea)
	else:
		if pl.has_method("display_notification"):
			pl.display_notification("💻 Tech Bro Segun: 'You look exhausted, dev! Grab Vitamin C from Nurse Amaka before coding your pitch!'")


func _on_ai_robotics_lab_interacted() -> void:
	if not player:
		return
	var needs: NeedsManager = player.get_node_or_null("NeedsManager") as NeedsManager
	if needs and needs.energy >= 10.0:
		needs.modify_energy(-10.0)
		needs.modify_cgpa(0.06)
		TimeSystem.advance_minutes(25)
		if SoundManager:
			SoundManager.play_click()
		if player.has_method("display_notification"):
			player.display_notification("🤖 AI & ROBOTICS LAB: Trained machine learning model for university coursework (+0.06 CGPA)!")
	else:
		if player.has_method("display_notification"):
			player.display_notification("🤖 AI Research Lab: Low energy! Take a rest in the Wellness Clinic.")


func _on_clinic_dispenser_interacted() -> void:
	if not player:
		return
	var needs: NeedsManager = player.get_node_or_null("NeedsManager") as NeedsManager
	if needs:
		needs.modify_energy(35.0)
		needs.modify_faith(15.0)
	StudentProfile.add_backpack_item({
		"id": "vitamin_c_pack",
		"name": "Chemist Vitamin C & Malt Pack",
		"type": "food",
		"hunger": 25.0,
		"energy": 40.0,
		"desc": "Campus Chemist wellness booster pack dispensed by Nurse Amaka.",
		"count": 1
	})
	if player.has_method("display_notification"):
		player.display_notification("● NURSE AMAKA WELLNESS CHECK: +35% Energy, +15 Faith & +1 Chemist Vitamin C Pack added to Backpack!")


func _on_player_passed_out(_reason: String) -> void:
	# Nurse Amaka immediately treats the student in the Campus Wellness Clinic
	if player:
		var needs: NeedsManager = player.get_node_or_null("NeedsManager") as NeedsManager
		if needs:
			needs.modify_hunger(55.0)
			needs.modify_energy(65.0)
			needs.modify_faith(25.0)
		TimeSystem.advance_minutes(20)
		if SoundManager:
			SoundManager.play_cheer()
		if player.has_method("display_notification"):
			player.display_notification("🏥 Nurse Amaka treats you at the Campus Clinic: 'Take this Lucozade Boost & Vitamin C! Don't burn out coding all night!' (+65 Energy, +55 Hunger)")
		player.global_position = Vector3(5.5, 0.1, 1.5)

