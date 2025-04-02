shader_type canvas_item;

void vertex() {
	UV.x += TIME * .03;
	UV.y += TIME * .03;
}

