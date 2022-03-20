state("Octopath_Traveler-Win64-Shipping")
{
  int start: 0x2B32C48, 0xE30;
  int characterIsHighlighted: 0x289D268, 0x368, 0x0, 0x328;

  int zoneID: 0x289D240, 0x36C;
  int money: 0x0289CC48, 0x370, 0x158;
  int gameState: 0x0289D270, 0x36C;
  int cutsceneScriptIndex: 0x289D230, 0x388;

  
  // Works but other is better? float cutsceneProgressBar: 0x0289D268, 0x378, 0x20, 0x230, 0xD0, 0x350;
  float cutsceneProgressBar: 0x0289D268, 0x378, 0x20, 0x230, 0x288;

  int ophiliaProgress: 0x0289CC48, 0x370, 0x1C8, 0x510;
  int cyrusProgress: 0x0289CC48, 0x370, 0x1C8, 0x1f0;
  int tressaProgress: 0x0289CC48, 0x370, 0x1C8, 0x128;
  int olbericProgress: 0x0289CC48, 0x370, 0x1C8, 0x60;
  int primroseProgress: 0x0289CC48, 0x370, 0x1C8, 0x2b8;
  int alfynProgress: 0x0289CC48, 0x370, 0x1C8, 0x5d8;
  int therionProgress: 0x0289CC48, 0x370, 0x1C8, 0x448;
  int haanitProgress: 0x0289CC48, 0x370, 0x1C8, 0x380;
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

  // Character Story Endings
  settings.Add("character_story_endings", true, "Character Story Endings");
  settings.SetToolTip("character_story_endings", "Split on final cutscene final input before credits. IF more than 1 Ch.4 completed in category, ONLY ENABLE THE FINAL CH4 CHARACTER.");
  settings.Add("character_story_endings_ophilia", false, "Ophilia Story Ending", "character_story_endings");
  settings.Add("character_story_endings_cyrus", false, "Cyrus Story Ending", "character_story_endings");
  settings.Add("character_story_endings_tressa", false, "Tressa Story Ending", "character_story_endings");
  settings.Add("character_story_endings_olberic", false, "Olberic Story Ending", "character_story_endings");
  settings.Add("character_story_endings_primrose", false, "Primrose Story Ending", "character_story_endings");
  settings.Add("character_story_endings_alfyn", false, "Alfyn Story Ending", "character_story_endings");
  settings.Add("character_story_endings_therion", false, "Therion Story Ending", "character_story_endings");
  settings.Add("character_story_endings_haanit", false, "H'aanit Story Ending", "character_story_endings");

  settings.Add("character_stories", true, "Character Stories");
  settings.SetToolTip("character_stories", "Splits for fights & events in character stories.");
  
  // Ophilia
  settings.Add("ophilia_story", true, "Ophilia Story", "character_stories");
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
  settings.Add("cyrus_story", true, "Cyrus Story", "character_stories");
  settings.Add("fight_russell", false, "Russell", "cyrus_story");
  settings.Add("chapter_end_cyrus_1", false, "Chapter 1 End", "cyrus_story");
  settings.Add("fight_gideon", false, "Gideon", "cyrus_story");
  settings.Add("chapter_end_cyrus_2", false, "Chapter 2 End", "cyrus_story");
  settings.Add("fight_yvon", false, "Yvon", "cyrus_story");
  settings.Add("chapter_end_cyrus_3", false, "Chapter 3 End", "cyrus_story");
  settings.Add("fight_lucia", false, "Lucia", "cyrus_story");
  settings.Add("chapter_end_cyrus_4", false, "Chapter 4 End", "cyrus_story");

  // Tressa
  settings.Add("tressa_story", true, "Tressa Story", "character_stories");
  settings.Add("fight_mikk_makk", false, "Mikk & Makk", "tressa_story");
  settings.Add("chapter_end_tressa_1", false, "Chapter 1 End", "tressa_story");
  settings.Add("fight_omar", false, "Omar", "tressa_story");
  settings.Add("chapter_end_tressa_2", false, "Chapter 2 End", "tressa_story");
  settings.Add("fight_venomtooth_tiger", false, "Venomtooth Tiger", "tressa_story");
  settings.Add("chapter_end_tressa_3", false, "Chapter 3 End", "tressa_story");
  settings.Add("fight_esmeralda", false, "Esmeralda", "tressa_story");
  settings.Add("chapter_end_tressa_4", false, "Chapter 4 End", "tressa_story");

  // Olberic
  settings.Add("olberic_story", true, "Olberic Story", "character_stories");
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
  settings.Add("primrose_story", true, "Primrose Story", "character_stories");
  settings.Add("fight_helgenish", false, "Helgenish", "primrose_story");
  settings.Add("chapter_end_primrose_1", false, "Chapter 1 End", "primrose_story");
  settings.Add("fight_rufus", false, "Rufus", "primrose_story");
  settings.Add("chapter_end_primrose_2", false, "Chapter 2 End", "primrose_story");
  settings.Add("fight_albus", false, "Albus", "primrose_story");
  settings.Add("chapter_end_primrose_3", false, "Chapter 3 End", "primrose_story");
  settings.Add("fight_simeon1", false, "Simeon 1", "primrose_story");
  settings.Add("fight_simeon2", false, "Simeon 2", "primrose_story");
  settings.Add("chapter_end_primrose_4", false, "Chapter 4 End", "primrose_story");

  // Alfyn
  settings.Add("alfyn_story", true, "Alfyn Story", "character_stories");
  settings.Add("fight_blotted_viper", false, "Blotted Viper", "alfyn_story");
  settings.Add("chapter_end_alfyn_1", false, "Chapter 1 End", "alfyn_story");
  settings.Add("fight_vanessa", false, "Vanessa", "alfyn_story");
  settings.Add("chapter_end_alfyn_2", false, "Chapter 2 End", "alfyn_story");
  settings.Add("fight_miguel", false, "Miguel", "alfyn_story");
  settings.Add("chapter_end_alfyn_3", false, "Chapter 3 End", "alfyn_story");
  settings.Add("fight_ogre_eagle", false, "Ogre Eagle", "alfyn_story");
  settings.Add("chapter_end_alfyn_4", false, "Chapter 4 End", "alfyn_story");

  // Therion
  settings.Add("therion_story", true, "Therion Story", "character_stories");
  settings.Add("fight_heathecote", false, "Heathecote", "therion_story");
  settings.Add("chapter_end_therion_1", false, "Chapter 1 End", "therion_story");
  settings.Add("fight_orlick", false, "Orlick", "therion_story");
  settings.Add("chapter_end_therion_2", false, "Chapter 2 End", "therion_story");
  settings.Add("fight_darius_henchmen", false, "Darius's Henchmen", "therion_story");
  settings.Add("fight_gareth", false, "Gareth", "therion_story");
  settings.Add("chapter_end_therion_3", false, "Chapter 3 End", "therion_story");
  settings.Add("fight_darius_underlings", false, "Darius's Underlings", "therion_story");
  settings.Add("3_percent_steal", false, "3% Steal", "therion_story");
  settings.Add("fight_darius", false, "Darius", "therion_story");
  settings.Add("chapter_end_therion_4", false, "Chapter 4 End", "therion_story");

  // H'aanit
  settings.Add("haanit_story", true, "H'aanit Story", "character_stories");
  settings.Add("fight_ghisarma", false, "Ghisarma", "haanit_story");
  settings.Add("chapter_end_haanit_1", false, "Chapter 1 End", "haanit_story");
  settings.Add("fight_nathans_bodyguard", false, "Nathan's Bodyguard", "haanit_story");
  settings.Add("fight_ancient_one", false, "Ancient One", "haanit_story");
  settings.Add("fight_lord_of_the_forest", false, "Lord of the Forest", "haanit_story");
  settings.Add("chapter_end_haanit_2", false, "Chapter 2 End", "haanit_story");
  settings.Add("fight_alaic", false, "Alaic", "haanit_story");
  settings.Add("fight_dragon", false, "Dragon", "haanit_story");
  settings.Add("chapter_end_haanit_3", false, "Chapter 3 End", "haanit_story");
  settings.Add("fight_redeye", false, "Redeye", "haanit_story");
  settings.Add("chapter_end_haanit_4", false, "Chapter 4 End", "haanit_story");
  
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

  settings.Add("get_shrine", true, "Get Shrines");
  settings.SetToolTip("get_shrine", "Split on getting Job from Shrine.");
  foreach (var shrineName in vars.ShrineZoneIDs.Values) {
    settings.Add("get_" + NameToKey(shrineName), false, "Get " + shrineName, "get_shrine");
  }

  // After finishing advanced job fight state goes from 6 to 5
  vars.AdvancedJobFights = new Dictionary<int,string> {
    { 187, "Steorra" },
    { 188, "Balogar" },
    { 189, "Winnehild" },
    { 190, "Dreisang" }
  };

  settings.Add("advanced_job_fights", true, "Advanced Job Fights");
  settings.SetToolTip("advanced_job_fights", "Split after defeating boss.");
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

  settings.Add("enter_exit_area", true, "Enter / Exit Area");
  settings.SetToolTip("enter_exit_area", "Split on entering and/or exiting an area.");

  foreach (var areaName in vars.AreaZoneIDs.Values) {
    string areaKey = NameToKey(areaName);
    settings.Add(areaKey, true, areaName, "enter_exit_area");
    settings.Add("enter_" + areaKey, false, "Enter", areaKey);
    settings.Add("exit_" + areaKey, false, "Exit", areaKey);
  }

  settings.Add("split_characters", false, "Split On Characters");
  settings.SetToolTip("split_characters", "Split on Character joining party (as soon as you say yes).");
  settings.Add("character_ophilia", false, "Ophilia", "split_characters");
  settings.Add("character_cyrus", false, "Cyrus", "split_characters");
  settings.Add("character_tressa", false, "Tressa", "split_characters");
  settings.Add("character_olberic", false, "Olberic", "split_characters");
  settings.Add("character_primrose", false, "Primrose", "split_characters");
  settings.Add("character_alfyn", false, "Alfyn", "split_characters");
  settings.Add("character_haanit", false, "H'aanit", "split_characters");
  settings.Add("character_therion", false, "Therion", "split_characters");

  // Galdera
  settings.Add("galdera", true, "Galdera");
  settings.SetToolTip("galdera", "Galdera Splits.");

  settings.Add("finis_start", false, "Enter Gate of Finis", "galdera");
  settings.Add("journeys_end_start", false, "Enter Journey's End", "galdera");
  settings.Add("at_journeys_end", false, "Galdera End", "galdera");
  settings.SetToolTip("at_journeys_end", "Split on category end (get Spurning Ribbon)");

  settings.Add("credits", false, "Credits");
  settings.SetToolTip("credits", "Split on Credits Start. Slightly late for ending on final cutscene before credits.");
}

start
{
  if (timer.CurrentPhase == TimerPhase.NotRunning &&
      current.start == 1 &&
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
  if(old.ophiliaProgress == 0 && current.ophiliaProgress >= 100) return vars.Split("character_ophilia");
  if(old.cyrusProgress == 0 && current.cyrusProgress >= 100) return vars.Split("character_cyrus");
  if(old.tressaProgress == 0 && current.tressaProgress >= 100) return vars.Split("character_tressa");
  if(old.olbericProgress == 0 && current.olbericProgress >= 100) return vars.Split("character_olberic");
  if(old.primroseProgress == 0 && current.primroseProgress >= 100) return vars.Split("character_primrose");
  if(old.alfynProgress == 0 && current.alfynProgress >= 90) return vars.Split("character_alfyn");
  if(old.haanitProgress == 0 && current.haanitProgress >= 100) return vars.Split("character_haanit");
  if(old.therionProgress == 0 && current.therionProgress >= 100) return vars.Split("character_therion");


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
    return vars.Split("character_story_endings_ophilia");
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
      return vars.Split("character_story_endings_cyrus");
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
    return vars.Split("character_story_endings_tressa");
  }

  // Primrose
  if (old.primroseProgress != current.primroseProgress && old.zoneID != 0) {
    if (current.primroseProgress == 160) return vars.Split("fight_helgenish");
    else if (current.primroseProgress == 1180) return vars.Split("fight_rufus");
    else if (current.primroseProgress == 2170) return vars.Split("fight_albus");
    else if (current.primroseProgress == 3120) return vars.Split("fight_simeon1");
    else if (current.primroseProgress == 3150) return vars.Split("fight_simeon2");
    else if (current.primroseProgress % 1000 == 0) {
      vars.isChapterEnding = true;
      vars.charChapterEnding = "Primrose";
    }
  }

  // Primrose Ending
  if (current.primroseProgress == 3150 && (current.cutsceneProgressBar > 0.98 || current.cutsceneScriptIndex > 94)) {
    return vars.Split("character_story_endings_primrose");
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
    return vars.Split("character_story_endings_olberic");
  }

  // Alfyn
  if (old.alfynProgress != current.alfynProgress && old.zoneID != 0) {
    if (current.alfynProgress == 90) return vars.Split("fight_blotted_viper");
    else if (current.alfynProgress == 1130) return vars.Split("fight_vanessa");
    else if (current.alfynProgress == 2140) return vars.Split("fight_miguel");
    else if (current.alfynProgress == 3240) return vars.Split("fight_ogre_eagle");
    else if (current.alfynProgress % 1000 == 0) {
      vars.isChapterEnding = true;
      vars.charChapterEnding = "Alfyn";
    }
  }
  
  // Alfyn Ending
  if (current.alfynProgress == 3300 && (current.cutsceneProgressBar > 0.98 || current.cutsceneScriptIndex > 93)) {
    return vars.Split("character_story_endings_alfyn");
  }


  // Therion
  if (old.therionProgress != current.therionProgress && old.zoneID != 0) {
    if (current.therionProgress == 140) return vars.Split("fight_heathecote");
    else if (current.therionProgress == 1130) return vars.Split("fight_orlick");
    else if (current.therionProgress == 2100) return vars.Split("fight_darius_henchmen");
    else if (current.therionProgress == 2150) return vars.Split("fight_gareth");
    else if (current.therionProgress == 3040) return vars.Split("fight_darius_underlings");
    else if (current.therionProgress == 3140) return vars.Split("3_percent_steal");
    else if (current.therionProgress == 3180) return vars.Split("fight_darius");
    else if (current.therionProgress % 1000 == 0) {
      vars.isChapterEnding = true;
      vars.charChapterEnding = "Therion";
    }
  }

  // Therion Ending
  if (current.therionProgress == 3200 && (current.cutsceneProgressBar > 0.98 || current.cutsceneScriptIndex > 275)) {
    return vars.Split("character_story_endings_therion");
  }

  // H'aanit
  if (old.haanitProgress != current.haanitProgress && old.zoneID != 0) {
    if (current.haanitProgress == 110) return vars.Split("fight_ghisarma");
    else if (current.haanitProgress == 1050) return vars.Split("fight_nathans_bodyguard");
    else if (current.haanitProgress == 1100) return vars.Split("fight_ancient_one");
    else if (current.haanitProgress == 1120) return vars.Split("fight_lord_of_the_forest");
    else if (current.haanitProgress == 2030) return vars.Split("fight_alaic");
    else if (current.haanitProgress == 2090) return vars.Split("fight_dragon");
    else if (current.haanitProgress == 3130) return vars.Split("fight_redeye");
    else if (current.haanitProgress % 1000 == 0) {
      vars.isChapterEnding = true;
      vars.charChapterEnding = "Haanit";
    }
  }
  
  // H'aanit Ending
  if (current.haanitProgress == 3140 && (current.cutsceneProgressBar > 0.98 || current.cutsceneScriptIndex > 195)) {
    return vars.Split("character_story_endings_haanit");
  }

  // All Character Chapter Ends
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