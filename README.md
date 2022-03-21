# Octopath Traveler Autosplitter
## Installation
1. Download [octopath.asl](https://github.com/Eein/octopath-autosplitter/releases/latest/download/octopath.asl)
2. Open Livesplit
3. Edit Layout
  1. Add `Control` > `Scriptable Auto Splitter` component to the layout.
  2. Double Click `Scriptable Auto Splitter` to edit its settings.
  3. Click `Browse`, and open the downloaded `octopath.asl` file.
    - On first load, all the setting are automatically expanded. I recommend pressing `OK` to close settings, and re-opening them. They will no longer be expanded and will be much more managable.
  4. Select desired options for your run!

**Note: The autosplitter is still being updated and must be manually updated until it is more complete. Once its "ready" we'll request a merge into LiveSplit for automatic loading/updates.**

## Usage
Note that you will likely need a different layout for each category, to store different autosplitter settings. Testing needed, and can possibly be improved.

### Options
- Start: Will start the timer on character selection
- Reset: If timer is running, will reset if you hover a character in New Game character selection.
- Split: If timer is running, will split on anything enabled in settings.

### Split Options
*Any option must have ALL of its parent options enabled to work!*
- **Character Story Endings**: Split on end character's final cutscene before Credits
  * The autosplitter doesn't check if the character is the main character! So enable only the main character's option. 
  * Used for any category that ends on credits. Not for use in ASS / Galdera.
- **Character Stories**: Splits for each character stories. 
  * Includes, fights, bosses, chapter endings, and 3%
    - Chapter 4 End is not suitable for ending a main character's run. It's good for end of a character's story in > half game categories. Splits on FIN image.
- **Get Shrines**: Split as you get the Job from the shrine.
- **Advanced Job Fights**: Split after finishing an advanced job fight.
- **Enter / Exit Area:**: Split when you enter or exit an area.
  * Areas are sorted by Region > Ring > Area
- **Split On Characters**: Split shortly after you select no for "hearing their tale". If you say yes to the tale, you will not get a split until you progress through their final cutscenes after their intro boss.
  * Don't enable for your starting character, or it will split at the start.
- **Galdera**: Splits for Galdera
  * Enter Journey's End: Finish Boss Gauntlet, enter next area.
  * Galdera End: Split on Spurning Ribbon / 100k, current Galdera end timing.
- **Credits**: Split on Credits Start
  * This isn't suitable for ending runs.

### Known Issues / Enhancements
 - Group areas by region
 - Would be nice to keep options folded by default
 - Would be nice to disable reset by default
