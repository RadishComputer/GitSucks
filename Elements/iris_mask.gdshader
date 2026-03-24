shader_type canvas_item;

uniform float radius = 0.0;            // pixel radius
uniform vec2 center = vec2(0.0, 0.0);  // normalized screen position

void fragment() {
    // Get actual window size in pixels
	vec2 window_size = 1.0 / SCREEN_PIXEL_SIZE;

    // SCREEN_UV is in screen space; scale to pixels
	vec2 pixel_uv = SCREEN_UV * window_size;
	vec2 pixel_center = (window_size * 0.5) + center;

	float dist = distance(pixel_uv, pixel_center);

    // INSIDE = hole
	if (dist <= radius) {
		discard;
	}
	COLOR = vec4(0.0, 0.0, 0.0, 1.0);
}
