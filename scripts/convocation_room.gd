class_name ConvocationRoom
extends "res://scripts/base_room.gd"

## University Great Hall of Convocation & Alumni Arena (Room 15) Controller.
## The grand climax of the campus journey:
## - Chancellor Prof. Oloyede & Vice-Chancellor Prof. Okonjo
## - Degree Conferment Ceremony & Senate Gold Medal Award
## - Mortarboard Academic Cap Toss with celebration crowd cheering
## - Official Convocation Photo Booth with proud Mama & Papa
## - Rotating ceremonial ceiling fans
## - Post-graduation sandbox transition & Supabase Hall of Fame sync

@onready var ceiling_fan_1: MeshInstance3D = get_node_or_null("ConvocationFixtures/CeilingFan1") as MeshInstance3D
@onready var ceiling_fan_2: MeshInstance3D = get_node_or_null("ConvocationFixtures/CeilingFan2") as MeshInstance3D
@onready var stage_podium: CampusObject3D = get_node_or_null("WorldObjects/StagePodium") as CampusObject3D
@onready var photo_booth: CampusObject3D = get_node_or_null("WorldObjects/PhotoBooth") as CampusObject3D
@onready var cap_toss_spot: CampusObject3D = get_node_or_null("WorldObjects/CapTossSpot") as CampusObject3D
@onready var stage_spotlight: SpotLight3D = get_node_or_null("ConvocationFixtures/StageSpotlight") as SpotLight3D

const ConvocationCeremonyScene = preload("res://scenes/convocation_ceremony_dialog.tscn")
var convocation_dialog: Control = null
var has_conferred_degree: bool = false


func _ready() -> void:
	room_name = "Great Hall of Convocation & Alumni Arena"
	room_id = &"convocation"
	super._ready()

	if ceiling_fan_1:
		active_ceiling_fans.append(ceiling_fan_1)
	if ceiling_fan_2:
		active_ceiling_fans.append(ceiling_fan_2)

	if stage_podium:
		stage_podium.interacted.connect(_on_stage_podium_interacted)
	if photo_booth:
		photo_booth.interacted.connect(_on_photo_booth_interacted)
	if cap_toss_spot:
		cap_toss_spot.interacted.connect(_on_cap_toss_interacted)


func _on_stage_podium_interacted() -> void:
	if not player:
		return

	has_conferred_degree = true

	# Flash stage spotlight for dramatic ceremony effect
	if stage_spotlight:
		stage_spotlight.light_energy = 4.0
		var tween: Tween = create_tween()
		tween.tween_property(stage_spotlight, "light_energy", 1.8, 1.2)

	if not convocation_dialog and menus_layer:
		convocation_dialog = ConvocationCeremonyScene.instantiate()
		menus_layer.add_child(convocation_dialog)
		if convocation_dialog.has_signal("dialog_closed"):
			convocation_dialog.dialog_closed.connect(_on_menu_closed)

	if convocation_dialog:
		player.set_physics_process(false)
		player.velocity = Vector3.ZERO
		convocation_dialog.open_ceremony(player)


func _on_cap_toss_interacted() -> void:
	if not player:
		return

	var needs: NeedsManager = player.get_node_or_null("NeedsManager") as NeedsManager
	if needs:
		needs.modify_faith(35.0)
		needs.modify_energy(25.0)

	if SoundManager:
		SoundManager.play_cheer()

	if player.has_method("display_notification"):
		player.display_notification("🎓🎉 CAP TOSS! You launch your mortarboard cap high into the arena lights! The crowd cheers: 'ALUTA CONTINUA! VICTORIA ACERTA!!' (+35 Faith, +25 Energy)")


func _on_photo_booth_interacted() -> void:
	if not player:
		return

	var needs: NeedsManager = player.get_node_or_null("NeedsManager") as NeedsManager
	if needs:
		needs.modify_faith(20.0)

	if SoundManager:
		SoundManager.play_click()

	if player.has_method("display_notification"):
		player.display_notification("📸 CONVOCATION PHOTO BOOTH: Proud Mama in her golden gele & Papa in agbada smile broadly: 'We are so proud of you, our graduate!' (+20 Faith)")


func _on_player_passed_out(_reason: String) -> void:
	# If graduate faints from euphoria or heat in the Great Hall, family assists
	if player:
		var needs: NeedsManager = player.get_node_or_null("NeedsManager") as NeedsManager
		if needs:
			needs.modify_hunger(50.0)
			needs.modify_energy(50.0)
			needs.modify_faith(35.0)
		TimeSystem.advance_minutes(25)
		if SoundManager:
			SoundManager.play_cheer()
		if player.has_method("display_notification"):
			player.display_notification("👪 Proud Mama & Papa rush over: 'Ehya our graduate! Fan him with this program booklet, drink this cold malt and eat meat pie!' (+50 Energy, +50 Hunger)")
		player.global_position = Vector3(0, 0.1, 2.0)

