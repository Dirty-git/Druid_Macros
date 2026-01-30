# WoW Macros Setup Guide

## Addons Required for Everything to Function

### For macro syntax
https://github.com/jrc13245/SuperCleveRoidMacros

### For exact debuff tracking and cursive conditional in macros
https://github.com/pepopo978/Cursive

### For /heal /hot command with auto target selection, aggro based precasting etc
https://github.com/Bestoriop/QuickHeal-Turtle-Wow

### For auto downranking of heals via /pfcast
(Outdated but good enough to cast a heal when you don't have enough mana for your min rank)
https://github.com/zmarotrix/SmartHealer

### Auto buff management once set up via /sb
https://github.com/Azzc0/SmartBuff

### Jrc's fork for pfUI for /pfcast and compatibility with SCRM and SuperMacros
https://github.com/jrc13245/pfUI

### 7000 character macro character limit and inline lua functions
https://github.com/jrc13245/SuperMacro-turtle-SuperWoW

### For TTK conditional and Time To Kill calculations
https://github.com/jrc13245/TimeToKill

### For threat conditional and Threat meter
https://github.com/MarcelineVQ/TWThreat

## Mods Required for Full Functionality

### Superwow
https://github.com/pepopo978/SuperwowInstallation

### UnitXP_SP3
https://codeberg.org/konaka/UnitXP_SP3/releases

### Nampower
https://gitea.com/avitasia/nampower

## Miscellaneous Information

I mainly played cat and resto therefore those setups are decently polished. There is a really basic casting macro `{0cast}` and a less polished but functional `{bear}` macro too.

- **QueueScript idol switches** highly depend on your connectivity to the server. It didn't work for me consistently either, but in a perfect scenario it switches your idol when GCD is ready but just before your ability cast, resulting in you equipping the correct idol for the ability without triggering the extra 1.5s GCD.
- **Heal values in heals.md** ignore +heal from items and in-combat cast time caused health deficit, but use crit value with the following formula: `(minheal + maxheal) / 2 * (1 + (critpct * 0.5))`
- **Regrowth values** used 57% crit chance, **Healing Touch** used 7% crit chance for calculations with the formula above.
- **Nampower** has `NP_QueueInstantSpells` disabled, but in some macros I explicitly set if a spell should be queued or not. All of these have significance, for example:
  - `cat.md / {xps}` uses `noqueue` for Reshift to prevent accidental reshift if an energy tick happens when reshift is already queued but the GCD is not ready yet.
- When healing, `NP_QueueCastTimeSpells` needs to be disabled; otherwise nampower will queue heals on your past target or yourself when heal target switching happens in the queue window.
- `{ff}` macro is used for faerie fire application in general, `{ffspread}` is used for fishing for clearcast procs when we are too low on mana to powershift.

## Rotation Guides

### For Cat Rotation
- If you want to go into bleed rotation, hold **Shift** until either Rake or Rip is applied to the target, then you can let go of Shift and the macro will act accordingly.
- If you are just shredding, don't press any extra mods.

### For Bear Rotation
- The idea is to keep enough rage for a Bash if target is casting for a quick bash, then spend the rest on abilities.
- Hold **Shift** to force Swipes for AOE.