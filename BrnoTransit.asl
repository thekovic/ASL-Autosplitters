state("BrnoTransit")
{
	int gameTime : 0x177958;
    int menu : 0x177850;
}

startup
{
    vars.totalGameTime = 0f;
}

start
{
    if (old.menu == 1 && current.menu == 0)
    {
        return true;
    }
}

gameTime
{
    int delta = current.gameTime - old.gameTime;
    if (delta < 0)
    {
        delta = 0;
    }
    vars.totalGameTime += delta;

    return TimeSpan.FromSeconds(vars.totalGameTime / 60f);
}

isLoading
{
    return true;
}

onReset
{
    vars.totalGameTime = 0f;
}
