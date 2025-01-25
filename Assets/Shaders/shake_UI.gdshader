shader_type canvas_item;

uniform float shakeAmount = 100;
uniform float frequency = 1.0;

void vertex() {
	VERTEX.y += cos(TIME*shakeAmount) * frequency;
	VERTEX.x += sin(TIME*shakeAmount) * frequency;
}