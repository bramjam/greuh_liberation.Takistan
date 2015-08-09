if ( !(isNil "param_wipe_savegame_1") && !(isNil "param_wipe_savegame_2") ) then {
	if ( param_wipe_savegame_1 == 1 && param_wipe_savegame_2 == 1 ) then {
		profileNamespace setVariable ["GREUH_LIBERATION_SAVEGAME",nil];
	};
};

blufor_sectors = [];
all_fobs = [];
buildings_to_save= [];
combat_readiness = 0;
saved_ammo_res = 0;
stats_opfor_soldiers_killed = 0;
stats_opfor_killed_by_players = 0;
stats_blufor_soldiers_killed = 0;
stats_player_deaths = 0;
stats_opfor_vehicles_killed = 0;
stats_opfor_vehicles_killed_by_players = 0;
stats_blufor_vehicles_killed = 0;
stats_blufor_soldiers_recruited = 0;
stats_blufor_vehicles_built = 0;
stats_civilians_killed = 0;
stats_civilians_killed_by_players = 0;
stats_sectors_liberated = 0;
stats_playtime = 0;
stats_spartan_respawns = 0;
stats_secondary_objectives = 0;
stats_hostile_battlegroups = 0;
stats_ieds_detonated = 0;
stats_saves_performed = 0;
stats_saves_loaded = 0;
stats_reinforcements_called = 0;
stats_prisonners_captured = 0;
stats_blufor_teamkills = 0;
stats_vehicles_recycled = 0;
stats_ammo_spent = 0;
stats_sectors_lost = 0;
stats_fobs_built = 0;
stats_fobs_lost = 0;
stats_readiness_earned = 0;

no_kill_handler_classnames = [FOB_typename, huron_typename];
classnames_to_save = [FOB_typename, huron_typename];
{
	no_kill_handler_classnames pushback (_x select 0);
	classnames_to_save pushback (_x select 0);
} foreach buildings;

{
	classnames_to_save pushback (_x select 0);
} foreach (static_vehicles + air_vehicles + heavy_vehicles + light_vehicles + support_vehicles);

classnames_to_save = classnames_to_save + militia_vehicles + opfor_vehicles + opfor_troup_transports + opfor_air + opfor_choppers;

trigger_server_save = false;
greuh_liberation_savegame = profileNamespace getVariable "GREUH_LIBERATION_SAVEGAME";

if ( !isNil "greuh_liberation_savegame" ) then {
	blufor_sectors = greuh_liberation_savegame select 0;
	all_fobs = greuh_liberation_savegame select 1;
	buildings_to_save = greuh_liberation_savegame select 2;
	time_of_day = greuh_liberation_savegame select 3;
	combat_readiness = greuh_liberation_savegame select 4;
	
	date_year = date select 0;
	date_month = date select 1;
	date_day = date select 2;
	date_year = greuh_liberation_savegame select 5;
	date_month = greuh_liberation_savegame select 6;
	date_day = greuh_liberation_savegame select 7;
	saved_ammo_res = greuh_liberation_savegame select 8;
	
	if ( count greuh_liberation_savegame > 9 ) then {
		_stats = greuh_liberation_savegame select 9;
		stats_opfor_soldiers_killed = _stats select 0;
		stats_opfor_killed_by_players = _stats select 1;
		stats_blufor_soldiers_killed = _stats select 2;
		stats_player_deaths = _stats select 3;
		stats_opfor_vehicles_killed = _stats select 4;
		stats_opfor_vehicles_killed_by_players = _stats select 5;
		stats_blufor_vehicles_killed = _stats select 6;
		stats_blufor_soldiers_recruited = _stats select 7;
		stats_blufor_vehicles_built = _stats select 8;
		stats_civilians_killed = _stats select 9;
		stats_civilians_killed_by_players = _stats select 10;
		stats_sectors_liberated = _stats select 11;
		stats_playtime = _stats select 12;
		stats_spartan_respawns = _stats select 13;
		stats_secondary_objectives = _stats select 14;
		stats_hostile_battlegroups = _stats select 15;
		stats_ieds_detonated = _stats select 16;
		stats_saves_performed = _stats select 17;
		stats_saves_loaded = _stats select 18;
		stats_reinforcements_called = _stats select 19;
		stats_prisonners_captured = _stats select 20;
		stats_blufor_teamkills = _stats select 21;
		stats_vehicles_recycled = _stats select 22;
		stats_ammo_spent = _stats select 23;
		stats_sectors_lost = _stats select 24;
		stats_fobs_built = _stats select 25;
		stats_fobs_lost = _stats select 26;
		stats_readiness_earned = _stats select 27;
	};
	
	stats_saves_loaded = stats_saves_loaded + 1;
	
	{
		_nextclass = _x select 0;
		
		if ( _nextclass in classnames_to_save ) then {
			_nextpos = _x select 1;
			_nextdir = _x select 2;
			_nextbuilding = _nextclass createVehicle _nextpos;
			_nextbuilding setVectorUp [0,0,1];
			_nextbuilding setpos _nextpos;
			_nextbuilding setdir _nextdir;
			_nextbuilding setVectorUp [0,0,1];
			_nextbuilding setpos _nextpos;
			_nextbuilding setdir _nextdir;
			_nextbuilding setdamage 0;
			
			if ( !(_nextclass in no_kill_handler_classnames ) ) then {
				_nextbuilding addMPEventHandler ["MPKilled", {_this spawn kill_manager}];
			};
		};
		
	} foreach buildings_to_save;
	
	setDate [date_year, date_month, date_day, time_of_day, date select 4];
};

publicVariable "blufor_sectors";
publicVariable "all_fobs";
uiSleep 0.1;
save_is_loaded = true; publicVariable "save_is_loaded";

while { true } do {
	waitUntil { 
		sleep 0.3; 
		trigger_server_save || endgame == 1;
	};
	
	if ( endgame == 1 ) then {
		profileNamespace setVariable [ "GREUH_LIBERATION_SAVEGAME", nil ];
		saveProfileNamespace;
		while { true } do { sleep 300; };
	} else {
	
		trigger_server_save = false;
		buildings_to_save = [];
		
		_all_buildings = [];
		{
			_fobpos = _x;
			_nextbuildings = _fobpos nearobjects 200;
			{
				if ( (typeof _x) in classnames_to_save ) then {
					if ( alive _x && ( speed _x < 1 ) && (((getpos _x) select 2) < 10 )) then {
						_all_buildings pushback _x;
					}
				};
			} foreach _nextbuildings;
		} foreach all_fobs;
		
		{
			_nextclass = typeof _x;
			_nextpos = [(getpos _x) select 0, (getpos _x) select 1, 0];
			_nextdir = getdir _x;
			buildings_to_save pushback [ _nextclass,_nextpos,_nextdir ];
		} foreach _all_buildings;
		
		time_of_day = date select 3;
		
		stats_saves_performed = stats_saves_performed + 1;
		
		_stats = [];
		_stats pushback stats_opfor_soldiers_killed;
		_stats pushback stats_opfor_killed_by_players;
		_stats pushback stats_blufor_soldiers_killed;
		_stats pushback stats_player_deaths;
		_stats pushback stats_opfor_vehicles_killed;
		_stats pushback stats_opfor_vehicles_killed_by_players;
		_stats pushback stats_blufor_vehicles_killed;
		_stats pushback stats_blufor_soldiers_recruited;
		_stats pushback stats_blufor_vehicles_built;
		_stats pushback stats_civilians_killed;
		_stats pushback stats_civilians_killed_by_players;
		_stats pushback stats_sectors_liberated;
		_stats pushback stats_playtime;
		_stats pushback stats_spartan_respawns;
		_stats pushback stats_secondary_objectives;
		_stats pushback stats_hostile_battlegroups;
		_stats pushback stats_ieds_detonated;
		_stats pushback stats_saves_performed;
		_stats pushback stats_saves_loaded;
		_stats pushback stats_reinforcements_called;
		_stats pushback stats_prisonners_captured;
		_stats pushback stats_blufor_teamkills;
		_stats pushback stats_vehicles_recycled;
		_stats pushback stats_ammo_spent;
		_stats pushback stats_sectors_lost;
		_stats pushback stats_fobs_built;
		_stats pushback stats_fobs_lost;
		_stats pushback stats_readiness_earned;
		
		greuh_liberation_savegame = [blufor_sectors, all_fobs, buildings_to_save,time_of_day,combat_readiness,date select 0, date select 1, date select 2, resources_ammo, _stats];
		
		profileNamespace setVariable ["GREUH_LIBERATION_SAVEGAME",greuh_liberation_savegame];
		saveProfileNamespace;
	};
	
	
};