shader_type canvas_item;

uniform bool light_enabled = true;
uniform vec3 light_color : source_color = vec3(1.0, 0.92, 0.0);
uniform float strength : hint_range(0.0, 4.0, 0.01) = 1.0;
uniform float tint_intensity : hint_range(0.0, 1.0, 0.01) = 1.0;

uniform sampler2D light_mask : repeat_disable, filter_linear;
uniform sampler2D screen_tex : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec4 base = texture(screen_tex, SCREEN_UV);
    float mask = texture(light_mask, UV).r;

    if (!light_enabled || mask < 0.001) {
        COLOR = base;
        discard;
    }

    float brightness = max(max(base.r, base.g), base.b);
    float is_dark = step(0.14, brightness);   // 0 = very dark, 1 = brighter
    float tint_amount = mask * strength * brightness;
    vec3 target_color = light_color;
    vec3 warmed = mix(base.rgb, target_color, tint_amount * tint_intensity);
    vec3 final = mix(base.rgb, warmed, is_dark);
    COLOR = vec4(final, base.a);
}