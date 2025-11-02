shader_type canvas_item;

uniform vec4 shader_color: source_color = vec4(1.0);
uniform float alpha;
uniform float whitedout;
uniform float shadowing;

uniform vec4 original_0: source_color;
uniform vec4 replace_0: source_color;

uniform vec4 original_1: source_color;
uniform vec4 replace_1: source_color;

uniform vec4 original_2: source_color;
uniform vec4 replace_2: source_color;

uniform vec4 original_3: source_color;
uniform vec4 replace_3: source_color;

uniform vec4 original_4: source_color;
uniform vec4 replace_4: source_color;

uniform vec4 original_5: source_color;
uniform vec4 replace_5: source_color;

uniform vec4 original_6: source_color;
uniform vec4 replace_6: source_color;

uniform vec4 original_7: source_color;
uniform vec4 replace_7: source_color;

uniform vec4 original_8: source_color;
uniform vec4 replace_8: source_color;

uniform vec4 original_9: source_color;
uniform vec4 replace_9: source_color;

uniform vec4 original_10: source_color;
uniform vec4 replace_10: source_color;

uniform vec4 original_11: source_color;
uniform vec4 replace_11: source_color;

uniform vec4 original_12: source_color;
uniform vec4 replace_12: source_color;

uniform vec4 original_13: source_color;
uniform vec4 replace_13: source_color;

uniform vec4 original_14: source_color;
uniform vec4 replace_14: source_color;

uniform vec4 original_15: source_color;
uniform vec4 replace_15: source_color;

uniform vec4 original_16: source_color;
uniform vec4 replace_16: source_color;

uniform vec4 original_17: source_color;
uniform vec4 replace_17: source_color;

uniform vec4 original_18: source_color;
uniform vec4 replace_18: source_color;

const float precision = 0.01;


vec4 swap_color(vec4 color){
	vec4 original_colors[19] = vec4[19] (
		original_0, original_1, original_2, original_3, original_4,
		original_5, original_6, original_7, original_8, original_9,
		original_10, original_11, original_12, original_13 ,original_14,
		original_15, original_16, original_17, original_18);

	vec4 replace_colors[19] = vec4[19] (
		replace_0, replace_1, replace_2, replace_3, replace_4,
		replace_5, replace_6, replace_7, replace_8, replace_9,
		replace_10,replace_11, replace_12, replace_13, replace_14,
		replace_15, replace_16, replace_17, replace_18);

	for (int i = 0; i < 19; i ++) {
		if (distance(color, original_colors[i]) <= precision){
			return replace_colors[i];
		}
	}
	return color;
}


void fragment() {
	vec4 color = swap_color(texture(TEXTURE, UV));
	color.rgb = mix
		(
		color.rgb, shader_color.rgb + (vec3(1,1,1) - shader_color.rgb)*whitedout -(shader_color.rgb)*shadowing ,alpha
		);
	COLOR = color;

}
