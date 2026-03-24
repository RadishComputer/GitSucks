shader_type canvas_item;

uniform bool grayscale_enabled = false;
uniform bool high_contrast_enabled = false;

uniform float contrast_amount : hint_range(0.5, 3.0) = 1.8;

uniform sampler2D screen_tex : hint_screen_texture;

void fragment() {
    vec4 base = texture(screen_tex, SCREEN_UV);

    vec3 color = base.rgb;

    // --- Grayscale ---
    if (grayscale_enabled) {
        float gray = dot(color, vec3(0.299, 0.587, 0.114));
        color = vec3(gray);
    }

    // --- High Contrast ---
if (high_contrast_enabled) {
    color = pow(color, vec3(contrast_amount));
    color = clamp(color * 1.05, 0.0, 1.0);
}


    COLOR = vec4(color, base.a);
}
