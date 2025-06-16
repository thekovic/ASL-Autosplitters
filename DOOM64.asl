state("DOOM64_x64", "Jun 10 2022 Steam")
{
    int map: 0x72968C;
    int warpTarget: 0x543428;
    int levelTics: 0x75B1F0;
    int mainMenu: 0x53AC24;
    int pause: 0x66815C;
    int gameState: 0x53FED4;
    int playerHealth: 0x75B250;
}
state("DOOM64_x64", "May 23 2022 GOG")
{
    int map: 0x714F4C;
    int warpTarget: 0x5300D8;
    int levelTics: 0x746970;
    int mainMenu: 0x527C04;
    int pause: 0x653B7C;
    int gameState: 0x52CC54;
    int playerHealth: 0x7469D0;
}

startup
{
    vars.totalGameTime = 0f;
    
    settings.Add("ILstart", false, "IL Autostart");
    settings.Add("warped", false, "Warped category run");
}

init
{
    switch (modules.First().ModuleMemorySize)
    {
        case 8409088: // 5.85 MB (6,136,832 bytes)
            version = "Jun 10 2022 Steam";
            break;
        case 8323072: // 5.76 MB (6,047,744 bytes)
            version = "May 23 2022 GOG";
            break;
        default:
            version = "UNKNOWN";
            MessageBox.Show(timer.Form, "Doom 64 autosplitter startup failure. \nCould not recognize what version of the game you are running", "Doom 64 startup failure", MessageBoxButtons.OK, MessageBoxIcon.Error);
            break;
    }
}

start
{
    if (
        ( (current.map == 1 || current.map == 34) || (settings["ILstart"] && current.map != 33) )
        && current.gameState == 1 && current.playerHealth != 0 && current.pause != 1
    )
    {
        // DOOM starts from tic 1.
        vars.totalGameTime = 1f;
        return true;
    }
}

gameTime
{
    int delta = current.levelTics - old.levelTics;
    if (delta < 0)
    {
        delta = 0;
    }
    vars.totalGameTime += delta;

    return TimeSpan.FromSeconds(vars.totalGameTime / 30f);
}

split
{
    // Split on level change.
    if (current.map > old.map)
    {
        // We need to add one tic every level start because DOOM doesn't start from tic 0.
        vars.totalGameTime += 1;
        return true;
    }

    // Split on game ending.
    if (
        (current.map == 28 && current.gameState == 4) ||
        (current.map == 39 && current.gameState == 4) ||
        (current.map == 30 && current.gameState == 4 && settings["warped"])
    )
    {
        return true;
    }
}

reset
{
    if (current.warpTarget == 70)
    {
        return false;
    }
    if (current.mainMenu == 1 && current.pause == 1)
    {
        vars.totalGameTime = 0f;
        return true;
    }
}

isLoading
{
    return true;
}

onReset
{
    vars.totalGameTime = 0f;
}