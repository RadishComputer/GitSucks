shader_type canvas_item;

uniform vec2 scroll_speed = vec2(0.1, 0.0);
uniform float time_accum = 0.0;

void fragment(){
    vec2 uv = UV + scroll_speed * time_accum;
    COLOR = texture(TEXTURE, uv);
}
