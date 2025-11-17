state("heretic", "August 7 2025 Steam")
{
    ulong base_ptr: 0x01248588;
    int ticks: 0x01248588, 0x9E8C;
    int intermission: 0x01248588, 0x5AB0;
}

state("heretic", "Sep 4 2025 Steam")
{
    ulong base_ptr: 0x012634E8;
    int ticks: 0x012634E8, 0x9FE4;
    int intermission: 0x012634E8, 0x5AB0;
}

state("heretic", "Oct 16 2025 Steam")
{
    ulong base_ptr: 0x012723E8;
    int ticks: 0x012723E8, 0x9FE4;
    int intermission: 0x012723E8, 0x5AB0;
}

startup
{
    vars.totalGameTime = 0f;

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
    switch (modules.First().ModuleMemorySize)
    {
        // TODO: Add module size for release day version.
        case 21934080: // 15.9 MB (16,763,312 bytes)
            version = "Sep 4 2025 Steam";
            break;
        case 22204416: // 16.0 MB (16,825,784 bytes)
            version = "Oct 16 2025 Steam";
            break;
        default:
            version = "UNKNOWN";
            MessageBox.Show(timer.Form, "Heretic + Hexen autosplitter startup failure. \nCould not recognize what version of the game you are running", "Heretic + Hexen startup failure", MessageBoxButtons.OK, MessageBoxIcon.Error);
            break;
    }
}

update
{
    if (current.base_ptr == 0)
    {
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
    // In Hexen, there's one tic of large delta when repeatedly travelling through the same portal.
    // I don't understand why so let's just add a hack to ignore it.
    if (delta > 35)
    {
        delta = 1;
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
