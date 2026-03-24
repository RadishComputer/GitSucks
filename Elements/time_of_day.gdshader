shader_type canvas_item;
render_mode blend_mix; // <-- IMPORTANT

uniform vec4 tint_color = vec4(0.5, 0.6, 0.9, 1.0);
uniform sampler2D screen_tex : hint_screen_texture;

void fragment() {
    vec4 base = texture(screen_tex, SCREEN_UV);
    vec4 mask = texture(TEXTURE, UV);

    vec3 tinted = base.rgb * mix(vec3(1.0), tint_color.rgb, mask.r);

    COLOR = vec4(tinted, base.a);
}
