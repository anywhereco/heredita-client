shader_type canvas_item;

uniform vec3 hue;

void fragment() {
	vec3 hs = mix(vec3(1), hue, UV.x);
	COLOR = vec4(mix(hs, vec3(0), UV.y), 1);
}