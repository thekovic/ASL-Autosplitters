state("QuantumBreak")
{
	int isLoading : 0xF50890;
	byte chapter : 0x121A080, 0x130;
	int mainMenu : 0xEE62E8;
}

start
{
	if (current.chapter == 1 && old.chapter == 0 && current.mainMenu == 0)
	{
		return true;
	}
}

split
{	
	if (current.chapter > old.chapter && old.chapter > 0)
	{
		return true;
	}
}

isLoading
{
	return (current.isLoading == 1);
}
