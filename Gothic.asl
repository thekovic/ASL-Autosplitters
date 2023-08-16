state("GothicMod", "v1.30")
{
    long igt: "ZSPEEDRUNTIMER.DLL", 0x1A048;
}
state("Gothic", "v1.12")
{
    long igt: "ZSPEEDRUNTIMER.DLL", 0x19F08;
}
state("GothicMod", "v1.12")
{
    long igt: "ZSPEEDRUNTIMER.DLL", 0x19F08;
}
state("Gothic2", "v2.6")
{
    long igt: "ZSPEEDRUNTIMER.DLL", 0x19FE0;
}
state("Gothic2", "v1.30")
{
    long igt: "ZSPEEDRUNTIMER.DLL", 0x19F70;
}
state("Gothic2Classic")
{
    long igt: "ZSPEEDRUNTIMER.DLL", 0x19F70;
}

init
{
    if (modules.First().ModuleMemorySize == 7675904)
    {
        version = "v2.6";
    }   
    else if (modules.First().ModuleMemorySize == 7061504)
    {
        version = "v1.12";
    }   
    else
    {
        version = "v1.30";
    }
}

isLoading
{
    return true;
}

gameTime
{
    return TimeSpan.FromMilliseconds(current.igt / 1000);
}
