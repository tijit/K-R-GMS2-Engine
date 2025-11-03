if (room == rLDtkSetup) {
	// set width and height of rLDtk then move there
	var info = getLevelInfoFromName(global.LDtkCurrentLevel);
	
	room_set_width(rLDtk, info.width);
	room_set_height(rLDtk, info.height);
	
	persistent = true;
	room_goto(rLDtk);
}
else {
	// load global.LDtkCurrentLevel
	LDtkLoad(global.LDtkCurrentLevel);
	persistent = false;
	
	// dont destroy - so we can do live-loading
	//instance_destroy();
}
