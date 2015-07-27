#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include qczm\_utility;

onPrecacheGameType()
{
	// this may or may not be precached in time in _globallogic
	game["strings"]["humans_eliminated"] = &"QCZM_GAME_ALLIES_ELIMINATED";
	game["strings"]["zombies_eliminated"] = &"QCZM_GAME_AXIS_ELIMINATED";
	
	// precached assets	
}

onSpawnPlayer()
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	self spawn( spawnPoint.origin, spawnPoint.angles );
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	// self == victim
	// attacker == inflictor
	
	// wait one frame in order to give all extra scripts time to process
	waitframe();
	if ( isDefined( attacker ) && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] && is_true( level.choseFirstZM ) )
	{
		if( self GetPlayerTeam() == "allies" )
			self SetPlayerTeam( "axis" );
		
		playSoundOnPlayers( "mp_enemy_obj_captured", "allies" );
		playSoundOnPlayers( "mp_war_objective_taken", "axis" );
		
		if( GetPlayersInTeam( "allies" ) > 1 )
			IPrintLnBold( "Human down!" );
		
		if( GetPlayersInTeam( "allies" ) == 1 )
			IPrintLnBold( "Only one Human left!" );
			
		if( GetPlayersInTeam( "allies" ) == 0 )
			thread maps\mp\gametypes\_globallogic::endGame( "axis",  );
		
	}
}

SetPlayerTeam( team, connecting )
{
	if( !IsDefined( self ) || !IsPlayer( self ) )
		return;
	
	switch( team )
	{
		case "allies":
			if( is_true( connecting ) && is_false( level.choseFirstZM ))
				self SetHuman();
		break;
		
		case "axis":
			if( is_true( level.choseFirstZM ) && self GetPlayerTeam() == "allies" )
				self SetZombie();
			break;
		
		default:
			self [[level.spectator]]();
			break;
	}
}

GetPlayersInTeam( team )
{
	if( !IsDefined( team ) )
		return;
	
	players = get_players();
	num = 0;
	for( i = 0; i < players.size; i++ )
	{
		if(players GetPlayerTeam() == team)
			num++;
	}
	return num;
}

SetHuman()
{
	self [[level.leavesquad]]();
	self closeMenus();
	
	if(self.pers["team"] != "allies")
	{		
		if (level.allow_teamchange == "0" && (isdefined(self.hasDoneCombat) && self.hasDoneCombat) )
		{
			return;
		}
		
		// allow respawn when switching teams during grace period.
		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;
			
		if(self.sessionstate == "playing")
		{
			self menuLeaveSquad();
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "allies";
		self.team = "allies";
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		self.sessionteam = "allies";

		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpselfguid = self getGuid();

		logPrint( "JT;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + "\n" );

		self notify("joined_team");
		self notify("end_respawn");
	}
	
	self SetHumanClass();
}


SetZombie()
{
	self [[level.leavesquad]]();
	self closeMenus();
	
	if(self.pers["team"] != "axis")
	{
		if (level.allow_teamchange == "0" && (isdefined(self.hasDoneCombat) && self.hasDoneCombat) )
		{
			return;
		}
		
		// allow respawn when switching teams during grace period.
		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;

		if(self.sessionstate == "playing")
		{
			self menuLeaveSquad();
			self.switching_teams = true;
			self.joining_team = "axis";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "axis";
		self.team = "axis";
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		self.sessionteam = "axis";

		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpselfguid = self getGuid();

		logPrint( "JT;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + "\n" );

		self notify("joined_team");
		self notify("end_respawn");
	}
	
	self SetZombieClass();
}

SetHumanClass()
{
	assert( self.pers["team"] == "axis" || self.pers["team"] == "allies" );
	
	team = self.pers["team"];
	
	
}
SetZombieClass()
{
	assert( self.pers["team"] == "axis" || self.pers["team"] == "allies" );
	
	team = self.pers["team"];

}