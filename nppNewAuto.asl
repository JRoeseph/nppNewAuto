state("N++")
{
	int gameTime : "npp.dll", 0x5E2628, 0x7CC8;
	int exitsEntered : "npp.dll", 0x5E2628, 0x810, 0x158;
	int deaths : "npp.dll", 0x5E2628, 0x810, 0x40;
}

startup
{
}

start
{
	vars.totalFrames = 0.0;
}

update
{
	if (current.gameTime > old.gameTime) {
		vars.totalFrames+=(current.gameTime-old.gameTime);
	}
	if (current.deaths > old.deaths) {
		vars.totalFrames+=1;
	}
	if (current.exitsEntered > old.exitsEntered) {
		vars.totalFrames+=1;
	}
	return true;
}

split
{
	if (current.exitsEntered > old.exitsEntered && current.deaths == old.deaths)
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
	vars.totalTime = vars.totalFrames/60.0;
	return TimeSpan.FromSeconds(System.Convert.ToDouble(vars.totalTime));
}
