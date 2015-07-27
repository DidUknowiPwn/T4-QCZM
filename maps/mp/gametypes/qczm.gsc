#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

/*
	QCZM
	Objective: 	Humans vs Zombies, which one survives at the end of the time wins.
	Map ends:	When either team has 0 players or time ends.
	Respawning:	No wait / Away from other players
*/

/*QUAKED mp_dm_spawn (1.0 0.5 0.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies at one of these positions.*/

main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 15, 0, 30 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 0, 0, 0 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 0 );
	
	level.teambased = true;

	level.onStartGameType = onStartGameType;
	level.onSpawnPlayer = qczm\main\_gamelogic::::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPlayerKilled = qczm\main\_gamelogic::onPlayerKilled;
	level.onPrecacheGameType = qczm\main\_gamelogic::::onPrecacheGameType;

	game["dialog"]["offense_obj"] = "ffa_boost";
	game["dialog"]["defense_obj"] = "ffa_boost";
}


onStartGameType()
{
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"QCZM_OBJECTIVES" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"QCZM_OBJECTIVES" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"QCZM_OBJECTIVES" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"QCZM_OBJECTIVES" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"QCZM_OBJECTIVES_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"QCZM_OBJECTIVES_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"QCZM_OBJECTIVES_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"QCZM_OBJECTIVES_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	allowed[0] = "dm";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();

	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_75", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_50", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_25", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "suicide", 0 );
	maps\mp\gametypes\_rank::registerScoreInfo( "teamkill", 0 );
	
	level.displayRoundEndText = false;
	level.QuickMessageToAll = false;
	
	qczm();
}

onSpawnPlayerUnified()
{
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}

qczm()
{
	
}