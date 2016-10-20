--[[
05405694, -- BLS Vanilla
72989439, -- BLS Envoy
07841921, -- Charging Gaia
61901281, -- Collapserpent
99234526, -- Wyverbuster
38695361, -- Envoy of Chaos
95492061, -- Manju
06628343, -- Beginning Knight
32013448, -- Evening Twilight Knight
54484652, -- BLSSS

01845204, -- Instant Fusion
32807846, -- RotA
35261759, -- Desires
38120068, -- Trade-In
70368879, -- Upstart
73628505, -- Terraforming
14094090, -- SSRitual
45948430, -- SSOrigin
43898403, -- Twin Twister
40089744, -- Gateway to Chaos

40605147, -- Strike
84749824, -- Warning
32360466, -- Universal Beginning

17412721, -- Norden
58820923, -- Dark Matter
39030163, -- Full Armor
31801517, -- Galaxy Prime
63767246, -- Titanic
56832966, -- Utopia Lightning
84013237, -- Utopia
21501505, -- Cairngorgon
94380860, -- Ragnazero
48739166, -- 101
63746411, -- Giant Hand
82633039, -- Castel
95169481, -- DDW
21044178, -- Dweller
12014404, -- Cowboy
]]

function BLSStartup(deck)
  deck.Init                 = BLSInit
  deck.Card                 = BLSCard
  deck.Chain                = BLSChain
  deck.EffectYesNo          = BLSEffectYesNo
  deck.Position             = BLSPosition
  deck.YesNo                = BLSYesNo
  deck.BattleCommand        = BLSBattleCommand
  deck.AttackTarget         = BLSAttackTarget
  deck.AttackBoost          = BLSAttackBoost
  deck.Tribute              = BLSTribute
  deck.Option               = BLSOption
  deck.ChainOrder           = BLSChainOrder
  --[[
  deck.Sum 
  deck.DeclareCard
  deck.Number
  deck.Attribute
  deck.MonsterType
  ]]
  deck.ActivateBlacklist    = BLSActivateBlacklist
  deck.SummonBlacklist      = BLSSummonBlacklist
  deck.RepositionBlacklist  = BLSRepoBlacklist
  deck.SetBlacklist         = BLSSetBlacklist
  deck.Unchainable          = BLSUnchainable
  --[[
  
  ]]
  deck.PriorityList         = BLSPriorityList
end
BLSIdentifier = 54484652 -- BLS Super Soldier
DECK_BLS = NewDeck("BLS",BLSIdentifier,BLSStartup) 
BLSActivateBlacklist={
05405694, -- BLS Vanilla
72989439, -- BLS Envoy
07841921, -- Charging Gaia
38695361, -- Envoy of Chaos
95492061, -- Manju
06628343, -- Beginning Knight
32013448, -- Evening Twilight Knight
54484652, -- BLSSS
04810828, -- Sauravis

01845204, -- Instant Fusion
35261759, -- Desires
14094090, -- SSRitual
45948430, -- SSOrigin
40089744, -- Gateway to Chaos

32360466, -- Universal Beginning

17412721, -- Norden
58820923, -- Dark Matter
39030163, -- Full Armor
31801517, -- Galaxy Prime
95169481, -- DDW
85115440, -- Zodiac Beast Bullhorn
48905153, -- Zodiac Beast Drancia
}
BLSSummonBlacklist={
72989439, -- BLS Envoy
07841921, -- Charging Gaia
61901281, -- Collapserpent
99234526, -- Wyverbuster
38695361, -- Envoy of Chaos
95492061, -- Manju
06628343, -- Beginning Knight
32013448, -- Evening Twilight Knight

58820923, -- Dark Matter
39030163, -- Full Armor
31801517, -- Galaxy Prime
63767246, -- Titanic
95169481, -- DDW
85115440, -- Zodiac Beast Bullhorn
48905153, -- Zodiac Beast Drancia
}
BLSSetBlacklist={
45948430, -- SSOrigin
}
BLSRepoBlacklist={
}
BLSUnchainable={
}
function BLSFilter(c,exclude)
  local check = true
  if exclude then
    if type(exclude)=="table" then
      check = not CardsEqual(c,exclude)
    elseif type(exclude)=="number" then
      check = (c.id ~= exclude)
    end
  end
  return FilterSet(c,0x10cf) and check
end
function BLSMonsterFilter(c,exclude)
  return FilterType(c,TYPE_MONSTER) 
  and BLSFilter(c,exclude)
end

function BLSInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  
  return nil
end

BLSTargetFunctions={
}
function BLSCard(cards,min,max,id,c)
  for i,v in pairs(BLSTargetFunctions) do
    if id == i then
      return v(cards,c,min,max)
    end
  end
  return nil
end
BLSChainFunctions={
}
function BLSChain(cards)
  for id,v in pairs(BLSChainFunctions) do
    if HasID(cards,id,v) then
      return Chain()
    end
  end
  return nil
end
function BLSEffectYesNo(id,card)
  for i,v in pairs(BLSChainFunctions) do
    if id == i then
      return v(card)
    end
  end
  return nil
end
function BLSYesNo(desc)
end
function BLSTribute(cards,min, max)
end
function BLSBattleCommand(cards,targets,act)
end
function BLSAttackTarget(cards,attacker)
end
function BLSAttackBoost(cards)
end
function BLSOption(options)
end
function BLSChainOrder(cards)
end
BLSAtt={
}
BLSVary={
}
BLSDef={
}
function BLSPosition(id,available)
  result = nil
  for i=1,#BLSAtt do
    if BLSAtt[i]==id 
    then 
      result=POS_FACEUP_ATTACK
    end
  end
  for i=1,#BLSVary do
    if BLSVary[i]==id 
    then 
      if (BattlePhaseCheck() or IsBattlePhase())
      and Duel.GetTurnPlayer()==player_ai 
      then 
        result=POS_FACEUP_ATTACK
      else 
        result=POS_FACEUP_DEFENSE 
      end
    end
  end
  for i=1,#BLSDef do
    if BLSDef[i]==id 
    then 
      result=POS_FACEUP_DEFENSE 
    end
  end
  return result
end
function BLSVanillaCond(loc,c)
  if loc == PRIO_TOHAND then
    return true
  end
  if loc == PRIO_TOGRAVE then
    return true
  end
  return true
end

BLSPriorityList={                      
--[12345678] = {1,1,1,1,1,1,1,1,1,1,XXXCond},  -- Format

-- BLS

[05405694] = {4,1,4,1,6,3,1,1,2,1,BLSVanillaCond},  -- BLS Vanilla
[72989439] = {1,1,1,1,2,1,1,1,4,1,BLSEnvoyCond},  -- BLS Envoy
[07841921] = {1,1,1,1,5,1,1,1,1,1,ChargingGaiaCond},  -- Charging Gaia
[38695361] = {5,1,1,1,4,1,1,1,1,1,EnvoyCond},  -- Envoy of Chaos

[06628343] = {7,1,1,1,8,1,1,1,9,1,BeginningKnightCond},  -- Beginning Knight
[32013448] = {6,1,1,1,7,1,1,1,8,1,TwilightKnightCond},  -- Evening Twilight Knight
[54484652] = {8,1,9,1,9,1,1,1,1,1,BLSSSCond},  -- BLSSS
[04810828] = {5,1,1,1,1,1,1,1,4,1,SauravisCond},  -- Sauravis

[14094090] = {5,1,1,1,4,1,1,1,1,1,SSRitualCond},  -- SSRitual
[45948430] = {9,5,1,1,1,1,1,1,1,1,SSOriginCond},  -- SSOrigin
[40089744] = {1,1,1,1,2,1,1,1,1,1,ChaosGatewayCond},  -- Gateway to Chaos

[32360466] = {1,1,1,1,1,1,1,1,1,1,UniversalBeginningCond},  -- Universal Beginning

[58820923] = {1,1,1,1,1,1,1,1,4,1,DarkMatterCond},  -- Dark Matter
[39030163] = {1,1,1,1,1,1,1,1,4,1,FullArmorCond},  -- Full Armor
[31801517] = {1,1,1,1,1,1,1,1,4,1,GalaxyPrimeCond},  -- Galaxy Prime
[63767246] = {1,1,1,1,1,1,1,1,4,1,TitanicGalaxyCond},  -- Titanic
[95169481] = {1,1,1,1,1,1,1,1,1,1},  -- DDW
[85115440] = {1,1,1,1,1,1,1,1,1,1},  -- Zodiac Beast Bullhorn
[48905153] = {1,1,1,1,1,1,1,1,1,1},  -- Zodiac Beast Drancia
[56832966] = {1,1,1,1,1,1,1,1,4,1,UtopiaLightningCond},  -- Utopia Lightning
[84013237] = {1,1,1,1,1,1,1,1,4,1,UtopiaCond},  -- Utopia

} 