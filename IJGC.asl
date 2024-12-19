state("TheGreatCircle", "Update 1 (Steam)") //120745984 
{
    string32 level: "TheGreatCircle.exe", 0x4ACF4C8;
    byte mainmenu: "TheGreatCircle.exe", 0x4AD26E7;
    string100 cutsceneid: "TheGreatCircle.exe", 0x04ABD800, 0x0;
    int InCutscene: "TheGreatCircle.exe", 0x650AFB8;
    int loading: "TheGreatCircle.exe", 0x4AB4D90;
}

state("TheGreatCircle", "Game Pass") //120168448 
{
    string32 level: "TheGreatCircle.exe", 0x4A79EC0;
    byte mainmenu: "TheGreatCircle.exe", 0x4A7D0E7;
    string100 cutsceneid: "TheGreatCircle.exe", 0x04A68200, 0x0;
    int InCutscene: "TheGreatCircle.exe", 0x64B5838;
    int loading: "TheGreatCircle.exe", 0x4A5F790;
}

startup
{
    settings.Add("map_splits", true, "Map Change Splits");
    settings.SetToolTip("map_splits", "Enables automatic splitting on various map changes.");
    
        settings.Add("peru", false, "Peru", "map_splits");
            settings.SetToolTip("peru", "This setting does nothing because it's covered by autostart. The map is only listed here for completeness.");
        settings.Add("college_night", true, "College (Night)", "map_splits");
        settings.Add("college_day", false, "College (Day)", "map_splits");
        settings.Add("vatican_intro", true, "Vatican (Night)", "map_splits");
        settings.Add("vatican", false, "Vatican (Day)", "map_splits");
        settings.Add("vatican_exit", false, "Vatican (Finale)", "map_splits");
            settings.SetToolTip("vatican_exit", "Map where Indy boards the German airship with Gina.");
        settings.Add("gizeh_intro", true, "Gizeh (Intro)", "map_splits");
            settings.SetToolTip("gizeh_intro", "Inside the airship.");
        settings.Add("gizeh", false, "Gizeh", "map_splits");
            settings.SetToolTip("gizeh", "Gizeh proper. You probably don't want to split here if you already split on gizeh_intro.");
        settings.Add("gizeh_outro", false, "Gizeh (Outro)", "map_splits");
            settings.SetToolTip("gizeh_outro", "Indy escapes the pyramid and gets buried in sand.");
        settings.Add("nepal_intro", true, "Nepal (Intro)", "map_splits");
            settings.SetToolTip("nepal_intro", "Short cutscene map right after exiting Gizeh.");
        settings.Add("nepal_mountain", false, "Nepal (Mountain)", "map_splits");
            settings.SetToolTip("nepal_mountain", "Nepal snow trek proper. You probably don't want to split here if you already split on nepal_intro.");
        settings.Add("nepal_ship_int", false, "Nepal (Ship Interior)", "map_splits");
        settings.Add("nepal_ship_ext", false, "Nepal (Ship Exterior)", "map_splits");
        settings.Add("shanghai", true, "Shanghai", "map_splits");
        settings.Add("sukhothai_intro", true, "Sukhothai (Hotel)", "map_splits");
        settings.Add("sukhothai", false, "Sukhothai (River)", "map_splits");
        settings.Add("iraq", true, "Iraq (Encampment)", "map_splits");
        settings.Add("iraq_lake", false, "Iraq (Ark)", "map_splits");

    settings.Add("cutscene_splits", false, "Cutscene Splits");
    settings.SetToolTip("cutscene_splits", "Enables automatic splitting on various cutscenes.");

        settings.Add("vatican_birdwatching", false, "Vatican (Window Skip)", "cutscene_splits");
            settings.SetToolTip("vatican_birdwatching", "Cutscene when Voss arrives via airship and Indy spies on him with binoculars (after performing Window Skip).");
        settings.Add("vatican_inspectletter", false, "Vatican (Trial Skip)", "cutscene_splits");
            settings.SetToolTip("vatican_inspectletter", "Cutscene when Indy investigates letter in Vatican secret library (after performing Trial Skip and interacting with letter through the wall).");
        settings.Add("gizeh_stonetablets", false, "Gizeh (Blue Tent)", "cutscene_splits");
            settings.SetToolTip("gizeh_stonetablets", "Cutscene when Indy can exit the Blue Tent.");
        settings.Add("gizeh_lighter", false, "Gizeh (Lighter)", "cutscene_splits");
            settings.SetToolTip("gizeh_lighter", "Cutscene when Indy finds the Lighter merchant.");
        settings.Add("gizeh_meetvoss", false, "Gizeh (Meet Voss)", "cutscene_splits");
            settings.SetToolTip("gizeh_meetvoss", "Cutscene where Indy meets Voss in the German encampment.");
        settings.Add("gizeh_carvings", false, "Gizeh (Resonance Chamber)", "cutscene_splits");
            settings.SetToolTip("gizeh_carvings", "Cutscene when Indy enters the Resonance Chamber and inspects the Adamic carvings.");
}

init
{	
    print(modules.First().ModuleMemorySize.ToString());
    switch (modules.First().ModuleMemorySize)
    {
        case (120745984):
            version = "Update 1 (Steam)";
            break;
        case (120168448):
            version = "Game Pass";
            break;
	}
}

start
{
    return (current.level == "peru" && current.mainmenu == 0 && current.InCutscene == 0 && old.InCutscene == 1);
}

split
{
    // Entered a different map.
    if (settings["map_splits"] && current.level != old.level)
    {
        // check if we're supposed to split on the new map
        if (settings[current.level.ToLower()])
        {
            return true;
        }
    }

    // Skipped a cutscene.
    if (settings["cutscene_splits"] && current.cutsceneid != old.cutsceneid)
    {
        // check if we're supposed to split on this cutscene
        if (settings["vatican_birdwatching"] && current.cutsceneid == "cs/vatican/ch02se02_birdwatching01_cm")
        {
            return true;
        }
        if (settings["vatican_inspectletter"] && current.cutsceneid == "cs/vatican/ch02se03_inspectletter02_cm")
        {
            return true;
        }
        if (settings["gizeh_stonetablets"] && current.cutsceneid == "cs/gizeh/ch03se01_stonetablets02_cm")
        {
            return true;
        }
        if (settings["gizeh_lighter"] && current.cutsceneid == "de/gizeh/ch03al01_asmaatalk01_de")
        {
            return true;
        }
        if (settings["gizeh_meetvoss"] && current.cutsceneid == "cs/gizeh/ch03se02_meetvoss02_cm")
        {
            return true;
        }
        if (settings["gizeh_carvings"] && current.cutsceneid == "cs/gizeh/ch03se03_carvings01_cm")
        {
            return true;
        }
    }

    // Game end.
    if ((current.level == "iraq_lake" && current.cutsceneid == "cs/iraq/ch06se02_washedover01_cm" && current.InCutscene == 1)
    // Fallback in case the cutscene pointer breaks.
        || current.level == "iraq_farewell")
    {
        return true;
    }
}

isLoading
{
    return (current.loading == 1);
}  
