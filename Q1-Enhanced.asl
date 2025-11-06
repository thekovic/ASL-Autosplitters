state("Quake_x64_steam", "Steam")
{
    string255 map: 0x18DDE30;
    int intermission: 0x9DD3AEC;
    int menu: 0xE7AC84;
}

state("Quake_Shipping_Playfab_GOG_x64", "GOG")
{
    string255 map: 0x18A4B70;
    int intermission: 0x9D9A68C;
    int menu: 0xE566F4;
}

startup
{
    settings.Add("episodeRun", false, "Episode Run");
    settings.SetToolTip
    (
        "episodeRun",
        "Select when doing Episode Runs. Starts timer on first map of each episode and splits at intermission of last map of each episode."
    );
    settings.Add("ignoreHub", false, "Don't time Hub maps");
    settings.Add("ignoreIntermission", false, "Don't time intermissions");
}

init
{
    switch (modules.First().ModuleMemorySize)
    {
        case 166821888:
            version = "Steam";
            break;
        case 166580224:
            version = "GOG";
            break;
        default:
            version = "UNKNOWN";
            MessageBox.Show
            (
                timer.Form,
                "Quake 1 Enhanced autosplitter startup failure. \nCould not recognize what version of the game you are running",
                "Quake 1 Enhanced startup failure", MessageBoxButtons.OK, MessageBoxIcon.Error
            );
            break;
    }

    vars.lastMap = "";
    vars.listVisitedMaps = new List<string>();
    vars.fullGameStarts = new string[] {
        "start"
    };
    vars.fullGameEnds = new string[] {
        "end", "hipend", "r2m8", "e5end", "mgend", "nend"
    };
    vars.episodeStarts = new string[] {
        "e1m1", "e2m1", "e3m1", "e4m1", "hip1m1", "hip2m1", "hip2m3", "r1m1", "r2m1", "mge1m1", "mge2m1", "mge3m1", "mge4m1", "mge5m1"
    };
    vars.episodeEnds = new string[] {
        "e1m7", "e2m6", "e3m6", "e4m7", "hip1m4", "hip2m5", "hipend", "r1m7", "r2m8", "mge1m2", "mge2m2", "mge3m2", "mge4m2", "mge5m2"
    };
}

start
{
    if (settings["episodeRun"]) 
    {
        if (Array.IndexOf(vars.episodeStarts, current.map) > -1)
        {
            vars.lastMap = current.map;
            return true;
        }
    }

    if (Array.IndexOf(vars.fullGameStarts, current.map) > -1)
    {
        vars.lastMap = current.map;
        return true;
    }
}

split
{
    if (settings["episodeRun"]) 
    {
        if ((Array.IndexOf(vars.episodeEnds, current.map) > -1) && current.intermission > 0)
        {
            vars.listVisitedMaps.Add(vars.lastMap + current.map);
            vars.lastMap = current.map;
            return true;
        }
    }

    if ((Array.IndexOf(vars.fullGameEnds, current.map) > -1) && current.intermission > 0)
    {
        vars.listVisitedMaps.Add(vars.lastMap + current.map);
        vars.lastMap = current.map;
        return true;
    }

    if (old.map != current.map && !(current.map == null || current.map.Length == 0))
    {
        if (vars.lastMap != current.map && !vars.listVisitedMaps.Contains(vars.lastMap + current.map))
        {
            vars.listVisitedMaps.Add(vars.lastMap + current.map);
            vars.lastMap = current.map;
            return true;
        }

        vars.lastMap = current.map;
    }
}

reset
{
    if (current.menu == 1 && (current.map == null || current.map.Length == 0) )
    {
        vars.listVisitedMaps.Clear();
        return true;
    }
}

isLoading
{
    if (settings["ignoreHub"] && (Array.IndexOf(vars.fullGameStarts, current.map) > -1))
    {
        return true;
    }
    
    if (settings["ignoreIntermission"] && (current.intermission > 0))
    {
        return true;
    }

    return false;
}

onReset
{
    vars.listVisitedMaps.Clear();
}
