state("defiance")
{
    float x :               0x14d4d8;
    float y :               0x14d4dc;
    string15 cell :         0x330bc4;
    int bossHP :            0x20182c, 0x194;  // pointer for Elder God HP when checkpoint used
    int bossHP_glitchless : 0x2242d0, 0x1b0;  // pointer for Elder God HP directly from cutscene
    int gameState :         0x224598;
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
    settings.SetToolTip("light_forge_exit", "Add an additional split point after exiting the Light forge. Applies to Any% and Vorador%.");
    settings.Add("glitchless", false, "Enable Any% Glitchless");
    settings.SetToolTip("glitchless", "Enabling this option will switch to Glitchless splits (requires 23 splits). Overrides Vorador%.");

    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show
        (
            "This game uses Game Time as default timing method \n"+
            "LiveSplit is currently set to show Real Time.\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Wrong Timing Method",
            MessageBoxButtons.YesNo, MessageBoxIcon.Question
        );
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

init
{
    vars.splits = new List<string>();
    
    if (settings["glitchless"])
    {
        vars.splits.Add("eldergod1a");          // Chapter 2 start
        vars.splits.Add("shold14a");            // Chapter 3 start
        vars.splits.Add("cemetery3a");          // Chapter 4 start
        vars.splits.Add("CITADEL14A");          // Chapter 4 enter dark forge
        vars.splits.Add("CITADEL10A");          // Chapter 4 enter light forge
        vars.splits.Add("SNOW_PILLARS10A");     // Chapter 5 start
        vars.splits.Add("pillars9a");           // Chapter 6 start
        vars.splits.Add("CITADEL9A");           // Chapter 6 enter air forge
        vars.splits.Add("CIT_EARLY1A");         // Chapter 7 start
        vars.splits.Add("CIT_EARLY12A");        // Chapter 7 enter water forge
        vars.splits.Add("vorador1A");           // Chapter 8 start
        vars.splits.Add("vorador5A");           // Chapter 8 gargoyles
        vars.splits.Add("CITADEL12A");          // Chapter 8 enter water forge
        vars.splits.Add("cit_early8a");         // Chapter 9 start
        vars.splits.Add("CIT_EARLY9A");         // Chapter 9 enter air forge
        vars.splits.Add("avernus99a");          // Chapter 10 start
        vars.splits.Add("avernus3A");           // Chapter 10 catacombs
        vars.splits.Add("AVERNUS1A");           // Chapter 11 start
        vars.splits.Add("vorador_ruin10a");     // Chapter 12 return to mansion
        vars.splits.Add("citadel1a");           // Chapter 12 revive janos
        vars.splits.Add("avernus6a");           // Chapter 13 start
        vars.splits.Add("citadel6A");           // Chapter 15 reach eg
    }
    else
    {
        vars.splits.Add("eldergod1a");          // Chapter 2 (Raziel)
        vars.splits.Add("cemetery1A");          // Escape from Underworld
        vars.splits.Add("CITADEL10A");          // Enter Light forge
        if (settings["light_forge_exit"])
        {
            vars.splits.Add("CEMETERY11A");     // Exit Light forge
        }
        vars.splits.Add("CITADEL14A");          // Enter Dark forge
        vars.splits.Add("SNOW_PILLARS10A");     // Chapter 5 (Kain)
        vars.splits.Add("pillars9a");           // Chapter 6 (Raziel)
        if (settings["vorador"])
        {
            vars.splits.Add("CITADEL11A");      // Enter Fire forge
            vars.splits.Add("CIT_EARLY1A");     // Chapter 7 (Kain)
            vars.splits.Add("CIT_EARLY12A");    // Collect Reaver emblem
            vars.splits.Add("vorador1A");       // Chapter 8 (Raziel)
            vars.splits.Add("CITADEL12A");      // Enter Water forge
            vars.splits.Add("vorador21A");      // Crypt done
            vars.splits.Add("cit_early1A");     // Chapter 9 (Kain)
        }
        else
        {
            vars.splits.Add("CIT_EARLY1A");     // Chapter 7 (Kain)
        }
        vars.splits.Add("citadel6A");           // Enter Elder God fight
    }

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

    // split on final boss death
    if (settings["glitchless"])
    {
        return (current.bossHP_glitchless == 0) && (current.bossHP_glitchless != old.bossHP_glitchless);
    }

    return (current.bossHP == 0) && (current.bossHP != old.bossHP);
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
