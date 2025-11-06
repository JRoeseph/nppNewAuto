state("N++")
{
	int gameTime : "npp.dll", 0x4F39E4, 0x8548;
	int exitsEntered : "npp.dll", 0x4F39E4, 0x810, 0x158;
	int deaths : "npp.dll", 0x4F39E4, 0x810, 0x40;
	int retries : "npp.dll", 0x4F39E4, 0x810, 0xF0;
	int levelStart : "npp.dll", 0x4F39E4, 0x810, 0xD8;
	
	int levelID : "npp.dll", 0x4F39E4, 0x898;
}

startup
{
	vars.running = false;
}

start
{
	vars.totalTime = 1 / 60.0;

	if (current.levelStart > old.levelStart && !vars.running && old.gameTime == 0)
	{
		vars.running = true;
		return true;
	}
}

update
{
	if (current.gameTime > old.gameTime) {
		vars.totalTime+=(current.gameTime-old.gameTime)/60.0;
	}
	
	if (current.deaths > old.deaths || current.retries > old.retries){
		vars.totalTime += 1 / 60.0;
	}
}

split
{
	if (current.exitsEntered > old.exitsEntered && current.deaths == old.deaths)
	{
		vars.totalTime += 1 / 60.0;
		return true;
	}
}

reset
{
	vars.running = false;
}

isLoading
{
	return true;
}

gameTime
{
	return TimeSpan.FromSeconds(System.Convert.ToDouble(vars.totalTime));
}
