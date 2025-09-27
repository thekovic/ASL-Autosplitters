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

    settings.Add("glitchless", false, "Enable Elder God end split for Any% Glitchless");
    settings.SetToolTip("glitchless", "This option enables automatic split when you kill Elder God without dying and respawning at a checkpoint first (aka you reach him the intended way and kill him first try). Meant for Any% Glitchless. NOT RECOMMENDED to enable when running Any% and Vorador%.");

    settings.Add("split_area_entry", true, "Enable progression split (triggers in order listed)");
        settings.Add("ch2_start", true, "Chapter 2 (Raziel): Start", "split_area_entry");
        settings.Add("ch2_escape", true, "Chapter 2 (Raziel): Escape from Underworld", "split_area_entry");
        settings.Add("ch3_start", false, "Chapter 3 (Kain): Start", "split_area_entry");
        settings.Add("ch4_start", false, "Chapter 4 (Raziel): Start", "split_area_entry");
        settings.Add("ch4_dark", false, "Chapter 4 (Raziel): Enter Dark Forge (intended order)", "split_area_entry");
            settings.SetToolTip("ch4_dark", "Meant for Any% Glitchless.");
        settings.Add("ch4_light_enter", true, "Chapter 4 (Raziel): Enter Light Forge", "split_area_entry");
        settings.Add("ch4_light_exit", false, "Chapter 4 (Raziel): Exit Light Forge", "split_area_entry");
        settings.Add("ch4_dark2", true, "Chapter 4 (Raziel): Enter Dark Forge", "split_area_entry");
            settings.SetToolTip("ch4_dark", "Meant for Any% and Vorador%.");
        settings.Add("ch5_start", true, "Chapter 5 (Kain): Start", "split_area_entry");
        settings.Add("ch6_start", true, "Chapter 6 (Raziel): Start", "split_area_entry");
        settings.Add("ch6_fire", false, "Chapter 6 (Raziel): Enter Fire Forge", "split_area_entry");
        settings.Add("ch6_air", false, "Chapter 6 (Raziel): Enter Air Forge", "split_area_entry");
        settings.Add("ch7_start", true, "Chapter 7 (Kain): Start", "split_area_entry");
        settings.Add("ch7_water", false, "Chapter 7 (Kain): Enter Water Forge", "split_area_entry");
        settings.Add("ch8_start", false, "Chapter 8 (Raziel): Start", "split_area_entry");
        settings.Add("ch8_pool", false, "Chapter 8 (Raziel): Reach gargoyle pool room", "split_area_entry");
        settings.Add("ch8_water", false, "Chapter 8 (Raziel): Enter Water Forge", "split_area_entry");
        settings.Add("ch8_crypt", false, "Chapter 8 (Raziel): Enter the Crypt", "split_area_entry");
        settings.Add("ch9_start", false, "Chapter 9 (Kain): Start", "split_area_entry");
        settings.Add("ch9_air", false, "Chapter 9 (Kain): Enter Air Forge", "split_area_entry");
        settings.Add("ch10_start", false, "Chapter 10 (Raziel): Start", "split_area_entry");
        settings.Add("ch10_catacombs", false, "Chapter 10 (Raziel): Enter the Catacombs", "split_area_entry");
        settings.Add("ch11_start", false, "Chapter 11 (Kain): Start", "split_area_entry");
        settings.Add("ch12_mansion", false, "Chapter 12 (Raziel): Revisit Vorador's Mansion", "split_area_entry");
        settings.Add("ch12_citadel", false, "Chapter 12 (Raziel): Reach Vampire Citadel with Janos", "split_area_entry");
        settings.Add("ch13_start", false, "Chapter 13 (Kain): Start", "split_area_entry");
        settings.Add("ch13_eg", true, "Chapter 13 (Kain): Reach Elder God", "split_area_entry");

    // Map area split settings to their respective IDs.
    vars.areaMappings = new Dictionary<string, string>
    {
        {"ch2_start", "eldergod1a"},
        {"ch2_escape", "cemetery1A"},
        {"ch3_start", "shold14a"},
        {"ch4_start", "cemetery3a"},
        {"ch4_dark", "CITADEL14A"},
        {"ch4_light_enter", "CITADEL10A"},
        {"ch4_light_exit", "CEMETERY11A"},
        {"ch4_dark2", "CITADEL14A"},
        {"ch5_start", "SNOW_PILLARS10A"},
        {"ch6_start", "pillars9a"},
        {"ch6_fire", "CITADEL11A"},
        {"ch6_air", "CITADEL9A"},
        {"ch7_start", "CIT_EARLY1A"},
        {"ch7_water", "CIT_EARLY12A"},
        {"ch8_start", "vorador1A"},
        {"ch8_pool", "vorador5A"},
        {"ch8_water", "CITADEL12A"},
        {"ch8_crypt", "vorador21A"},
        {"ch9_start", "cit_early8a"},
        {"ch9_air", "CIT_EARLY9A"},
        {"ch10_start", "avernus99a"},
        {"ch10_catacombs", "avernus3A"},
        {"ch11_start", "AVERNUS1A"},
        {"ch12_mansion", "vorador_ruin10a"},
        {"ch12_citadel", "citadel1a"},
        {"ch13_start", "avernus6a"},
        {"ch13_eg", "citadel6A"}
    };

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
    vars.currentSplit = 0;
    vars.start = false;
    vars.waitingForStart = false;
    vars.splits = new List<string>();
}

update
{
    vars.in_start_y = (vars.startY + vars.leniency > current.y) && (vars.startY - vars.leniency < current.y);
    vars.in_start_x = (vars.startX + vars.leniency > current.x) && (vars.startX - vars.leniency < current.x);
}

split
{
    if (vars.currentSplit < vars.splits.Count)
    {
        if ((current.cell == vars.splits[vars.currentSplit]) && (current.cell != old.cell))
        {
            vars.currentSplit++;
            return true;
        }
    }
    // Split on final boss death.
    else
    {
        if (settings["glitchless"])
        {
            return (current.bossHP_glitchless == 0) && (current.bossHP_glitchless != old.bossHP_glitchless);
        }
        
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
        vars.splits.Clear();
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
        if (vars.splits.Count == 0)
        {
            // Fill splits for the upcoming run.
            foreach (var areaMapping in vars.areaMappings)
            {
                if (settings[areaMapping.Key])
                {
                    vars.splits.Add(areaMapping.Value);
                }
            }
        }

        vars.waitingForStart = false;
        return true;
    }
    return false;
}

onReset
{
    vars.currentSplit = 0;
    vars.waitingForStart = false;
    vars.splits.Clear();
}
