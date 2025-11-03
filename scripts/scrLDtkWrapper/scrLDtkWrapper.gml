function loadLevel(levelName=global.LDtkCurrentLevel, spawnEntity="") {
	instance_destroy(objLDtk);
	
	global.LDtkCurrentLevel = levelName;
	global.LDtkSpawnEntity = spawnEntity;
	
	room_goto(rLDtkSetup);
}

function getLevelInfoFromName(levelName=global.LDtkCurrentLevel) {
	if (is_undefined(global.LDtkMapInfo)) {
		LDtkInit();
	}
	var keys = variable_struct_get_names(global.LDtkMapInfo);
	var i = 0; repeat(array_length(keys)) {
		var info = global.LDtkMapInfo[$ keys[i]];
		if (info.name == levelName) {
			return info;
		}
		i++;
	}
	throw "not found: "+levelName;
	return undefined;
}

/// warps player to destination entity
function warpPlayerTo(destination) {
	if (is_struct(destination)) {
		if (destination[$ "entity_ref"] == noone) return false;
		loadLevel(destination[$ "level_name"], destination[$ "entity_ref"]);
		return true;
	}
	else if (instance_exists(destination)) {
		with (destination) {
			spawnPlayer();
			return true;
		}
	}
	return false; // this is so doors etc know when there is no valid destination
}

function inLDtkRoom(r = room) {
	return (r == rLDtk || r == rLDtkSetup);
}

// iteratively trigger each instance in a chain
function doTriggerLDtk(e) {
	while (instance_exists(e)) {
		var next = e.target; // temporarily store current instance in case onTrigger() calls instance_destroy()
		e.onTrigger();
		e = next;
	}
}
