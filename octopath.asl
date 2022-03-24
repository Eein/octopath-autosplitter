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

  vars.deaths = 0;
  vars.encounters = 0;
  vars.counterTextComponent = -1;

  Func<string> UpdateCounter = () => vars.counterTextComponent.Settings.Text2 = vars.encounters + "/" + vars.deaths;
  vars.UpdateCounter = UpdateCounter;

  // Stole this from FF13 Autosplitter, thanks Roosta :)
  // Might be better implementation possible
  foreach (LiveSplit.UI.Components.IComponent component in timer.Layout.Components) {
	  if (component.GetType().Name == "TextComponent") {
		  if (settings["encounter_death_counter"] == true & vars.counterTextComponent == -1) {
        vars.counterTextComponent = component;
        vars.counterTextComponent.Settings.Text1 = "Encounters / Deaths";
        UpdateCounter();
      }
		}
  }
}

update
{
  if (timer.CurrentPhase == TimerPhase.NotRunning) {
    vars.Splits.Clear();
    vars.ClearCharacterEnding();

    // Encounter / Death Counter logic 
    if (settings["encounter_death_counter"]) {
      vars.deaths = 0;
      vars.encounters = 0;
      vars.UpdateCounter();
    }
  } else if (timer.CurrentPhase == TimerPhase.Running) {
    if (current.gameState == 6 && old.gameState == 2) {
      vars.encounters = vars.encounters + 1;
      vars.UpdateCounter();
    } else if (current.gameState == 7 && old.gameState == 6) {
      vars.deaths = vars.deaths + 1;
      vars.UpdateCounter();
    }
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

  Func<string,string,int,ExpandoObject> CreateArea = (name, region, ring) => {
    dynamic area = new ExpandoObject();
    area.name = name;
    area.region = region;
    area.ring = ring;
    return area;
  };

  vars.AreaZoneIDs = new Dictionary<int, ExpandoObject> {
    { 12, CreateArea("Cobbleston", "Highlands", 1) },
    { 13, CreateArea("Stonegard", "Highlands", 2) },
    { 14, CreateArea("Stonegard Heights", "Highlands", 2) },
    { 15, CreateArea("Stonegard Valleys", "Highlands", 2) },
    { 16, CreateArea("Everhold", "Highlands", 3) },
    { 17, CreateArea("Everhold Amphitheatre", "Highlands", 3) },
    { 18, CreateArea("Mountain Pass", "Highlands", 1) },
    { 19, CreateArea("North Cobbleston Gap", "Highlands", 1) },
    { 20, CreateArea("South Cobbleston Gap", "Highlands", 1) },
    { 21, CreateArea("Brigand's Den", "Highlands", 1) },
    { 22, CreateArea("Untouched Sanctum", "Highlands", 1) },
    { 23, CreateArea("Spectrewood Path", "Highlands", 2) },
    { 24, CreateArea("North Stoneguard Pass", "Highlands", 2) },
    { 25, CreateArea("West Stonegard Pass", "Highlands", 2) },
    { 26, CreateArea("The Spectrewood", "Highlands", 2) },
    { 27, CreateArea("Yvon's Cellar, Yvon's Birthplace", "Highlands", 2) },
    { 28, CreateArea("Tomb of Kings", "Highlands", 2) },
    { 29, CreateArea("West Everhold Pass", "Highlands", 3) },
    { 30, CreateArea("Amphitheatre: Arena", "Highlands", 3) },
    { 31, CreateArea("Amphitheatre: Balcony", "Highlands", 3) },
    { 32, CreateArea("Everhold Amphitheatre (deeper into Prim 4, end of Prim 4)", "Highlands",  3) },
    { 33, CreateArea("Everhold Tunnels", "Highlands", 3) },
    { 34, CreateArea("Sunshade", "Sunlands", 1) },
    { 35, CreateArea("Sunshade Tavern", "Sunlands", 1) },
    { 36, CreateArea("Southern Sunshade Sands", "Sunlands", 1) },
    { 37, CreateArea("Eastern Sunshade Sands", "Sunlands", 1) },
    { 38, CreateArea("Sunshade Catacombs", "Sunlands", 1) },
    { 39, CreateArea("Whistling Cavern", "Sunlands", 1) },
    { 40, CreateArea("Wellspring", "Sunlands", 2) },
    { 42, CreateArea("Western Wellspring Sands", "Sunlands", 2) },
    { 43, CreateArea("Southern Wellspring Sands", "Sunlands", 2) },
    { 44, CreateArea("Northern Wellspring Sands", "Sunlands", 2) },
    { 45, CreateArea("Eastern Wellspring Sands", "Sunlands", 2) },
    { 46, CreateArea("Lizardman's Den", "Sunlands", 2) },
    { 47, CreateArea("Black Market", "Sunlands", 2) },
    { 48, CreateArea("Quicksand Caves", "Sunlands", 2) },
    { 49, CreateArea("Marsalim", "Sunlands", 3) },
    { 50, CreateArea("Marsalim Palace", "Sunlands", 3) },
    { 51, CreateArea("Grimsand Road", "Sunlands", 3) },
    { 52, CreateArea("Eastern Marsalim Sands", "Sunlands", 3) },
    { 53, CreateArea("Grimsand Ruins #1", "Sunlands", 3) },
    { 54, CreateArea("Grimsand Ruins #2", "Sunlands", 3) },
    { 55, CreateArea("Marsalim Catacombs", "Sunlands", 3) },
    { 56, CreateArea("Clearbrook", "Riverlands", 1) },
    { 57, CreateArea("Path of Rhiyo", "Riverlands", 1) },
    { 58, CreateArea("South Clearbrook Traverse", "Riverlands", 1) },
    { 59, CreateArea("West Clearbrook Traverse", "Riverlands", 1) },
    { 60, CreateArea("Cave of Rhiyo", "Riverlands", 1) },
    { 61, CreateArea("Twin Falls", "Riverlands", 1) },
    { 62, CreateArea("Saintsbridge", "Riverlands", 2) },
    { 63, CreateArea("Saintsbridge: Upstream", "Riverlands", 2) },
    { 64, CreateArea("Saintsbridge Cathedral", "Riverlands", 2) },
    { 65, CreateArea("Murkwood Trail", "Riverlands", 2) },
    { 66, CreateArea("East Saintsbridge Traverse", "Riverlands", 2) },
    { 67, CreateArea("The Murkwood", "Riverlands", 2) },
    { 68, CreateArea("Rivira Woods", "Riverlands", 2) },
    { 69, CreateArea("Farshore", "Riverlands", 2) },
    { 70, CreateArea("Riverford", "Riverlands", 3) },
    { 71, CreateArea("Manse Gardens, Lower Riverford", "Riverlands", 3) },
    { 72, CreateArea("North Riverford Traverse", "Riverlands", 3) },
    { 73, CreateArea("Hidden Path", "Riverlands", 3) },
    { 74, CreateArea("Lord's Manse", "Riverlands", 3) },
    { 75, CreateArea("Refuge Ruins", "Riverlands", 3) },
    { 76, CreateArea("Atlasdam", "Flatlands", 1) },
    { 77, CreateArea("Atlasdam Palace Gate, Royal Academy of Atlasdam", "Flatlands", 1) },
    { 78, CreateArea("Atlasdam Palace", "Flatlands", 1) },
    { 79, CreateArea("East Atlasdam Flats", "Flatlands", 1) },
    { 80, CreateArea("North Atlasdam Flats", "Flatlands", 1) },
    { 81, CreateArea("Subterranean Study", "Flatlands", 1) },
    { 82, CreateArea("The Whistlewood", "Flatlands", 1) },
    { 83, CreateArea("Noblecourt", "Flatlands", 2) },
    { 84, CreateArea("East Noblecourt", "Flatlands", 2) },
    { 85, CreateArea("Western Noblecourt Flats", "Flatlands", 2) },
    { 86, CreateArea("Orlick's Manse", "Flatlands", 2) },
    { 87, CreateArea("Obsidian Manse", "Flatlands", 2) },
    { 88, CreateArea("The Hollow Throne", "Flatlands", 2) },
    { 89, CreateArea("Wispermill", "Flatlands", 3) },
    { 90, CreateArea("Western Wispermill Flats", "Flatlands", 3) },
    { 91, CreateArea("Ebony Grotto #1", "Flatlands", 3) },
    { 92, CreateArea("Ebony Grotto #2", "Flatlands", 3) },
    { 93, CreateArea("Forest of Purgation", "Flatlands", 3) },
    { 94, CreateArea("Bolderfall", "Clifflands", 1) },
    { 95, CreateArea("Lower Bolderfall", "Clifflands", 1) },
    { 96, CreateArea("Ruvus Manor Gate", "Clifflands", 1) },
    { 97, CreateArea("North Bolderfall Pass", "Clifflands", 1) },
    { 98, CreateArea("South Bolderfall Pass", "Clifflands", 1) },
    { 99, CreateArea("Ravus Manor", "Clifflands", 1) },
    { 100, CreateArea("Carrion Caves", "Clifflands", 1) },
    { 101, CreateArea("Quarrycrest", "Clifflands", 2) },
    { 102, CreateArea("Quarrycrest Mines", "Clifflands", 2) },
    { 103, CreateArea("Road to Morlock's Manse", "Clifflands", 2) },
    { 104, CreateArea("South Quarrycrest Pass", "Clifflands", 2) },
    { 105, CreateArea("Morlock's Manse", "Clifflands", 2) },
    { 106, CreateArea("The Sewers", "Clifflands", 2) },
    { 107, CreateArea("Derelict Mine", "Clifflands", 2) },
    { 108, CreateArea("Orewell", "Clifflands", 3) },
    { 109, CreateArea("Trail to Forest of Rubeh", "Clifflands", 3) },
    { 110, CreateArea("South Orewell Pass", "Clifflands", 3) },
    { 111, CreateArea("Forest of Rubeh #1", "Clifflands", 3) },
    { 112, CreateArea("Forest of Rubeh #2", "Clifflands", 3) },
    { 113, CreateArea("Dragonsong Fane", "Clifflands", 3) },
    { 114, CreateArea("Rippletide", "Coastlands", 1) },
    { 115, CreateArea("Path to the Caves of Maiya", "Coastlands", 1) },
    { 116, CreateArea("North Rippletide Coast", "Coastlands", 1) },
    { 117, CreateArea("East Rippletide Coast", "Coastlands", 1) },
    { 118, CreateArea("Caves of Maiya", "Coastlands", 1) },
    { 119, CreateArea("Undertow Cave", "Coastlands", 1) },
    { 120, CreateArea("Goldshore", "Coastlands", 2) },
    { 121, CreateArea("Goldshore Manor District", "Coastlands", 2) },
    { 122, CreateArea("Goldshore Cathedral", "Coastlands", 2) },
    { 123, CreateArea("Road to the Seaside Grotto", "Coastlands", 2) },
    { 124, CreateArea("Road to the Caves of Azure", "Coastlands", 2) },
    { 125, CreateArea("West Goldshore Coast", "Coastlands", 2) },
    { 126, CreateArea("Moonstruck Coast", "Coastlands", 2) },
    { 127, CreateArea("Seaside Grotto", "Coastlands", 2) },
    { 128, CreateArea("Caves of Azure", "Coastlands", 2) },
    { 129, CreateArea("Captain's Bane", "Coastlands", 2) },
    { 130, CreateArea("Grandport #1", "Coastlands", 3) },
    { 131, CreateArea("Grandport #2", "Coastlands", 3) },
    { 132, CreateArea("Grandport #3", "Coastlands", 3) },
    { 133, CreateArea("West Grandport Coast", "Coastlands", 3) },
    { 134, CreateArea("Grandport Sewers #1", "Coastlands", 3) },
    { 135, CreateArea("Grandport Sewers #2", "Coastlands", 3) },
    { 136, CreateArea("Loch of the Lost King", "Coastlands", 3) },
    { 137, CreateArea("Flamesgrace #1", "Frostlands", 1) },
    { 138, CreateArea("Flamesgrace #2", "Frostlands", 1) },
    { 139, CreateArea("Flamesgrace Church", "Frostlands", 1) },
    { 140, CreateArea("Path to the Cave of Origin", "Frostlands", 1) },
    { 141, CreateArea("Western Flamesgrace Wilds", "Frostlands", 1) },
    { 142, CreateArea("Northern Flamesgrace Wilds", "Frostlands", 1) },
    { 143, CreateArea("Cave of Origin", "Frostlands", 1) },
    { 144, CreateArea("Hoarfrost Grotto", "Frostlands", 1) },
    { 145, CreateArea("Stillsnow", "Frostlands", 2) },
    { 146, CreateArea("Trail to the Whitewood", "Frostlands", 2) },
    { 147, CreateArea("Road to the Obsidian Parlor", "Frostlands", 2) },
    { 148, CreateArea("Western Stillsnow Wilds", "Frostlands", 2) },
    { 149, CreateArea("The Whitewood", "Frostlands", 2) },
    { 150, CreateArea("Secret Path", "Frostlands", 2) },
    { 151, CreateArea("Tomb of the Imperator", "Frostlands", 2) },
    { 152, CreateArea("Northreach", "Frostlands", 3) },
    { 153, CreateArea("Northreach: Lorn Cathedral", "Frostlands", 3) },
    { 154, CreateArea("Southern Northreach Wilds", "Frostlands", 3) },
    { 155, CreateArea("Lorn Cathedral: Cellars", "Frostlands", 3) },
    { 156, CreateArea("Lorn Cathedral: Cellars #2", "Frostlands", 3) },
    { 157, CreateArea("Maw of the Ice Dragon", "Frostlands", 3) },
    { 158, CreateArea("S'warkii", "Woodlands", 1) },
    { 159, CreateArea("Path to the Whisperwood", "Woodlands", 1) },
    { 160, CreateArea("West S'warkii Trail", "Woodlands", 1) },
    { 161, CreateArea("North S'warkii Trail", "Woodlands", 1) },
    { 162, CreateArea("The Whisperwood", "Woodlands", 1) },
    { 163, CreateArea("Path of Beasts", "Woodlands", 1) },
    { 164, CreateArea("Victor's Hollow", "Woodlands", 2) },
    { 165, CreateArea("Victor's Hollow: Arena Gate", "Woodlands", 2) },
    { 166, CreateArea("Victor's Hollow: Arena", "Woodlands", 2) },
    { 167, CreateArea("Path to the Forgotten Grotto", "Woodlands", 2) },
    { 168, CreateArea("East Victor's Hollow Trail", "Woodlands", 2) },
    { 169, CreateArea("Forgotten Grotto", "Woodlands", 2) },
    { 170, CreateArea("Forest of No Return", "Woodlands", 2) },
    { 171, CreateArea("Duskbarrow", "Woodlands", 3) },
    { 172, CreateArea("East Duskbarrow Trail", "Woodlands", 3) },
    { 173, CreateArea("Ruins of Eld #1", "Woodlands", 3) },
    { 174, CreateArea("Ruins of Eld #2", "Woodlands", 3) },
    { 175, CreateArea("Moldering Ruins", "Woodlands", 3) },
    { 179, CreateArea("Shrine of the Flamebearer", "Frostlands", 2) },
    { 180, CreateArea("Shrine of the Sage", "Flatlands", 2) },
    { 181, CreateArea("Shrine of the Trader", "Coastlands", 2) },
    { 182, CreateArea("Shrine of the Thunderblade", "Highlands", 2) },
    { 183, CreateArea("Shrine of the Lady of Grace", "Sunlands", 2) },
    { 184, CreateArea("Shrine of the Healer", "Frostlands", 2) },
    { 185, CreateArea("Shrine of the Prince of Thieves", "Clifflands", 2) },
    { 186, CreateArea("Shrine of the Huntress", "Woodlands", 2) },
    { 187, CreateArea("Shrine of the Starseer", "Flatlands", 3) },
    { 188, CreateArea("Shrine of the Runeblade", "Highlands", 3) },
    { 189, CreateArea("Shrine of the Warbringer", "Riverlands", 3) },
    { 190, CreateArea("Shrine of the Archmagus", "Woodlands", 3) },
    { 193, CreateArea("Obsidian Parlor", "Frostlands", 2) },
    { 194, CreateArea("Ruins of Hornburg", "Highlands", 3) },
    { 195, CreateArea("The Gate of Finis", "Highlands", 3) },
    { 196, CreateArea("Journey's End", "Highlands", 3) },
  };

  settings.Add("enter_exit_area", true, "Enter / Exit Area");
  settings.SetToolTip("enter_exit_area", "Split on entering and/or exiting an area.");

  string[] regions = new string[] { "Frostlands", "Flatlands", "Coastlands", "Highlands", "Sunlands", "Riverlands", "Clifflands", "Woodlands" };
  int[] rings = new int[] { 1, 2, 3 };
  foreach (var region in regions) {
    string regionKey = NameToKey(region);
    settings.Add("enter_exit_area_" + regionKey, true, region, "enter_exit_area");
    foreach (var ring in rings) {
      settings.Add("enter_exit_area_" + regionKey + "_" + ring, true, "Ring " + ring, "enter_exit_area_" + regionKey);
    }
  }

  foreach (var areaInfo in vars.AreaZoneIDs) {
    var area = areaInfo.Value;
    int zoneID = areaInfo.Key;
    string parentKey = "enter_exit_area_" + NameToKey(area.region) + "_" + area.ring; 
    settings.Add("area_"+ zoneID, true, area.name, parentKey);
    settings.Add("enter_" + zoneID, false, "Enter", "area_" + zoneID);
    settings.Add("exit_" + zoneID, false, "Exit", "area_" + zoneID);
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

  settings.Add("encounter_death_counter", false, "Override Text Component with a Enounter / Death Counter.");
}

start
{
  if (timer.CurrentPhase == TimerPhase.NotRunning &&
      old.start == 0 &&
      current.start == 1 &&
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
    return vars.Split("enter_" + current.zoneID);
  }

  // Exit Area
  if (current.zoneID != 0 && current.zoneID != old.zoneID && vars.AreaZoneIDs.ContainsKey(old.zoneID) && (old.gameState == 2 || old.gameState == 4)) {
    return vars.Split("exit_" + old.zoneID);
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

  else if (current.zoneID == 194 && current.money - old.money == 100000) {
    return vars.Split("at_journeys_end");
  }
}