--[[
ai.lua

Author: Percival18
Version: 0.5.1
Website: http://www.ygopro.co

Updated: November 14.2013 by Sebrian
Version: AI_Beta

Currently working on Ytterbite's AI script, to update and improve it, 
change log can be found at: http://www.ygopro.co/tabid/95/g/posts/t/2824/Some-AI-fixes-and-updates--Latest-Version-08-03.aspx


Updated: May 29.2013 by ytterbite
Version: 604 LP


(ytb)  Hi, I'm ytterbite, and I'm working on modifying this ai.lua
       to help the AI play YGO a little more properly. I'm basing
       it on the way that I tend to play YGO. Is that good or bad?
       I don't know. You decide!

(ytb)  For ease in further modification, I'm leaving the original
       comments and help sections written by Percival18 intact.
       Any comments of mine will be preceded by (ytb). Also all
       modifications of mine will be preceded by long dashed
       lines (-------------------------------) along with a short
       explanation of what the modification will do.
	     	   
To be used with ygopro ai version. For help on how to use this file please read the comments thoroughly.

Tips for ai developers
-Knowledge of the Lua programming language is highly recommended http://www.lua.org/manual/5.2/
-Make a backup of this file before editing
-Always return a valid value! The program will crash otherwise
-Use the debug executable that has the console available (ygopro_vs_ai_debug.exe)
-Use print() or AI.Chat() to debug. The print() statements will show up in the console
-To test game situations use the puzzle mode:
	-find and open /script/utility.lua
	-make a backup of that file
	-find the function Auxiliary.BeginPuzzle(effect)
	-comment out everything in that function (or remove the contents)
	-now the puzzle won't end at the end phase


Available functions:
AI.Chat(text) --text: a string
AI.GetPlayerLP(player) --1 = AI, 2 = the player
AI.GetCurrentPhase() --Refer to /script/constant.lua for a list of valid phases

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

--Sample usage
local cards = AI.GetOppMonsterZones()
for i=1,#cards do
	if cards[i] == false then			
		-- this zone is empty
		print(i..": [empty]")			
	else
		-- this zone has a card, print the id
		print(i..": "..cards[i].id)
	end
end


Still have to implement the stuff listed here:
-OnSelectCounter() -> Chaos Zone, Gateway of the Six
-OnSelectSum() -> Machina Fortress
-Allow access to the players' main deck, extra deck
-Better error checking
-Do fallbacks if error found
--]]


--------------------------------------------------------
-- A list of lua files found in the "ai/mod" sub-folder.
--------------------------------------------------------
require("ai.mod.AICheckList")
require("ai.mod.AIHelperFunctions")
require("ai.mod.AICheckPossibleST")
require("ai.mod.AIOnDeckSelect")
require("ai.mod.DeclareAttribute")
require("ai.mod.DeclareCard")
require("ai.mod.DeclareMonsterType")
require("ai.mod.SelectBattleCommand")
require("ai.mod.SelectCard")
require("ai.mod.SelectChain")
require("ai.mod.SelectEffectYesNo")
require("ai.mod.SelectInitCommand")
require("ai.mod.SelectNumber")
require("ai.mod.SelectOption")
require("ai.mod.SelectPosition")
require("ai.mod.SelectTribute")
require("ai.mod.SelectYesNo")
require("ai.decks.FireFist")
require("ai.decks.HeraldicBeast")
require("ai.decks.Gadget")
require("ai.decks.Bujin")
require("ai.decks.Mermail")
require("ai.decks.Shadoll")

math.randomseed( require("os").time() )

--- OnStartOfDuel ---
-- Called at start of duel. 
-- You can put stuff like gl hf, taunts, copyright in here.
-- 
-- Parameters:
-- (none)
--
-- Return: 
-- (none)


--function OnStartOfDuel()
--        AI.Chat("gl hf")
--end


-------------------------------------------------
-- A modified version of the above example.
-- This will also create an empty "save state" to
-- help detect when the opponent plays a card.
-------------------------------------------------
function OnStartOfDuel()
  SaveState()
end

