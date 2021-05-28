extends ColorRect
var changelog : String

# Todo:
# Currently lacks functionality for certain attributes like armor bonus damage from tools
# Desktop Icon :)
# Lacking support for spotting removed attributes (opposite of func new_stat())

func _ready():
	OS.window_size.y *= 2
	$button_new.connect("pressed", self, "refresh_dialog", [$button_new/FileDialog])
	$button_old.connect("pressed", self, "refresh_dialog", [$button_old/FileDialog])
	$button_new/FileDialog.set_filters(PoolStringArray(["*.json ; JSON text"]))
	$button_old/FileDialog.set_filters(PoolStringArray(["*.json ; JSON text"]))
	$button_compare.connect("pressed",self,"run_compare")
	
	$button_new/FileDialog.set_current_dir($button_new/FileDialog.current_dir)
	
func refresh_dialog( dialog : FileDialog) -> void:
	dialog.show()
	dialog.set_current_dir(dialog.current_dir)
	
func read_json(dir : String) -> Array:
	var json_file : File = File.new()
	print( "Read succesful " + str( json_file.open(dir,File.READ) == OK) )
	
	var json_parse : JSONParseResult = JSON.parse(json_file.get_as_text())
	
	json_file.close()
	return json_parse.result
	
func run_generic_stat_comparison(stat : String, insert : String, old_value, new_value):
	stat = stat.replace(insert+"_","") # Removes "ore" from "ore_harvest_level"
	stat = stat.replace("_"," ")
	if old_value < new_value:
		changelog += "	 - Increased "+insert+" "+stat+" from "+str(old_value)+" to "+str(new_value)+".\n"
	elif old_value > new_value:
		changelog += "	 - Decreased "+insert+" "+stat+" from "+str(old_value)+" to "+str(new_value)+".\n"
	else:
		pass

func new_stat(stat : String, item_type : String, value):
	stat = stat.replace("_"," ")
	changelog += "	 - Added new attribute to "+item_type+", "+stat.capitalize()+", which is equal to "+str(value)+".\n"

func value_array_formating(string : String) -> String:
	string = string.replace("[","").replace("]","").replace(",","/").replace(" ","")
	return string

func run_compare() -> void:
	var data_progenitor : Array = read_json($button_old/FileDialog.current_path)
	var data_successor : Array = read_json($button_new/FileDialog.current_path)
	
	for metal_id in range(data_progenitor.size()):
		if data_progenitor[metal_id] is String: #skip the comments
			pass
		else:
			#Redundant assertion
			assert(data_progenitor[metal_id] is Dictionary)
			
			#Metal name
			changelog += "- **"+data_progenitor[metal_id].name.capitalize()+"**:\n"
			
			#Special case for color
			if data_progenitor[metal_id].color != data_successor[metal_id].color:
				changelog += "	 - Updated the color hex value.\n"
			
			#Base stats
			for stat in ["hardness","ore_harvest_level","blast_resistance"]:
				if data_progenitor[metal_id].has(stat) and data_successor[metal_id].has(stat):
					run_generic_stat_comparison(stat, "ore", data_progenitor[metal_id][stat], data_successor[metal_id][stat] )
				
			#Armor stats
			if data_progenitor[metal_id].has("armor_stats"):
				
				#Special case for damage reduction due to use of an array
				if data_progenitor[metal_id].armor_stats["damage_reduction"] != data_successor[metal_id].armor_stats["damage_reduction"]:
					var old_reduction : String = str(data_progenitor[metal_id].armor_stats["damage_reduction"])
					var new_reduction : String = str(data_successor[metal_id].armor_stats["damage_reduction"])
						
					changelog += "	 - Rescaled armor damage reduction from "+value_array_formating(old_reduction)+" to "+value_array_formating(new_reduction)+".\n"
				
				for stat in ["enchantability","durability","toughness","max_health","knockback_resistance","movement_speed"]:
					if data_progenitor[metal_id].armor_stats.has(stat) and data_successor[metal_id].armor_stats.has(stat):
						run_generic_stat_comparison(stat, "armor", data_progenitor[metal_id].armor_stats[stat], data_successor[metal_id].armor_stats[stat] )
					if not data_progenitor[metal_id].armor_stats.has(stat) and data_successor[metal_id].armor_stats.has(stat):
						new_stat(stat, "armor", data_successor[metal_id].armor_stats[stat])
			
			#Tool stats
			if data_progenitor[metal_id].has("tool_stats"):
				for stat in ["enchantability","durability","damage","max_health","efficiency","attack_speed","reach_distance"]:
					if data_progenitor[metal_id].tool_stats.has(stat) and data_successor[metal_id].tool_stats.has(stat):
						run_generic_stat_comparison(stat, "tool",data_progenitor[metal_id].tool_stats[stat], data_successor[metal_id].tool_stats[stat] )
					if not data_progenitor[metal_id].tool_stats.has(stat) and data_successor[metal_id].tool_stats.has(stat):
						new_stat(stat, "tools", data_successor[metal_id].tool_stats[stat])
			
			#Return on end of metal read
			changelog += "\n"
	print("comparison finished")
	$label_result/TextEdit.text = changelog
		
