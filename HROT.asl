state("HROT")
{
    // int gameIsRunning: 0x159C2EC;
    // byte endScreen: 0x12AE178; 0.5.9
    // int gameState: 0xB66934;
    // int inGameTimer: 0x159A0EC;
}

startup
{
    settings.Add("pause", true, "Pause timer while in the Escape key pause menu");
    refreshRate = 30;
}

init
{
    // Check if game somehow isn't running
    ProcessModuleWow64Safe process = modules.FirstOrDefault(x => x.ModuleName.ToLower() == "hrot.exe");
    if (process == null)
    {
        Thread.Sleep(1000);
        print("process not loaded!");
        throw new Exception();
    }
    
    // Set up sigscanning
    var TheScanner = new SignatureScanner(game, process.BaseAddress, process.ModuleMemorySize);
    
    var sig_gameIsRunning = new SigScanTarget(2, "80 3D ?? ?? ?? ?? 00 74 ?? C6 05 ?? ?? ?? ?? 00 C6 05 ?? ?? ?? ?? 00");
    sig_gameIsRunning.OnFound = (proc, scanner, ptr) => !proc.ReadPointer(ptr, out ptr) ? IntPtr.Zero : ptr;

    var sig_endScreen = new SigScanTarget(2, "80 3D ?? ?? ?? ?? 00 75 ?? 80 3D ?? ?? ?? ?? 00 74 ?? C7 45 ?? 00 00 80 3F");
    sig_endScreen.OnFound = (proc, scanner, ptr) => !proc.ReadPointer(ptr, out ptr) ? IntPtr.Zero : ptr;

    var sig_gameState = new SigScanTarget(2, "88 1D ?? ?? ?? ?? C6 05 ?? ?? ?? ?? 00");
    sig_gameState.OnFound = (proc, scanner, ptr) => !proc.ReadPointer(ptr, out ptr) ? IntPtr.Zero : ptr;

    var sig_inGameTimer = new SigScanTarget(1, "A3 ?? ?? ?? ?? 8B 45 ?? E8 ?? ?? ?? ?? 8B 45 ??");
    sig_inGameTimer.OnFound = (proc, scanner, ptr) => !proc.ReadPointer(ptr, out ptr) ? IntPtr.Zero : ptr;

    IntPtr ptr_gameIsRunning = TheScanner.Scan(sig_gameIsRunning);
    // print("game is running: " + ptr_gameIsRunning.ToString("x"));
    IntPtr ptr_endScreen = TheScanner.Scan(sig_endScreen);
    // print("end screen: " + ptr_endScreen.ToString("x"));
    IntPtr ptr_gameState = TheScanner.Scan(sig_gameState); 
    // print("game state: " + ptr_gameState.ToString("x"));
    IntPtr ptr_inGameTimer = TheScanner.Scan(sig_inGameTimer);
    // print("game timer: " + ptr_inGameTimer.ToString("x"));
    
    vars.gameIsRunning = new MemoryWatcher<int>(ptr_gameIsRunning);
    vars.endScreen = new MemoryWatcher<byte>(ptr_endScreen);
    vars.gameState = new MemoryWatcher<byte>(ptr_gameState);
    vars.inGameTimer = new MemoryWatcher<int>(ptr_inGameTimer);
    
    vars.watchList = new MemoryWatcherList()
    {
        vars.gameIsRunning, vars.endScreen, vars.gameState, vars.inGameTimer
    };

    // Get StopWatch for counting time while the game is paused
    vars.pauseTimer = new Stopwatch();

    vars.lastPauseTime = 0f;
    vars.gameTimer = 0f;
    vars.betweenEpisodes = false;
}

update
{
    vars.watchList.UpdateAll(game);
}

gameTime
{
    // Pause the timer when between episodes during a full game run
    if (vars.gameState.Current == 20 && !vars.betweenEpisodes)
    {
        vars.betweenEpisodes = true;
    }
    else if (vars.gameState.Current == 0 && vars.betweenEpisodes)
    {
        vars.betweenEpisodes = false;
    }

    int delta = vars.inGameTimer.Current - vars.inGameTimer.Old;
    // Clamp delta to avoid weird jumps when using quicksaves
    if (delta > 0 && delta < 100 && vars.endScreen.Current == 0 && !vars.betweenEpisodes)
    {
        vars.gameTimer += delta;
    }

    if (!settings["pause"])
    {
        if (vars.gameIsRunning.Current < vars.gameIsRunning.Old)
        {
            //print("PAUSE TIMER STARTS");
            vars.pauseTimer.Start();
        }
        else if (vars.gameIsRunning.Current > vars.gameIsRunning.Old)
        {
            //print("PAUSE TIMER STOPS");
            vars.pauseTimer.Reset();
            vars.lastPauseTime = 0f;
        }

        if (vars.gameState.Current != 0 && vars.endScreen.Current == 0 && vars.gameIsRunning.Current == 0)
        {
            vars.gameTimer += (vars.pauseTimer.Elapsed.TotalSeconds - vars.lastPauseTime) * 100;
            vars.lastPauseTime = vars.pauseTimer.Elapsed.TotalSeconds;
        }
    }

    return TimeSpan.FromSeconds(vars.gameTimer / 100f);
}

start
{
    if (vars.gameState.Current == 0)
    {
        vars.gameTimer = 0f;
        vars.pauseTimer.Reset();
        vars.lastPauseTime = 0f;
        vars.betweenEpisodes = false;
        return true;
    }
    
}

split
{
    if (vars.endScreen.Current > vars.endScreen.Old)
    {
        return true;
    }
}

reset
{
    if (vars.gameState.Current == 21 && vars.gameIsRunning.Current == 0)
    {
        vars.gameTimer = 0f;
        vars.pauseTimer.Reset();
        vars.lastPauseTime = 0f;
        vars.betweenEpisodes = false;
        return true;
    }
}

isLoading
{
    return true;
}

onReset
{
    vars.gameTimer = 0f;
    vars.pauseTimer.Reset();
    vars.lastPauseTime = 0f;
    vars.betweenEpisodes = false;
}
