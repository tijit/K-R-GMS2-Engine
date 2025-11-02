if (room == rLDtk) {
	if (LDTK_LIVE) {
		// currently broken
		//LDtkLive(global.LDtkCurrentMap);
	}
}
else {
	if (room != rLDtkSetup) instance_destroy();
}
