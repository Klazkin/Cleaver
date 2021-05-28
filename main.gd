extends Node

var export_directory : String = "/Users/matve/Desktop/paint.net/metallurgy/test123/doc/export/"
var import_directory : String = "/Users/matve/Desktop/paint.net/metallurgy/test123/doc/import/"
var file_format : String = ".png"

var metal_name_array : Array = [
"adamantine",
"amordrine",
"angmallen",
"alduorite",
"astral_silver",
"atlarus",
"black_steel",
"brass",
"bronze",
"carmot",
"celenegil",
"ceruclase",
"copper",
"damascus_steel",
"deep_iron",
"desichalkos",
"electrum",
"etherium",
"eximite",
"haderoth",
"hepatizon",
"ignatius",
"infuscolium",
"inolashite",
"kalendrite",
"krik",
"lemurite",
"lutetium",
"manganese",
"meutoite",
"midasium",
"mithril",
"orichalcum",
"osmium",
"oureclase",
"platinum",
"prometheum",
"quicksilver",
"rubracium",
"sanguinite",
"shadow_iron",
"shadow_steel",
"silver",
"steel",
"tartarite",
"tin",
"vulcanite",
"vyroxeres",
"zinc"
]
var base_name_array : Array = [
	"_palette",
	"_reinforced_glass",
	"_hazard_block",
	"_block",
	"_engraved_block",
	"_large_bricks",
	"_bricks",
	"_crystals",
	"_ingot",
	"_nugget",
	"_dust",
]

func get_file_name_using_id( id : int ) -> String:
	var metal_id : int = id % metal_name_array.size()
	var base_id : int = id / metal_name_array.size()
	return metal_name_array[ metal_id ]+base_name_array[ base_id ]

func _ready() -> void:
	var import_dir = Directory.new()

	if import_dir.open(import_directory) == OK:
		import_dir.list_dir_begin()
		var file_name = import_dir.get_next()

		while file_name != "":
			if not import_dir.current_is_dir():
				var texture_id = abs(int(file_name))
				var new_name = get_file_name_using_id(texture_id)
				if import_dir.rename( import_directory + file_name, export_directory + new_name + file_format) == OK:
					print("Succesfully renamed "+file_name+" to "+new_name + file_format)
				else:
					print("Errored when renaming - "+ file_name + " in " + import_dir.get_current_dir() )

			file_name = import_dir.get_next()
	else:
		print("Error, unknown directory")

	
	
