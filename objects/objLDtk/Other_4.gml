if (room == rLDtkSetup) {
	// set width and height of rLDtk then move there
	
	var info = getLevelInfoFromName();
	
	var w = info.width;
	var h = info.height;
	
	room_set_width(rLDtk, w);
	room_set_height(rLDtk, h);
	
	persistent = true;
	room_goto(rLDtk);
}
else {
	// load global.LDtkCurrentMap
	LDtkLoad(global.LDtkCurrentMap);
	persistent = false;
	
	//instance_destroy();
}
