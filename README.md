# Octopath Traveler Autosplitter
## Installation
1. Open Livesplit
2. Edit Splits
3. Ensure your game name is "Octopath Traveler"
4. Below you should see an "Activate" and "Settings" button; Click activate, then click settings. That should bring you to a settings pane.

![image](https://user-images.githubusercontent.com/5025835/162367535-edf9a716-d228-483f-ba90-048af10a2181.png)

5. You can select the desired settings for your run in this settings window.

![image](https://user-images.githubusercontent.com/5025835/162367742-ab494dc2-7b1f-4422-851e-ce4bd3f6a4e5.png)

If your splits look live the above, you'd select the following:
1. Character Stories > Opilia Story > Guardian of the First Flame
2. Split on Chracters > Cyrus
3. Character Stories > Cyrus Story > Russell
4. and so on - etc.

You do not need to select these in order, as they will split when the flags happen, so you can select all of the bosses in livesplit you plan to kill. Just remember that each of these are simply triggers so no need to overcomplicate it.

As mentioned below, Chapter 4 End is NOT the final split for Single story runs. You will need to select:
- Character Story Endings > <Your Character> Story Ending

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
