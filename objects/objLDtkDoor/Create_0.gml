spawnPlayer = function() {
	instance_destroy(objPlayer);
	instance_create_layer(x, y, "Player", objPlayerStart);
};
