shader_type canvas_item;
render_mode blend_mix;

uniform vec4 tint_color = vec4(0.5, 0.6, 0.9, 1.0);
uniform sampler2D screen_tex : hint_screen_texture, filter_nearest;

void fragment() {
    vec4 base = texture(screen_tex, SCREEN_UV);
    float mask = texture(TEXTURE, UV).r;

    float brightness = max(max(base.r, base.g), base.b);
    float is_dark = step(0.14, brightness);

    vec3 tinted = base.rgb * mix(vec3(1.0), tint_color.rgb, mask);
    vec3 final  = mix(base.rgb, tinted, is_dark);

    COLOR = vec4(final, base.a);
}