shader_type canvas_item;

uniform bool light_enabled = false;
uniform vec4 light_color : source_color = vec4(1.0, 0.95, 0.70, 1.0);
uniform float light_strength : hint_range(0.0, 3.0) = 1.0;
uniform sampler2D light_mask;
uniform sampler2D screen_tex : hint_screen_texture;

void fragment() {
	vec4 base = texture(screen_tex, SCREEN_UV);
	float raw = texture(light_mask, UV).r;
	float mask = raw;

	if (light_enabled) {
		vec3 illuminated = base.rgb * mix(vec3(1.0), light_color.rgb, light_strength * mask);
		illuminated *= (1.0 + 0.1
		 * mask);
		float alpha = mask;
		COLOR = vec4(illuminated, alpha);
	} else {
		COLOR = vec4(base.rgb, 0.0);
	}
}