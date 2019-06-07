state("N++")
{
	int gameTime : "npp.dll", 0xE8F4B8, 0x7CC8;
	int exitsEntered : "npp.dll", 0xE8F4B8, 0x810, 0x158;
	int gameState : "npp.dll", 0x14B4270, 0x2B1157C;
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
	if ((current.exitsEntered > old.exitsEntered) && (current.gameState == 3 || current.gameState == 4)) 
	{
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
