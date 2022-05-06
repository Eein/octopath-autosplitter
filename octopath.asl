state("Octopath_Traveler-Win64-Shipping", "Steam") {
  int start: 0x2B32C48, 0xE30;
  int characterIsHighlighted: 0x289D268, 0x368, 0x0, 0x328;

  int zoneID: 0x289D240, 0x36C;
  int money: 0x0289CC48, 0x370, 0x158;
  int gameState: 0x0289D270, 0x36C;
  int cutsceneScriptIndex: 0x289D230, 0x388;

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

state("Octopath_Traveler-Win64-Shipping", "Xbox") {
  int start: 0x031C1FB0, 0x18, 0x700;
  int characterIsHighlighted: 0x0302AF18, 0x240, 0x0, 0x358;

  int zoneID: 0x0302AEF0, 0x244;
  int money: 0x0302A8E8, 0x280, 0x150;
  int gameState: 0x0302AF20, 0x244;
  int cutsceneScriptIndex: 0x0302AEE0, 0x260;

  float cutsceneProgressBar: 0x0302AF18, 0x250, 0x20, 0x260, 0x310, 0x230;

  int ophiliaProgress: 0x0302A8E8, 0x280, 0x1C0, 0x510;
  int cyrusProgress: 0x0302A8E8, 0x280, 0x1C0, 0x1f0;
  int tressaProgress: 0x0302A8E8, 0x280, 0x1C0, 0x128;
  int olbericProgress: 0x0302A8E8, 0x280, 0x1C0, 0x60;
  int primroseProgress: 0x0302A8E8, 0x280, 0x1C0, 0x2b8;
  int alfynProgress: 0x0302A8E8, 0x280, 0x1C0, 0x5d8;
  int therionProgress: 0x0302A8E8, 0x280, 0x1C0, 0x448;
  int haanitProgress: 0x0302A8E8, 0x280, 0x1C0, 0x380;
}

init {
  vars.moduleSize = modules.First().ModuleMemorySize;
  if (vars.moduleSize == 58732544) {
    version = "Xbox";
  } else {
    // Steam = 51175424, but setting it as default.
    // Don't know how effective this code will be yet.
    version = "Steam";
  }

  vars.Splits = new HashSet<string>();
  vars.isChapterEnding = false;
  vars.charChapterEnding = "";

  vars.deaths = 0;
  vars.encounters = 0;
  vars.counterTextComponent = -1;

  vars.Split = (Func<string,bool>)(key => {
    if(vars.Splits.Contains(key)) { return false; }
    vars.Splits.Add(key);
    return settings[key];
  });

  vars.SetCharacterEnding = (Action<string>)(character => {
    vars.isChapterEnding = true;
    vars.charChapterEnding = character;
  });

  vars.ClearCharacterEnding = (Action)(() => {
    vars.isChapterEnding = false;
    vars.charChapterEnding = "";
  });

  vars.SplitChapter = (Func<int,int,int,bool>)((progress, curGameState, oldGameState) => {
    if (progress % 1000 == 0 && vars.isChapterEnding && curGameState == 2 && oldGameState == 5) {
      int currentChapter = progress / 1000;
      if (currentChapter == 0) { return false; }
      string key = String.Format("chapter_end_" + vars.charChapterEnding.ToLower() + "_" + currentChapter.ToString());
      vars.ClearCharacterEnding();
      return vars.Split(key);
    }
    return false;
  });

  // Stole this from FF13 Autosplitter, thanks Roosta :)
  // Might be better implementation possible
  foreach (LiveSplit.UI.Components.IComponent component in timer.Layout.Components) {
    if (component.GetType().Name == "TextComponent") {
      if (settings["encounter_death_counter"] == true & vars.counterTextComponent == -1) {
        vars.counterTextComponent = component;
        vars.counterTextComponent.Settings.Text1 = "Encounters / Deaths";
        vars.UpdateCounter();
      }
    }
  }

  vars.UpdateCounter = (Action)(() => {
    vars.counterTextComponent.Settings.Text2 = vars.encounters + "/" + vars.deaths;
  });
}

onReset {
  vars.Splits.Clear();
  vars.ClearCharacterEnding();

  // Encounter / Death Counter logic 
  if (settings["encounter_death_counter"]) {
    vars.deaths = 0;
    vars.encounters = 0;
    vars.UpdateCounter();
  }
}

update {
 if (timer.CurrentPhase == TimerPhase.Running) {
    if (current.gameState == 6 && old.gameState == 2) {
      vars.encounters = vars.encounters + 1;
      vars.UpdateCounter();
    } else if (current.gameState == 7 && old.gameState == 6) {
      vars.deaths = vars.deaths + 1;
      vars.UpdateCounter();
    }
  }
}

startup {
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
  settings.Add("fight_brigands1", false, "Brigands 1", "olberic_story");
  settings.Add("fight_brigands2", false, "Brigands 2", "olberic_story");
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
  settings.Add("fight_red_hat", false, "Red Hat", "olberic_story");
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
  
  vars.NameToKey = (Func<string,string>)(name => {
    return name.ToLower().Replace(' ', '_').Replace("'", "");
  });

  settings.Add("get_shrine", true, "Get Shrines");
  settings.SetToolTip("get_shrine", "Split on getting Job from Shrine.");
  foreach (var shrineName in vars.ShrineZoneIDs.Values) {
    settings.Add("get_" + vars.NameToKey(shrineName), false, "Get " + shrineName, "get_shrine");
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
  foreach (string fight in vars.AdvancedJobFights.Values) {
    settings.Add("advanced_job_fight_" + vars.NameToKey(fight), false, fight, "advanced_job_fights");
  }

  vars.AreaZoneIDs = new Dictionary<int, dynamic> {
    { 12, new { name = "Cobbleston", region = "Highlands", ring = 1 } },
    { 13, new { name = "Stonegard", region = "Highlands", ring = 2 } },
    { 14, new { name = "Stonegard Heights", region = "Highlands", ring = 2 } },
    { 15, new { name = "Stonegard Valleys", region = "Highlands", ring = 2 } },
    { 16, new { name = "Everhold", region = "Highlands", ring = 3 } },
    { 17, new { name = "Everhold Amphitheatre", region = "Highlands", ring = 3 } },
    { 18, new { name = "Mountain Pass", region = "Highlands", ring = 1 } },
    { 19, new { name = "North Cobbleston Gap", region = "Highlands", ring = 1 } },
    { 20, new { name = "South Cobbleston Gap", region = "Highlands", ring = 1 } },
    { 21, new { name = "Brigand's Den", region = "Highlands", ring = 1 } },
    { 22, new { name = "Untouched Sanctum", region = "Highlands", ring = 1 } },
    { 23, new { name = "Spectrewood Path", region = "Highlands", ring = 2 } },
    { 24, new { name = "North Stoneguard Pass", region = "Highlands", ring = 2 } },
    { 25, new { name = "West Stonegard Pass", region = "Highlands", ring = 2 } },
    { 26, new { name = "The Spectrewood", region = "Highlands", ring = 2 } },
    { 27, new { name = "Yvon's Cellar, Yvon's Birthplace", region = "Highlands", ring = 2 } },
    { 28, new { name = "Tomb of Kings", region = "Highlands", ring = 2 } },
    { 29, new { name = "West Everhold Pass", region = "Highlands", ring = 3 } },
    { 30, new { name = "Amphitheatre: Arena", region = "Highlands", ring = 3 } },
    { 31, new { name = "Amphitheatre: Balcony", region = "Highlands", ring = 3 } },
    { 32, new { name = "Everhold Amphitheatre (deeper into Prim 4, end of Prim 4)", region = "Highlands",  ring = 3 } },
    { 33, new { name = "Everhold Tunnels", region = "Highlands", ring = 3 } },
    { 34, new { name = "Sunshade", region = "Sunlands", ring = 1 } },
    { 35, new { name = "Sunshade Tavern", region = "Sunlands", ring = 1 } },
    { 36, new { name = "Southern Sunshade Sands", region = "Sunlands", ring = 1 } },
    { 37, new { name = "Eastern Sunshade Sands", region = "Sunlands", ring = 1 } },
    { 38, new { name = "Sunshade Catacombs", region = "Sunlands", ring = 1 } },
    { 39, new { name = "Whistling Cavern", region = "Sunlands", ring = 1 } },
    { 40, new { name = "Wellspring", region = "Sunlands", ring = 2 } },
    { 42, new { name = "Western Wellspring Sands", region = "Sunlands", ring = 2 } },
    { 43, new { name = "Southern Wellspring Sands", region = "Sunlands", ring = 2 } },
    { 44, new { name = "Northern Wellspring Sands", region = "Sunlands", ring = 2 } },
    { 45, new { name = "Eastern Wellspring Sands", region = "Sunlands", ring = 2 } },
    { 46, new { name = "Lizardman's Den", region = "Sunlands", ring = 2 } },
    { 47, new { name = "Black Market", region = "Sunlands", ring = 2 } },
    { 48, new { name = "Quicksand Caves", region = "Sunlands", ring = 2 } },
    { 49, new { name = "Marsalim", region = "Sunlands", ring = 3 } },
    { 50, new { name = "Marsalim Palace", region = "Sunlands", ring = 3 } },
    { 51, new { name = "Grimsand Road", region = "Sunlands", ring = 3 } },
    { 52, new { name = "Eastern Marsalim Sands", region = "Sunlands", ring = 3 } },
    { 53, new { name = "Grimsand Ruins #1", region = "Sunlands", ring = 3 } },
    { 54, new { name = "Grimsand Ruins #2", region = "Sunlands", ring = 3 } },
    { 55, new { name = "Marsalim Catacombs", region = "Sunlands", ring = 3 } },
    { 56, new { name = "Clearbrook", region = "Riverlands", ring = 1 } },
    { 57, new { name = "Path of Rhiyo", region = "Riverlands", ring = 1 } },
    { 58, new { name = "South Clearbrook Traverse", region = "Riverlands", ring = 1 } },
    { 59, new { name = "West Clearbrook Traverse", region = "Riverlands", ring = 1 } },
    { 60, new { name = "Cave of Rhiyo", region = "Riverlands", ring = 1 } },
    { 61, new { name = "Twin Falls", region = "Riverlands", ring = 1 } },
    { 62, new { name = "Saintsbridge", region = "Riverlands", ring = 2 } },
    { 63, new { name = "Saintsbridge: Upstream", region = "Riverlands", ring = 2 } },
    { 64, new { name = "Saintsbridge Cathedral", region = "Riverlands", ring = 2 } },
    { 65, new { name = "Murkwood Trail", region = "Riverlands", ring = 2 } },
    { 66, new { name = "East Saintsbridge Traverse", region = "Riverlands", ring = 2 } },
    { 67, new { name = "The Murkwood", region = "Riverlands", ring = 2 } },
    { 68, new { name = "Rivira Woods", region = "Riverlands", ring = 2 } },
    { 69, new { name = "Farshore", region = "Riverlands", ring = 2 } },
    { 70, new { name = "Riverford", region = "Riverlands", ring = 3 } },
    { 71, new { name = "Manse Gardens, Lower Riverford", region = "Riverlands", ring = 3 } },
    { 72, new { name = "North Riverford Traverse", region = "Riverlands", ring = 3 } },
    { 73, new { name = "Hidden Path", region = "Riverlands", ring = 3 } },
    { 74, new { name = "Lord's Manse", region = "Riverlands", ring = 3 } },
    { 75, new { name = "Refuge Ruins", region = "Riverlands", ring = 3 } },
    { 76, new { name = "Atlasdam", region = "Flatlands", ring = 1 } },
    { 77, new { name = "Atlasdam Palace Gate, Royal Academy of Atlasdam", region = "Flatlands", ring = 1 } },
    { 78, new { name = "Atlasdam Palace", region = "Flatlands", ring = 1 } },
    { 79, new { name = "East Atlasdam Flats", region = "Flatlands", ring = 1 } },
    { 80, new { name = "North Atlasdam Flats", region = "Flatlands", ring = 1 } },
    { 81, new { name = "Subterranean Study", region = "Flatlands", ring = 1 } },
    { 82, new { name = "The Whistlewood", region = "Flatlands", ring = 1 } },
    { 83, new { name = "Noblecourt", region = "Flatlands", ring = 2 } },
    { 84, new { name = "East Noblecourt", region = "Flatlands", ring = 2 } },
    { 85, new { name = "Western Noblecourt Flats", region = "Flatlands", ring = 2 } },
    { 86, new { name = "Orlick's Manse", region = "Flatlands", ring = 2 } },
    { 87, new { name = "Obsidian Manse", region = "Flatlands", ring = 2 } },
    { 88, new { name = "The Hollow Throne", region = "Flatlands", ring = 2 } },
    { 89, new { name = "Wispermill", region = "Flatlands", ring = 3 } },
    { 90, new { name = "Western Wispermill Flats", region = "Flatlands", ring = 3 } },
    { 91, new { name = "Ebony Grotto #1", region = "Flatlands", ring = 3 } },
    { 92, new { name = "Ebony Grotto #2", region = "Flatlands", ring = 3 } },
    { 93, new { name = "Forest of Purgation", region = "Flatlands", ring = 3 } },
    { 94, new { name = "Bolderfall", region = "Clifflands", ring = 1 } },
    { 95, new { name = "Lower Bolderfall", region = "Clifflands", ring = 1 } },
    { 96, new { name = "Ruvus Manor Gate", region = "Clifflands", ring = 1 } },
    { 97, new { name = "North Bolderfall Pass", region = "Clifflands", ring = 1 } },
    { 98, new { name = "South Bolderfall Pass", region = "Clifflands", ring = 1 } },
    { 99, new { name = "Ravus Manor", region = "Clifflands", ring = 1 } },
    { 100, new { name = "Carrion Caves", region = "Clifflands", ring = 1 } },
    { 101, new { name = "Quarrycrest", region = "Clifflands", ring = 2 } },
    { 102, new { name = "Quarrycrest Mines", region = "Clifflands", ring = 2 } },
    { 103, new { name = "Road to Morlock's Manse", region = "Clifflands", ring = 2 } },
    { 104, new { name = "South Quarrycrest Pass", region = "Clifflands", ring = 2 } },
    { 105, new { name = "Morlock's Manse", region = "Clifflands", ring = 2 } },
    { 106, new { name = "The Sewers", region = "Clifflands", ring = 2 } },
    { 107, new { name = "Derelict Mine", region = "Clifflands", ring = 2 } },
    { 108, new { name = "Orewell", region = "Clifflands", ring = 3 } },
    { 109, new { name = "Trail to Forest of Rubeh", region = "Clifflands", ring = 3 } },
    { 110, new { name = "South Orewell Pass", region = "Clifflands", ring = 3 } },
    { 111, new { name = "Forest of Rubeh #1", region = "Clifflands", ring = 3 } },
    { 112, new { name = "Forest of Rubeh #2", region = "Clifflands", ring = 3 } },
    { 113, new { name = "Dragonsong Fane", region = "Clifflands", ring = 3 } },
    { 114, new { name = "Rippletide", region = "Coastlands", ring = 1 } },
    { 115, new { name = "Path to the Caves of Maiya", region = "Coastlands", ring = 1 } },
    { 116, new { name = "North Rippletide Coast", region = "Coastlands", ring = 1 } },
    { 117, new { name = "East Rippletide Coast", region = "Coastlands", ring = 1 } },
    { 118, new { name = "Caves of Maiya", region = "Coastlands", ring = 1 } },
    { 119, new { name = "Undertow Cave", region = "Coastlands", ring = 1 } },
    { 120, new { name = "Goldshore", region = "Coastlands", ring = 2 } },
    { 121, new { name = "Goldshore Manor District", region = "Coastlands", ring = 2 } },
    { 122, new { name = "Goldshore Cathedral", region = "Coastlands", ring = 2 } },
    { 123, new { name = "Road to the Seaside Grotto", region = "Coastlands", ring = 2 } },
    { 124, new { name = "Road to the Caves of Azure", region = "Coastlands", ring = 2 } },
    { 125, new { name = "West Goldshore Coast", region = "Coastlands", ring = 2 } },
    { 126, new { name = "Moonstruck Coast", region = "Coastlands", ring = 2 } },
    { 127, new { name = "Seaside Grotto", region = "Coastlands", ring = 2 } },
    { 128, new { name = "Caves of Azure", region = "Coastlands", ring = 2 } },
    { 129, new { name = "Captain's Bane", region = "Coastlands", ring = 2 } },
    { 130, new { name = "Grandport #1", region = "Coastlands", ring = 3 } },
    { 131, new { name = "Grandport #2", region = "Coastlands", ring = 3 } },
    { 132, new { name = "Grandport #3", region = "Coastlands", ring = 3 } },
    { 133, new { name = "West Grandport Coast", region = "Coastlands", ring = 3 } },
    { 134, new { name = "Grandport Sewers #1", region = "Coastlands", ring = 3 } },
    { 135, new { name = "Grandport Sewers #2", region = "Coastlands", ring = 3 } },
    { 136, new { name = "Loch of the Lost King", region = "Coastlands", ring = 3 } },
    { 137, new { name = "Flamesgrace #1", region = "Frostlands", ring = 1 } },
    { 138, new { name = "Flamesgrace #2", region = "Frostlands", ring = 1 } },
    { 139, new { name = "Flamesgrace Church", region = "Frostlands", ring = 1 } },
    { 140, new { name = "Path to the Cave of Origin", region = "Frostlands", ring = 1 } },
    { 141, new { name = "Western Flamesgrace Wilds", region = "Frostlands", ring = 1 } },
    { 142, new { name = "Northern Flamesgrace Wilds", region = "Frostlands", ring = 1 } },
    { 143, new { name = "Cave of Origin", region = "Frostlands", ring = 1 } },
    { 144, new { name = "Hoarfrost Grotto", region = "Frostlands", ring = 1 } },
    { 145, new { name = "Stillsnow", region = "Frostlands", ring = 2 } },
    { 146, new { name = "Trail to the Whitewood", region = "Frostlands", ring = 2 } },
    { 147, new { name = "Road to the Obsidian Parlor", region = "Frostlands", ring = 2 } },
    { 148, new { name = "Western Stillsnow Wilds", region = "Frostlands", ring = 2 } },
    { 149, new { name = "The Whitewood", region = "Frostlands", ring = 2 } },
    { 150, new { name = "Secret Path", region = "Frostlands", ring = 2 } },
    { 151, new { name = "Tomb of the Imperator", region = "Frostlands", ring = 2 } },
    { 152, new { name = "Northreach", region = "Frostlands", ring = 3 } },
    { 153, new { name = "Northreach: Lorn Cathedral", region = "Frostlands", ring = 3 } },
    { 154, new { name = "Southern Northreach Wilds", region = "Frostlands", ring = 3 } },
    { 155, new { name = "Lorn Cathedral: Cellars", region = "Frostlands", ring = 3 } },
    { 156, new { name = "Lorn Cathedral: Cellars #2", region = "Frostlands", ring = 3 } },
    { 157, new { name = "Maw of the Ice Dragon", region = "Frostlands", ring = 3 } },
    { 158, new { name = "S'warkii", region = "Woodlands", ring = 1 } },
    { 159, new { name = "Path to the Whisperwood", region = "Woodlands", ring = 1 } },
    { 160, new { name = "West S'warkii Trail", region = "Woodlands", ring = 1 } },
    { 161, new { name = "North S'warkii Trail", region = "Woodlands", ring = 1 } },
    { 162, new { name = "The Whisperwood", region = "Woodlands", ring = 1 } },
    { 163, new { name = "Path of Beasts", region = "Woodlands", ring = 1 } },
    { 164, new { name = "Victor's Hollow", region = "Woodlands", ring = 2 } },
    { 165, new { name = "Victor's Hollow: Arena Gate", region = "Woodlands", ring = 2 } },
    { 166, new { name = "Victor's Hollow: Arena", region = "Woodlands", ring = 2 } },
    { 167, new { name = "Path to the Forgotten Grotto", region = "Woodlands", ring = 2 } },
    { 168, new { name = "East Victor's Hollow Trail", region = "Woodlands", ring = 2 } },
    { 169, new { name = "Forgotten Grotto", region = "Woodlands", ring = 2 } },
    { 170, new { name = "Forest of No Return", region = "Woodlands", ring = 2 } },
    { 171, new { name = "Duskbarrow", region = "Woodlands", ring = 3 } },
    { 172, new { name = "East Duskbarrow Trail", region = "Woodlands", ring = 3 } },
    { 173, new { name = "Ruins of Eld #1", region = "Woodlands", ring = 3 } },
    { 174, new { name = "Ruins of Eld #2", region = "Woodlands", ring = 3 } },
    { 175, new { name = "Moldering Ruins", region = "Woodlands", ring = 3 } },
    { 179, new { name = "Shrine of the Flamebearer", region = "Frostlands", ring = 2 } },
    { 180, new { name = "Shrine of the Sage", region = "Flatlands", ring = 2 } },
    { 181, new { name = "Shrine of the Trader", region = "Coastlands", ring = 2 } },
    { 182, new { name = "Shrine of the Thunderblade", region = "Highlands", ring = 2 } },
    { 183, new { name = "Shrine of the Lady of Grace", region = "Sunlands", ring = 2 } },
    { 184, new { name = "Shrine of the Healer", region = "Frostlands", ring = 2 } },
    { 185, new { name = "Shrine of the Prince of Thieves", region = "Clifflands", ring = 2 } },
    { 186, new { name = "Shrine of the Huntress", region = "Woodlands", ring = 2 } },
    { 187, new { name = "Shrine of the Starseer", region = "Flatlands", ring = 3 } },
    { 188, new { name = "Shrine of the Runeblade", region = "Highlands", ring = 3 } },
    { 189, new { name = "Shrine of the Warbringer", region = "Riverlands", ring = 3 } },
    { 190, new { name = "Shrine of the Archmagus", region = "Woodlands", ring = 3 } },
    { 193, new { name = "Obsidian Parlor", region = "Frostlands", ring = 2 } },
    { 194, new { name = "Ruins of Hornburg", region = "Highlands", ring = 3 } },
    { 195, new { name = "The Gate of Finis", region = "Highlands", ring = 3 } },
    { 196, new { name = "Journey's End", region = "Highlands", ring = 3 } },
  };

  settings.Add("enter_exit_area", true, "Enter / Exit Area");
  settings.SetToolTip("enter_exit_area", "Split on entering and/or exiting an area.");

  string[] regions = new string[] { "Frostlands", "Flatlands", "Coastlands", "Highlands", "Sunlands", "Riverlands", "Clifflands", "Woodlands" };
  int[] rings = new int[] { 1, 2, 3 };
  foreach (var region in regions) {
    string regionKey = vars.NameToKey(region);
    settings.Add("enter_exit_area_" + regionKey, true, region, "enter_exit_area");
    foreach (var ring in rings) {
      settings.Add("enter_exit_area_" + regionKey + "_" + ring, true, "Ring " + ring, "enter_exit_area_" + regionKey);
    }
  }

  foreach (var areaInfo in vars.AreaZoneIDs) {
    var area = areaInfo.Value;
    int zoneID = areaInfo.Key;
    string parentKey = "enter_exit_area_" + vars.NameToKey(area.region) + "_" + area.ring; 
    settings.Add("area_"+ zoneID, true, area.name, parentKey);
    settings.Add("enter_" + zoneID, false, "Enter", "area_" + zoneID);
    settings.Add("exit_" + zoneID, false, "Exit", "area_" + zoneID);
  }

  settings.Add("split_characters", true, "Split On Characters");
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
  settings.Add("galdera_phase_1_start", false, "Galdera Phase 1 Battle Start", "galdera");
  settings.Add("galdera_phase_1_end", false, "Galdera Phase 1 Battle End", "galdera");
  settings.Add("galdera_phase_2_start", false, "Galdera Phase 2 Battle Start", "galdera");
  settings.Add("galdera_phase_2_end", false, "Galdera Phase 2 Battle End", "galdera");
  settings.Add("at_journeys_end", false, "Galdera End", "galdera");
  settings.SetToolTip("at_journeys_end", "Split on category end (get Spurning Ribbon)");

  settings.Add("credits", false, "Credits");
  settings.SetToolTip("credits", "Split on Credits Start. Slightly late for ending on final cutscene before credits.");

  settings.Add("encounter_death_counter", false, "Override Text Component with a Enounter / Death Counter.");
}

start {
  if (timer.CurrentPhase == TimerPhase.NotRunning &&
      old.start == 0 &&
      current.start == 1 &&
      current.zoneID == 0) {
    return true;
  }
}

reset {
  if (timer.CurrentPhase == TimerPhase.Running &&
      current.characterIsHighlighted == 1 &&
      old.characterIsHighlighted == 0 &&
      current.zoneID == 0) {
    return true;
  }
}

split {
  // Shrines
  if (vars.ShrineZoneIDs.ContainsKey(current.zoneID) && current.gameState == 5 && old.gameState == 2) {
    string getShrineKey = "get_" + vars.NameToKey(vars.ShrineZoneIDs[current.zoneID]);
    return vars.Split(getShrineKey);
  }

  // Advanced Job Fights
  if (vars.AdvancedJobFights.ContainsKey(current.zoneID) && current.gameState == 5 && old.gameState == 6) {
    return vars.Split("advanced_job_fight_" + vars.NameToKey(vars.AdvancedJobFights[current.zoneID]));
  }

  // Enter & Exit Area
  if (old.zoneID != current.zoneID && old.zoneID != 0) {
    // Enter Area
    if (vars.AreaZoneIDs.ContainsKey(current.zoneID) && current.gameState == 2 && old.gameState == 2 && vars.Split("enter_" + current.zoneID)) {
      return true;
    }
    // Exit Area
    if (vars.AreaZoneIDs.ContainsKey(old.zoneID) && (old.gameState == 2 || old.gameState == 4) && vars.Split("exit_" + old.zoneID)) {
      return true;
    }
  }

  // Characters Joining
  if(old.ophiliaProgress == 0 && current.ophiliaProgress >= 120) return vars.Split("character_ophilia");
  if(old.cyrusProgress == 0 && current.cyrusProgress >= 100) return vars.Split("character_cyrus");
  if(old.tressaProgress == 0 && current.tressaProgress >= 110) return vars.Split("character_tressa");
  if(old.olbericProgress == 0 && current.olbericProgress >= 110) return vars.Split("character_olberic");
  if(old.primroseProgress == 0 && current.primroseProgress >= 140) return vars.Split("character_primrose");
  if(old.alfynProgress == 0 && current.alfynProgress >= 70) return vars.Split("character_alfyn");
  if(old.haanitProgress == 0 && current.haanitProgress >= 110) return vars.Split("character_haanit");
  if(old.therionProgress == 0 && current.therionProgress >= 70) return vars.Split("character_therion");

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
    if (current.olbericProgress == 110) return vars.Split("fight_brigands1");
    else if (current.olbericProgress == 140) return vars.Split("fight_brigands2");
    else if (current.olbericProgress == 160) return vars.Split("fight_gaston");
    else if (current.olbericProgress == 1070) return vars.Split("fight_victorino");
    else if (current.olbericProgress == 1140) return vars.Split("fight_joshua");
    else if (current.olbericProgress == 1180) return vars.Split("fight_archibold");
    else if (current.olbericProgress == 1220) return vars.Split("fight_gustav");
    else if (current.olbericProgress == 2070) return vars.Split("fight_lizards1");
    else if (current.olbericProgress == 2080) return vars.Split("fight_lizards2");
    else if (current.olbericProgress == 2110) return vars.Split("fight_lizardking");
    else if (current.olbericProgress == 2130) return vars.Split("fight_erhardt");
    else if (current.olbericProgress == 3050) return vars.Split("fight_red_hat");
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

  else if (current.zoneID == 196 && current.gameState == 6 && old.gameState == 5) {
    return vars.Split("galdera_phase_1_start");
  }

  else if (current.zoneID == 198 && old.zoneID == 196) {
    return vars.Split("galdera_phase_1_end");
  }

  else if (current.zoneID == 198 && old.zoneID == 198 && current.gameState == 6 && old.gameState == 5) {
    return vars.Split("galdera_phase_2_start");
  }

  else if (current.zoneID == 198 && old.zoneID == 198 && current.gameState == 5 && old.gameState == 6) {
    return vars.Split("galdera_phase_2_end");
  }

  else if (current.zoneID == 194 && current.money - old.money == 100000) {
    return vars.Split("at_journeys_end");
  }
}
