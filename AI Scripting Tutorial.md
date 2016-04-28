This tutorial explains, how to create or modify an AI script for YGOPro. The first few sections are tailored towards beginners, while the later sections cover a little more in-depth stuff, as well as how to integrate your own deck into the standard AI. Prerequisites are rudimentary knowledge of Lua and/or programming languages in general, and a lot of patience. AI scripting isn't exactly user-friendly :D

###Table of Contents###

1. Generic Information  
2. Getting Started  
3. Breakdown of the ai-template.lua  
4. Making our first AI  
5. Custom Functions  
6. Common problems  
7. Card script assistance  
8. Adding new decks to the existing AI  
9. Fin  

###1) Generic information###

You can play a game against the YGOPro AI by starting YGOPro, then selecting the "AI Mode (beta)" button. You can modify some rulings and duel settings in the following screen, then press "OK". Now you can select a deck and a script file for the AI to use. The deck has to be located in your "deck" folder of YGOPro, the script file sits in the "ai" subfolder. By default, you can use 3 ai files: 

"ai.lua", the standard AI file  
"ai-cheating.lua", the same as "ai.lua", except the AI gets some benefits  
"ai-exodialib.lua", an AI file to be used with the AI_Exodia deck. As of the AI script version 0.26, this file is obsolete and can be deleted, the standard AI file handles the Exodia deck from now on.

In theory, the AI can use any deck you make for it. However, if any card is not specifically scripted into the AI, it will usually just be activated whenever possible. Target selection for effects will be random, so the AI will usually search or target the wrong cards with its effects.

That is why there are specific decks scripted into the ai file. These decks are prefixed with the "AI_" prefix to indicate, that the AI can use them. You may also select the "Random Deck" option, the AI will then use a random "AI_"- prefixed deck. It is possible to rename or remove AI decks, so the random deck option does not use those decks.

Just like the Yugioh cards, the ai files are scripted in Lua, a fairly common scripting language: http://www.lua.org/about.html

This tutorial does have a couple of seemingly redundant chapters, the same functionality is coded in multiple different ways. The first few chapters show you, how to use the basic AI functions by themselves, later chapters incorporate custom functions I added to make my life easier. Using them can result in much shorter code, and they handle a lot of problems internally already. However, they also impose some limitations, and they might not always be useful for your specific problems. That is why I try to explain their inner workings and also give you a rundown of how to script their functionality in "raw" AI script.

If you are not interested in the inner workings of these AI functions, or if you are already familiar with them, feel free to skip ahead to Chapter 5: Custom Functions. If you already have a working AI script, and only want to know, how to integrate your own deck into the standard AI script, Chapter 8: Adding new decks to the existing AI is the place for you.

###2) Getting started###

If you want to get into AI scripting, the first thing I would recommend is taking a look at the "ai-template.lua" file in your "ai" folder. It does not show up when you select the AI to play against, since it is only relevant for developing. You can read and edit .lua files in any common text editor. I personally use Notepad++: http://notepad-plus-plus.org/  
There are other programs, like LuaEdit, but that is quite outdated and crashes on my system. If you have programming experience yourself, you may of course use the IDE of your choice, as long as it supports Lua.

The template holds most of the important functions you can use to modify the AI's behavior. It also has comments and notes about how to use these functions. More about that in the detailed breakdown of the ai-template.lua

For scripting AI files, it is always recommended to have some sort of syntax check to eliminate some errors before testing the script. If your IDE supports this already, great.  
For my Notepad++, I use [this](http://www.mediafire.com/download/qd4po92yddy48rr/Notepad%2B%2B+Syntax+Check.rar) file.   
Follow the instructions in the readme to add a syntax check to your Notepad++.


###3) Breakdown of the ai-template.lua###

In my opinion, the best starting point to get into AI scripting is a file called "ai-template.lua". It is located in the "ai" subfolder of your YGOPro folder, and it is kind of the most basic of AIs you can get. It is a fully working AI file by itself, it is well documented and holds most of the available AI functions you can use. 


So, we will open up this file, and have a look at it. Starting at the top, we have a ton of comments, including version info, changelogs, some useful tips. After the tips, we have a list of available AI functions you can call at any time: 

    AI.Chat(text) --text: a string

This function makes the AI say things. You can use this for information, debugging, taunts, insults or whatever you want the AI to say.

    AI.GetPlayerLP(player) --1 = AI, 2 = the player

Returns the current LP of the player.

    AI.GetCurrentPhase() --Refer to /script/constant.lua for a list of valid phases

The "constant.lua" file in the script subfolder is referred to on a regular basis, so open that as well and look for the phases. They are prefixed with PHASE_ , for example PHASE_MAIN2 or PHASE_BATTLE.  
You can use this function and compare it to the current phase like this:
  
    If AI.GetCurrentPhase()==PHASE_BATTLE then -- do stuff in the Battle Phase 

    AI.GetOppMonsterZones()
    AI.GetAIMonsterZones()
    AI.GetOppSpellTrapZones()
    AI.GetAISpellTrapZones()
    AI.GetOppGraveyard()
    AI.GetAIGraveyard()
    AI.GetOppBanished()
    AI.GetAIBanished()
    AI.GetOppHand()
    AI.GetAIHand()
    AI.GetOppExtraDeck()
    AI.GetAIExtraDeck()
    AI.GetOppMainDeck()
    AI.GetAIMainDeck()

All the cards you ever wanted. Pretty self explanatory, these return a list of all the cards located in the specified location. If there are no cards in a location, it will return a list filled with nil entrys. Usage example in the template.

Now comes the first line of actual script in the template:

    math.randomseed( require("os").time() )

This line is mandatory. I do not know exactly, what it does, it probably sets up the random seed and syncs it with the system time. Just include this line into your AI file, it is important.

Next up:

    function OnStartOfDuel()	
      ...
    end

This function is called by the system automatically at the start of each duel. In the template, it uses the AI.Chat() function to display some information.


Following are a bunch of functions provided by the system, designed to give you an interface to regulate decisions the AI has to make. These include:

    OnSelectOption
    OnSelectEffectYesNo
    OnSelectYesNo
    OnSelectPosition
    OnSelectTribute
    OnDeclareMonsterType
    OnDeclareAttribute
    OnDeclareCard
    OnSelectNumber
    OnSelectChain
    OnSelectSum
    OnSelectCard
    OnSelectBattleCommand
    OnSelectInitCommand

Each of these functions are called by the system, whenever a situation occurs, where the AI has to take a choice of some sort. Most of them are pretty self-explanatory, or explained in the comments of the template. I will go over the important ones later.

Right before the OnSelectInitCommand function, you get a list of a whole bunch of card functions. 

    card.id
    card.original_id
    card.cardid
    card.description 
    card.type 
    card.attack
    card.defense
    card.base_attack
    card.base_defense
    card.level
    card.base_level
    card.rank
    card.race 
    card.attribute
    card.position
    card.setcode 
    card.location
    card.xyz_material_count
    card.xyz_materials
    card.owner
    card.status
    card:is_affected_by(effect_type)
    card:get_counter(counter_type)
    card.previous_location 
    card.summon_type
    card.lscale
    card.rscale
    card.equip_count
    card:is_affectable_by_chain(index)
    card:can_be_targeted_by_chain(index)
    card:get_equipped_cards()
    card:get_equip_target()
    card.text_attack
    card.text_defense

Most of them should be pretty obvious again, the others are explained in the comments. If you have a card object, you have access to all kinds of information using these.


###4) Making our first AI###

Great, now we have looked at the template. But what now? How can we make an actual AI out of this?

In this paragraph, we will create a new AI file. We will learn, how the cards are handled by the AI script, and how we can use the available functions to modify the behavior, on a basic level. Do note, that the end result will be quite a mess, and not very comfortable to work with. It is meant to demonstrate, how the AI works internally. If you're already familiar with how the AI functions, you can check out the next chapter for a more user-friendly approach using some custom functions, which are way more comfortable to use.

First, we will make a copy of the ai-template.lua and rename it. For this tutorial, we will name it "ai-tutorial.lua". Feel free to clean it up a bit, you don't really need to keep all the comments, you can always read them up in the original template. I took the liberty of preparing a cleaned up version of the file, you can download it [here](https://www.dropbox.com/s/202usn80ow63zqq/ai-tutorial-1.lua). Note, that you can already play using this file. As long as it is still in the "ai" folder and is not named "ai-template.lua", it should be available. If you try it out and give the AI some random deck, you will notice, the AI will misplay a LOT, it will just activate every single card whenever possible, even blowing up its own cards in the process.

So, how do we improve on that? For this example, we will use "Breaker the Magical Warrior". I am pretty sure, you are all familiar with his effect, he can use 1 Spell Counter to blow up a Spell or Trap on the field. Lets make a test deck to see, how our AI handles him. The deck should consist of Breaker, 1 spell card that does stay on the field or cannot be activated (say Swords of Revealing Light), and a bunch of unusable filler cards. I like to use /Assault Mode monsters for this, but it can be any card, that cannot be summoned or used from the hand by itself. [This](https://www.dropbox.com/s/80x341fjevnh3kf/TestAI.ydk) would be a test deck like this. Start a game, make sure to check the "don't shuffle" check-box (and "don't check deck" if you use an invalid test deck yourself), select the tutorial AI file and the test deck for the AI player. Now you will already see the problem: The AI activates Swords, and destroys them with its own Breaker. Since the AI's own S/T are valid targets for his effect, Breaker can be activated, so the AI will do it. How do we keep him from doing that?

The summoning and activation of Breaker is handled in the "OnSelectInitCommand" function. OnSelectInit is always called, if the AI can perform actions in its of Main Phase, it handles all kinds of things, from normal- and special summoning or setting monsters over activating spells and ignition effects to setting trap cards and entering the next phase. Breaker is an ignition effect, which can only be activated in the main phase, so it is handled here.

In particular, this bit here handles the activation of Breaker:

    if #cards.activatable_cards > 0 then
      return COMMAND_ACTIVATE,1
    end

cards.activatable_cards is a list of all cards, that can be activated at the moment. The "#" counts all the cards in the list. The return expects a COMMAND constant and an index. You can look up the constants in the template, the index is always the position of the activated card in the list. Since this function just activates everything, we can just return 1, since that will always activate the first card in the list. To clarify, this function basically reads "If the count of cards in the list of activatable cards is bigger than 0, activate the first card in the list, otherwise do nothing".

Do note, that a single call of OnSelectInit only ever performs a single action. If an activate command is returned, that card will be activated, then, after all chains have resolved, OnSelectInit is called again, with a new list of activatable cards.

So, how do we handle Breaker now? First, we will have to limit the AI from using him at will, we want to define the terms of his usage. So we will need to change the activate function to not activate everything always, but to make an exception for Breaker. For this, we will loop all activatable cards, and activate them only, if they are not Breaker.

So we change this:

    if #cards.activatable_cards > 0 then
      return COMMAND_ACTIVATE,1
    end

to that:

    for i=1,#cards.activatable_cards do 
      local c = cards.activatable_cards[i]
      if c.id ~= 71413901 then -- Breaker
        return COMMAND_ACTIVATE,i
      end
    end

71413901 is Breaker's ID, the unique number associated with the card. We will be using these IDs a lot, they are the way to differentiate the cards in the script. Be careful, it is very easy to mess up an ID in the script. Now what does this do? This is a standard for-loop in lua, this will loop through all activatable cards, and only if the card doesn't have Breaker's ID (~= means "not equal" in lua), it will be activated. So now, Breaker will never be activated, ever.

Since that is not exactly what we want, we need to add some sort of condition, that will allow Breaker to be activated. What would make sense here? Probably activate Breaker, if the player controls at least 1 Spell or Trap card.

So we can modify our activations to:

    for i=1,#cards.activatable_cards do 
      local c = cards.activatable_cards[i]
      if c.id == 71413901 then -- Breaker
        for j=1,#AI.GetOppSpellTrapZones() do
          if AI.GetOppSpellTrapZones()[j] then
            return COMMAND_ACTIVATE,i
          end
        end
      end
      if c.id ~= 71413901 then
        return COMMAND_ACTIVATE,i
      end
    end

AI.GetOppSpellTrapZones() is one of the functions mentioned in the template, it returns a list of all of the opponent's Spell&Trap zones. However, we also need to check, if these zones actually holds any cards. This means looping through those as well. If a zone is not occupied, it will be false, otherwise it holds a card. So why aren't we just using the "#" here? Problem is, it counts the empty S&T zones as well, so the count for AI.GetOppSpellTrapZones() will almost always be 8. (5 S/T, 2 Pendulum, 1 field spell).

So this reads as "if the activatable card is Breaker, and if a card exists in the opponent's Spell&Trap zones, activate the card", and then still "if the activatable card is not breaker, activate"

Now go ahead and test. Breaker shouldn't activate its effect, unless you control a spell yourself. However, if you do, you will notice the next problem: Breaker might hold back on his effect activation, but when he activates, he still destroys the AI's own spell! So how do we fix that problem?

The selection of targets for most effects is handled in the OnSelectCard function. Currently, it looks like this:

    function OnSelectCard(cards, minTargets, maxTargets, triggeringID, triggeringCard)
      local result = {}
        for i=1,minTargets do
          result[i]=i
        end
      return result
    end

You will notice, it has a bunch of parameters, which can be useful. "cards" is a list of cards, that can be selected as targets. minTargets and maxTargets define the amount of targets you need to select. triggeringID and triggerinCard point to the card, that activated the effect for which you select the targets right now.

To select the correct target for Breaker, we will modify the function like this:

    local result = {}
    if triggeringID == 71413901 then -- Breaker
      for i=1,#cards do
        if cards[i].owner == 2 then
          return {i}
        end
      end
    end
    for i=1,minTargets do
      result[i]=i
    end
    return result


So we are comparing the triggering ID to Breaker, and if it matches, we loop through all available targets, and return the first one, that belongs to the opponent. Do note, that the return has to be a list of indexes, not an index, since some cards require multiple targets. So you cannot return i here, you have to return {i}. The game will crash otherwise!

Now try it out. Breaker should only hit the opponent's cards now. [This](https://www.dropbox.com/s/dxwk1c6cs3pmf3v/ai-tutorial-2.lua) is how your AI does look like now. Do note, that this is a very verbose way of doing things. If you add hundreds of cards to the AI, you'll probably want to make some functions that help you keeping things short and organized, so you don't have to write out new loops for every single card etc. I will give a brief overview over the functions I made to help with this later in the tutorial.

We covered the basics of 2 very important aspects now: Handling of OnSelectInitCommand and OnSelectCard. Next up: OnSelectChain and OnSelectEffectYesNo. Those 2 handle the activation of most chainable cards and effects, and they work essentially the same way, even if their handling is quite different. OnSelectChain has a list of chainable cards, similar to OnSelectInit, and it will be called, whenever any card could be chained. OnSelectEffectYesNo usually triggers for specific trigger events, that allow only 1 card to be activated. 

Many chainable cards or effects can be handled by either function, depending on the board state. For example, lets say the AI controls a Thunder King Rai-Oh, and your opponent special summons a monster. Now OnSelectEffectYesNo will trigger and handle the question "Activate the effect of TKRO to negate the summon?". The human player would get a dialog box in this situation. However, if you control a Black Horn of Heaven as well, instead of a dialog box, you would get the option to chain either of these cards/effects. So in this case, the AI would handle the activation of these cards in OnSelectChain and not OnSelectEffectYesNo. Note, that this is just an example, TKRO is actually not handled by OnSelectEffectYesNo at all. But you get the idea, this is definitely the case for some cards.

So, what does this mean for us? Generally, we have to add all effects, that can be handled by either function to both functions. Some cards can never be handled by one of the functions, that makes things easier, but unless you know exactly, if a card will be handled only by one, it is recommended to add it to both functions.

Lets take the mentioned TKRO as an example. How does he work with our current test AI? As you might expect, he will just chain his negation to every single special summon we perform. If you set up a test deck like before, where the AI's only usable card is TKRO, and in a test duel you let your opponent summon him and then special summon a weak monster, lets say Jester Confit, the AI will still chain its effect, despite Jester Confit having 0 ATK and DEF and generally being not a thread at all.

How do we improve on that? First, we take a look at our relevant functions:

    function OnSelectEffectYesNo(id, triggeringCard)
      return 1 -- this means always returns yes
    end

    function OnSelectChain(cards, only_chains_by_player, forced)
      return 1,1 -- this always chains the first possible card
    end

They look simple enough. Now, we have to make sure, they don't always activate for TKRO, so we will add exceptions, just like before:

    function OnSelectEffectYesNo(id, triggeringCard)
      if id == 71564252 then -- TKRO
        return 0 
      end
      return 1
    end

    function OnSelectChain(cards, only_chains_by_player, forced)
      for i=1,#cards do
        local c = cards[i]
        if c.id ~= 71564252 then -- TKRO
          return 1,i
        end
      end
      return 0,0
    end

This does look quite different for both functions, because YesNo is only called in a specific situation and one specific card, so you can just check, if that card is TKRO, then return no, and if it is not, let the function return yes as usual. Chain is more complicated, as it holds a list of cards. YOu want to loop through the cards, chain anything that is not TKRO, and if no card other than TKRO remains, don't chain anything further. Try it out, with these changes TKRO shouldn't activate at all anymore.

Alright. Now, when do we want him to activate at all? This is quite a tricky question, but for now, we'll go with a pretty simple solution: Negate the summon, if the summoned monster could destroy TKRO in battle. Now, how do we do that? Unfortunately, we don't have direct access to the monster TKRO would destroy with its effect, so we have to get a little creative here. In YGOPro, monsters currently summoning have a certain status, the STATUS_SUMMONING. This status is only activae during the summon negation window, where TKRO can be activated, and we can check for that. So what do we do? Looping, of course. We loop all available monsters of the opponent and check for the status:

    for i=1,#AI.GetOppMonsterZones() do
      local c = AI.GetOppMonsterZones()[i]
      if c and bit32.band(c.status,STATUS_SUMMONING)>0 then
        --c is our summoned monster
      end
    end

The bit32.band stuff is necessary, because the card may have multiple statuses, so checking c.status==STATUS_SUMMONING might be false, because its actual status might be STATUS_SUMMONING+STATUS_SOMETHING_ELSE. bit32.band performs a bitwise and operation and can separate the status this way. Do note, that it returns a number and not true or false. 0 means it doesn't have the status , >0 has the status.

Now that we have our summoned monster, we can check for its stats and decide, if TKRO should be activated or not. We will do this in a separate function for easier handling, lets call it ChainTKRO() and place it anywhere in the script, outside of the other functions:

    function ChainTKRO()
      for i=1,#AI.GetOppMonsterZones() do
        local c = AI.GetOppMonsterZones()[i]
        if c and bit32.band(c.status,STATUS_SUMMONING)>0 then
          if c.attack>=1900 then 
            return true
          end
        end
      end
      return false
    end

This function is pretty neat, we can call it from anywhere, and it will return true, if any currently special summoned monster is stronger than 1900 ATK, and false, if the monster is weaker, or if no monster with the summon status exists. This allows us to use it in both Chain and EffectYesNo without having to add the checks for the summoning to both functions explicitly:

    function ChainTKRO()
      for i=1,#AI.GetOppMonsterZones() do
        local c = AI.GetOppMonsterZones()[i]
        if c and bit32.band(c.status,STATUS_SUMMONING)>0 then
          if c.attack>=1900 then 
            return true
          end
        end
      end
      return false
    end

    function OnSelectEffectYesNo(id, triggeringCard)
      if id == 71564252 then -- TKRO
        if ChainTKRO() then
          return 1
        else
          return 0
        end
      end
      return 1
    end

    function OnSelectChain(cards, only_chains_by_player, forced)
      for i=1,#cards do
        local c = cards[i]
        if c.id == 71564252 and ChainTKRO() then -- TKRO
          return 1,i
        end
        if c.id ~= 71564252 then 
          return 1,i
        end
      end
      return 0,0
    end
 
Try it out. Let your opponent summon TKRO, then special summon a weak monster, then try a stronger one (Photon Thrasher maybe). For reference, your AI would now look somewhat like [this](https://www.dropbox.com/s/f0xj1hpcxm7ow5n/ai-tutorial-3.lua?dl=0).

I personally like to use separate functions like these for almost every card, and not only for chains. I'll have SummonX(), ActivateX(), ChainX() etc etc all for the same card.

Alright, that should do it for our very first AI. These are only the very basics, but we learned a little about how to handle the OnSelectInitCommand, OnSelectCard, OnSelectEffectYesNo and OnSelectChain functions. These are by far the most important ones, I guess about 80% of the entire AI is just handling of these functions. The basic principle is always the same, a lot of looping, checking specific conditions, returning the correct index.

###5) Custom Functions###

In the last paragraph, we added 2 cards to the AI, which it can handle a little better now. Great, only 8,829 to go :D  
On a serious note, adding lots of cards or a complete deck to YGOPro is a lot of work, so you do want to find some ways to optimize this procedure. Also, the 2 cards we added are not exactly used very well yet. Breaker targets random cards, he might blow his effect on an indestructible card, or kill an orphan Call of the Haunted without a target over a much more threatening Macro Cosmos. TKRO might let the special summon of a dangerous effect monster go through, because its attack is just low enough.

To improve on the handling of newly added cards and the speed these can be added without having to add hundreds of checks for every card, a couple of useful custom functions developed over time, while I proceeded scripting the AI.

A fair bit of warning: Keep in mind, that I am not a professional programmer and I am not very familiar with Lua, I didn't know it at all when I started scripting for the AI. So most of these functions could probably be improved upon, or they do not conform usual programming standards.

Also, do note, that any of the custom functions you use here will not be available in your custom AIs you built earlier, at least not without adding them to the AI via a requirement. Adding the following line:

require("ai.ai")

to your ai-tutorial.lua should enable you to use most of these functions. This links to the standard AI file, which in turn requires all the other files in their respective folders, holding the functions. Additionally, this allows you to skip some functions and let the default AI handle it. Don't want to write your own attack logic? Just delete OnSelectBattleCommand from your tutorial AI, and the standard AI attack logic should take over.

**Shorter variables/functions**

Stuff you use a LOT should probably be short, so you don't have to write a whole lot. AIMon() is a shortened version of AI.GetAIMonsterZones() with all empty zones filtered out already, which makes it a lot easier to handle for most practical applications. Similar functions exist in OppMon(), AIGrave(), AIHand() etc ect. I will list an API of useful custom functions later in the tutorial.

Other examples include storing stuff like cards.activatable_cards etc in shorter variables, like cards.activatable_cards => Act cards.summonable_cards => Sum, SpSum, ... you get the idea.

**HasID**

Probably the function I use the most: The HasID function is a very basic looping function. It takes a list of cards and an ID, loops through the cards and returns true, if the ID is among them. It also sets a global variable, the GlobalIndex, which can be used to return the correct index.

So instead of:

    for i=1,#cards do
      local c = cards()[i]
      if c.id == 71564252 and ChainTKRO() then
        return 1,i
      end
    end

I can do this:

    if HasID(cards,71564252) and ChainTKRO() then
      return 1,CurrentIndex
    end

It has a bunch of other parameters, most of which I added at some point to solve a very specific problem. But the basic function can be used with 2 parameters only.

Warning: Careful when using HasID again before actually using the CurrentIndex global, it will override the index. If you want to use it to check for other cards on the field and still need the global index, use it with the 3rd parameter as true, which will make it skip the global index:

    if HasID(cards,71564252) and not HasID(AIMon(),71564252) then -- Don't do that!

A reasonable check for a summoning condition, only summon TKRO if you don't already have one. However, this will produce errors, probably even crashes. You need to do it this way:

    if HasID(cards,71564252) and not HasID(AIMon(),71564252[h],true[/h]) then -- That is better

There is also HasIDNotNegated, which does the same thing + a negation check, so cards don't attempt to activate their effects if they are negated.

**BestTargets**

An attempt to generalize removal effects and make them aware of as many things as possible, that might prevent them from working. BestTargets takes a list of cards, a count and a custom constant, defining, what kind of effect it is currently used with. It assigns priorities to the targets, based on type, position, location, stats, the effect type, and the kinds of protection effects the targets are affected by. It also checks for blacklists, some cards just shouldn't be targeted or affected by certain card effects. By default, it assumes a destruction effect, but you can pass the following constants:

    TARGET_OTHER
    TARGET_DESTROY
    TARGET_TOGRAVE
    TARGET_BANISH
    TARGET_TOHAND
    TARGET_TODECK
    TARGET_FACEDOWN
    TARGET_CONTROL -- as in Snatch Steal
    TARGET_BATTLE -- redirects to battle target logic
    TARGET_DISCARD
    TARGET_PROTECT -- this can be any beneficial effect

It returns a list of indexes based on the card list input, so it is designed to work in OnSelectCard, obviously. For the example of Breaker, it would look like this:

    function OnSelectCard(cards, minTargets, maxTargets, triggeringID, triggeringCard)
    if id == 71413901 then -- Breaker
      return BestTargets(cards) -- or BestTargets(cards,1,TARGET_DESTROY)
....

For a basic destruction effect with a single target, you only need to pass the card list, the count defaults to 1, and the target constant defaults to destroy, making it very easy to use for Breaker. And it will automatically handle stuff like destruction immune cards or cards that probably shouldn't be targeted, if known (like Artifacts). However, it only handles target selection, if there are only bad targets to choose from, it will still pick one. You'll need an additional check in OnSelectInit to prevent the activation, if no favourable targets to destroy exist.

**Add**

Another attempt at generalizing card target selection, this time for all kinds of search effects. However this one comes with a catch: The priority system. To see what I mean, take a look at the "AIOnDeckSelect" file in the "mods" subfolder of the AI. See that huge, intimidating bunch of numbers? Yeah, that is, what you will have to use to make use of the Add function. 

This system has developed over quite a couple of versions. Its probably way too bloated for any serious programmer, and there are most likely better ways to approach this, but it has been working out for me so far. Every row represents a card, while all the number columns are priority values. The last column is a condition function, which can be nil. The columns represent the location, the card would end up in. The first column is the hand, third the field, 5th grave, 7th varies and number 9 is banish. If there is a condition function, the 2nd,4th etc functions are for the same locations, for the case that the condition fails. So, if you have a condition, and the card is going to the hand, check the condition. Is the condition true? Return first column. False? Return 2nd instead. If no condition is defined, it will always return the first column.

So to add a card, you will need to think, how this card is being used. Do you want it in the hand a lot? Then the first column should probably be high (I use values from 1 to 10 mostly). Do you need it in the grave? 5th column for that. Do you only want it in hand, if you have another card already? High in 1, low in 2, and make a condition, that returns true, if you have the other card.

This sounds horribly complicated, how does that help us and why do we need it? Well, many archetypes have tons and tons of search effects these days. If you want to code all of them specifically, you would have a lot of repetition, tons of loops checking for specific cards to find. If you did set up a priority for all cards in your deck, and you defined proper conditions etc ect, you can use the Add function for all your search effects now.

    if id == 32807846 then -- RotA
      return Add(cards) -- or Add(cards,PRIO_TOHAND,1)
....

You can pass a bunch of custom constants again:

    PRIO_TOHAND
    PRIO_TOFIELD
    PRIO_TOGRAVE
    PRIO_DISCARD=PRIO_TODECK=PRIO_EXTRA
    PRIO_BANISH

The 4th one depends on the deck I am using it in. For Mermails or Dark World, I handle discards with it (since discarding or sending from hand to grave makes a huge difference here). Others use it for shuffling their cards back to the deck, with Daigusto Emeral for example, or Satellarknight Sirius.

Now, if your priorities and conditions are defined properly, you can use Add for all kinds of functions, that search or use your own cards somehow. Summon a chaos monster? Add(cards,PRIO_BANISH) to banish cards from the grave that like to be banished. Foolish? Add(cards,PRIO_TOGRAVE) to send the card that works best in the grave. However, this can become increasingly difficult, especially for combo decks. Just take a look at the Noble Knight condition functions at the top of the NobleKnight.lua file. Its a mess :)


You will need to use the AddPriority() function at the start of the duel to setup your priorities.


**CardsMatchingFilter**

Another simple looping function, that takes a group and a filter, and returns, how many cards in that group match the filter. A filter can be any function, that takes a card and returns a boolean, for example:

    function FilterLevel4(c)
      return c.level==4
    end
    local count = CardsMatchingFilter(cards,FilterLevel4) -- counts all Level 4 monsters in cards

Many of my custom functions support optional filters, and most of them can pass an additional optional argument for filters with 2 arguments. This allows the use of some generic filters, like this:
    local count = CardsMatchingFilter(cards,FilterType,TYPE_MONSTER) -- counts all monsters in cards

FilterType is a filter with 2 arguments, it compares the passed type with the type of the cards. There are others like FilterRace, FilterAttribute, FilterPosition, FilterLocation etc ect to use like this. The functions previously mentioned all have the option to add filters as well, like HasID, Add, BestTargets, although you have to be careful about their respective positioning. See the upcoming API list for the correct order of parameters.

**FieldCheck**

An easy way to check, how many cards of a specific level the AI controls, mostly used for XYZ summon checks. FieldCheck(4) returns the count of all Level 4 monsters the AI currently controls. This function supports a filter as well, FieldCheck(4,FilterRace,RACE_WINDBEAST) returns the count of all Level 4 Winged-Beast type monsters the AI controls.

**DestroyCheck**

Remember Breaker? Remember when I said, that we need an additional activation check to not activate this card, when the opponent only controls cards we don't want to destroy? This it what DestroyCheck is for. It loops a card list and returns the count of viable targets to destroy. So Breaker's activation check can look like this:

    function UseBreaker()
      return DestroyCheck(OppST())>0
    end

    if HasID(Act,71413901) and UseBreaker() then
      return COMMAND_ACTIVATE,CurrentIndex
    end

**Affected and Targetable**
There are lots of monsters, that are protected from targeting or unaffected by certain cards. These are very hard to detect, as there is no difference in AI script between a card unaffected by all card effects, or just unaffected by spells+traps (Forbidden Lance, for example). Also some cards are not untargetable, but can negate targeted effects and punish you for targeting them. 

Affected takes the card to check, a type and a level/rank, it checks for Qliphort's monster effect immunity and for stuff like Forbidden Lance. However, these will not be 100% accurate, for example the Forbidden Lance only checks for the unaffected "buff" and an attack drop. It cannot reliably check, if those are actually caused by Forbidden Lance. Targetable takes the card and a type.

So for something like PWWB, you want to check the targets like this:

    if Targetable(c,TYPE_TRAP) and Affected(c,TYPE_TRAP) then
      return true
      
For Castel, you use this instead:

    if Targetable(c,TYPE_MONSTER) and Affected(c,TYPE_MONSTER,4) then
      return true

More functions to come. Currently thinking about, which ones are important enough to mention here.


###6) Common problems###

There are a lot of things, that can be problematic, when coding an AI. I will try to go over some of the problems I encountered, and how to solve them or work around them.

**The indexing system**

The YGOPro AI uses a complex system of card lists and indexes, where a lot of functions provide card lists for you to use and require you to return the correct index. One problem, that is hard to grasp at first would be, that this makes cards not compatible with each other, even if they technically point to the same card.

For example, you have a card, that can target all opponent's monsters, and provides a "cards" list of targets for OnSelectCard. Now you can call OppMon() in OnSelectCard as well, which, in theory, provides a list of the exact same monsters. However, the cards in both lists will be different, you cannot compare them in the script by just doing something like if cards[i]==OppMon[i]. Even if those point to the same card, this will return false. However, there is a card property named card.cardid, which provides a unique ID for every card used in the duel. So you can use this to compare 2 cards from different lists, that point to the same card, for our example: if cards[i].cardid == OppMon[i].cardid

The index is another story. Many functions require you to return an index. This index is based on the original position of the card in the list provided by the function. Many of my custom functions actually change the order of the cards in the list, sort them by attack or priorities etc. If you ever do this, make sure to either copy the list before, so you still have access to the original index, or you store the index somehow. I usually just store the index in an additional field, card.index=i. Additional fields like these are temporary, they will only exist within the current list of cards. If the same card shows up in a different list again, any fields added like this will be gone. But since we only need the index with the current list anyway, thats perfect.

**Multiple effects on the same card**

If a card can activate multiple effects at the same time, it will show up multiple times in the activatable list in OnSelectInit or in cards in OnSelectChain respectively. A common example is Lavalval Chain. Both the dump and the stack effect will show up in the activatable cards list as separate "cards" if you will. If that is the case, the cards will have a "description" property to differentiate them.For Lavalval Chain, this description is 545382497 for the dump or 545382498 for the stack. 

So how do we use that? You can either check for it in a loop:

    for i=1,#cards do
     local c = cards[i]
     if c.id == 34086406 and c.description == 545382497 then --Lavalval Chain Dump Effect
     if c.id == 34086406 and c.description == 545382498 then --Lavalval Chain Stack Effect

Or you use the 4th parameter of HasID:

    if HasID(cards,34086406,nil,545382497) then --Lavalval Chain Dump Effect

To find out, which description ID your card uses, you can use the "print" function:
    
    for i=1,#cards do
      local c = cards[i]
      if c.id == 34086406 then
        print (c.description)
      end
    end

If the AI controls a single Lavalval Chain and can activate both effects, this should print:
545382497
545382498

**Multiple target selections for the same card**

Some cards do trigger OnSelectCard a couple of times with different effects, or even for the same effect. Especially XYZ monsters need to almost always target an XYZ material first, before they can select a target on the field.

So, how do we handle that? OnSelectCard only provides the id of the card that triggered it, it doesn't have any information about the effect currently being used. If I cannot handle the card selection in one line, I usually make a separate function out of it. For our example Lavalval Chain we have both issues, since it has 2 different effects and is an XYZ monster. I mostly use 2 methods to determine the correct target selection: Checking the available targets for perks unique to that effect, or setting up a global variable before. 

We can make a function like this:

    function LavalvalChainTarget(cards)
      if LocCheck(cards,LOCATION_OVERLAY) then -- check if the first available target is currently an xyz material.
        return Add(cards,PRIO_TOGRAVE) -- detach XYZ material
      end
      if GlobalCardMode==1 then -- global variable to indicate the kind of effect used
        GlobalCardMode = nil -- always reset the global
        return Add(cards)
      end
      return Add(cards,PRIO_TOGRAVE)
    end
    function OnSelectCard(cards,...
      if id == 34086406 then
        return LavalvalChainTarget(cards)
      end
    ...
    
LocCheck is another custom function, it checks the location of the first target, like this:  bit32.band(cards[1].location,LOCATION_OVERLAY)>0

    We also need to set up the global variable before activating the effect:
    if HasID(cards,34086406,nil,545382497) then --Lavalval Chain Dump Effect
      return COMMAND_ACTIVATE,CurrentIndex
    end
    if HasID(cards,34086406,nil,545382498) then --Lavalval Chain Stack Effect
      GlobalCardMode = 1 -- set global variable to 1 to indicate, that the stack effect is used
      return COMMAND_ACTIVATE,CurrentIndex
    end

Why do we use both LocCheck and a global variable here? Well, we can correctly identify the detach target selection. If the target is an XYZ material, its obviously the detach. But for the other 2 selections, we don't have an easy way to find out, which effect is used currently just based on the target cards. For both effects, the targets are in the deck, we cannot check the destination, where the effect would send them. We could check for spell cards, as the stack only targets monsters while the dump can also target spells&traps, but this check might fail for pure monster decks or late game, if all S/T have been drawn. So to identify this effect correctly, we need the global variable, at least I think so.

Will add more problems as I remember them.

###7) Card Script assistance###

Some of you might be familiar with scripting cards for YGOPro. There are tons of card script functions available, that provide information or functionality otherwise not available to the AI. This is mainly useful in the battle phase, to determine current attacker and attack target, or for chainable effects to get information about the current chain and respond accordingly.

**Detection of removal effects**

This can be useful for cards, that offer protection against removal effects, or just to chain cards, that are about to be removed. You can achieve this by using a function called Duel.GetOperationInfo, like this:

    local ex,cg = Duel.GetOperationInfo(Duel.GetCurrentChain(),CATEGORY_DESTROY)
    if ex then
      return cg -- returns a group of cards about to be affected by destruction.
    end
    
cg in this case is a group of card script cards. Unfortunately, these are different cards than the AI script cards, and need to be handled separately. You cannot use c.id, you need c:GetCode() instead. Also a group is different from a table, you cannot access individual members via just indexing the group with cg[i], you need to use card group functions for this.

But luckily for you, I made some custom functions to handle this, and those are way easier to use. For example, if we want the AI to chain MST to its own destruction, we can do it like this:

    function ChainMST(card)
      local targets = DestroyCheck(OppST())
      if targets>0 and RemovalCheckCard(card) then
        return true
      end
      return false
    end
    function OnSelectChain(cards...
      if HasID(cards,05318639,ChainMST) then 
    -- HasID will detect the first parameter after the initial 2 that is a function and use it as a filter, regardless of parameter order.
        return true
      end
    end

RemovalCheckCard does check, if the card is about to be removed anywhere in the current chain. It checks for most common ways of removal, like destroying, banishing, returning to hand or field, sending to graveyard etc. Optional parameters allow specifications of categorys, chain links and the type of card, that performs the removal.

So this way, the AIs MST should be chained to a removal effect affecting it, if the opponent controls a valid target to destroy as well.

**Negating of effects**

Very similar to detecting removal effects, we can check the current effect in the chain, to see, if it should be negated or not, with cards like Stardust Dragon. Or we can check the entire chain, if something needs to be negated with cards like Breakthrough Skill etc.

This is done with the Duel.GetChainInfo function, like this:

    local e = Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_EFFECT)
    if e then
      -- proceed to check e, who owns the card that triggered this effect etc

Of course, we also have some easy to use custom functions for this, which neatly handle all these things internally and have some additional perks as well.

For example, most cards, that negate the last chain link specifically via trigger effect or counter trap or stuff like that, can be handled by the ChainNegation function. Lets take Wiretap as an example, you can use it like this in OnSelectChain:

    if HasIDNotNegated(cards,34507039,ChainNegation) then -- Wiretap
      return {1,CurrentIndex}
    end

Not only will this negate only your opponent's card effects, it will check, if the effect is on a list of cards never to negate (Upstart for example), and it will mark the chain link as negated, which causes it to be ignored for stuff like RemovalCheck, if you happen to use it. So if you chain negation to some sort of field nuke, the AI will be aware of that and not chain all S/T in response to the field nuke. However, as of now, the AI cannot check, if the negation was negated. So if the opponent attempts to Black Rose the field, you negate it with something like Stardust Dragon, but he chains a Divine Wrath, the AI will fail to realize, that the field is still blown up and not chain S/T, even if it could benefit from it (granted, there is not much you can chain after a Divine Wrath :D)

A similar function exists for the likes of Breakthrough Skill, although it is used slightly differently. It returns the card, that should be negated, and you'll need to make sure to handle target selection accordingly:

    function ChainBTS(card)
      local c = ChainCardNegation(card,true) -- the 2nd parameter is for a targeting check. Use true for targeted negation like BTS, false for non-targeted like Skill Drain
      if c then
        GlobalTargetSet(c)
        return true
      end
    end

GlobalTargetSet finds the target on the field and stores it in a global variable. It is designed to work with GlobalTargetGet, which recovers the target from a list of cards and is used in OnSelectCard:

    function BTSTarget(cards)
      return GlobalTargetGet(cards,true) -- 2nd parameter dtermines, if a card should be returned, or the index of the card in the list. true = index, false = card
    end

This will flag the chain link activated by the targeted card as negated 


###8) Adding new decks to the existing AI###

Everything we have learned so far can be used to make our very own AI script. However, a seperate AI script file does come with some problems. You would have to repeat a lot of code, which is already handled by the standard AI, you would need to select a different AI file, every time, you want to play against your deck, the "random deck" function cannot be used, because the program cannot change the used AI file automatically. Integrating new code into the existing AI is quite troublesome as well, you would need to deal with my huge mess of code, you might interfere with already existing decks etc etc...

As of AI version 0.28, there is a solution to this problem. I included a bunch of custom functions designed to integrate custom AI deck scripts into the existing AI, in a few simple steps. These allow your deck to function almost 100% independantly of any other deck, while still giving you the option to let the standard AI script handle most of the cards, if you want. We will use our previous example of Breaker the Magical Warrior and see, how we can integrate him into the standard AI.

**First step: The bare minimum.**

What are the absolute minimum requirements to add your own deck to the AI?

- (Have your decklist as .ydk file. For this exalmple, it should have at least 1 Breaker the Magical Warrior)
- Create a new LUA file in the ai/decks subfolder of your YGOPro installation, call it however you like. We will use "Breaker.lua"
- Add a single line of code to your file, like this:

    DECK_BREAKER = NewDeck("Breaker",71413901,nil) 

DECK_BREAKER is the variable holding your deck from now on.
NewDeck has 3 parameters:  
1) The name of your deck. Mainly used for displaying the current deck type during debug mode. Use anything you like, but it should be informative, like your deck's archetype (Nekroz) or common abbreviation (HAT).  
For the purpose of this example, we will use the name "Breaker".
2) The deck identifier. This can be a card id, or a list of multiple card ids. You want to use a card, that distinguishes your deck from other decks. For example, it might be a bad idea to use Fire Formation - Tenki to identify a Fire Fist deck, because Tenki can be used in basically anything that runs Beast-Warriors.  
For our example, we will use the id of Breaker, 71413901.
3) The startup function. It will be called at the start of the duel, if the AI detects your deck. Not required, but you probably want to have it.
We will add it later on, use nil for now.

So now you have a file, that is completely empty, except a single line of code. Next thing you do is open your "ai.lua" file, and add your own file to the list of requirements:
	
    ...
    require("ai.decks.Constellar")
    require("ai.decks.Blackwing")
    require("ai.decks.Harpie")
    require("ai.decks.Breaker") <--


Thats it, you added your first deck file. Try it out now, start YGOPro in Debug Mode. For Windows users, this is done by using the 2nd exe file in your installation folder, called "ygopro_vs_ai_debug.exe". The game should start, and there should be a DOS window as well, displaying some text. Users on other operating systems might have to start YGOPro via console to get those debug messages. Start a game against your AI decklist. Have a look at the console, it should display a message at the start of the game (after rock/paper/scissors): "AI deck is Breaker."

If this message appears, it means, the AI has identified your decklist from the identifier card you specified. Note that this is obviously not very precise, and it might detect other decks as your deck, but more about that later. If the message does not appear, something is wrong. Check the steps so far. Make sure, the AI plays the correct deck, you specified the correct identifier id, and you added the require properly.

**Adding your code to your AI**

Now that we're set up, we can start to actually do something with our file. As of right now, all it does is detect the deck, nothing more. Everything is still handled by the standard AI. This changes, once we set up our startup function:

    function BreakerStartup(deck)
    end
     
    DECK_BREAKER = NewDeck("Breaker",71413901,BreakerStartup) 

Note, that the startup function has to be above the other line we added earlier. The parameter is our deck, the same we stored in DECK_BREAKER.

Now we can use the startup function to modify parameters of the deck, like accessing the respective AI functions or adding cards to the various AI banlists:

    function MyDeckStartup(deck)
      deck.Init = MyDeckInit
        
      deck.SummonBlacklist = MyDeckSummonBlacklist
    end
     
    function MyDeckInit(cards, to_bp_allowed, to_ep_allowed)
      local Act = cards.activatable_cards
      local Sum = cards.summonable_cards
      local SpSum = cards.spsummonable_cards
      local Rep = cards.repositionable_cards
      local SetMon = cards.monster_setable_cards
      local SetST = cards.st_setable_cards
      return nil
    end
     
    MyDeckSummonBlacklist = {71413901}


If you set deck.Init to a function, the AI will call it like your standard OnSelectInitCommand function. Here you can handle all the cards the same way you would in a seperate AI file.

deck.SummonBlacklist expects a table of card ids. Those cards will never be normal- or special summoned by the standard AI, if it detects your deck.

For a full list of functions and lists available here, refer to the documented [template](https://www.dropbox.com/s/sl254q1lfvqw5at/DeckTemplate.lua?dl=1). The most important ones are
probably:

    deck.Init -- OnSelectInit
    deck.Card -- OnSelectCard
    deck.Chain -- OnSelectChain
    deck.EffectYesNo -- OnSelectEffectYesNo

    deck.ActivateBlacklist -- never activate or chain any cards or effects in this list
    deck.SummonBlacklist -- never normal-, special summon or set monsters in this list

    deck.PriorityList -- sets up the priority list. Refer to AIOnDeckSelect.lua and the "Add" function.

Do note, if you use the blacklists, the game expects you to handle those cards in your script. Otherwise, they won't be used at all.

From here on, we can script more cards, add more functions as we need them. The beauty of this is, that you don't need to make your AI complicated at all. Its perfectly fine to only add an Init function to handle the summoning of a couple of cards, while still retaining access to all the features of the standard AI. If thats all the AI needs, perfect. You can leave out everything else, just make the file, add the required line + startup function, registed the init function, and be done with it. Everything you don't specify otherwise will just be handled by the default AI. You can easily leave out stuff like staple traps, staple extra deck monsters and the like, if the default AI already handles them properly. But if the AI misuses a certain card, just blacklist it and code your own logic instead, without limiting any other deck, as the blacklist will only be in effect for your own deck.

Do note, that you don't need to use most of my custom functions to make use of this feature. If you set up your deck and the respective deck functions, the rest is entirely up to you. You can use the raw scripts as described in Chapter 4, or you can make your own set of custom functions, if you're not comfortable with mine.

**Making a deck work**

In this section, we take all the information of the last chapters to properly add Breaker and TKRO as a new "deck" to the AI. We start by using the [template deck file](https://www.dropbox.com/s/sl254q1lfvqw5at/DeckTemplate.lua?dl=1).

- The very first step is saving the template under a new name. Save it as "Breaker.lua" in your "ai/decks" subfolder. 
- Open the template, and change all references of "MyDeck" to "Breaker". Most text or code editors have the functionality to do this automatically with "replace all".
- Change the deck name from "My Deck" to "Breaker" as well:

    DECK_BREAKER = NewDeck("Breaker",BreakerIdentifier,BreakerStartup) 
    
- Change the deck identifier. You can use multiple cards to identify the deck as well. With this code, any deck, that has both Breaker and TKRO will be detected as the "Breaker" deck:

    BreakerIdentifier = {71413901,71564252}

- Add the deck to the "ai.lua" requirement list as before, if not done already:

    ...
    require("ai.decks.Constellar")
    require("ai.decks.Blackwing")
    require("ai.decks.Harpie")
    require("ai.decks.Breaker") <--


Alright, basic setup complete. Now we integrate all the functionality we added earlier.

- Add Breaker and TKRO to the activation blacklist:

    BreakerActivateBlacklist={
    -- add cards to never activate/chain here
    71413901, -- Breaker
    71564252, -- TKRO
    }

- Add the code we used earlier to make Breaker and TKRO be used properly to the respective functions. I modified some of the functions using the information of the previous chapters.  
Using Breaker:

    function UseBreaker()
      return DestroyCheck(OppST())>0
    end
    function BreakerInit(cards)
      local Act = cards.activatable_cards
      -- add OnSelectInit logic here
      if HasID(Act,71413901,UseBreaker) then
        return COMMAND_ACTIVATE,CurrentIndex
      end
      return nil
    end
    
Target selection:

    function BreakerTarget(cards)
      return BestTargets(cards,1,TARGET_DESTROY)
    end
    function BreakerCard(cards,min,max,id,c)
      -- add OnSelectCard logic here
      if id == 71413901 then
        return BreakerTarget(cards)
      end
      return nil
    end

Chaining TKRO:

    function TKROFilter(c)
      -- a filter checking, if the target should be hit by TKRO
      return FilterStatus(c,STATUS_SUMMONING)
      and c.attack>=1900
    end
    function ChainTKRO()
      return CardsMatchingFilter(OppMon(),TKROFilter)>0
    end
    function BreakerChain(cards)
      -- add OnSelectChain logic here
      if HasID(cards,71564252,ChainTKRO) then
        return 1,CurrentIndex
      end
      return nil
    end
    function BreakerEffectYesNo(id,card)
      -- add OnSelectEffectYesNo logic here
      if id == 71564252 and ChainTKRO() then
        return true
      end
      return nil
    end

You can check out the end result in [this file](https://www.dropbox.com/s/al8hj8lqd4j4s61/Breaker.lua?dl=1). Do note, that this can be expanded upon at will. Currently, the normal summons of the cards are handled by the default logic, because we did not restrict them. You can add them to the summon blacklist and add conditions for their summoning, like only summon Breaker, if the opponent controls any targets to destroy for his effect. Or only summon TKRO, if the opponent does not control monsters stronger than 1900.

###9)Fin###

This concludes the AI Scripting Tutorial, I hope, you can make use of it. It is a lot of information to absorb, I know. Scripting for the YGOPro AI is not a trivial matter, there are lots of obstacles on the way. I look forward to test all your new custom decks, and eventually integrate them into the AI officially:)