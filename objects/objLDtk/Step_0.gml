if (room == rLDtk) {
	if (LDTK_LIVE) {
		// currently broken
		//LDtkLive(global.LDtkCurrentLevel);
	}
}
else {
	if (room != rLDtkSetup) instance_destroy();
}
