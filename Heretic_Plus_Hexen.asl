state("heretic", "August 7 2025, Steam")
{
    ulong base_ptr: 0x01248588;
    int ticks: 0x01248588, 0x9E8C;
    int intermission: 0x01248588, 0x5AB0;
}

startup
{
    vars.totalGameTime = 0f;
}

update
{
    if (current.base_ptr == 0)
    {
        print("TITLE SCREEN");
        return false;
    }
}

start
{
    if (current.intermission == 0 && old.intermission == 3)
    {
        vars.totalGameTime = 0f;
        // Intermission switches to 0 late so we need to add an initial burst of ticks.
        vars.totalGameTime += current.ticks;
        print("Start: " + current.ticks.ToString());
        
        return true;
    }
}

split
{
    // Split on level intermission.
    if (current.intermission == 1 && old.intermission == 0)
    {
        return true;
    }
}

gameTime
{
    // We keep a running total using delta time because we can't rely solely
    // on the level time (for example, to account for saving/loading). 
    int delta = current.ticks - old.ticks;
    if (delta < 0)
    {
        delta = 0;
    }

    vars.totalGameTime += delta;

    return TimeSpan.FromSeconds(vars.totalGameTime / 35f);
}

isLoading
{
    return true;
}

onReset
{
    vars.totalGameTime = 0f;
}
