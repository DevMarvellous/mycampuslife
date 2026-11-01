class_name CampusGigsData
extends RefCounted

## Fully data-driven catalog of student side hustles & campus gigs.
## Easily editable: modify payouts, requirements, and descriptions here.

const GIGS: Array[Dictionary] = [
	{
		"id": "graphic_design",
		"title": "SUB Graphic Design Studio",
		"location": "Student Union Building",
		"payout": 2500,
		"energy_cost": 18.0,
		"duration_minutes": 35,
		"min_cgpa": 0.0,
		"icon": "🎨",
		"desc": "Design publicity flyers and social media banners for campus conferences and academic summits.",
		"is_interactive": true
	},
	{
		"id": "code_bounty",
		"title": "Silicon Lagoon Bug Bounty",
		"location": "Silicon Lagoon Tech Hub",
		"payout": 3500,
		"energy_cost": 22.0,
		"duration_minutes": 40,
		"min_cgpa": 2.50,
		"icon": "💻",
		"desc": "Debug student portal scripts and fix software glitches for the university computer society.",
		"is_interactive": true
	},
	{
		"id": "handout_printing",
		"title": "Cybercafe Handout Fast Printing",
		"location": "Cybercafe & Business Center",
		"payout": 1800,
		"energy_cost": 15.0,
		"duration_minutes": 25,
		"min_cgpa": 0.0,
		"icon": "🖨️",
		"desc": "Fast typing, photocopying, and spiral-binding 100L past question booklets for freshers.",
		"is_interactive": true
	},
	{
		"id": "peer_tutoring",
		"title": "100L Freshers Peer Tutoring",
		"location": "Lecture Theatre Tutorial Room",
		"payout": 2000,
		"energy_cost": 20.0,
		"duration_minutes": 45,
		"min_cgpa": 3.00,
		"icon": "📚",
		"desc": "Teach junior 100L students core course fundamentals before semester exams to boost CGPA.",
		"is_interactive": true
	},
	{
		"id": "project_typing",
		"title": "Type & Bind Student Project",
		"location": "Library / Cybercafe",
		"payout": 3500,
		"energy_cost": 20.0,
		"duration_minutes": 45,
		"min_cgpa": 0.0,
		"icon": "📄",
		"desc": "Format and spiral-bind a 40-page final year project report for a graduating senior.",
		"is_interactive": false
	},
	{
		"id": "phone_repair",
		"title": "Phone Screen & Port Repair",
		"location": "SUB Commercial Center",
		"payout": 4500,
		"energy_cost": 24.0,
		"duration_minutes": 50,
		"min_cgpa": 0.0,
		"icon": "🔧",
		"desc": "Replace a cracked Android LCD screen and clean the charging port for a coursemate.",
		"is_interactive": false
	},
	{
		"id": "food_delivery",
		"title": "Campus Canteen Food Delivery",
		"location": "Mama Put -> Hostels",
		"payout": 2000,
		"energy_cost": 16.0,
		"duration_minutes": 30,
		"min_cgpa": 0.0,
		"icon": "🍲",
		"desc": "Deliver 3 takeaway packs of hot jollof rice and fried fish to Moremi Hall hostel.",
		"is_interactive": false
	},
	{
		"id": "hostel_laundry",
		"title": "Hostel Weekend Laundry Hustle",
		"location": "Hall 2 Laundry Line",
		"payout": 3000,
		"energy_cost": 26.0,
		"duration_minutes": 45,
		"min_cgpa": 0.0,
		"icon": "🧺",
		"desc": "Hand-wash and hang 2 buckets of jeans and shirts using morning borehole water.",
		"is_interactive": false
	},
	{
		"id": "math_tutoring",
		"title": "Calculus & Engineering Tutorial",
		"location": "Lecture Theatre 2",
		"payout": 5000,
		"energy_cost": 22.0,
		"duration_minutes": 60,
		"min_cgpa": 3.50,
		"icon": "📐",
		"desc": "Organize a 1-hour advanced calculus tutorial. (Requires CGPA >= 3.50)",
		"is_interactive": false
	},
	{
		"id": "event_dj",
		"title": "SUG Hall Sound & Mic Assistant",
		"location": "Student Union Building",
		"payout": 6000,
		"energy_cost": 30.0,
		"duration_minutes": 75,
		"min_cgpa": 0.0,
		"icon": "🎧",
		"desc": "Help connect amplifiers and control the audio mixer during campus awards evening.",
		"is_interactive": false
	}
]

static func get_all_gigs() -> Array[Dictionary]:
	return GIGS

static func get_gig_by_id(gig_id: String) -> Dictionary:
	for g in GIGS:
		if g["id"] == gig_id:
			return g
	return {}

