
function MegaMonarchStartup(deck)
  deck.Init                 = MegaMonarchInit
  deck.Card                 = MegaMonarchCard
  deck.Chain                = MegaMonarchChain
  deck.EffectYesNo          = MegaMonarchEffectYesNo
  deck.Position             = MegaMonarchPosition
  deck.YesNo                = MegaMonarchYesNo
  deck.BattleCommand        = MegaMonarchBattleCommand
  deck.AttackTarget         = MegaMonarchAttackTarget
  deck.AttackBoost          = MegaMonarchAttackBoost
  deck.Tribute				      = MegaMonarchTribute
  --[[
  deck.Option 
  deck.Sum 
  deck.DeclareCard
  deck.Number
  deck.Attribute
  deck.MonsterType
  ]]
  deck.ActivateBlacklist    = MegaMonarchActivateBlacklist
  deck.SummonBlacklist      = MegaMonarchSummonBlacklist
  deck.RepositionBlacklist  = MegaMonarchRepoBlacklist
  deck.SetBlacklist		      = MegaMonarchSetBlacklist
  deck.Unchainable          = MegaMonarchUnchainable
  --[[
  
  ]]
  deck.PriorityList         = MegaMonarchPriorityList
  
end

MegaMonarchIdentifier = 84171830 -- Dominion

DECK_MegaMonarch = NewDeck("Vassal/Mega Monarchs",MegaMonarchIdentifier,MegaMonarchStartup) 

MegaMonarchActivateBlacklist={
00006700, -- Aither
00006701, -- Erebus
69230391, -- Mega Thestalos
87288189, -- Mega Caius
09748752, -- Caius

95993388, -- Landrobe
22382087, -- Garum
00006702, -- Eidos
00006703, -- Idea

00006723, -- Pandeity
02295440, -- One for one
32807846, -- RotA
33609262, -- Tenacity
81439173, -- Foolish
05318639, -- MST
79844764, -- Stormforth
19870120, -- March
61466310, -- Return
84171830, -- Dominion

00006734, -- Original
}
MegaMonarchSummonBlacklist={
00006700, -- Aither
00006701, -- Erebus
69230391, -- Mega Thestalos
87288189, -- Mega Caius
09748752, -- Caius

95993388, -- Landrobe
22382087, -- Garum
00006702, -- Eidos
00006703, -- Idea
}
MegaMonarchSetBlacklist={
}
MegaMonarchRepoBlacklist={
}
MegaMonarchUnchainable={
}
MegaMonarchPriorityList={                      
--[12345678] = {1,1,1,1,1,1,1,1,1,1,XXXCond},  -- Format

-- MegaMonarch


[00006700] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Aither
[00006701] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Erebus
[69230391] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Mega Thestalos
[87288189] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Mega Caius
[09748752] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Caius

[95993388] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Landrobe
[22382087] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Garum
[00006702] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Eidos
[00006703] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Idea

[00006723] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Pandeity
[02295440] = {1,1,1,1,1,1,1,1,1,1,nil},  -- One for one
[32807846] = {1,1,1,1,1,1,1,1,1,1,nil},  -- RotA
[33609262] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Tenacity
[81439173] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Foolish
[05318639] = {1,1,1,1,1,1,1,1,1,1,nil},  -- MST
[79844764] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Stormforth
[19870120] = {1,1,1,1,1,1,1,1,1,1,nil},  -- March
[61466310] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Return
[84171830] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Dominion

[00006734] = {1,1,1,1,1,1,1,1,1,1,nil},  -- Original

} 

--[[
00006700 -- Aither
00006701 -- Erebus
69230391 -- Mega Thestalos
87288189 -- Mega Caius
09748752 -- Caius

95993388 -- Landrobe
22382087 -- Garum
00006702 -- Eidos
00006703 -- Idea

00006723 -- Pandeity
02295440 -- One for one
32807846 -- RotA
33609262 -- Tenacity
81439173 -- Foolish
05318639 -- MST
79844764 -- Stormforth
19870120 -- March
61466310 -- Return
84171830 -- Dominion

00006734 -- Original
]]
function MegaMonarchInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  if HasID(Act,33609262,UseTenacity) then
    return COMMAND_ACTIVATE,CurrentIndex
  end
  return nil
end
--[[
00006700 -- Aither
00006701 -- Erebus
69230391 -- Mega Thestalos
87288189 -- Mega Caius
09748752 -- Caius

95993388 -- Landrobe
22382087 -- Garum
00006702 -- Eidos
00006703 -- Idea

00006723 -- Pandeity
02295440 -- One for one
32807846 -- RotA
33609262 -- Tenacity
81439173 -- Foolish
05318639 -- MST
79844764 -- Stormforth
19870120 -- March
61466310 -- Return
84171830 -- Dominion

00006734 -- Original
]]

function MegaMonarchCard(cards,min,max,id,c)
  if not c and GlobalStormforth==Duel.GetTurnCount()
  and min==1 and max==1 and Duel.GetTurnPlayer()==player_ai
  and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
  then
    return StormforthTarget(cards)
  end
  return nil
end
function MegaMonarchChain(cards)
  if HasID(cards,46895036,ChainDullahan) then
    return 1,CurrentIndex
  end
  return nil
end
function MegaMonarchEffectYesNo(id,card)
  if id == 46895036 and ChainDullahan(card) then 
    return 1
  end
  return nil
end

function MegaMonarchYesNo(desc)
  if desc == 92 then -- Stormforth tribute enemy
    return 1
  end
  return nil
end

function MegaMonarchTribute(cards,min, max)
end
function MegaMonarchBattleCommand(cards,targets,act)
end
function MegaMonarchAttackTarget(cards,attacker)
end
function MegaMonarchAttackBoost(cards)
end

MegaMonarchAtt={
00006700, -- Aither
00006701, -- Erebus
69230391, -- Mega Thestalos
87288189, -- Mega Caius
09748752, -- Caius
}
MegaMonarchDef={
95993388, -- Landrobe
22382087, -- Garum
00006702, -- Eidos
00006703, -- Idea
00006734, -- Original
}
function MegaMonarchPosition(id,available)
  result = nil
  for i=1,#MegaMonarchAtt do
    if MegaMonarchAtt[i]==id 
    then 
      result=POS_FACEUP_ATTACK
    end
  end
  for i=1,#MegaMonarchDef do
    if MegaMonarchDef[i]==id 
    then 
      result=POS_FACEUP_DEFENCE 
    end
  end
  if id==09126351 and TurnEndCheck() then
    result=POS_FACEUP_DEFENCE 
  end
  if id==53334641 and TurnEndCheck() then
    result=POS_FACEUP_DEFENCE 
  end
  return result
end

