state("Octopath_Traveler-Win64-Shipping")
{
  int start: 0x2B3D270, 0x174;
  int zoneID: 0x289D240, 0x36C;
  int money: 0x0289CC48, 0x370, 0x158;

  int ophiliaProgress: 0x0289CC48, 0x370, 0x1C8, 0x510;
  int cyrusProgress: 0x0289CC48, 0x370, 0x1C8, 0x1f0;
  int tressaProgress: 0x0289CC48, 0x370, 0x1C8, 0x128;
  int olbericProgress: 0x0289CC48, 0x370, 0x1C8, 0x60;
  int primroseProgress: 0x0289CC48, 0x370, 0x1C8, 0x2b8;
  int alfynProgress: 0x0289CC48, 0x370, 0x1C8, 0x5d8;
  int therionProgress: 0x0289CC48, 0x370, 0x1C8, 0x448;
  int haanitProgress: 0x0289CC48, 0x370, 0x1C8, 0x380;

  int enemyOneID: 0x289CBC8, 0x4C0, 0x8, 0x160, 0x20, 0x3D8, 0xE0, 0x3E0;
  int enemyOneHP: 0x289CBC8, 0x4C0, 0x8, 0x160, 0x20, 0x3D8, 0xE0, 0x3E4;

  int enemyTwoID: 0x289CBC8, 0x4C0, 0x10, 0x160, 0x20, 0x3D8, 0xE0, 0x3E0;
  int enemyTwoHP: 0x289CBC8, 0x4C0, 0x10, 0x160, 0x20, 0x3D8, 0xE0, 0x3E4;

  int enemyThreeID: 0x289CBC8, 0x4C0, 0x18, 0x160, 0x20, 0x3D8, 0xE0, 0x3E0;
  int enemyThreeHP: 0x289CBC8, 0x4C0, 0x18, 0x160, 0x20, 0x3D8, 0xE0, 0x3E4;

  int enemyFourID: 0x289CBC8, 0x4C0, 0x20, 0x160, 0x20, 0x3D8, 0xE0, 0x3E0;
  int enemyFourHP: 0x289CBC8, 0x4C0, 0x20, 0x160, 0x20, 0x3D8, 0xE0, 0x3E4;

  // used for splitting when character enters party
  int ophiliaHP: 0x0289CC48, 0x370, 0x1C8, 0x4BC;
  int cyrusHP: 0x0289CC48, 0x370, 0x1C8, 0x19C;
  int tressaHP: 0x0289CC48, 0x370, 0x1C8, 0xD4;
  int olbericHP: 0x0289CC48, 0x370, 0x1C8, 0xC;
  int primroseHP: 0x0289CC48, 0x370, 0x1C8, 0x264;
  int alfynHP: 0x0289CC48, 0x370, 0x1C8, 0x584;
  int haanitHP: 0x0289CC48, 0x370, 0x1C8, 0x32C;
  int therionHP: 0x0289CC48, 0x370, 0x1C8, 0x3F4;
}

init 
{
  vars.Splits = new HashSet<string>();
}

update
{
  if (timer.CurrentPhase == TimerPhase.NotRunning)
  {
    vars.Splits.Clear();
  }
}

startup 
{
  /
  settings.Add("characters", true, "Characters");
  settings.Add("character_ophilia", true, "Split on Ophilia", "characters");
  settings.Add("character_cyrus", true, "Split on Cyrus", "characters");
  settings.Add("character_tressa", true, "Split on Tressa", "characters");
  settings.Add("character_olberic", true, "Split on Olberic", "characters");
  settings.Add("character_primrose", true, "Split on Primrose", "characters");
  settings.Add("character_alfyn", true, "Split on Alfyn", "characters");
  settings.Add("character_haanit", true, "Split on H'aanit", "characters");
  settings.Add("character_therion", true, "Split on Therion", "characters");

  settings.Add("galdera", false, "Galdera");

  //Ophilia
  settings.Add("fight_guardian_of_the_lost_flame", true, "Guardian of the First Flame", "character_ophilia");
  settings.Add("fight_hrodvitnir", true, "Hrodvitnir", "character_ophilia");
  settings.Add("fight_mm_sf", true, "Mystery Man & Shady Figure", "character_ophilia");
  settings.Add("fight_cultists", true, "Cultists", "character_ophilia");
  settings.Add("fight_mattias", true, "Mattias", "character_ophilia");

  // Olberic
  settings.Add("fight_gaston", true, "Gaston", "character_olberic");
  settings.Add("fight_victorino", true, "Victorino", "character_olberic");
  settings.Add("fight_joshua", true, "Goshua", "character_olberic");
  settings.Add("fight_archibold", true, "Archibold", "character_olberic");
  settings.Add("fight_gustav", true, "Gustav", "character_olberic");
  settings.Add("fight_lizards1", true, "Lizards #1", "character_olberic");
  settings.Add("fight_lizards2", true, "Lizards #2", "character_olberic");
  settings.Add("fight_lizardking", true, "Lizardking", "character_olberic");
  settings.Add("fight_erhardt", true, "Erhardt", "character_olberic");
  settings.Add("fight_redhat", true, "Red Hat", "character_olberic");
  settings.Add("fight_werner", true, "Werner", "character_olberic");


  // Galdera
  settings.Add("finis_start", false, "Enter Gate of Finis", "galdera");
  settings.Add("journeys_end_start", false, "Enter Journey's End", "galdera");
  settings.Add("at_journeys_end", false, "Galdera End", "galdera");

  settings.Add("credits", true, "Credits");
}

start
{
  // return (timer.CurrentPhase == TimerPhase.NotRunning && current.zoneID == 0 && current.start != old.start);
}

split 
{
  // Characters
  if(old.ophiliaHP == 0 && current.ophiliaHP != 0)
  {
    if(vars.Splits.Contains("character_ophilia")) { return false; }
    vars.Splits.Add("character_ophilia");
    return settings["character_ophilia"];
  }

  if(old.cyrusHP == 0 && current.cyrusHP != 0) 
  {
    if(vars.Splits.Contains("character_cyrus")) { return false; }
    vars.Splits.Add("character_cyrus");
    return settings["character_cyrus"];
  }

  if(old.tressaHP == 0 && current.tressaHP != 0)
  {
    if(vars.Splits.Contains("character_tressa")) { return false; }
    vars.Splits.Add("character_tressa");
    return settings["character_tressa"];
  }

  if(old.olbericHP == 0 && current.olbericHP != 0)
  {
    if(vars.Splits.Contains("character_olberic")) { return false; }
    vars.Splits.Add("character_olberic");
    return settings["character_olberic"];
  }

  if(old.primroseHP == 0 && current.primroseHP != 0)
  {
    if(vars.Splits.Contains("character_primrose")) { return false; }
    vars.Splits.Add("character_primrose");
    return settings["character_primrose"];
  }

  if(old.alfynHP == 0 && current.alfynHP != 0)
  {
    if(vars.Splits.Contains("character_alfyn")) { return false; }
    vars.Splits.Add("character_alfyn");
    return settings["character_alfyn"];
  }

  if(old.haanitHP == 0 && current.haanitHP != 0)
  {
    if(vars.Splits.Contains("character_haanit")) { return false; }
    vars.Splits.Add("character_haanit");
    return settings["character_haanit"];
  }

  if(old.therionHP == 0 && current.therionHP != 0)
  {
    if(vars.Splits.Contains("character_therion")) { return false; }
    vars.Splits.Add("character_therion");
    return settings["character_therion"];
  }

  // Olberic
  if (old.olbericProgress != current.olbericProgress  && old.zoneID != 0) {
    if (current.olbericProgress == 160) return settings["fight_gaston"];
    else if (current.olbericProgress == 1070) return settings["fight_victorino"];
    else if (current.olbericProgress == 1140) return settings["fight_joshua"];
    else if (current.olbericProgress == 1180) return settings["fight_archibold"];
    else if (current.olbericProgress == 1220) return settings["fight_gustav"];
    else if (current.olbericProgress == 2070) return settings["fight_lizards1"];
    else if (current.olbericProgress == 2080) return settings["fight_lizards2"];
    else if (current.olbericProgress == 2110) return settings["fight_lizardking"];
    else if (current.olbericProgress == 2130) return settings["fight_erhardt"];
    else if (current.olbericProgress == 3050) return settings["fight_red Hat"];
    else if (current.olbericProgress == 3110) return settings["fight_werner"];
  }

  if (old.ophiliaProgress != current.ophiliaProgress && old.zoneID != 0) {
    if (current.ophiliaProgress == 170) return settings["fight_guardian"];
    else if (current.ophiliaProgress == 1140) return settings["fight_hrodvitnir"];
    else if (current.ophiliaProgress == 2110) return settings["fight_mm_sf"];
    else if (current.ophiliaProgress == 3090) return settings["fight_cultists"];
    else if (current.ophiliaProgress == 3150) return settings["fight_mattias"];
  }

  // Credits
  else if (current.zoneID == 10 && current.zoneID != old.zoneID) {
    return settings["credits"];
  }

  // Galdera Splits
  else if (current.zoneID == 195 && old.zoneID == 194) {
    return settings["finis_start"];
  }

  else if (current.zoneID == 196 && old.zoneID == 195) {
    return settings["journeys_end_start"];
  }

  else if (current.zoneID == 194 && current.money - old.money == 100000) {
    return settings["at_journeys_end"];
  }
}
