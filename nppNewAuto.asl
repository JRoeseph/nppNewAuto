state("N++")
{
	int gameTime : "npp.dll", 0xE8F4B8, 0x7CC8;
	int levelID : 0x0004B698, 0xC, 0x88, 0x1C, 0xA0;
	int levelInfo: "npp.dll", 0xE8F4B8, 0x810;
	int gameState : "npp.dll", 0x14B4270, 0x2B1157C;
	int deaths: "npp.dll", 0xE8F4B8, 0x810, 0x40;
	int resets: "npp.dll", 0xE8F4B8, 0x810, 0xF0;
}

startup
{
	settings.Add("g++", false, "G++");
	settings.Add("il", false, "IL");
}

start
{
	vars.totalTime = 0.0;
	vars.hasSplit = false;
	if (settings["il"])
	{
		if (current.gameTime > old.gameTime && current.resets <= old.resets && current.deaths <= old.deaths) {return true;}
	}
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
	if (vars.hasSplit && !(current.gameState == 3 || current.gameState == 4 || current.gameState == 5))
	{
		vars.hasSplit = false;
	}
	
	if (!settings["g++"])
	{
		if (!vars.hasSplit && (current.gameState == 3 || current.gameState == 4 || current.gameState == 5)) 
		{
			vars.hasSplit = true;
			return true;
		}
	}

	if (settings["g++"])
	{
		vars.offset = 0x80C168 + ((current.levelID - 1) * 0x30);
		vars.test = new DeepPointer("npp.dll", 0xE8F4B8, 0x810, vars.offset).Deref<int>(game);
		if ((vars.test & 131072) == 131072 && !vars.hasSplit && (current.gameState == 3 || current.gameState == 4 || current.gameState == 5))
		{
			return true;
		}
	}
}

reset
{
	if (settings["il"]) 
	{
		if (current.resets > old.resets || current.deaths > old.deaths) {return true;}
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
