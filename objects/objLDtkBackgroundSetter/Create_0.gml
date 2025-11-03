var spr = asset_get_index(name);
if (spr > -1) {
	var lay_id = layer_get_id("Background");
	var back_id = layer_background_get_id(lay_id);
	
	layer_background_blend(back_id, c_white);
	
	layer_background_sprite(back_id, spr);
	
	if (stretched) {
		layer_background_stretch(back_id, true);
	}
	else {
		layer_background_htiled(back_id, true);
		layer_background_vtiled(back_id, true);
	}
}
