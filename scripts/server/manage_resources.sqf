waitUntil { !isNil "blufor_sectors" };
waitUntil { !isNil "save_is_loaded" };

[] call recalculate_caps;

tick_period = 60;

ammo_sector_value = 0.5;
resources_ammo = saved_ammo_res;

while { endgame == 0 } do {

	[] call recalculate_caps;
	
	_nbsectorsmil = 0;
	
	{
		if ( _x in sectors_military ) then {
			_nbsectorsmil = _nbsectorsmil + 1;
		};
	} foreach blufor_sectors;
	
	resources_ammo = resources_ammo + ( ammo_sector_value * _nbsectorsmil) ;
	sleep tick_period;
};