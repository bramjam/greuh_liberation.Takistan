waitUntil { !isNil "blufor_sectors" };
waitUntil { !isNil "combat_readiness" };
waitUntil { !isNil "sectors_bigtown" };
waitUntil { !isNil "active_sectors" };

while { true } do {
	if ( (count blufor_sectors) >= ((count sectors_allSectors) * 0.85)) then {
		if ( combat_readiness > 0 ) then {
			combat_readiness = combat_readiness - 0.25;
		};
	} else {
		if ( combat_readiness < ((count blufor_sectors) * 0.66) && combat_readiness < 70 ) then {
			combat_readiness = combat_readiness + 0.25;
			stats_readiness_earned = stats_readiness_earned + 0.25;
		};
	};
	
	if (combat_readiness > 100) then {
		combat_readiness = 100;
	};
	
	sleep (30 + random (60));
};