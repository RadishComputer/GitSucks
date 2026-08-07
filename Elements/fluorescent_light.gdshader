shader_type canvas_item;

uniform bool light_enabled = false;
uniform vec4 light_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); 
uniform float light_strength : hint_range(0.0, 3.0) = 1.25;
uniform sampler2D light_mask;
uniform sampler2D screen_tex : hint_screen_texture;

void fragment() {
	vec4 base = texture(screen_tex, SCREEN_UV);
	float raw = texture(light_mask, UV).r;
	float mask = raw;

	if (light_enabled) {
		// Blends the light with a slightly boosted base to mimic diffuse brightness
		vec3 illuminated = base.rgb * mix(vec3(1.3), light_color.rgb, light_strength * mask);
		// Adds a bright, clean highlight glow based on the light mask
		illuminated *= (1.0 + 0.15 * mask);
		float alpha = mask;
		COLOR = vec4(illuminated, alpha);
	} else {
		COLOR = vec4(base.rgb, 0.0);
	}
}
