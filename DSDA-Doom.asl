state("dsda-doom", "0.29.0")
{
    int episode : 0x72F7B0;
    int map : 0x72F7B4;
    int isPaused : 0x9A0B4C;
    int levelTicks : 0x97EF70;
    int playerHealth : 0x72FE58;
}

startup
{
    vars.gameTimer = 0f;
}

start
{
    if (current.map == 1 && current.isPaused == 0 && current.playerHealth != 0)
    {
        vars.gameTimer = 0f;
        return true;
    }
}

split
{
    if (current.episode > old.episode || current.map > old.map)
    {
        return true;
    }
}

gameTime
{
    int delta = current.levelTicks - old.levelTicks;
    if (delta < 0)
    {
        delta = 0;
    }
    
    vars.gameTimer += delta;

    return TimeSpan.FromSeconds(vars.gameTimer / 35f);
}

isLoading
{
    return true;
}

onReset
{
    vars.gameTimer = 0f;
}
