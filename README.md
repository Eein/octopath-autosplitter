# octopath-autosplitter
## Installation
 1. Download [https://github.com/Eein/octopath-autosplitter/releases/latest/download/octopath.asl](octopath.asl)
 2. Open Livesplit
  - Edit Layout
  - Add `Control` > `Scriptable Auto Splitter` component to the layout.
  - Double Click `Scriptable Auto Splitter` to edit its settings.
  - Select desired options for your run!

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
- **Split On Characters**: Split when you say "Yes" to a character joining you.
  * Don't enable for your starting character, or it will split at the start.
- **Galdera**: Splits for Galdera
  * Enter Journey's End: Finish Boss Gauntlet, enter next area.
  * Galdera End: Split on Spurning Ribbon / 100k, current Galdera end timing.
- **Credits**: Split on Credits Start
  * 

### Known Issues / Enhancements
 - Start isn't perfect, can sometimes be off by < 0.05s. Therion seems to be delayed by more.
 - Group areas by region
 - Would be nice to keep options folded by default
 - Would be nice to disable reset by default