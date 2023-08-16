state("defiance")
{
	float x : 			0x14d4d8;
	float y : 			0x14d4dc;
	string15 cell : 	0x330bc4;
	int bossHP : 		0x20182c, 	0x194;
	int gameState :		0x224598;
}

startup
{
	vars.startZone = "shold1a";
	vars.startX = -3621.2f; //default position for shold1a
	vars.startY = -1271.6f; //default position for shold1a
	vars.leniency = 0.5f;
	
	vars.currentSplit = 0;
	
	vars.start = false;
	vars.waitingForStart = false;

	settings.Add("vorador", false, "Enable Vorador%");
	settings.SetToolTip("vorador", "By default, Any% route is followed (requires 9 splits). Enabling this option will switch to Vorador% (requires 15 splits).");
	settings.Add("light_forge_exit", false, "Split after exiting the Light forge");
	settings.SetToolTip("light_forge_exit", "Add a new split point after exiting the Light forge. Applies to both Any% and Vorador%.");
}

init
{
	vars.splits = new List<string>();
	vars.splits.Add("eldergod1a"); // Chapter 2 (Raziel)
	vars.splits.Add("cemetery1A"); // Escape from Underworld
	vars.splits.Add("CITADEL10A"); // Enter Light forge
	if (settings["light_forge_exit"])
	{
		vars.splits.Add("CEMETERY11A");	// Exit Light forge
	}
	vars.splits.Add("CITADEL14A");	// Enter Dark forge
	vars.splits.Add("SNOW_PILLARS10A");	// Chapter 5 (Kain)
	vars.splits.Add("pillars9a");	// Chapter 6 (Raziel)
	if (settings["vorador"])
	{
		vars.splits.Add("CITADEL11A");	// Enter Fire forge
	}
	vars.splits.Add("CIT_EARLY1A");	// Chapter 7 (Kain)
	if (settings["vorador"]) {
		vars.splits.Add("CIT_EARLY12A");	// Collect Reaver emblem
		vars.splits.Add("vorador1A");	// Chapter 8 (Raziel)
		vars.splits.Add("CITADEL12A");	// Enter Water forge
		vars.splits.Add("vorador21A");	// Crypt done
		vars.splits.Add("cit_early1A");	// Chapter 9 (Kain)
	}
	vars.splits.Add("citadel6A"); // Enter Elder God fight
	vars.splits = vars.splits.ToArray();
}

update
{
	vars.in_start_y = (vars.startY + vars.leniency > current.y) && (vars.startY - vars.leniency < current.y);
	vars.in_start_x = (vars.startX + vars.leniency > current.x) && (vars.startX - vars.leniency < current.x);
	if (timer.CurrentPhase == TimerPhase.NotRunning)
	{
		vars.currentSplit = 0;
	}
}

split
{
	if (vars.currentSplit < vars.splits.Length)
	{
		if ((current.cell == vars.splits[vars.currentSplit]) && (current.cell != old.cell))
		{
			vars.currentSplit++;
			return true;
		}
	}
	else
	{
		// split on final boss death
		return (current.bossHP == 0) && (current.bossHP != old.bossHP);
	}
}

isLoading
{
	return (current.gameState == 2);
}

reset
{
	if (current.cell == vars.startZone && vars.in_start_y && vars.in_start_x)
	{
		vars.currentSplit = 0;
		vars.waitingForStart = true;
		return true;
	}
	return false;
}

start
{
    if (current.cell == vars.startZone && vars.in_start_y && vars.in_start_x)
	{
        vars.waitingForStart = true;
    }
   
    if (vars.waitingForStart == true && current.cell == vars.startZone && !(vars.in_start_y && vars.in_start_x))
    {
        vars.waitingForStart = false;
        return true;
    }
    return false;
}