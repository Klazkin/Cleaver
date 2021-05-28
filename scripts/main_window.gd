extends ColorRect

var grid_size : Vector2 = Vector2(16,16)
var sprite_count : int
var sheet_image : Image = Image.new()
var segment : Sprite

func load_new_sheet( directory : String) -> void:
	sheet_image = Image.new()
	sheet_image.load(directory)
	var new_spritesheet_texture : ImageTexture = ImageTexture.new()
	new_spritesheet_texture.create_from_image(sheet_image,0)
	$Preview/textrue_preview.texture = new_spritesheet_texture
	$Properties/label_sheet_size.text = str("Sheet size: "+str(sheet_image.get_size().x)+" x "+str(sheet_image.get_size().y)) 
	$Properties/label_warning.visible = is_grid_aligned()
	segment.texture = new_spritesheet_texture
	update_gird_size("")
	
func is_grid_aligned() -> bool:
	if int(sheet_image.get_size().x) % int(grid_size.x) == 0 and int(sheet_image.get_size().y) % int(grid_size.y) == 0:
		return false
	else:
		return true

func _ready() -> void:
	segment = $Viewport/segment
	load_new_sheet("res://icon.png")
	$button_split.connect("pressed",self,"split")
	$Properties/x_size.connect("text_changed",self,"update_gird_size")
	$Properties/y_size.connect("text_changed",self,"update_gird_size")
	$Properties/x_size.connect("focus_exited",self,"clear_irregulars",["x"])
	$Properties/y_size.connect("focus_exited",self,"clear_irregulars",["y"])
	$button_other.connect("pressed",self,"open_materials_compare")

func open_materials_compare() -> void:
	get_tree().change_scene("res://scenes/materials_compare.tscn")

func split() -> void:
	$ProgressBar.visible = true
	$progress_label.visible = true
	$button_split.visible = false
	for n in range(sprite_count):
		$ProgressBar.value = (float(n)/sprite_count)*100
		segment.frame = n
		yield(VisualServer,"frame_post_draw")
		var viewport_texture : ViewportTexture = $Viewport.get_texture()
		var new_image = viewport_texture.get_data()
		new_image.convert(Image.FORMAT_RGBA8)
		var path : String = $FilePaths/edit_output.text+"/"+str(n)+".png"
		$progress_label.text = path
		new_image.save_png(path)
	$ProgressBar.visible = false
	$button_split.visible = true
	$progress_label.visible = false

func clear_irregulars( coord : String ) -> void:
	get_node("Properties/"+coord+"_size").text = str(grid_size[coord])
	
func update_gird_size(dump) -> void:
	grid_size = Vector2(clamp(int($Properties/x_size.text),2,1024), clamp(int($Properties/y_size.text),2,1024))
	$Viewport.size = grid_size
	$Preview/textrue_preview.material.set_shader_param("grid_size",grid_size)
	$Properties/label_warning.visible = is_grid_aligned()
	
	$segment_preview.update()
	segment.vframes = int( sheet_image.get_size().y / grid_size.y )
	segment.hframes = int( sheet_image.get_size().x / grid_size.x )
	sprite_count = segment.vframes * segment.hframes
	$Properties/label_sprite_count.text = "Sprite count: "+str(sprite_count)
