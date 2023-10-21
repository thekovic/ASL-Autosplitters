state("quake2ex_gog", "GOG")
{
    string255 map: 0x1347E10;
    int intermission: 0x9C52AC;
    int menu: 0x6F862C;
    int loading: 0x1AF32D8;
    int isGameplay: 0x157C124;
    //int isGameplay2: 0x158566C;
}

state("quake2ex_steam", "Steam")
{
    string255 map: 0x1351350;
    int intermission: 0x7EE4CC;
    int menu: 0x701DAC;
    int loading: 0x1AFC8C8;
    int isGameplay: 0x1585664;
    //int isGameplay2: 0x158566C;
}

init
{
    switch (modules.First().ModuleMemorySize)
    {
        case 39583744:
            version = "Steam";
            break;
        case 39542784:
            version = "GOG";
            break;
        default:
            version = "UNKNOWN";
            MessageBox.Show
            (
                timer.Form,
                "Quake 2 Enhanced autosplitter startup failure. \nCould not recognize what version of the game you are running",
                "Quake 2 Enhanced startup failure", MessageBoxButtons.OK, MessageBoxIcon.Error
            );
            break;
    }

    // Name of last valid map we visited
    vars.lastMap = "";
    // List of level changes that were already used (eg. base1base2 or base2base1 or base2base3)
    vars.usedLevelChanges = new List<string>();
    // We forbid intermission splits if one has already occured (so that it doesn't get spammed)
    // or if we want to prevent a false positive (in Q2 64)
    vars.allowIntermissionSplit = true;

    vars.campaignStarts = new string[] {
        "base1", "mguhub", "xswamp", "rmine1", "q64/outpost"
    };
    vars.campaignEnds = new string[] {
        "boss2", "mguboss", "xmoon1", "rboss", "q64/command"
    };
    vars.q64NotUnitEnds = new string[] {
        "q64/outpost", "q64/complex", "q64/intel", //"q64/comm",
        "q64/orbit", //"q64/station",
        "q64/ship", //"q64/cargo",
        "q64/mines", //"q64/storage",
        "q64/organic", "q64/process", "q64/geo-stat", "q64/jail", "q64/lab", "q64/bio", //"q64/conduits",
        "q64/core" 
    };
}

startup
{
    settings.Add("splitEveryMap", true, "Split on mid-unit map transitions.");
    settings.SetToolTip("splitEveryMap", "When this setting is unchecked, splits will occur only at the end of units.");
    settings.Add("splitChecks", true, "Enable checks for duplicate map transitions.", "splitEveryMap");
    settings.SetToolTip("splitChecks",
    "When this setting is checked, every unique map change pair will trigger a split only once. This is to prevent duplicate and accidental splits.");
}

start
{
    if (Array.IndexOf(vars.campaignStarts, current.map) > -1)
    {
        vars.lastMap = current.map;
        return true;
    }
}

split
{
    // Checks for any change in current map
    // Map name can sometimes be empty while loading - we ignore those
    // Cinematics are also ignored
    if ((old.map != current.map) && !(current.map == null || current.map.Length == 0) && !current.map.Contains(".cin"))
    {
        // If map changed, we can allow intermissions to trigger a split again
        vars.allowIntermissionSplit = true;

        // If we split on every map, check that we really changed map (could be just a quickload)
        if (settings["splitEveryMap"] && (vars.lastMap != current.map))
        {
            // Split checks are enabled so we check if we didn't already go through this level change
            if (settings["splitChecks"])
            {
                if (!vars.usedLevelChanges.Contains(vars.lastMap + current.map))
                {
                    vars.usedLevelChanges.Add(vars.lastMap + current.map);
                    vars.lastMap = current.map;
                    return true;
                }
            }
            // Just split always
            else
            {
                vars.lastMap = current.map;
                return true;
            }
        }

        // Always update this even if we didn't split so that the last map doesn't stay hanging somewhere unexpected
        vars.lastMap = current.map;
    }

    // In Q2 64 campaign, all maps have intermissions. If map is not End of Unit, forbid splitting.
    if (vars.allowIntermissionSplit && (Array.IndexOf(vars.q64NotUnitEnds, current.map) > -1))
    {
        vars.allowIntermissionSplit = false;
    }

    // Intermission screen
    if (current.intermission > 6)
    {
        // Always split on campaign end
        if (Array.IndexOf(vars.campaignEnds, current.map) > -1)
        {
            vars.usedLevelChanges.Add(vars.lastMap + current.map);
            vars.lastMap = current.map;
            return true;
        }

        // Split on End of Unit (they always have intermission)
        if (!settings["splitEveryMap"] && vars.allowIntermissionSplit)
        {
            vars.lastMap = current.map;
            vars.allowIntermissionSplit = false;
            return true;
        }
    }
}

reset
{
    // Reset in main menu but not if you just pause
    if (current.menu == 1 && (current.map == null || current.map.Length == 0) )
    {
        vars.usedLevelChanges.Clear();
        return true;
    }
}

isLoading
{
    if (current.intermission != 0)
    {
        return true;
    }

    if (current.loading != 0)
    {
        return true;
    }

    if (current.isGameplay == 0)
    {
        return true;
    }

    return false;
}

onStart
{
    vars.lastMap = current.map;
}

onReset
{
    vars.usedLevelChanges.Clear();
    vars.allowIntermissionSplit = true;
}