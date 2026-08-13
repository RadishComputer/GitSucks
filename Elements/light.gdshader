shader_type canvas_item;
render_mode blend_mix;

uniform bool light_enabled = false;
uniform int light_mode = 0;

//White
uniform vec3 white_color : source_color = vec3(1.0, 1.0, 1.0);
//Warm
uniform vec3 warm_color  : source_color = vec3(1.0, 0.92, 0.0);
//Other
uniform vec3 custom_color : source_color = vec3(1.0, 0.5, 0.2);

uniform float strength : hint_range(0.0, 1.0) = 1.0;

uniform sampler2D light_mask;
uniform sampler2D screen_tex : hint_screen_texture;

void fragment() {
    vec4 base = texture(screen_tex, SCREEN_UV);
    float mask = texture(light_mask, UV).r;
    vec3 final = base.rgb;
    float alpha = base.a;

    if (light_enabled && mask > 0.001) {
        float brightness = max(max(base.r, base.g), base.b);
        float is_dark = smoothstep(0.0, 0.4, brightness);
        float amount = clamp(strength * mask, 0.0, 1.0);

        vec3 light_color = white_color;
        if (light_mode == 1) {light_color = warm_color;}
		else if (light_mode == 2) {light_color = custom_color;}

        vec3 lit = mix(base.rgb, light_color, amount);
        final = mix(base.rgb, lit, is_dark);
        alpha = mask;
    }

    COLOR = vec4(final, alpha);
}
