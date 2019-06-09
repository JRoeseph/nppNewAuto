state("N++")
{
	int gameTime : "npp.dll", 0xE8F4B8, 0x7CC8;
	int levelID : 0x0004B698, 0xC, 0x88, 0x1C, 0xA0;
	int levelInfo: "npp.dll", 0xE8F4B8, 0x810;
	int gameState : "npp.dll", 0x14B4270, 0x2B1157C;
	int exitsEntered : "npp.dll", 0xE8F4B8, 0x810, 0x158;
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
	if (!settings["g++"])
	{
		if ((current.exitsEntered > old.exitsEntered) && (current.gameState == 3 || current.gameState == 4)) 
		{
			return true;
		}
	}

	if (settings["g++"])
	{
		vars.offset = 0x80C168 + ((current.levelID - 1) * 0x30);
		vars.test = new DeepPointer("npp.dll", 0xE8F4B8, 0x810, vars.offset).Deref<int>(game);
		if ((vars.test & 131072) == 131072 && (current.gameState == 3 || current.gameState == 4) && (current.exitsEntered > old.exitsEntered))
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
