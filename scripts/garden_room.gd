class_name GardenRoom
extends "res://scripts/base_room.gd"

## Campus Botanical Gardens & Nature Sanctuary (Room 11) Controller.
## Scenic outdoor relaxation, meditation & street food haven:
## - Iya Boli (Sweet Roasted Plantain & Pepper Fish Vendor)
## - Final Year Senior Tobi
## - Charcoal smoke particles, park benches, nature canopy trees
## - Stress relief, prayer walk, and passing out rescue

@onready var park_bench: CampusObject3D = get_node_or_null("WorldObjects/ParkBench") as CampusObject3D
@onready var iya_boli_stand: CampusObject3D = get_node_or_null("WorldObjects/IyaBoliStand") as CampusObject3D
@onready var tobi_npc: NPC3D = get_node_or_null("NPCs/StudentChilling") as NPC3D


func _ready() -> void:
	room_name = "Campus Botanical Gardens & Quiet Park"
	room_id = &"garden"
	super._ready()

	if park_bench:
		park_bench.interacted.connect(_on_park_bench_interacted)
	if tobi_npc:
		tobi_npc.dialogue_requested.connect(_on_tobi_dialogue_requested)


func _on_park_bench_interacted() -> void:
	if not player:
		return
	var needs: NeedsManager = player.get_node_or_null("NeedsManager") as NeedsManager
	if needs:
		needs.modify_energy(25.0)
		needs.modify_faith(20.0)
	TimeSystem.advance_minutes(20)
	if player.has_method("play_pray_animation"):
		player.play_pray_animation()
	if player.has_method("display_notification"):
		player.display_notification("🌿 BOTANICAL PEACE WALK: Meditated under the park shade trees. Peace of Mind granted! (+25 Energy, +20 Faith)")


func _on_tobi_dialogue_requested(_npc: NPC3D, pl: CharacterBody3D) -> void:
	if not pl:
		return
	var needs: NeedsManager = pl.get_node_or_null("NeedsManager") as NeedsManager
	if needs:
		needs.modify_cgpa(0.04)
		needs.modify_faith(15.0)
	if pl.has_method("display_notification"):
		pl.display_notification("🎓 Senior Tobi's Final Year Advice: 'Read past questions chapter by chapter, and never miss morning devotions!' (+0.04 CGPA, +15 Faith)")


func _on_player_passed_out(_reason: String) -> void:
	# If student collapses in the garden, Iya Boli revives them with chilled zobo and roasted boli
	if player:
		var needs: NeedsManager = player.get_node_or_null("NeedsManager") as NeedsManager
		if needs:
			needs.modify_hunger(45.0)
			needs.modify_energy(40.0)
			needs.modify_faith(25.0)
		TimeSystem.advance_minutes(25)
		if SoundManager:
			SoundManager.play_cheer()
		if player.has_method("display_notification"):
			player.display_notification("🌿 Iya Boli revives you: 'Pikin, sit down under the tree shade! Chop this hot sweet boli and drink zobo!' Restored +45 Hunger, +40 Energy!")
		player.global_position = Vector3(0, 0.1, 0)

