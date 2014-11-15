-- A cheating AI file, which draws additional cards and recovers LP each turn


-- Configure these to your liking
EXTRA_DRAW = 3
LP_RECOVER = 2000


require("ai.ai")
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

math.randomseed( require("os").time() )

function OnStartOfDuel()
  AI.Chat("AI script version "..Version)
  AI.Chat("You selected a cheating AI")
	AI.Chat("The AI will recover "..LP_RECOVER.." LP and draw "..EXTRA_DRAW.." additional cards each turn")
  GlobalCheating = 1
  SaveState()
end
