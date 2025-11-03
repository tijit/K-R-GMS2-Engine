/// @

// for live loading, "disable file system sandbox" needs to be enabled
// when creating a build, this should be unchecked again
#macro LDTK_LIVE (0)

#macro LDTK_PATH ""

#macro LDTK_FILENAME "examplemap.ldtk"

#macro LDTK_LOGS (false)

function LDtkInit() {
	var config = global.__ldtk_config;
	
	global.LDtkMapInfo = { };
	global.LDtkWorldData = { };
	
	var file = config.file;
	if (!file_exists(file)) {
		throw "Warning! LDtk project file is not specified or file does not exist! (" + string(file) + ")";
		return -1;
	}
	else {
		// load file contents
		var buffer = buffer_load(file);
		//var json = buffer_read(buffer, buffer_string);
		
		global.LDtkWorldData = json_parse(buffer_read(buffer, buffer_string));
		
		buffer_delete(buffer);
	}
	
	var data = global.LDtkWorldData;
	
	var externalLevels = true;
	// if worlds is undefined, there is only ONE world, use data in root
	// otherwise data for each level is in worlds[] array
	//var worlds = data[$ "worlds"] ?? [ ];
	var worlds = [ ];
	var noworlds = true;// (array_length(worlds)==0);
	
	// worlds[i].levels[j]
	
	// generate a map of level iid -> identifier
	var worldsCount;
	if (noworlds) {
		worldsCount = 1;
	}
	else {
		worldsCount = array_length(worlds);
	}
	for (var j = 0; j < worldsCount; j++) {
		var next = undefined;
		if (noworlds) {
			next = data;
		}
		else {
			next = worlds[j];
		}
		
		for (var i = 0; i < array_length(next.levels); i++) {
			var lev = next.levels[i];
			if (externalLevels) {
				LDtkReloadExternalLevel(lev);
			}
			// update the "quick info" struct
			global.LDtkMapInfo[$ string(lev.iid)] = {
				iid :		lev.iid,
				name :		lev.identifier,
				width :		lev.pxWid,
				height :	lev.pxHei,
				worldX :	lev.worldX,
				worldY :	lev.worldY,
				bg :		__LDtkPrepareColor(lev.__bgColor ?? "#000000"),
				levelnum :	string(i),
				worldname :	next[$ "identifier"] ?? "",
				worldiid :	next[$ "iid"] ?? "",
				worldnum :	string(j),
			};
		}
	}
	generateWorldCoordinateArray();
}

// reloads an EXTERNAL level. basically for use with ldtk live only
function LDtkReloadExternalLevel(lev) {
	var fname = LDTK_PATH+lev[$ "externalRelPath"];
				
	var buffer = buffer_load(fname);
	var json = buffer_read(buffer, buffer_string);
	buffer_delete(buffer);
				
	var leveldata = json_parse(json);
				
	// add this data to the main struct
	lev.data = leveldata;
}

function generateWorldCoordinateArray() {
	var levels = global.LDtkWorldData.levels;
	var x0 = 0;
	var y0 = 0;
	var x1 = 800;
	var y1 = 608;
	// find the top left point
	for (var i = 0; i < array_length(levels); i++) {
		var lev = levels[i];
		x0 = min(x0, lev.worldX); x1 = max(x1, lev.worldX+lev.pxWid);
		y0 = min(y0, lev.worldY); y1 = max(y1, lev.worldY+lev.pxHei);
	}
	global.worldMinX = x0;
	global.worldMinY = y0;
	
	var WIDTH = 800;
	var HEIGHT = 608;
	
	var w = floor((x1-x0) div WIDTH);
	var h = floor((y1-y0) div HEIGHT);
	global.LDtkWorldArray = [ ];
	repeat(w) array_push(global.LDtkWorldArray, array_create(h, -1));
	for (var i = 0; i < array_length(levels); i++) {
		var lev = levels[i];
		for (var j = floor((lev.worldX-x0) div WIDTH); j < floor((lev.worldX+lev.pxWid-x0) div WIDTH); j++) {
			for (var k = floor((lev.worldY-y0) div HEIGHT); k < floor((lev.worldY+lev.pxHei-y0) div HEIGHT); k++) {
				global.LDtkWorldArray[j][k] = i;
			}
		}
	}
}

function findLevelAtCoordinates(_x, _y) {
	if (!inLDtkRoom()) return -1;
	var WIDTH = 800;
	var HEIGHT = 608;
	// get current worldX, worldY
	var xx = floor((_x+global.worldX-global.worldMinX)/WIDTH);
	var yy = floor((_y+global.worldY-global.worldMinY)/HEIGHT);
	if (xx < 0 || xx >= array_length(global.LDtkWorldArray)) return -1;
	if (yy < 0 || yy >= array_length(global.LDtkWorldArray[0])) return -1;
	return global.LDtkWorldArray[xx][yy];
}
