state("maxpayne")
{
	int onLoadScreen : 0x4A6400, 0x80, 0xB4;
	int viewingComic : "e2mfc.dll", 0x651DC;
	int inCutscene : 0x4B5080;
	int level : 0x4B1370;
	int lastLevelComplete : 0x4B408C, 0x154;
	int tutorialStatus : 0x4B3E7C;
	int secretFinaleComplete : 0xF6770, 0x144;
	float playerX : 0x4B709C, 0x49C;
	float playerY : 0x4B709C, 0x4A0;
	float playerZ : 0x4B709C, 0x4A4;
	float nymGameTime : 0x4B709C, 0x770;
}

startup
{
	vars.EPSILON = 0.0001;

	vars.LEVELS_START_POS = new Dictionary<int, Tuple<double, double, double>>()
	{
		{651, new Tuple<double, double, double>(-0.63, -0.235, -13.37)}, 			//P1C0
		{1608, new Tuple<double, double, double>(-3.72829, 0.265, 2.93426)}, 		//P1C1
		{1260, new Tuple<double, double, double>(-7.9164, -1.535, 11.05049)}, 		//P1C2
		{2094, new Tuple<double, double, double>(5.35735, -1.23565, -0.19876)}, 	//P1C3
		{1656, new Tuple<double, double, double>(-0.245, 4.18743, 1.245)}, 			//P1C4
		{1338, new Tuple<double, double, double>(8.9852, -8.735, 16.8309)}, 		//P1C5
		{1254, new Tuple<double, double, double>(8.91932, -2.70375, -19.90189)},	//P1C6
		{1344, new Tuple<double, double, double>(-13.42828, 3.765, -21.90380)}, 	//P1C7
		{1347, new Tuple<double, double, double>(3.228, -1.235, 4.41129)}, 			//P1C8
		{234, new Tuple<double, double, double>(-4.16971, 3.265, -11.75)}, 			//P1C9
		{417, new Tuple<double, double, double>(-0.88, 0.265, 0.13)}, 				//P2C0
		{1179, new Tuple<double, double, double>(1.58614, -1.735, 5.83239)}, 		//P2C1
		{1086, new Tuple<double, double, double>(-5.22265, -5.735, -7.73495)}, 		//P2C2
		{897, new Tuple<double, double, double>(7.86934, -3.735, -14.86930)}, 		//P2C3
		{1581, new Tuple<double, double, double>(-3.88, -0.735, -12.12)}, 			//P2C4
		{1620, new Tuple<double, double, double>(-2.9325, 3.39, -0.495)}, 			//P2C5
		{714, new Tuple<double, double, double>(-0.96905, -11.735, 0.17413)}, 		//P3C0
		{1146, new Tuple<double, double, double>(18.52538, 8.02949, 21.91796)}, 	//P3C1
		{1920, new Tuple<double, double, double>(1.995, 0.265, -6.495)}, 			//P3C2
		{2781, new Tuple<double, double, double>(0.87, 0.265, 0.13)}, 				//P3C3
		{1209, new Tuple<double, double, double>(-17.57814, -2.235, 27.09968)}, 	//P3C4
		{1401, new Tuple<double, double, double>(13.86994, -1.735, 8.8075)}, 		//P3C5
		{1014, new Tuple<double, double, double>(-12.995, -0.735, -1.87)}, 			//P3C6
		{1110, new Tuple<double, double, double>(3.20039, -4.735, -0.1623)}, 		//P3C7
		{1374, new Tuple<double, double, double>(6.92828, -30.735, -0.84619)}, 		//P3C8
		{531, new Tuple<double, double, double>(0.05304, -5.235, 14.39606)}, 		//Tutorial
		{402, new Tuple<double, double, double>(3.755, -1.235, 3.63)} 				//Secret Finale
	};

	vars.LEVEL_NUMS = new int[27] {651, 1608, 1260, 2094, 1656, 1338, 1254, 1344, 1347, 234, 417, 1179, 1086, 897, 1581, 1620, 714, 1146, 1920, 2781, 1209, 1401, 1014, 1110, 1374, 531, 402};
	
	settings.Add("nymRunMode", false, "NYM Run Mode");
	settings.SetToolTip("nymRunMode", "Times the current run using the in game New York Minute timer.");

	settings.Add("ilRunMode", false, "IL Run Mode");
	settings.SetToolTip("ilRunMode", "Starts the timer at the start of any level. Stops the timer when the level has been completed.");
}

init
{
	vars.nextLevelIndex = 1;
	vars.autoEndDone = false;
	vars.resetValid = false;
	vars.playerInStartPosition = false;
	vars.playerInStartPosSet = false;
	vars.shouldSplit = false;
	vars.tutorialStatusIncrementedCount = 0;
	vars.gameTime = new TimeSpan(0, 0, 0, 0);
	vars.startPositionX = new Tuple<double, double>(0, 0);
	vars.startPositionY = new Tuple<double, double>(0, 0);
	vars.startPositionZ = new Tuple<double, double>(0, 0);
}

update
{
	vars.playerInStartPosSet = false;

	if (current.level > 0 && current.level != old.level)
	{
		// defines the coordinate range of Max's starting position for the current level (to deal with float inaccuracies)
		vars.startPositionX = new Tuple<double, double>(vars.LEVELS_START_POS[current.level].Item1 - vars.EPSILON, vars.LEVELS_START_POS[current.level].Item1 + vars.EPSILON);
		vars.startPositionY = new Tuple<double, double>(vars.LEVELS_START_POS[current.level].Item2 - vars.EPSILON, vars.LEVELS_START_POS[current.level].Item2 + vars.EPSILON);
		vars.startPositionZ = new Tuple<double, double>(vars.LEVELS_START_POS[current.level].Item3 - vars.EPSILON, vars.LEVELS_START_POS[current.level].Item3 + vars.EPSILON);
	}

	if (settings["ilRunMode"] && current.level > 0 && current.viewingComic == 0 && current.inCutscene == 0 &&
			current.playerX >= vars.startPositionX.Item1 && current.playerX <= vars.startPositionX.Item2 &&
			current.playerY >= vars.startPositionY.Item1 && current.playerY <= vars.startPositionY.Item2 &&
			current.playerZ >= vars.startPositionZ.Item1 && current.playerZ <= vars.startPositionZ.Item2)
	{
		vars.playerInStartPosition = true;
		vars.playerInStartPosSet = true;
	}

	if (!settings["ilRunMode"] && current.level == 651 && current.viewingComic == 0 && current.inCutscene == 0 &&
			current.playerX >= vars.startPositionX.Item1 && current.playerX <= vars.startPositionX.Item2 &&
			current.playerY >= vars.startPositionY.Item1 && current.playerY <= vars.startPositionY.Item2 &&
			current.playerZ >= vars.startPositionZ.Item1 && current.playerZ <= vars.startPositionZ.Item2)
	{
		vars.playerInStartPosition = true;
		vars.playerInStartPosSet = true;
	}

	// almost every time you kill an enemy in the tutorial, the so-called tutorial status will increment...
	// we can use this to tell when the tutorial is complete, since killing enemies is the main and final goal
	// note: there are some other tutorial actions that increment the tutorial status
	if (current.level == 531 && current.tutorialStatus == old.tutorialStatus + 1)
	{
		vars.tutorialStatusIncrementedCount += 1;
	}

	if (!vars.playerInStartPosSet)
	{
		vars.playerInStartPosition = false;
		vars.resetValid = true;
	}

	return true;
}

start
{
	if (vars.playerInStartPosition)
	{
		return true;
	}
}

onStart
{
	vars.autoEndDone = false;
	vars.tutorialStatusIncrementedCount = 0;
}

reset
{
	if (vars.resetValid && vars.playerInStartPosition)
	{
		return true;
	}
}

onReset
{
	vars.resetValid = false;
	vars.autoEndDone = false;
	vars.tutorialStatusIncrementedCount = 0;
	vars.nextLevelIndex = 1;
	vars.gameTime = new TimeSpan(0, 0, 0, 0);
}

split
{
	vars.shouldSplit = false;

	if (settings["ilRunMode"] && !vars.autoEndDone)
	{
		// split at the end of P3C8 when the final cutscene begins
		if (current.level == 1374 && current.inCutscene == 1 && current.lastLevelComplete == 0)
		{
			vars.shouldSplit = true;
		}
		// split at the end of the Tutorial when the final enemy has been killed
		else if (current.level == 531 && vars.tutorialStatusIncrementedCount == 8)
		{
			vars.shouldSplit = true;
		}
		// split at the end of the Secret Finale when all the enemies are dead
		else if (current.level == 402 && current.secretFinaleComplete == 1)
		{
			vars.shouldSplit = true;
		}
		// split at the loading screen at the end for all the other levels
		else if (current.level != old.level && current.level > 0)
		{
			vars.shouldSplit = true;
		}
	}

	if (!settings["ilRunMode"] && !vars.autoEndDone)
	{
		if (current.level != old.level && current.level > 0)
		{
			if (current.level == vars.LEVEL_NUMS[vars.nextLevelIndex])
			{
				vars.nextLevelIndex++;
				vars.shouldSplit = true;
			}
		}

		//special case to autosplit once the final cutscene in P3C8 has started
		if (current.level == 1374 && current.inCutscene == 1 && current.lastLevelComplete == 0)
		{
			vars.autoEndDone = true;
			vars.shouldSplit = true;
		}
	}

	if (vars.shouldSplit)
	{
		vars.resetValid = true;
		return true;
	}
}

gameTime
{
	if (settings["nymRunMode"])
	{
		if (current.level > 0 && current.nymGameTime > vars.EPSILON)
		{
			//just take the time from the game, as it keeps the entire time of the run
			//doing it this way allows loading quick saves or autosaves to correctly adjust the timer
			vars.gameTime = TimeSpan.FromSeconds(current.nymGameTime);
		}
		
		return vars.gameTime;
	}
}

isLoading
{
	if (settings["nymRunMode"])
	{
		return true;
	}
	else
	{
		return current.onLoadScreen > 0 && current.viewingComic == 0;
	}
}