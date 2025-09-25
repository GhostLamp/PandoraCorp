shader_type canvas_item;
uniform vec4 shader_color: source_color = vec4(1.0);
uniform float alpha;

void fragment() {
	vec4 color = texture(TEXTURE,UV);
	color.rgb = mix(color.rgb,shader_color.rgb,1);
	COLOR = color;
	if (COLOR.a !=0.0){
		COLOR.a = alpha;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
