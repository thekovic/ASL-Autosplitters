state("TheGreatCircle", "Steam (Update 1)") //120745984 
{
    string32 level: "TheGreatCircle.exe", 0x4ACF4C8;
    byte mainmenu: "TheGreatCircle.exe", 0x4AD26E7;
    string100 cutsceneid: "TheGreatCircle.exe", 0x04ABD800, 0x0;
    int InCutscene: "TheGreatCircle.exe", 0x650AFB8;
    int loading: "TheGreatCircle.exe", 0x4AB4D90;
}

state("TheGreatCircle", "Steam (Update 2)") //120745984 
{
    string32 level: "TheGreatCircle.exe", 0x4ACE3C8;
    byte mainmenu: "TheGreatCircle.exe", 0x4AD15E7;
    string100 cutsceneid: "TheGreatCircle.exe", 0x04ABC700, 0x0;
    int InCutscene: "TheGreatCircle.exe", 0x6509EB8;
    int loading: "TheGreatCircle.exe", 0x4AB3C90;
}

state("TheGreatCircle", "Steam (1.00)") //117886976
{
    string32 level: "TheGreatCircle.exe", 0x4A853B8;
    byte mainmenu: "TheGreatCircle.exe", 0x4A885D7;
    string100 cutsceneid: "TheGreatCircle.exe", 0x04A736F0, 0x0;
    int InCutscene: "TheGreatCircle.exe", 0x6250C98;
    int loading: "TheGreatCircle.exe", 0x4A6AC80;
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
    settings.Add("any_percent_ending", true, "Any% autoend.");
    settings.SetToolTip("any_percent_ending", "Enables autoend for Any% category runs (split on cutscene when you grab Gina's hand).");

    settings.Add("map_splits", true, "Map Change Splits");
    settings.SetToolTip("map_splits", "Enables automatic splitting on various map changes.");
    
        settings.Add("peru", false, "Peru", "map_splits");
            settings.SetToolTip("peru", "This setting does nothing because it's covered by autostart. The map is only listed here for completeness.");
        settings.Add("college_night", true, "College (Night)", "map_splits");
        settings.Add("college_day", false, "College (Day)", "map_splits");
        settings.Add("vatican_intro", true, "Vatican Castle (Night)", "map_splits");
            settings.SetToolTip("vatican_intro", "Vatican intro map in the castle where you first meet Antonio.");
        settings.Add("vatican_intro_day", false, "Vatican Castle (Day)", "map_splits");
            settings.SetToolTip("vatican_intro", "Vatican map in the castle during daytime. Only visited if you backtrack.");
        settings.Add("vatican", false, "Vatican City", "map_splits");
            settings.SetToolTip("vatican", "You may not want to split here if you run All Ancient Relics or 100% because of backtracking for the Serpent's Chest.");
        settings.Add("vatican_exit", false, "Vatican (Finale)", "map_splits");
            settings.SetToolTip("vatican_exit", "Map where Indy boards the German airship with Gina.");
        settings.Add("gizeh_intro", true, "Gizeh (Intro)", "map_splits");
            settings.SetToolTip("gizeh_intro", "Inside the airship.");
        settings.Add("gizeh", false, "Gizeh", "map_splits");
            settings.SetToolTip("gizeh", "Gizeh proper. You probably don't want to split here if you already split on gizeh_intro. You may not want to split here if you run All Ancient Relics or 100% category because of backtracking for the Serpent's Chest.");
        settings.Add("gizeh_outro", false, "Gizeh (Outro)", "map_splits");
            settings.SetToolTip("gizeh_outro", "Indy escapes the pyramid and gets buried in sand.");
        settings.Add("nepal_intro", true, "Nepal (Intro)", "map_splits");
            settings.SetToolTip("nepal_intro", "Short cutscene map right after exiting Gizeh.");
        settings.Add("nepal_mountain", false, "Nepal (Mountain)", "map_splits");
            settings.SetToolTip("nepal_mountain", "Nepal snow trek proper. You probably don't want to split here if you already split on nepal_intro.");
        settings.Add("nepal_ship_int", false, "Nepal (Ship Interior)", "map_splits");
        settings.Add("nepal_ship_ext", false, "Nepal (Ship Exterior)", "map_splits");
        settings.Add("shanghai", true, "Shanghai", "map_splits");
            settings.SetToolTip("shanghai", "You may not want to split here if you run All Ancient Relics or 100% category because of backtracking for the Serpent's Chest.");
        settings.Add("sukhothai_intro", true, "Sukhothai (Hotel)", "map_splits");
        settings.Add("sukhothai", false, "Sukhothai (River)", "map_splits");
            settings.SetToolTip("sukhothai", "You may not want to split here if you run All Ancient Relics or 100% category because of backtracking for the Serpent's Chest.");
        settings.Add("iraq", true, "Iraq (Encampment)", "map_splits");
        settings.Add("iraq_lake", false, "Iraq (Ark)", "map_splits");
        // Used as map split as fallback for Any% runs in case the cutscene pointer breaks.
        settings.Add("iraq_farewell", true, "Iraq (Outro)", "map_splits");
            settings.SetToolTip("iraq_farewell", "You may not want to split here if you run All Ancient Relics or 100% category if you already split on iraq.");

    settings.Add("cutscene_splits", false, "Cutscene Splits");
    settings.SetToolTip("cutscene_splits", "Enables automatic splitting on various cutscenes.");

        settings.Add("vatican_camera", false, "Vatican (Camera)", "cutscene_splits");
            settings.SetToolTip("vatican_camera", "Cutscene when Indy finds the Camera merchant.");
        settings.Add("vatican_wine", false, "Vatican (Wine)", "cutscene_splits");
            settings.SetToolTip("vatican_wine", "Cutscene when Indy and Antonio examine the photos and Antonio gives Indy a wine bottle.");
        settings.Add("vatican_birdwatching", false, "Vatican (Window Skip)", "cutscene_splits");
            settings.SetToolTip("vatican_birdwatching", "Cutscene when Voss arrives via airship and Indy spies on him with binoculars (after performing Window Skip).");
        settings.Add("vatican_ginaappears", false, "Vatican (Gina Fountain)", "cutscene_splits");
            settings.SetToolTip("vatican_ginaappears", "Cutscene when Gina appears at the Fountain of Confession and spooks Indy.");
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

    // Map cutscene settings to their respective cutscene IDs.
    vars.cutsceneMappings = new Dictionary<string, string>
    {
        {"vatican_camera", "de/vatican/ch02al01_ernestotalk01_de"},
        {"vatican_wine", "cs/vatican/ch02se02_sacredwounds02_cm"},
        {"vatican_birdwatching", "cs/vatican/ch02se02_birdwatching01_cm"},
        {"vatican_ginaappears", "cs/vatican/ch02se03_ginaappears01_cm"},
        {"vatican_inspectletter", "cs/vatican/ch02se03_inspectletter02_cm"},
        {"gizeh_stonetablets", "cs/gizeh/ch03se01_stonetablets02_cm"},
        {"gizeh_lighter", "de/gizeh/ch03al01_asmaatalk01_de"},
        {"gizeh_meetvoss", "cs/gizeh/ch03se02_meetvoss02_cm"},
        {"gizeh_carvings", "cs/gizeh/ch03se03_carvings01_cm"}
    };

    vars.gameVersion = "Unknown";
}

init
{	
    print(modules.First().ModuleMemorySize.ToString());
    switch (modules.First().ModuleMemorySize)
    {
        case (120745984):
            // Test Update 1.
            vars.gameVersion = memory.ReadString(modules.First().BaseAddress + 0x34F502F, 12);
            if (vars.gameVersion == "umber-jasper")
            {
                version = "Steam (Update 1)";
                return;
            }
            // Test Update 2.
            vars.gameVersion = memory.ReadString(modules.First().BaseAddress + 0x34F2FAF, 12);
            if (vars.gameVersion == "jasper-olive")
            {
                version = "Steam (Update 2)";
                return;
            }
            // Can't figure it out.
            version = "Steam (Unknown)";
            break;
        case (117886976):
            version = "Steam (1.00)";
            break;
        case (120168448):
            version = "Game Pass";
            break;
        default:
            version = "Unknown";
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
        // Check if we're supposed to split on this cutscene.
        foreach (var cutsceneMapping in vars.cutsceneMappings)
        {
            if (settings[cutsceneMapping.Key] && current.cutsceneid == cutsceneMapping.Value)
            {
                return true;
            }
        }
    }

    // Game end for Any%.
    if (settings["any_percent_ending"] && current.level == "iraq_lake" && current.cutsceneid == "cs/iraq/ch06se02_washedover01_cm" && current.InCutscene == 1)
    {
        return true;
    }
}

isLoading
{
    return (current.loading == 1);
}  
