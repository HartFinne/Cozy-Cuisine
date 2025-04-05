shader_type canvas_item;

void vertex() {
	UV.x += TIME * .004;
	UV.y += TIME * .004;
}
