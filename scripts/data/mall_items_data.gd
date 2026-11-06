class_name MallItemsData
extends RefCounted

## Modular Campus Mall Catalog.
## Lists all equipment, study gear, snacks, and gadgets available for sale.
## Easily editable by changing items in this array.

const ITEMS: Array[Dictionary] = [
	{
		"id": "power_bank",
		"name": "20,000mAh Heavy Duty Power Bank",
		"price": 6500,
		"category": "gadget",
		"icon": "🔋",
		"description": "Never get stranded when Hall 2 experiences a blackout! Keeps phone at 100%."
	},
	{
		"id": "calc_fx991",
		"name": "Scientific Calculator (Casio fx-991)",
		"price": 4500,
		"category": "academic",
		"icon": "🧮",
		"description": "Essential tool for MTH 101 Calculus and PHY tests. +15% Exam Performance."
	},
	{
		"id": "oxford_set",
		"name": "Oxford Mathematical Drawing Set",
		"price": 1800,
		"category": "academic",
		"icon": "📐",
		"description": "Tin box with metal compass, divider, and ruler. Needed for lab diagrams."
	},
	{
		"id": "designer_shades",
		"name": "Dark Campus Sunglasses",
		"price": 2500,
		"category": "fashion",
		"icon": "🕶️",
		"description": "High swagger points. Walk through the quad looking like a final year boss (+15 Clout)."
	},
	{
		"id": "perfume_oil",
		"name": "6ml Arabian Oud Perfume Oil",
		"price": 1500,
		"category": "fashion",
		"icon": "✨",
		"description": "Smell fresh throughout long 4-hour lectures (+10 Social Confidence)."
	},
	{
		"id": "indomie_carton",
		"name": "Carton of Indomie Noodles (40 Packs)",
		"price": 8500,
		"category": "provisions",
		"icon": "📦",
		"description": "The ultimate campus lifesaver. Keeps you fed for an entire month without stepping out."
	},
	{
		"id": "white_sneakers",
		"name": "Clean White Campus Sneakers",
		"price": 7500,
		"category": "fashion",
		"icon": "👟",
		"description": "Fresh white kicks that match both denim jeans and sweatpants."
	},
	{
		"id": "hostel_fan",
		"name": "QASA 18-Inch Rechargeable Standing Fan",
		"price": 8500,
		"category": "upgrade",
		"icon": "🌀",
		"description": "Cools your hostel room during heat waves. Restores +25% extra energy while sleeping!"
	},
	{
		"id": "mini_fridge",
		"name": "Hostel Mini-Fridge & Cold Beverage Chiller",
		"price": 18000,
		"category": "upgrade",
		"icon": "🧊",
		"description": "Keeps your zobo and canned drinks chilled, preserving food freshness indefinitely."
	},
	{
		"id": "study_lamp",
		"name": "Solar LED Rechargeable Study Lamp",
		"price": 3500,
		"category": "upgrade",
		"icon": "💡",
		"description": "Enables quiet desk cramming and revision even when campus electricity is cut off."
	},
	{
		"id": "mac_desk",
		"name": "Executive Coding Desk & Ergonomic Chair",
		"price": 12500,
		"category": "upgrade",
		"icon": "🖥️",
		"description": "Upgraded workstation that increases all hostel freelance typing and coding earnings by +35%."
	},
	{
		"id": "sound_speaker",
		"name": "Bluetooth Boombox Wireless Speaker",
		"price": 6000,
		"category": "upgrade",
		"icon": "📻",
		"description": "Plays soothing hostel music tunes to clear exam stress and boost student happiness."
	},
	{
		"id": "double_bookshelf",
		"name": "Double-Deck Solid Wood Bookshelf",
		"price": 7000,
		"category": "upgrade",
		"icon": "📚",
		"description": "Stores past questions and heavy textbooks. Grants +25% Study Focus and doubles exam revision speed."
	},
	{
		"id": "campus_wall_poster",
		"name": "Panoramic Campus Map & Scripture Poster",
		"price": 2000,
		"category": "upgrade",
		"icon": "🗺️",
		"description": "Features campus landmarks and inspiring Bible verses (+15 Daily Faith & Study Morale)."
	},
	{
		"id": "orthopedic_mattress",
		"name": "Mouka Foam Orthopedic Bunk Mattress",
		"price": 11000,
		"category": "upgrade",
		"icon": "🛏️",
		"description": "Replaces thin hostel bunk foam with luxury orthopedic support. Sleep restores energy 2x faster."
	},
	{
		"id": "executive_desk_chair",
		"name": "Ergonomic High-Back Swivel Desk Chair",
		"price": 5500,
		"category": "upgrade",
		"icon": "🪑",
		"description": "Lumbar support for long study nights. Reduces study energy drain by -30%."
	},
	{
		"id": "vitamin_c_pack",
		"name": "Campus Chemist Wellness Pack (Vitamin C & Malt Tonic)",
		"price": 2200,
		"category": "provisions",
		"icon": "💊",
		"description": "Nurse Amaka's immune booster pack! Restores +40% Energy, +25% Hunger, and +15 Faith."
	},
	{
		"id": "mosquito_net",
		"name": "Insecticide-Treated Hostel Mosquito Net",
		"price": 3000,
		"category": "upgrade",
		"icon": "🛡️",
		"description": "Protects your bunk from campus mosquitoes! Prevents night fever and adds +15 Faith on sleep."
	},
	{
		"id": "scholars_rug",
		"name": "Royal Persian Hostel Center Rug & Executive Curtains",
		"price": 9500,
		"category": "upgrade",
		"icon": "✨",
		"description": "Transforms your hostel room into a VIP Scholar Suite! Grants +20 Clout and +10% Study Focus."
	}
]

static func get_item_by_id(item_id: String) -> Dictionary:
	for item in ITEMS:
		if item["id"] == item_id:
			return item
	return {}

