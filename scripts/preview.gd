extends ColorRect

func _ready():
	connect("mouse_entered",$slider_visual,"set_visible",[true])
	connect("mouse_exited",$slider_visual,"set_visible",[false])

func _gui_input(event):
	if event is InputEventMouseButton and (event.button_index == BUTTON_WHEEL_UP or event.button_index ==  BUTTON_WHEEL_DOWN):
		$slider_visual.value += (event.button_index*2 - 9)
		$textrue_preview.rect_scale = Vector2(1,1)*$slider_visual.value
		$slider_visual.visible = true
