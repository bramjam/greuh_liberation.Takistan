_thispos = _this select 0;

_attacktime = time;
waitUntil { 
	sleep 1;
	(time > (_attacktime  + 600 )) || [_thispos] call F_sectorOwnership != EAST;
};
waitUntil { [_thispos] call F_sectorOwnership != RESISTANCE };

if ( endgame == 0 ) then {
	if ( [_thispos] call F_sectorOwnership == EAST ) then {
		[ [ _thispos , 2 ] , "remote_call_fob" ] call BIS_fnc_MP;
		sleep 3;
		all_fobs = all_fobs - [_thispos];
		publicVariable "all_fobs";
		reset_battlegroups_ai = true;
		[_thispos] call destroy_fob;
		trigger_server_save = true;
		[] call recalculate_caps;
		stats_fobs_lost = stats_fobs_lost + 1;
	} else {
		[ [ _thispos , 3 ] , "remote_call_fob" ] call BIS_fnc_MP;
	};
};

sleep 15;