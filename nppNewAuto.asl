state("N++")
{
	int gameTime : "npp.dll", 0xE8F4B8, 0x7CC8;
	int levelsCompleted : "npp.dll", 0xE8F4B8, 0x810, 0x100;
}

start
{
	vars.totalTime = 0.0;
	vars.levelsCompl = old.levelsCompleted;
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
	if (current.levelsCompleted > vars.levelsCompl + 1) 
	{
		vars.levelsCompl = current.levelsCompleted;
		return true;
	}
}

isLoading
{
	return true;
}

gameTime
{
	return TimeSpan.FromSeconds(System.Convert.ToDouble(vars.totalTime));
}