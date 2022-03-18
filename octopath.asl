state("Octopath_Traveler-Win64-Shipping")
{
  int start: 0x2E08100, 0x44;
  int characterIsHighlighted: 0x289D268, 0x368, 0x0, 0x328;

  int zoneID: 0x289D240, 0x36C;
  int money: 0x0289CC48, 0x370, 0x158;
  int gameState: 0x0289D270, 0x36C;

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

  Func<string,bool> Split = (key) => {
    if(vars.Splits.Contains(key)) { return false; }
    vars.Splits.Add(key);
    return settings[key];
  };
  vars.Split = Split;

  Func<int,string,string,bool> SplitChapter = (progress, key, name) => {
    if (progress % 1000 == 0) {
      int currentChapter = progress / 1000;
      string splitKey = String.Format("chapter_end_" + key + "{0}", currentChapter.ToString());
      if(vars.Splits.Contains(splitKey)) { return false; }
      if (current.gameState == 2 && old.gameState == 5) {
        return vars.Split(splitKey);
      }
    }
    return false;
  };
  vars.SplitChapter = SplitChapter;
}

update
{
  if (timer.CurrentPhase == TimerPhase.NotRunning)
  {
    vars.Splits.Clear();
    vars.isChapterEnding = false;
    vars.charChapterEnding = "";
  }
}

startup 
{
  Func<string,string> NameToKey = (name) => {
    return name.ToLower().Replace(' ', '_');
  };
  vars.NameToKey = NameToKey;

  vars.ShrineZoneIDs = new Dictionary<int,string> {
    { 179, "Cleric Shrine" },
    { 180, "Scholar Shrine" },
    { 181, "Merchant Shrine" },
    { 182, "Warrior Shrine" },
    { 183, "Dancer Shrine" },
    { 184, "Apothecary Shrine" },
    { 185, "Thief Shrine" },
    { 186, "Hunter Shrine" }
  };

  settings.Add("get_shrine", true, "Get Shrine");
  foreach (var shrineName in vars.ShrineZoneIDs.Values) {
    settings.Add(
      String.Format("get_{0}", NameToKey(shrineName)),
      false,
      String.Format("Get {0}", shrineName),
      "get_shrine"
    );
  }
  settings.Add("split_characters", true, "Split On Characters");
  settings.Add("character_ophilia", false, "Ophilia", "split_characters");
  settings.Add("character_cyrus", false, "Cyrus", "split_characters");
  settings.Add("character_tressa", false, "Tressa", "split_characters");
  settings.Add("character_olberic", false, "Olberic", "split_characters");
  settings.Add("character_primrose", false, "Primrose", "split_characters");
  settings.Add("character_alfyn", false, "Alfyn", "split_characters");
  settings.Add("character_haanit", false, "H'aanit", "split_characters");
  settings.Add("character_therion", false, "Therion", "split_characters");

  //Ophilia
  settings.Add("ophilia_story", true, "Ophilia Story");
  settings.Add("fight_guardian", false, "Guardian of the First Flame", "ophilia_story");
  settings.Add("chapter_end_ophilia_1", false, "Chapter 1 End", "ophilia_story");
  settings.Add("fight_hrodvitnir", false, "Hrodvitnir", "ophilia_story");
  settings.Add("chapter_end_ophilia_2", false, "Chapter 2 End", "ophilia_story");
  settings.Add("fight_mm_sf", false, "Mystery Man & Shady Figure", "ophilia_story");
  settings.Add("chapter_end_ophilia_3", false, "Chapter 3 End", "ophilia_story");
  settings.Add("fight_cultists", false, "Cultists", "ophilia_story");
  settings.Add("fight_mattias", false, "Mattias", "ophilia_story");
  settings.Add("chapter_end_ophilia_4", false, "Chapter 4 End", "ophilia_story");

  // Olberic
  settings.Add("olberic_story", true, "Olberic Story");
  settings.Add("fight_gaston", false, "Gaston", "olberic_story");
  settings.Add("chapter_end_olberic_1", false, "Chapter 1 End", "olberic_story");
  settings.Add("fight_victorino", false, "Victorino", "olberic_story");
  settings.Add("fight_joshua", false, "Joshua", "olberic_story");
  settings.Add("fight_archibold", false, "Archibold", "olberic_story");
  settings.Add("fight_gustav", false, "Gustav", "olberic_story");
  settings.Add("chapter_end_olberic_2", false, "Chapter 2 End", "olberic_story");
  settings.Add("fight_lizards1", false, "Lizards #1", "olberic_story");
  settings.Add("fight_lizards2", false, "Lizards #2", "olberic_story");
  settings.Add("fight_lizardking", false, "Lizardking", "olberic_story");
  settings.Add("fight_erhardt", false, "Erhardt", "olberic_story");
  settings.Add("chapter_end_olberic_3", false, "Chapter 3 End", "olberic_story");
  settings.Add("fight_redhat", false, "Red Hat", "olberic_story");
  settings.Add("fight_werner", false, "Werner", "olberic_story");
  settings.Add("chapter_end_olberic_4", false, "Chapter 4 End", "olberic_story");

  // Cyrus
  settings.Add("cyrus_story", true, "Cyrus Story");
  settings.Add("fight_russell", false, "Russell", "cyrus_story");
  settings.Add("chapter_end_cyrus_1", false, "Chapter 1 End", "cyrus_story");
  settings.Add("fight_gideon", false, "Gideon", "cyrus_story");
  settings.Add("chapter_end_cyrus_2", false, "Chapter 2 End", "cyrus_story");
  settings.Add("fight_yvon", false, "Yvon", "cyrus_story");
  settings.Add("chapter_end_cyrus_3", false, "Chapter 3 End", "cyrus_story");
  settings.Add("fight_lucia", false, "Lucia", "cyrus_story");
  settings.Add("chapter_end_cyrus_4", false, "Chapter 4 End", "cyrus_story");

  // Tressa
  settings.Add("tressa_story", true, "Tressa Story");
  settings.Add("fight_mikk_and_makk", false, "Mikk and Makk", "tressa_story");
  settings.Add("chapter_end_tressa_1", false, "Chapter 1 End", "tressa_story");
  settings.Add("chapter_end_tressa_2", false, "Chapter 2 End", "tressa_story");
  settings.Add("chapter_end_tressa_3", false, "Chapter 3 End", "tressa_story");
  settings.Add("chapter_end_tressa_4", false, "Chapter 4 End", "tressa_story");

  // Galdera
  settings.Add("galdera", true, "Galdera");
  settings.Add("finis_start", false, "Enter Gate of Finis", "galdera");
  settings.Add("journeys_end_start", false, "Enter Journey's End", "galdera");
  settings.Add("at_journeys_end", false, "Galdera End", "galdera");

  settings.Add("credits", true, "Credits");
}

start
{
  if (timer.CurrentPhase == TimerPhase.NotRunning &&
      current.start == 2 &&
      old.characterIsHighlighted == 1 &&
      current.characterIsHighlighted == 1 &&
      current.zoneID == 0) {
    return true;
  }
}

reset
{
  if (timer.CurrentPhase == TimerPhase.Running &&
      current.characterIsHighlighted == 1 &&
      old.characterIsHighlighted == 0 &&
      current.zoneID == 0) {
    return true;
  }
}

split 
{
  // Shrines
  if (vars.ShrineZoneIDs.ContainsKey(current.zoneID) && current.gameState == 5 && old.gameState == 2) {
    string getShrineKey = "get_" + vars.NameToKey(vars.ShrineZoneIDs[current.zoneID]);
    return vars.Split(getShrineKey);
  }

  // Characters
  if(old.ophiliaHP == 0 && current.ophiliaHP != 0) return vars.Split("character_ophilia");
  if(old.cyrusHP == 0 && current.cyrusHP != 0) return vars.Split("character_cyrus");
  if(old.tressaHP == 0 && current.tressaHP != 0) return vars.Split("character_tressa");
  if(old.olbericHP == 0 && current.olbericHP != 0) return vars.Split("character_olberic");
  if(old.primroseHP == 0 && current.primroseHP != 0) return vars.Split("character_primrose");
  if(old.alfynHP == 0 && current.alfynHP != 0) return vars.Split("character_alfyn");
  if(old.haanitHP == 0 && current.haanitHP != 0) return vars.Split("character_haanit");
  if(old.therionHP == 0 && current.therionHP != 0) return vars.Split("character_therion");

  // Olberic
  if (old.olbericProgress != current.olbericProgress && old.zoneID != 0) {
    if (current.olbericProgress == 160) return vars.Split("fight_gaston");
    else if (current.olbericProgress == 1070) return vars.Split("fight_victorino");
    else if (current.olbericProgress == 1140) return vars.Split("fight_joshua");
    else if (current.olbericProgress == 1180) return vars.Split("fight_archibold");
    else if (current.olbericProgress == 1220) return vars.Split("fight_gustav");
    else if (current.olbericProgress == 2070) return vars.Split("fight_lizards1");
    else if (current.olbericProgress == 2080) return vars.Split("fight_lizards2");
    else if (current.olbericProgress == 2110) return vars.Split("fight_lizardking");
    else if (current.olbericProgress == 2130) return vars.Split("fight_erhardt");
    else if (current.olbericProgress == 3050) return vars.Split("fight_red Hat");
    else if (current.olbericProgress == 3110) return vars.Split("fight_werner");
    else { vars.SplitChapter(current.olbericProgress, "olberic", "Olberic"); }
  }

  // Olphilia
  if (old.ophiliaProgress != current.ophiliaProgress && old.zoneID != 0) {
    if (current.ophiliaProgress == 170) return vars.Split("fight_guardian");
    else if (current.ophiliaProgress == 1140) return vars.Split("fight_hrodvitnir");
    else if (current.ophiliaProgress == 2110) return vars.Split("fight_mm_sf");
    else if (current.ophiliaProgress == 3090) return vars.Split("fight_cultists");
    else if (current.ophiliaProgress == 3150) return vars.Split("fight_mattias");
    else { vars.SplitChapter(current.ophiliaProgress, "ophilia", "Ophilia"); }
  }

  // Cyrus
  if (old.cyrusProgress != current.cyrusProgress && old.zoneID != 0) {
    if (current.cyrusProgress == 130) return vars.Split("fight_russell");
    else if (current.cyrusProgress == 1110) return vars.Split("fight_gideon");
    else if (current.cyrusProgress == 2160) return vars.Split("fight_yvon");
    else if (current.cyrusProgress == 3060) return vars.Split("fight_lucia");
    else { vars.SplitChapter(current.cyrusProgress, "cyrus", "Cyrus"); }
  }

  // Tressa
  if (old.tressaProgress != current.tressaProgress && old.zoneID != 0) {
    if (current.tressaProgress == 170) return vars.Split("fight_mikk_and_makk");
    else { vars.SplitChapter(current.tressaProgress, "tressa", "Tressa"); }
  }

  // Credits
  else if (current.zoneID == 10 && current.zoneID != old.zoneID) {
    return vars.Split("credits");
  }

  // Galdera Splits
  else if (current.zoneID == 195 && old.zoneID == 194) {
    return vars.Split("finis_start");
  }

  else if (current.zoneID == 196 && old.zoneID == 195) {
    return vars.Split("journeys_end_start");
  }

  else if (current.zoneID == 194 && current.money - old.money == 100000) {
    return vars.Split("at_journeys_end");
  }
}