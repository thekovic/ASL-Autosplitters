state("indy")
{
    byte320 data: 0xbce70;
}

startup
{
    // Missing levels are cutscenes
    vars.levelList = new string[] {
        "M01_SriLanka_01", "M01_SriLanka_02", "M01_SriLanka_03",
        "M01_SriLanka_04", "M01_SriLanka_05", "M01_SriLanka_06",
        "M01_SriLanka_07", "M01_SriLanka_08", "M01_SriLanka_09",
        "M02_Prague_01", "M02_Prague_02", "M02_Prague_03",
        "M02_Prague_04", "M02_Prague_05", "M02_Prague_06",
        "M02_Prague_07", "M02_Prague_08", "M02_Prague_09",
        "M02_Prague_10", "M02_Prague_11", "M02_Prague_12",
        "M02_Prague_13",
        "M03_Istanbul_01", "M03_Istanbul_02", "M03_Istanbul_03",
        "M03_Istanbul_04", "M03_Istanbul_05", "M03_Istanbul_06",
        "M03_Istanbul_07",
        "M04_HongKong_01", "M04_HongKong_02",
        "M04_HongKong_03", "M04_HongKong_04",
        "M05_SUBBASE_01", "M05_SUBBASE_02", "M05_SUBBASE_03",
        "M05_SUBBASE_05", "M05_SUBBASE_06",
        "M06_Gondola_01", "M06_Gondola_02", "M06_Gondola_03",
        "M06_Gondola_04", "M06_Gondola_05",
        "M07_Fortress_01", "M07_Fortress_02", "M07_Fortress_03", "M07_Fortress_04",
        "M08_EvilTemple_01", "M08_EvilTemple_02", "M08_EvilTemple_03", "M08_EvilTemple_04",
        "M09_Tomb_01", "M09_Tomb_02", "M09_Tomb_03", "M09_Tomb_04",
        "M10_DeadCity_01", "M10_DeadCity_02", "M10_DeadCity_03", "M10_DeadCity_04"
    };

    settings.Add("automaticResetEnable", false, "Automatic Reset (HOVER MOUSE OVER ME!)");
    settings.SetToolTip("automaticResetEnable",
        "By ticking this box, you confirm that you WANT the timer to automatically reset when the main menu is entered.\n DON'T USE THIS IF YOUR GAME TENDS TO CRASH!");
}

init
{
    vars.currentLevelName = "";
    vars.nextLevel = 1;
    vars.readyToStart = true;
}

start
{
    if (vars.readyToStart == true &&
        (vars.currentLevelName == vars.levelList[0]         // Ceylon
        || vars.currentLevelName == vars.levelList[9]       // Prague
        || vars.currentLevelName == vars.levelList[22]      // Istanbul
        || vars.currentLevelName == vars.levelList[29]      // Hong Kong
        || vars.currentLevelName == vars.levelList[33]      // Lagoon
        || vars.currentLevelName == vars.levelList[38]      // Mountains
        || vars.currentLevelName == vars.levelList[43]      // Black Dragon Fortress
        || vars.currentLevelName == vars.levelList[47]      // Temple of Kong Tien
        || vars.currentLevelName == vars.levelList[51]      // Emperor's Tomb
        || vars.currentLevelName == vars.levelList[55])     // Netherworld
        )
    {
        vars.readyToStart = false;
        char chapter = vars.currentLevelName[2];
        switch (chapter)
        {
            case '1':
                vars.nextLevel = 1;
                break;
            case '2':
                vars.nextLevel = 10;
                break;
            case '3':
                vars.nextLevel = 23;
                break;
            case '4':
                vars.nextLevel = 30;
                break;
            case '5':
                vars.nextLevel = 34;
                break;
            case '6':
                vars.nextLevel = 39;
                break;
            case '7':
                vars.nextLevel = 44;
                break;
            case '8':
                vars.nextLevel = 48;
                break;
            case '9':
                vars.nextLevel = 52;
                break;
            case '0':
                vars.nextLevel = 56;
                break;
            default:
                break;
        }
        return true;
    }
    return false;
}

update
{
    // Parses level name from the hunk of data in memory
    // Needed because the exact location of the level name string can change during gameplay
    string[] dataStrings = Encoding.UTF8.GetString(current.data).Split('\0');
    foreach (string x in dataStrings)
    {
        string[] temp = x.Split(':');
        if (temp[0] == "map")
        {
            vars.currentLevelName = temp[1];
        }
    }
    // TODO: Remove (debug only)
    // print(vars.currentLevelName);

    if (vars.currentLevelName == "")
    {
        vars.readyToStart = true;
    }
}

split
{
    // Needs to be lower case because the level name is in lower case in memory
    // after you die for some reason
    if (vars.levelList[vars.nextLevel].ToLower() == vars.currentLevelName.ToLower())
    {
        vars.nextLevel++;
        return true;
    }
    // TODO: Add autosplit for final boss being defeated
    return false;
}

reset
{
    if (settings["automaticResetEnable"] && vars.currentLevelName == "")
    {
        vars.readyToStart = true;
        return true;
    }
    return false;
}
