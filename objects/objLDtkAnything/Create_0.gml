onTrigger = function() {};

var obj = asset_get_index(objectName);

if (obj > -1) {
	// for now we use instance_change instead of destroying this and creating a new object
	// to maintain instance ID
	instance_change(obj, true);
}
