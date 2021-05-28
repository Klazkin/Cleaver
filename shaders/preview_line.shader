shader_type canvas_item;

uniform vec4 line_color_x : hint_color = vec4( 1.0, 0.0, 0.0, 1.0);
uniform vec4 line_color_y : hint_color = vec4( 0.0, 0.0, 1.0, 1.0);
uniform vec4 out_color : hint_color = vec4(0.9, 0.7, 0.0, 1.0); //
uniform vec2 grid_size = vec2(16,16);

void fragment(){
	COLOR = texture(TEXTURE,UV);
	ivec2 size = textureSize(TEXTURE,0);
	vec2 pixel_local = UV * vec2(size);
	if( int(pixel_local.y+1.0) % int(grid_size.y) == 0 ){
		COLOR = line_color_y;
	}
	if( int(pixel_local.x+1.0) % int(grid_size.x) == 0 ){
		COLOR = line_color_x;
	}
	COLOR.a = clamp(COLOR.a, 0.0, 1.0);
}