var doWarp = false;
with (other) {
	if (is_pressed(global.controls.up)) {
		doWarp = true;
	}
}

if (doWarp)	{
	if (destination != noone) {
		warpPlayerTo(destination);
	}
}
