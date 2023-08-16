state("Indy3d")
{
    int missionNumber : 0x0139C0, 0x168;
    float coordsX : 0x032304, 0x918;
    float coordsY : 0x032304, 0x91C;
    int cutscene : 0x1401404;
    int isMenuOpen : 0x00014204, 0x0;
    int isGameOpen : 0x0001F1F0, 0x8;
    int isLoading : 0x00013224, 0x0;
    int credits : 0x000415CC, 0x22C;
    int treasureCounter : 0x00016A94, 0x4;
    int msecTimer : 0x16B878;
}

startup
{
    settings.Add("all_treasures", false, "All Treasures splitting");
    settings.SetToolTip("all_treasures", "Enabling this option will split on every treasure pick-up.");
}

init
{
    // Get StopWatch for counting time while the game is paused
    vars.pauseTimer = new Stopwatch();
    vars.lastPauseTime = 0f;
    vars.gameTimer = 0f;
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
    if (old.isMenuOpen == 0)
    {
        vars.pauseTimer.Start();
    }
    // Stop inventory timer
    else if (current.isMenuOpen == 0)
    {
        vars.pauseTimer.Reset();
        vars.lastPauseTime = 0f;
    }
    // Add inventory timer delta
    if (current.isMenuOpen > 0 && current.isGameOpen == 1)
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
    // Start when the starting cutscene starts
    // (prevents early start of the timer for RTA after you click the Start New Game button but before
    //  the level starts playing)
    // Special case for Nub's Tomb which has no starting cutscene
    if (current.cutscene > old.cutscene || current.missionNumber == 14 && current.isLoading < old.isLoading)
    {
        vars.lastPauseTime = 0f;
        vars.gameTimer = 0f;
        vars.pauseTimer.Reset();
        return true;
    }
    
    //Coords for the begin of Canyon
    /*if (current.missionNumber == 1 && current.posX <= -0.72 && current.posY >= 1.41)
    {
        return true;
    }*/
}

split
{   
    //Split by level
    if (current.missionNumber > old.missionNumber)
    {
        return true; 
    }
    
    //Split by treasure
    if (settings["all_treasures"] && current.treasureCounter > old.treasureCounter)
    {
        return true;
    }
    
    // Last split at the end of Peru
    if (current.missionNumber == 17 && current.credits != 0)
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
    vars.gameTimer = 0f;
    vars.lastPauseTime = 0f;
    vars.pauseTimer.Reset();
}
