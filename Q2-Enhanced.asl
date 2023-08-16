state("quake2ex_gog", "GOG")
{
    string255 map: "game_x64.dll", 0x239050;
    int intermission: "game_x64.dll", 0x1CDD38;
    int menu: 0x6EB6FC;
}

state("quake2ex_steam", "Steam")
{
    string255 map: "game_x64.dll", 0x239050;
    int intermission: "game_x64.dll", 0x1CDD38;
    int menu: 0x6F4E7C;
}

startup
{
    settings.Add("ignoreIntermission", false, "Don't time intermissions");
}

init
{
    switch (modules.First().ModuleMemorySize)
    {
        case 39395328:
            version = "Steam";
            break;
        case 39354368:
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

    vars.lastMap = "";
    vars.listVisitedMaps = new List<string>();
    vars.campaignStarts = new string[] {
        "base1", "mguhub", "xswamp", "rmine1", "q64/outpost"
    };
    vars.campaignEnds = new string[] {
        "boss2", "mguboss", "xmoon1", "rboss", "q64/command"
    };
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
    if ((Array.IndexOf(vars.campaignEnds, current.map) > -1) && current.intermission > 0)
    {
        vars.listVisitedMaps.Add(vars.lastMap + current.map);
        vars.lastMap = current.map;
        return true;
    }

    if (old.map != current.map && !(current.map == null || current.map.Length == 0) && !current.map.Contains(".cin"))
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