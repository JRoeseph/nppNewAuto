state("N++")
{
	int gameTime : "npp.dll", 0x5E2628, 0x7CC8;
	int exitsEntered : "npp.dll", 0x5E2628, 0x810, 0x158;
}

startup
{
}

start
{
	vars.totalTime = 0.0;
}

update
{
	if (current.gameTime > old.gameTime) {
		vars.totalTime+=(current.gameTime-old.gameTime)/60.0;
	}
	return true;
}

split
{
	if (current.exitsEntered > old.exitsEntered)
	{
		return true;
	}
}

reset
{
}

isLoading
{
	return true;
}

gameTime
{
	return TimeSpan.FromSeconds(System.Convert.ToDouble(vars.totalTime));
}
