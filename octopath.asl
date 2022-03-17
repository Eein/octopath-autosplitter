state("Octopath_Traveler-Win64-Shipping")
{
  int start: 0x2B3D270, 0x174;
  int zoneID: 0x289D240, 0x36C;

  int enemyOneID: 0x289CBC8, 0x4C0, 0x8, 0x160, 0x20, 0x3D8, 0xE0, 0x3E0;
  // int enemyOneFormation: 0x289CBC8, 0x4C0, 0x8, 0x160, 0x20, 0x3D8, 0xE0, 0x3FC;
  int enemyOneHP: 0x289CBC8, 0x4C0, 0x8, 0x160, 0x20, 0x3D8, 0xE0, 0x3E4;

  int enemyTwoID: 0x289CBC8, 0x4C0, 0x10, 0x160, 0x20, 0x3D8, 0xE0, 0x3E0;
  // int enemyTwoFormation: 0x289CBC8, 0x4C0, 0x10, 0x160, 0x20, 0x3D8, 0xE0, 0x3FC;
  int enemyTwoHP: 0x289CBC8, 0x4C0, 0x10, 0x160, 0x20, 0x3D8, 0xE0, 0x3E4;

  int enemyThreeID: 0x289CBC8, 0x4C0, 0x18, 0x160, 0x20, 0x3D8, 0xE0, 0x3E0;
  // int enemyThreeFormation: 0x289CBC8, 0x4C0, 0x10, 0x160, 0x20, 0x3D8, 0xE0, 0x3FC;
  int enemyThreeHP: 0x289CBC8, 0x4C0, 0x18, 0x160, 0x20, 0x3D8, 0xE0, 0x3E4;

  int enemyFourID: 0x289CBC8, 0x4C0, 0x20, 0x160, 0x20, 0x3D8, 0xE0, 0x3E0;
  // int enemyFourFormation: 0x289CBC8, 0x4C0, 0x10, 0x160, 0x20, 0x3D8, 0xE0, 0x3FC;
  int enemyFourHP: 0x289CBC8, 0x4C0, 0x20, 0x160, 0x20, 0x3D8, 0xE0, 0x3E4;

  // used for splitting when character enters party
  int cyrusHP: 0x0289CC48, 0x370, 0x1C8, 0x19C;
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
  settings.Add("bosses", true, "Bosses");
  settings.Add("boss_guardian_of_the_first_flame", false, "Guardian of the First Flame", "bosses");
  settings.Add("boss_russell", false, "Russell", "bosses");

  settings.Add("characters", true, "Characters");
  settings.Add("character_cyrus", false, "Split on Cyrus", "characters");
}

start
{
  return (timer.CurrentPhase == TimerPhase.NotRunning && current.zoneID == 0 && current.start != old.start);
}

split 
{
  // Characters
  if(old.cyrusHP == 0 && current.cyrusHP != 0) 
  {
    if(vars.Splits.Contains("character_cyrus")) { return false; }
    vars.Splits.Add("character_cyrus");
    return settings["character_cyrus"];
  }

  // Bosses
  if(current.enemyOneID >= 609 && current.enemyOneID <= 612 && current.enemyOneHP <= 0) 
  { 
    if(vars.Splits.Contains("boss_guardian_of_the_first_flame")) { return false; }
    vars.Splits.Add("boss_guardian_of_the_first_flame");
    return settings["boss_guardian_of_the_first_flame"];
  }

  if(
    (settings["boss_russell"]) &&
    (!vars.Splits.Contains("boss_russell")) &&
    (current.enemyTwoID >= 701 && current.enemyTwoID <= 704 && current.enemyTwoHP <= 0) && // russell
    (current.enemyThreeID >= 705 && current.enemyThreeID <= 708 && current.enemyThreeHP <= 0) && // wisp
    (current.enemyFourID >= 705 && current.enemyFourID <= 708 && current.enemyFourHP <= 0) // wisp
  )
  { 
    if(vars.Splits.Contains("boss_russell")) { return false; }
    vars.Splits.Add("boss_russell");
    return settings["boss_russell"];
  }
}
