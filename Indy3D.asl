state("Indy3d")
{
    // UNUSED
    //float coordsX : 0x032304, 0x918;
    //float coordsY : 0x032304, 0x91C;

    int msecTimer : 0x16B878;
    int isLoading : 0x153850;

    int levelNumber : 0x1552E8;

    int isInventoryOpen : 0x1544A0;
    int isGameOpen : 0x0001F1F0, 0x8;
    int cutscene : 0x1401404;
    int credits : 0x1647CC;

    int treasureCounter : 0x155120;
}

startup
{
    settings.Add("all_treasures", false, "All Treasures splitting");
    settings.SetToolTip("all_treasures", "Enabling this option will split on every treasure pick-up.");
    settings.Add("custom_levels", false, "Enable custom level support");
    settings.SetToolTip("custom_levels", "Enabling this option will allow to split on more generic conditions, designed to support speedrunning custom levels which may or may not have opening cutscenes. Leave this disabled if you're playing the base campaign and you wish to prevent potential false positive starts.");

    // Get StopWatch for counting time while the game is paused
    vars.pauseTimer = new Stopwatch();
    vars.lastPauseTime = 0f;
    vars.gameTimer = 0f;

    vars.levelSelected = false;
}

gameTime
{
    int delta = current.msecTimer - old.msecTimer;
    // Clamp delta to avoid weird jumps when using quicksaves
    if (delta < 0 || delta > 100)
    {
        delta = 0;
    }

    // Add game time delta
    if (current.isLoading == 0 && current.isGameOpen == 1)
    {
        vars.gameTimer += delta;
    }

    // Start inventory timer
    if (old.isInventoryOpen == 0)
    {
        vars.pauseTimer.Start();
    }
    // Stop inventory timer
    else if (current.isInventoryOpen == 0)
    {
        vars.pauseTimer.Reset();
        vars.lastPauseTime = 0f;
    }
    // Add inventory timer delta
    if (current.isInventoryOpen > 0 && current.isGameOpen == 1)
    {
        vars.gameTimer += (vars.pauseTimer.ElapsedMilliseconds  - vars.lastPauseTime);
    }
    // Update last inventory timer time
    vars.lastPauseTime = vars.pauseTimer.ElapsedMilliseconds;

    // Return game time object
    return TimeSpan.FromMilliseconds(vars.gameTimer);
}

start
{   
    // Level ID == 0 signifies custom level.
    // However, level ID == 0 is also the default state so we don't want to handle
    // start for custom level until we're sure that a level has begun loading.
    if (current.levelNumber == 0 && current.isLoading == 1)
    {
        vars.levelSelected = true;
    }

    // Start when the starting cutscene starts
    // (prevents early start of the timer for RTA after you click the Start New Game button
    // but before the level starts playing).
    if ((current.cutscene > old.cutscene)

    // Special case for Nub's Tomb (which has no starting cutscene).
    || (current.levelNumber == 14 && current.isLoading < old.isLoading)

    // Special case for custom levels with ID == 0 (which may have no starting cutscene).
    || (settings["custom_levels"] && current.levelNumber == 0 && vars.levelSelected == true && current.isLoading < old.isLoading))
    {
        vars.levelSelected = false;
        vars.lastPauseTime = 0f;
        vars.gameTimer = 0f;
        vars.pauseTimer.Reset();
        return true;
    }
}

split
{   
    //Split by level
    if (current.levelNumber > old.levelNumber)
    {
        return true; 
    }
    
    //Split by treasure
    if (settings["all_treasures"] && current.treasureCounter > old.treasureCounter)
    {
        return true;
    }
    
    // Last split at the end of Peru
    if (current.levelNumber == 17 && current.credits != 0)
    {
        return true;
    }
}

isLoading
{
    return true;
}

onReset
{
    vars.levelSelected = false;
    vars.gameTimer = 0f;
    vars.lastPauseTime = 0f;
    vars.pauseTimer.Reset();
}
