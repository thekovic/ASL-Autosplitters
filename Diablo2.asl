state("Game", "1.14a")
{
    bool loading : 0x30A844;
    bool saving : 0x37D110;
    bool saving2 : 0x37DD30;
    bool inGame: 0x30A45C;
    bool inMenu : 0x478B70;
}

state("Game", "1.14b")
{
    bool loading : 0x30EF7C;
    bool saving : 0x370760;
    bool saving2 : 0x371380;
    bool inGame : 0x30EBC4;
    bool inMenu : 0x47993C;
}

state("Game", "1.14c")
{
    bool loading : 0x30DF7C;
    bool saving : 0x36F760;
    bool saving2 : 0x370380;
    bool inGame : 0x30DBC4;
    bool inMenu : 0x478884;
}

state("Game", "1.14d")
{
    bool loading : 0x30F2C0;
    bool saving : 0x3792F8;
    bool saving2 : 0x3786D0;
    bool inGame : 0x30EE8C;
    bool inMenu : 0x379970;
    // This one retains last area ID after save&exit but briefly resets to 0 while loading character.
    //int areaId : 0x3C89DC;
    // This one goes to 0 in main menu.
    int areaId : 0x3C8C7C;
    int ptr_playerLevel : 0x3BB5C0;
    short playerLevel : 0x3BB5C0, 0x20;
}

startup
{
    settings.Add("split_level_up", false, "Split on level up. Check one option below to split only up to certain level.");
        settings.Add("split_level_up_to_18", false, "Up to level 18", "split_level_up");
        settings.Add("split_level_up_to_24", false, "Up to level 24", "split_level_up");
        settings.Add("split_level_up_to_30", false, "Up to level 30", "split_level_up");

    settings.Add("split_area_entry", true, "Split on first time area entry");
        settings.Add("act1_stony_field", false, "Act 1: Stony Field", "split_area_entry");
        settings.Add("act1_outer_cloister", false, "Act 1: Outer Cloister", "split_area_entry");
        settings.Add("act1_inner_cloister", false, "Act 1: Inner Cloister", "split_area_entry");
        settings.Add("act2_lut_gholein", true, "Act 2: Lut Gholein", "split_area_entry");
        settings.Add("act2_far_oasis", false, "Act 2: Far Oasis", "split_area_entry");
        settings.Add("act2_valley_of_snakes", false, "Act 2: Valley of Snakes", "split_area_entry");
        settings.Add("act2_harem", false, "Act 2: Harem", "split_area_entry");
        settings.Add("act2_canyon_of_the_magi", false, "Act 2: Canyon of the Magi", "split_area_entry");
        settings.Add("act3_kurast_docks", true, "Act 3: Kurast Docks", "split_area_entry");
        settings.Add("act3_flayer_jungle", false, "Act 3: Flayer Jungle", "split_area_entry");
        settings.Add("act3_lower_kurast", false, "Act 3: Lower Kurast", "split_area_entry");
        settings.Add("act3_kurast_causeway", false, "Act 3: Kurast Causeway", "split_area_entry");
        settings.Add("act3_durance_of_hate", false, "Act 3: Durance of Hate", "split_area_entry");
        settings.Add("act4_pandemonium_fortress", true, "Act 4: Pandemonium Fortress", "split_area_entry");
        settings.Add("act4_river_of_flame", false, "Act 4: River of Flame", "split_area_entry");
        settings.Add("act4_chaos_sanctuary", false, "Act 4: Chaos Sanctuary", "split_area_entry");
        settings.Add("act5_harrogath", true, "Act 5: Harrogath", "split_area_entry");
        settings.Add("act5_worldstone_keep", false, "Act 5: Worldstone Keep", "split_area_entry");

    // Map area split settings to their respective IDs.
    vars.areaMappings = new Dictionary<string, int>
    {
        {"act1_stony_field", 4},
        {"act1_outer_cloister", 27},
        {"act1_inner_cloister", 32},
        {"act2_lut_gholein", 40},
        {"act2_far_oasis", 43},
        {"act2_valley_of_snakes", 44},
        {"act2_harem", 50},
        {"act2_canyon_of_the_magi", 46},
        {"act3_kurast_docks", 75},
        {"act3_flayer_jungle", 78},
        {"act3_lower_kurast", 79},
        {"act3_kurast_causeway", 82},
        {"act3_durance_of_hate", 100},
        {"act4_pandemonium_fortress", 103},
        {"act4_river_of_flame", 107},
        {"act4_chaos_sanctuary", 108},
        {"act5_harrogath", 109},
        {"act5_worldstone_keep", 128}
    };

    // List of areas that have already been reached.
    vars.reachedAreas = new List<int>();
}

init
{
    switch (modules.First().FileVersionInfo.FileVersion)
    {
        case "1.14.0.64":
            version = "1.14a";
            break;
        case "1.14.1.68":
            version = "1.14b";
            break;
        case "1.14.2.70":
            version = "1.14c";
            break;
        case "1.14.3.71":
            version = "1.14d";
            break;
    }

    vars.crashed = false;
}

isLoading
{
    return (current.loading || ((current.saving || current.saving2) && !current.inGame && !current.inMenu)) && !vars.crashed;
}

start
{
    if (old.inMenu == true && current.inMenu == false)
    {
        return true;
    }
}

split
{
    // Split on level up.
    if (settings["split_level_up"] && current.ptr_playerLevel != 0 && current.playerLevel > old.playerLevel)
    {
        if (settings["split_level_up_to_18"] && current.playerLevel > 18)
        {
            return false;
        }
        if (settings["split_level_up_to_24"] && current.playerLevel > 24)
        {
            return false;
        }
        if (settings["split_level_up_to_30"] && current.playerLevel > 30)
        {
            return false;
        }
        
        return true;
    }

    // Split on area change (first time the area is reached).
    if (settings["split_area_entry"] && current.areaId != old.areaId)
    {
        // Check if we're supposed to split on this cutscene.
        foreach (var areaMapping in vars.areaMappings)
        {
            if (settings[areaMapping.Key] && current.areaId == areaMapping.Value && !vars.reachedAreas.Contains(current.areaId))
            {
                vars.reachedAreas.Add(current.areaId);
                return true;
            }
        }
    }
}

exit
{
    timer.IsGameTimePaused = false;
    vars.crashed = true;
}

onReset
{
    vars.reachedAreas.Clear();
}
