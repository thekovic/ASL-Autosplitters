state("maxpayne")
{
	int onLoadScreen : 0x4A6400, 0x80, 0xB4;
	int comic : "e2mfc.dll", 0x651DC;
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

	vars.LEVEL_NUMS = new Dictionary<int, Tuple<double, double, double>>()
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

	settings.Add("nymRunMode", false, "NYM Run Mode");
	settings.SetToolTip("nymRunMode", "Times the current run using the in game New York Minute timer.");

	settings.Add("ilRunMode", false, "IL Run Mode");
	settings.SetToolTip("ilRunMode", "Starts the timer at the start of any level. Stops the timer when the level has been completed.");
}

init
{
	vars.levelIndex = 1;
	vars.autoEndDone = false;
	vars.resetValid = false;
	vars.playerInStartPosition = false;
	vars.playerInStartPosSet = false;
	vars.tutorialStatusIncrementedCount = 0;
	vars.keyCount = 1;
	vars.gameTime = new TimeSpan(0, 0, 0, 0);
	vars.tempX = new Tuple<double, double>(0, 0);
	vars.tempY = new Tuple<double, double>(0, 0);
	vars.tempZ = new Tuple<double, double>(0, 0);
}

update
{
	vars.playerInStartPosSet = false;

	if (current.level > 0 && current.level != old.level)
	{
		vars.tempX = new Tuple<double, double>(vars.LEVEL_NUMS[current.level].Item1 - vars.EPSILON, vars.LEVEL_NUMS[current.level].Item1 + vars.EPSILON);
		vars.tempY = new Tuple<double, double>(vars.LEVEL_NUMS[current.level].Item2 - vars.EPSILON, vars.LEVEL_NUMS[current.level].Item2 + vars.EPSILON);
		vars.tempZ = new Tuple<double, double>(vars.LEVEL_NUMS[current.level].Item3 - vars.EPSILON, vars.LEVEL_NUMS[current.level].Item3 + vars.EPSILON);
	}

	print("Current Level: " + current.level + "\nComic: " + current.comic +
				"\nIn Cutscene: " + current.inCutscene + 
				"\nPlayer Position: (" + current.playerX + ", " + current.playerY + ", " + current.playerZ + ")" + 
				"\nX Vals: (" + vars.tempX.Item1 + ", " + vars.tempX.Item2 + ")" +
				"\nY Vals: (" + vars.tempY.Item1 + ", " + vars.tempY.Item2 + ")" +
				"\nZ Vals: (" + vars.tempZ.Item1 + ", " + vars.tempZ.Item2 + ")" +
				"\n Game Time: " + current.nymGameTime +
				"\n Last Level Complete: " + current.lastLevelComplete);

	if (settings["ilRunMode"] && current.level > 0 && current.comic == 0 && current.inCutscene == 0 &&
			current.playerX >= vars.tempX.Item1 && current.playerX <= vars.tempX.Item2 &&
			current.playerY >= vars.tempY.Item1 && current.playerY <= vars.tempY.Item2 &&
			current.playerZ >= vars.tempZ.Item1 && current.playerZ <= vars.tempZ.Item2)
	{
		vars.playerInStartPosition = true;
		vars.playerInStartPosSet = true;
	}

	if (!settings["ilRunMode"] && current.level == 651 && current.comic == 0 && current.inCutscene == 0 &&
			current.playerX >= vars.tempX.Item1 && current.playerX <= vars.tempX.Item2 &&
			current.playerY >= vars.tempY.Item1 && current.playerY <= vars.tempY.Item2 &&
			current.playerZ >= vars.tempZ.Item1 && current.playerZ <= vars.tempZ.Item2)
	{
		vars.playerInStartPosition = true;
		vars.playerInStartPosSet = true;
	}

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
	vars.levelIndex = 1;
	vars.gameTime = TimeSpan.FromSeconds(0);
}

split
{
	if (settings["ilRunMode"] && !vars.autoEndDone)
	{
		if (current.level == 1374 && current.inCutscene == 1 && current.lastLevelComplete == 0)
		{
			vars.autoEndDone = true;
			vars.resetValid = true;
			return true;
		}
		else if (current.level == 531 && vars.tutorialStatusIncrementedCount == 8)
		{
			vars.autoEndDone = true;
			vars.resetValid = true;
			return true;
		}
		else if (current.level == 402 && current.secretFinaleComplete == 1)
		{
			vars.autoEndDone = true;
			vars.resetValid = true;
			return true;
		}
		else if (current.level != old.level && current.level > 0)
		{
			vars.autoEndDone = true;
			vars.resetValid = true;
			return true;
		}
	}

	if (!settings["ilRunMode"])
	{
		if (current.level != old.level && current.level > 0)
		{
			vars.keyCount = 0;

			foreach (int currentKey in vars.LEVEL_NUMS.Keys)
			{
				if (vars.keyCount == vars.levelIndex && currentKey == current.level)
				{
					vars.levelIndex++;
					return true;
				}

				vars.keyCount++;
			}
		}

		if (!vars.autoEndDone && current.level == 1374 && current.inCutscene == 1 && current.lastLevelComplete == 0)
		{
			vars.autoEndDone = true;
			vars.resetValid = true;
			return true;
		}
	}
}

gameTime
{
	if (settings["nymRunMode"])
	{
		if (current.level > 0 && current.nymGameTime > vars.EPSILON)
		{
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
		return current.onLoadScreen > 0 && current.comic == 0;
	}
}