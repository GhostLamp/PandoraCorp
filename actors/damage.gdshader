shader_type canvas_item;
uniform vec4 shader_color: source_color = vec4(1.0);
uniform float alpha;

void fragment() {
	vec4 color = texture(TEXTURE,UV);
	color.rgb = mix(color.rgb,shader_color.rgb,alpha);
	COLOR = color;

}
