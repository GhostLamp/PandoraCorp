shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform sampler2D screem_texture : hint_screen_texture,repeat_disable,filter_nearest;
uniform sampler2D curve;
uniform float size;
uniform float thick;

void fragment() {
	float ratio = TEXTURE_PIXEL_SIZE.x/  TEXTURE_PIXEL_SIZE.y;
	vec2 scaled_uv = (UV - vec2(0.5,0))/vec2(ratio,1) + vec2(0.5,0);
	float mask = (1.0 - smoothstep(size - 0.1, size , length(scaled_uv - center)))
			* smoothstep(size - thick-0.1, size - thick,length(scaled_uv - center));
	vec2 disp = normalize(scaled_uv - center)* force * mask;
	COLOR = textureLod(screem_texture, SCREEN_UV - disp  , 0);
	//COLOR.rgb = vec3(mask);
}
