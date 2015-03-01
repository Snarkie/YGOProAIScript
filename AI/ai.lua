Version = "0.26a"
Experimental = true

--[[
  AI Script for YGOPro Percy:
  http://www.ygopro.co/

  script by Snarky
  original script by Percival18
  
  GitHub repository: 
  https://github.com/Snarkie/YGOProAIScript/
  
  Check here for updates: 
  http://www.ygopro.co/Forum/tabid/95/g/posts/t/7877/AI-Updates
  
  Contributors: ytterbite, Sebrian, Skaviory, francot514
  
  for more information about the AI script, check the ai-template.lua
]]

require("ai.mod.AICheckList")
require("ai.mod.AIHelperFunctions")
require("ai.mod.AIHelperFunctions2")
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
require("ai.mod.SelectSum")
require("ai.mod.SelectTribute")
require("ai.mod.SelectYesNo")
require("ai.decks.Generic")
require("ai.decks.FireFist")
require("ai.decks.HeraldicBeast")
require("ai.decks.Gadget")
require("ai.decks.Bujin")
require("ai.decks.Mermail")
require("ai.decks.Shadoll")
require("ai.decks.Satellarknight")
require("ai.decks.ChaosDragon")
require("ai.decks.HAT")
require("ai.decks.Qliphort")
require("ai.decks.NobleKnight")
require("ai.decks.Necloth")
require("ai.decks.BurningAbyss")
require("ai.decks.DarkWorld")

math.randomseed( require("os").time() )

function OnStartOfDuel()
  AI.Chat("AI script version "..Version)
  --if Experimental then AI.Chat("This is an experimental AI version, it might contain bugs and misplays") end
  SaveState()
end

