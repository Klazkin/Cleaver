extends ColorRect

func _ready() -> void:
	$button_output.connect("pressed",self,"open_dialog",[$button_output/output_dialog])
	$button_input.connect("pressed",self,"open_dialog",[$button_input/input_dialog])
	$button_input/input_dialog.connect("file_selected",self,"control_spritesheet")
	$button_output/output_dialog.connect("dir_selected",self,"control_outputfolder")
	$button_input/input_dialog.set_filters( PoolStringArray(["*.png ; PNG Images"]) )
	#$edit_input.connect("text_change_rejected",self,"check_for_valid_spritesheet")
	
func open_dialog( dialog : FileDialog):
	dialog.show()
	dialog.set_current_dir( dialog.current_dir )

func control_outputfolder(folder_dir : String) -> void:
	if folder_dir.is_abs_path():
		$edit_output.set_text(folder_dir)
	else:
		$edit_output.placeholder_text = "Invalid folder: "+folder_dir

func control_spritesheet(file_dir : String) -> void:
	if file_dir.is_abs_path():
		$edit_input.set_text(file_dir)
		get_parent().load_new_sheet(file_dir)
	else:
		$edit_input.placeholder_text = "Invalid file: "+file_dir
	
func check_for_valid_spritesheet( file : String ) -> void:
	print(file)
