state("Octopath_Traveler-Win64-Shipping")
{
  int start: 0x2E08100, 0x44;
  int characterIsHighlighted: 0x289D268, 0x368, 0x0, 0x328;

  int zoneID: 0x289D240, 0x36C;
  int money: 0x0289CC48, 0x370, 0x158;
  int gameState: 0x0289D270, 0x36C;
  int cutsceneScriptIndex: 0x289D230, 0x388;

  
  float cutsceneProgressBar: 0x0289D268, 0x378, 0x20, 0x230, 0xD0, 0x350;
  float cutsceneProgressBar2: 0x0289D268, 0x378, 0x20, 0x230, 0x288;


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

  vars.isChapterEnding = false;
  vars.charChapterEnding = "";

  // bool return doesnt do anything, i just dont know how to make a lambda without a return lol
  Func<string,bool> SetCharacterEnding = (character) => {
    vars.isChapterEnding = true;
    vars.charChapterEnding = character;
    return false;
  };
  // same here
  Func<bool> ClearCharacterEnding = () => {
    vars.isChapterEnding = false;
    vars.charChapterEnding = "";
    return false;
  };
  vars.SetCharacterEnding = SetCharacterEnding;
  vars.ClearCharacterEnding = ClearCharacterEnding;

  Func<int,int,int,bool> SplitChapter = (progress, curGameState, oldGameState) => {
    if (progress % 1000 == 0 && vars.isChapterEnding && curGameState == 2 && oldGameState == 5) {
      int currentChapter = progress / 1000;
      if (currentChapter == 0) { return false; }
      string key = String.Format("chapter_end_" + vars.charChapterEnding.ToLower() + "_" + currentChapter.ToString());
      ClearCharacterEnding();
      return vars.Split(key);
    }
    return false;
  };
  vars.SplitChapter = SplitChapter;
}

update
{
  if (timer.CurrentPhase == TimerPhase.NotRunning) {
    vars.Splits.Clear();
    vars.ClearCharacterEnding();
  }
}

startup 
{
  Func<string,string> NameToKey = (name) => {
    return name.ToLower().Replace(' ', '_').Replace("'", "");
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

  // After finishing advanced job fight state goes from 6 to 5
  vars.AdvancedJobFights = new Dictionary<int,string> {
    { 187, "Steorra" },
    { 188, "Balogar" },
    { 189, "Winnehild" },
    { 190, "Dreisang" }
  };

  settings.Add("advanced_job_fights", true, "Advanced Job Fights");
  foreach (var fight in vars.AdvancedJobFights.Values) {
    settings.Add("advanced_job_fight_" + NameToKey(fight), true, fight, "advanced_job_fights");
  }

  vars.AreaZoneIDs = new Dictionary<int, string> {
    { 137, "Flamesgrace" },
    { 76, "Atlasdam" },
    { 114, "Rippletide" },
    { 12, "Cobbleston" },
    { 34, "Sunshade" },
    { 56, "Clearbrook" },
    { 94, "Bolderfall" },
    { 158, "S'warkii" },
    { 145, "Stillsnow" },
    { 83, "Noblecourt" },
    { 120, "Goldshore" },
    { 13, "Stonegard" },
    { 40, "Wellspring" },
    { 62, "Saintsbridge" },
    { 101, "Quarrycrest" },
    { 164, "Victor's Hollow" },
    { 152, "Northreach" },
    { 89, "Wispermill" },
    { 130, "Grandport" },
    { 16, "Everhold" },
    { 49, "Marsalim" },
    { 70, "Riverford" },
    { 108, "Orewell" },
    { 171, "Duskbarrow" },
    { 194, "Ruins of Hornburg" },
    { 93, "Forest of Purgation" },
    { 136, "Loch of the Lost King" },
    { 33, "Everhold Tunnels" },
    { 188, "Shrine of the Runeblade" },
    { 55, "Marsalim Catacombs" },
    { 69, "Farshore" },
    { 189, "Shrine of the Warbringer" },
    { 157, "Maw of the Ice Dragon" }
  };

  settings.Add("enter_exit_area", true, "Enter / Exit area");
  foreach (var areaName in vars.AreaZoneIDs.Values) {
    string areaKey = NameToKey(areaName);
    settings.Add(areaKey, true, areaName, "enter_exit_area");
    settings.Add("enter_" + areaKey, false, "Enter", areaKey);
    settings.Add("exit_" + areaKey, false, "Exit", areaKey);
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

  // Ophilia
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
  settings.Add("fight_mikk_makk", false, "Mikk & Makk", "tressa_story");
  settings.Add("chapter_end_tressa_1", false, "Chapter 1 End", "tressa_story");
  settings.Add("fight_omar", false, "Omar", "ophilia_story");
  settings.Add("chapter_end_tressa_2", false, "Chapter 2 End", "tressa_story");
  settings.Add("fight_venomtooth_tiger", false, "Venomtooth Tiger", "tressa_story");
  settings.Add("chapter_end_tressa_3", false, "Chapter 3 End", "tressa_story");
  settings.Add("fight_esmeralda", false, "Esmeralda", "tressa_story");
  settings.Add("chapter_end_tressa_4", false, "Chapter 4 End", "tressa_story");

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

  // Primrose
  settings.Add("primrose_story", true, "Primrose Story");
  settings.Add("fight_helgenish", false, "Helgenish", "primrose_story");
  settings.Add("chapter_end_primrose_1", false, "Chapter 1 End", "primrose_story");
  settings.Add("fight_rufus", false, "Rufus", "primrose_story");
  settings.Add("chapter_end_primrose_2", false, "Chapter 2 End", "primrose_story");
  settings.Add("fight_albus", false, "Albus", "primrose_story");
  settings.Add("chapter_end_primrose_3", false, "Chapter 3 End", "primrose_story");
  settings.Add("fight_simeon1", false, "Simeon 1", "primrose_story");
  settings.Add("fight_simeon2", false, "Simeon 2", "primrose_story");
  settings.Add("chapter_end_primrose_4", false, "Chapter 4 End", "primrose_story");

  // Galdera
  settings.Add("galdera", true, "Galdera");
  settings.Add("finis_start", false, "Enter Gate of Finis", "galdera");
  settings.Add("journeys_end_start", false, "Enter Journey's End", "galdera");
  settings.Add("at_journeys_end", false, "Galdera End", "galdera");

  settings.Add("ending_split", true, "Ending Split");
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
  print("cPB1: " + current.cutsceneProgressBar.ToString() + " oPB1: " + old.cutsceneProgressBar.ToString());
  print("cPB2: " + current.cutsceneProgressBar2.ToString() + " oPB2: " + old.cutsceneProgressBar2.ToString());

  // Shrines
  if (vars.ShrineZoneIDs.ContainsKey(current.zoneID) && current.gameState == 5 && old.gameState == 2) {
    string getShrineKey = "get_" + vars.NameToKey(vars.ShrineZoneIDs[current.zoneID]);
    return vars.Split(getShrineKey);
  }

  // Advanced Job Fights
  if (vars.AdvancedJobFights.ContainsKey(current.zoneID) && current.gameState == 5 && old.gameState == 6) {
    return vars.Split("advanced_job_fight_" + vars.NameToKey(vars.AdvancedJobFights[current.zoneID]));
  }

  // Enter Area
  if (vars.AreaZoneIDs.ContainsKey(current.zoneID) && old.zoneID != current.zoneID && old.zoneID != 0 && old.gameState == 2) {
    return vars.Split("enter_" + vars.NameToKey(vars.AreaZoneIDs[current.zoneID]));
  }

  // Exit Area
  if (current.zoneID != 0 && current.zoneID != old.zoneID && vars.AreaZoneIDs.ContainsKey(old.zoneID) && (old.gameState == 2 || old.gameState == 4)) {
    return vars.Split("exit_" + vars.NameToKey(vars.AreaZoneIDs[old.zoneID]));
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


  // Ophilia
  if (old.ophiliaProgress < current.ophiliaProgress && old.zoneID != 0) {
    if (current.ophiliaProgress == 170) return vars.Split("fight_guardian");
    else if (current.ophiliaProgress == 1140) return vars.Split("fight_hrodvitnir");
    else if (current.ophiliaProgress == 2110) return vars.Split("fight_mm_sf");
    else if (current.ophiliaProgress == 3090) return vars.Split("fight_cultists");
    else if (current.ophiliaProgress == 3150) return vars.Split("fight_mattias");
    else if (current.ophiliaProgress % 1000 == 0) {
      vars.isChapterEnding = true;
      vars.charChapterEnding = "Ophilia";
    }
  }

  // Ophilia Ending
  if (current.ophiliaProgress == 3160 && (current.cutsceneProgressBar > 0.98 || current.cutsceneScriptIndex > 94)) {
    return vars.Split("ending_split");
  }

  // Cyrus
  if (old.cyrusProgress != current.cyrusProgress && old.zoneID != 0) {
    if (current.cyrusProgress == 130) return vars.Split("fight_russell");
    else if (current.cyrusProgress == 1110) return vars.Split("fight_gideon");
    else if (current.cyrusProgress == 2160) return vars.Split("fight_yvon");
    else if (current.cyrusProgress == 3060) return vars.Split("fight_lucia");
    else if (current.cyrusProgress % 1000 == 0) {
      vars.isChapterEnding = true;
      vars.charChapterEnding = "Cyrus";
    }
  }

  // Cyrus Ending
  if (current.cyrusProgress == 3110 &&
    current.cutsceneScriptIndex >= 138 &&
    current.cutsceneProgressBar > 0.98) {
      return vars.Split("ending_split");
  }

  // Tressa
  if (old.tressaProgress != current.tressaProgress && old.zoneID != 0) {
    if (current.tressaProgress == 170) return vars.Split("fight_mikk_makk");
    else if (current.tressaProgress == 1120) return vars.Split("fight_omar");
    else if (current.tressaProgress == 2150) return vars.Split("fight_venomtooth_tiger");
    else if (current.tressaProgress == 3120) return vars.Split("fight_esmeralda");
    else if (current.tressaProgress % 1000 == 0) {
      vars.isChapterEnding = true;
      vars.charChapterEnding = "Tressa";
    }
  }

  // Tressa Ending
  if (current.tressaProgress == 3180 && (current.cutsceneProgressBar > 0.98 || current.cutsceneScriptIndex > 209)) {
    return vars.Split("ending_split");
  }

  // Primrose
  if (old.primroseProgress != current.primroseProgress && old.zoneID != 0) {
    if (current.primroseProgress == 160) return vars.Split("fight_helgenish");
    else if (current.primroseProgress == 1180) return vars.Split("fight_rufus");
    else if (current.primroseProgress == 2170) return vars.Split("fight_albus");
    else if (current.primroseProgress == 3120) return vars.Split("fight_simeon1");
    else if (current.primroseProgress == 3150) return vars.Split("fight_simeon2");
  }

  // Primrose Ending
  if (current.primroseProgress == 3150 && (current.cutsceneProgressBar > 0.98 || current.cutsceneScriptIndex > 94)) {
    return vars.Split("ending_split");
  }

  // Olberic
  if (old.olbericProgress < current.olbericProgress && old.zoneID != 0) {
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
    else if (current.olbericProgress % 1000 == 0) {
      vars.isChapterEnding = true;
      vars.charChapterEnding = "Olberic";
    }
  }

  // Olberic Ending
  if (current.olbericProgress == 3120 && (current.cutsceneProgressBar > 0.98 || current.cutsceneScriptIndex > 174)) {
    return vars.Split("ending_split");
  }

  if (vars.isChapterEnding) {
    int progress = 0;
    if (vars.charChapterEnding == "Ophilia") progress = current.ophiliaProgress;
    if (vars.charChapterEnding == "Cyrus") progress = current.cyrusProgress;
    if (vars.charChapterEnding == "Tressa") progress = current.tressaProgress;
    if (vars.charChapterEnding == "Olberic") progress = current.olbericProgress;
    if (vars.charChapterEnding == "Primrose") progress = current.primroseProgress;
    if (vars.charChapterEnding == "Alfyn") progress = current.alfynProgress;
    if (vars.charChapterEnding == "Therion") progress = current.therionProgress;
    if (vars.charChapterEnding == "Haanit") progress = current.haanitProgress;
    if (vars.SplitChapter(progress, current.gameState, old.gameState)) return true;
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