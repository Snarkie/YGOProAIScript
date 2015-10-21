
function ShaddollStartup(deck)
  deck.Init                 = ShaddollInit
  deck.Card                 = ShaddollCard
  deck.Chain                = ShaddollChain
  deck.EffectYesNo          = ShaddollEffectYesNo
  deck.Position             = ShaddollPosition
  deck.YesNo                = ShaddollYesNo
  deck.BattleCommand        = ShaddollBattleCommand
  deck.AttackTarget         = ShaddollAttackTarget
  deck.AttackBoost          = ShaddollAttackBoost
  deck.Tribute				      = ShaddollTribute
  deck.Option               = ShaddollOption
  deck.ChainOrder           = ShaddollChainOrder
  --[[
  deck.Sum 
  deck.DeclareCard
  deck.Number
  deck.Attribute
  deck.MonsterType
  ]]
  deck.ActivateBlacklist    = ShaddollActivateBlacklist
  deck.SummonBlacklist      = ShaddollSummonBlacklist
  deck.RepositionBlacklist  = ShaddollRepoBlacklist
  deck.SetBlacklist		      = ShaddollSetBlacklist
  deck.Unchainable          = ShaddollUnchainable
  --[[
  
  ]]
  deck.PriorityList         = ShaddollPriorityList
  
end

ShaddollIdentifier = {44394295,77505534} -- Shaddoll Fusion, Shadow Games
-- TODO: backwards compatibility, change identifier

DECK_SHADDOLL = NewDeck("Shaddoll",ShaddollIdentifier,ShaddollStartup) 


ShaddollActivateBlacklist={
67696066, -- Performage Trick Clown
68819554, -- Performage Damage Juggler
31292357, -- Performage Hat Tricker
06417578, -- El-Shaddoll Fusion
74822425, -- El-Shaddoll Shekinaga
17016362, -- Trapeze Magician
}
ShaddollSummonBlacklist={
67696066, -- Performage Trick Clown
68819554, -- Performage Damage Juggler
31292357, -- Performage Hat Tricker
17016362, -- Trapeze Magician
}
ShaddollSetBlacklist={
}
ShaddollRepoBlacklist={
}
ShaddollUnchainable={
06417578, -- El-Shaddoll Fusion
}
function ShaddollFilter(c,exclude)
  local check = true
  if exclude then
    if type(exclude)=="table" then
      check = not CardsEqual(c,exclude)
    elseif type(exclude)=="number" then
      check = (c.id ~= exclude)
    end
  end
  return FilterSet(c,0x9d) and check
end
function ShaddollMonsterFilter(c,exclude)
  return FilterType(c,TYPE_MONSTER) 
  and ShaddollFilter(c,exclude)
end
function ShaddollSTFilter(c,exclude)
  return FilterType(c,TYPE_SPELL+TYPE_TRAP)
  and ShaddollFilter(c,exclude)
end
function PerformageFilter(c,exclude)
  return FilterSet(card,0xc6)
  and (exclude == nil or c.id~=exclude)
end
function PerformageMonsterFilter(c,exclude)
  return FilterType(c,TYPE_MONSTER) 
  and PerformageFilter(c,exclude)
end
function ShaddollFusionCond(loc)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),44394295,true)
  end
  return true
end
function SendToGraveFilter(c,id)
   return c.id == id 
  and c.turnid == Duel.GetTurnCount()
end
function ShaddollGraveCheck(id)
  return CardsMatchingFilter(AIGrave(),SendToGraveFilter,id)==0
end
function FalconCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(37445295) 
    and GetMultiple(37445295)==0 
    and (not HasID(AIMon(),37445295,true)
    or FilterLocation(c,LOCATION_MZONE))
    and ShaddollGraveCheck(37445295)
  end
  return true
end
function HedgehogCond(loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(04939890) 
    and GetMultiple(04939890)==0
    and ShaddollGraveCheck(04939890)
  end
  return true
end

function SquamataCond(loc)
  if loc == PRIO_TOGRAVE then
    return (OPTCheck(30328508) 
    and (HasID(AIGrave(),44394295,true) 
    and HasID(AIDeck(),04904633,true)
    or CardsMatchingFilter(AIGrave(),ShaddollMonsterFilter)<6)
    and not HasID(AIMon(),37445295,true,nil,nil,POS_FACEDOWN_DEFENCE,OPTCheck,37445295)
    and GetMultiple(30328508)==0)
    and ShaddollGraveCheck(30328508)
  end
  return true
end
function DragonFilter(c)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
end
function DragonCond(loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(77723643) 
    and CardsMatchingFilter(OppST(),DragonFilter)>0 
    and GetMultiple(77723643)==0
    and ShaddollGraveCheck(77723643)
  end
  return true
end
function BeastCond(loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(03717252) 
    and GetMultiple(03717252)==0
    and ShaddollGraveCheck(03717252)
  end
  return true
end
function ConstructFilter(c)
  return bit32.band(c.summon_type,SUMMON_TYPE_SPECIAL)>0
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 
  and Affected(c,TYPE_MONSTER,8)
end
function ConstructCond(loc)
  if loc == PRIO_TOFIELD then
    return OppGetStrongestAttack() < 2800 or HasID(AIMon(),94977269,true)
    or CardsMatchingFilter(OppMon(),ConstructFilter)>0
    and not HasID(AIMon(),20366274,true)
  end
  return true
end
function WindaCond(loc)
  if loc == PRIO_TOFIELD then
    return OppGetStrongestAttack() < 2200 or HasID(AIMon(),20366274,true)
    and PriorityCheck(UseLists({AIHand(),AIMon()}),PRIO_TOGRAVE,2,ShaddollMonsterFilter)>2
    and not HasID(AIMon(),94977269,true)
  end
  return true
end
function CoreCond(loc)
  if loc == PRIO_TOGRAVE then
    return NeedsCard(44394295,AIGrave(),AIHand(),true) or HasID(AIMon(),04904633,true)
  end
  return true
end
function FelisCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return true
  end
  return true
end
function MathCond(loc,c)
  return true
end
function ShekinagaCond(loc,c)
  return true
end
function EgrystalCond(loc,c)
  return true
end
function ClownCond(loc,c)
  if loc == PRIO_TOFIELD then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  if loc == PRIO_TOGRAVE then 
    return OPTCheck(c.id) 
    and (Duel.GetLocationCount(player_ai,LOCATION_MZONE)>2
    or FilterLocation(c,LOCATION_MZONE))
    and (AI.GetPlayerLP(1)>1800 
    or HasIDNotNegated(AIMon(),17016362,true,FilterAttackMin,1001))
  end
  return true
end
function JugglerCond(loc,c)
  if loc == PRIO_TOGRAVE then 
    return OPTCheck(c.id) 
    and not HasID(AIGrave(),c.id,true)
  end
  return true
end
function HatCond(loc,c)
  if loc == PRIO_TOHAND then
    return FieldCheck(4)==1 and #AllMon()>1
  end
  return true
end
ShaddollPriorityList={                      
--[12345678] = {1,1,1,1,1,1,1,1,1,1,XXXCond},  -- Format

-- Shaddoll

[37445295] = {3,3,3,1,7,1,6,1,1,1,FalconCond},        -- Shaddoll Falcon
[04939890] = {5,2,2,1,5,2,5,4,1,1,HedgehogCond},      -- Shaddoll Hedgehog
[30328508] = {4,1,5,1,9,1,9,1,1,1,SquamataCond},      -- Shaddoll Squamata
[77723643] = {3,1,4,1,7,1,7,1,1,1,DragonCond},        -- Shaddoll Dragon
[03717252] = {4,1,6,1,6,1,8,1,1,1,BeastCond},         -- Shaddoll Beast

[67696066] = {1,1,1,1,1,1,1,1,1,1,ClownCond},         -- Performage Trick Clown
[68819554] = {1,1,1,1,1,1,1,1,1,1,JugglerCond},       -- Performage Damage Juggler
[31292357] = {1,1,1,1,1,1,1,1,1,1,HatCond},           -- Performage Hat Tricker

[41386308] = {1,1,1,1,1,1,1,1,1,1,MathCond},          -- Mathematician
[23434538] = {1,1,1,1,1,1,1,1,1,1},                   -- Maxx "C"
[97268402] = {1,1,1,1,1,1,1,1,1,1},                   -- Effect Veiler

[24062258] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Secret Sect Druid Dru
[73176465] = {1,1,1,1,6,5,1,1,1,1,FelisCond},         -- Lightsworn Felis

[44394295] = {9,5,1,1,1,1,1,1,1,1,ShadFusionCond},    -- Shaddoll Fusion
[06417578] = {8,6,1,1,1,1,1,1,1,1,ElFusionCond},      -- El-Shaddoll Fusion
[04904633] = {4,2,1,1,9,1,9,1,1,1,CoreCond},          -- Shaddoll Core

[60226558] = {7,4,1,1,1,1,1,1,1,1,NephFusionCond},    -- Nepheshaddoll Fusion
[77505534] = {3,1,1,1,1,1,1,1,1,1},                   -- Shadow Games

[01845204] = {1,1,1,1,1,1,1,1,1,1},                   -- Instant Fusion
[12580477] = {1,1,1,1,1,1,1,1,1,1},                   -- Raigeki
[81439173] = {1,1,1,1,1,1,1,1,1,1},                   -- Foolish Burial
[14087893] = {1,1,1,1,1,1,1,1,1,1},                   -- Book of Moon
[29401950] = {1,1,1,1,1,1,1,1,1,1},                   -- Bottomless Trap Hole
[29616929] = {1,1,1,1,1,1,1,1,1,1},                   -- Traptrix Trap Hole Nightmare
[53582587] = {1,1,1,1,1,1,1,1,1,1},                   -- Torrential Tribute
[78474168] = {1,1,1,1,1,1,1,1,1,1},                   -- Breakthrough Skill
[05851097] = {1,1,1,1,1,1,1,1,1,1},                   -- Vanity's Emptiness


[20366274] = {1,1,6,4,2,1,2,1,1,1,ConstructCond},     -- El-Shaddoll Construct
[94977269] = {1,1,7,3,2,1,2,1,1,1,WindaCond},         -- El-Shaddoll Winda
[74822425] = {1,1,1,1,1,1,1,1,1,1,ShekinagaCond},     -- El-Shaddoll Shekinaga
[19261966] = {1,1,1,1,1,1,1,1,1,1,AnoyatilisCond},    -- El-Shaddoll Anoyatilis

[48424886] = {1,1,1,1,1,1,1,1,1,1,EgrystalCond},      -- El-Shaddoll Egrystal

[52687916] = {1,1,1,1,1,1,1,1,1,1},                   -- Trishula
[17016362] = {1,1,1,1,1,1,1,1,1,1},                   -- Trapeze Magician
[82633039] = {1,1,1,1,6,1,1,1,1,1,CastelCond},        -- Skyblaster Castel
[00581014] = {1,1,1,1,1,1,1,1,1,1},                   -- Daigusto Emeral
[00581014] = {1,1,1,1,1,1,1,1,1,1},                   -- Emeral
[21044178] = {1,1,1,1,1,1,1,1,1,1},                   -- Dweller
[06511113] = {1,1,1,1,1,1,1,1,1,1},                   -- Rafflesia
} 
function ShaddollFusionFilter(c)
  return c and c.summon_type and c.previous_location
  and bit32.band(c.summon_type,SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
  and bit32.band(c.previous_location,LOCATION_EXTRA)==LOCATION_EXTRA
end
function WindaCheck()
  -- returns true, if there is no Winda on the field
  return not HasIDNotNegated(AllMon(),94977269,true)
end
function FilterAttributeFusion(c,attribute,cards)
  return FilterAttribute(c,attribute) 
  and CardsMatchingFilter(cards,ShaddollMonsterFilter,c)>0
end 
function CanFusionAttribute(spell,attribute,targets)
  -- no target -> can fusion in general from available cards
  -- 1 target -> can fusion using that target and any other card
  -- 2 or more targets -> can fusion from only the targets
  local cards = AICards()
  if spell == 1 and DeckFuseCheck then
    cards = UseLists(AICards(),AIDeck())
  end
  if targets then
    if targets.id then
      targets = {targets}
    elseif #targets>1 then
      cards=targets
    end
  else
    targets = cards
  end
  local result = false
  for i=1,#targets do
    local c = targets[i]
    if FilterAttributeFusion(c,attribute,cards) then
      result = true
    end
  end
  return result
end
function CanFusionWinda(spell,targets)
  if HasID(AIExtra(),94977269,true)
  and CanFusionAttribute(spell,ATTRIBUTE_DARK,targets)
  and DualityCheck()
  then
    return true
  end
  return false
end
function CanFusionConstruct(spell,targets)
  if HasID(AIExtra(),20366274,true)
  and CanFusionAttribute(spell,ATTRIBUTE_LIGHT,targets)
  and DualityCheck()
  then
    return true
  end
  return false
end
function CanFusionShekinaga(spell,targets)
  if HasID(AIExtra(),20366274,true)
  and CanFusionAttribute(spell,ATTRIBUTE_EARTH,targets)
  and DualityCheck()
  then
    return true
  end
  return false
end
function CanFusionAnoyatilis(spell,targets)
  if HasID(AIExtra(),20366274,true)
  and CanFusionAttribute(spell,ATTRIBUTE_WATER,targets)
  and DualityCheck()
  then
    return true
  end
  return false
end

function ShaddollFusionFilter(c)
  return c and c.summon_type and c.previous_location
  and bit32.band(c.summon_type,SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
  and bit32.band(c.previous_location,LOCATION_EXTRA)==LOCATION_EXTRA
end
function DeckFuseCheck()
  return CardsMatchingFilter(OppMon(),ShaddollFusionFilter)>0
end
function UseShaddollFusion()
  if HasID(AIMon(),94977269,true) and HasID(AIMon(),20366274,true) then return false end
  return OverExtendCheck()
  and (PriorityCheck(AICards(),PRIO_TOGRAVE,2,ShaddollMonsterFilter)>2
  and not HasID(AIMon(),94977269,true)
  or PriorityCheck(AICards(),PRIO_TOGRAVE,1,ShaddollMonsterFilter)>2
  and PriorityCheck(AICards(),PRIO_TOGRAVE,1,ArtifactFilter)>2
  and not HasID(AIMon(),20366274,true)
  or CardsMatchingFilter(OppMon(),ShaddollFusionFilter)>0)
end
function UseCore()
  return HasID(AIHand(),44394295,true) and WindaCheck()
  and not Duel.IsExistingMatchingCard(ShaddollFusionFilter,1-player_ai,LOCATION_MZONE,0,1,nil)
end
function DruFilter(c)
  return bit32.band(c.attribute,ATTRIBUTE_DARK)>0 and c.level==4 and (c.attack==0 or c.defense==0)
end
function SummonDru()
  return CardsMatchingFilter(AIGrave(),DruFilter)>0 and WindaCheck() 
  and (SummonSkyblaster() or SummonEmeral())
end
function FalconFilter2(c)
  return bit32.band(c.attribute,ATTRIBUTE_LIGHT)>0 and c.level==5 and bit32.band(c.position,POS_FACEUP)>0
end
function FalconFilter3(c)
  return bit32.band(c.race,RACE_SPELLCASTER)>0 and c.level==5 and bit32.band(c.position,POS_FACEUP)>0
end
function SummonFalcon()
  return (SummonMichael(FindID(04779823,AIExtra())) and CardsMatchingFilter(AIMon(),FalconFilter2)>0 
  or SummonArcanite() and CardsMatchingFilter(AIMon(),FalconFilter3)>0 
  or SummonArmades() and FieldCheck(3)>0)
  and (WindaCheck() or not SpecialSummonCheck(player_ai))
end
function SetFalcon()
  return TurnEndCheck() 
  and (CardsMatchingFilter(AIGrave(),FalconFilter)>0 
  or HasID(AIST(),77505534,true)
  or HasID(AIHand(),77505534,true) and Duel.GetLocationCount(player_ai,LOCATION_SZONE)>1)
  and not HasID(AIMon(),37445295,true)
end
function SummonDragon()
  return Duel.GetTurnCount()>1 and not OppHasStrongestMonster() and OverExtendCheck() 
  or FieldCheck(4) == 1 and (SummonSkyblaster() or SummonEmeral())
end
function SetDragon()
  return (Duel.GetTurnCount()==1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
  and not HasID(AIMon(),37445295,true) and OverExtendCheck()
end
function SummonHedgehog()
  return HasID(AIMon(),37445295,true,nil,nil,POS_FACEUP) and SummonArmades()
end
function SetHedgehog()
  return (Duel.GetTurnCount()==1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
  and not HasID(AIMon(),04939890,true) and not HasID(AIHand(),44394295,true) 
end
function SummonSquamata()
  return Duel.GetTurnCount()>1 and not OppHasStrongestMonster() and OverExtendCheck() 
  or FieldCheck(4) == 1 and (SummonSkyblaster() or SummonEmeral())
end
function SetSquamata()
  return (Duel.GetTurnCount()==1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
  and not HasID(AIMon(),37445295,true) and OverExtendCheck()
end
function SummonBeast()
  return false
end
function SetBeast()
  return false
end
function SetShadowGames()
  return Duel.GetTurnCount()==1 or Duel.GetCurrentPhase()==PHASE_MAIN2 
  and not HasIDNotNegated(AIST(),77505534,true)
end
--[[function UseShaddollFusion(c,mode) -- TODO
  if mode == 1 then
    if CardsMatchingFilter(OppMon(),ShaddollFusionFilter)>0 
    then
      return true
    end
  end
  if mode == 2 then
  end
  return false
end]]
function SummonMathShaddoll(c)
end
function FalconFilter(c)
  return ShaddollMonsterFilter(c,37445295)
end
function UseFalcon()
  return OPTCheck(37445295) and PriorityCheck(AIGrave(),PRIO_TOFIELD,1,FalconFilter)>1
end
function UseHedgehog()
  return OPTCheck(04939890) and HasID(AIDeck(),44394295,true)
end
function SquamataFilter(c)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
end
function UseSquamata()
  return CardsMatchingFilter(OppMon(),SquamataFilter)>0-- and OPTCheck(37445295)
end
function DragonFilter2(c)
  return c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0 and (c.level>4 
  or bit32.band(c.type,TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ)>0) 
end
function UseDragon()
  return OPTCheck(37445295) and CardsMatchingFilter(OppMon(),DragonFilter2)>0
end
function DragonFilter3(c)
  return c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
end
function UseDragon2()
  return OPTCheck(37445295) and CardsMatchingFilter(OppMon(),DragonFilter3)>0
end
function UseBeast()
  return OPTCheck(03717252) --and PriorityCheck(AIHand(),PRIO_TOGRAVE)>3
end
function UseFelis()
  return Duel.GetCurrentPhase()==PHASE_MAIN2 and DestroyCheck(OppMon())
end
function ShaddollInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummmonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  if HasID(Act,04904633) and UseCore() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,00581014,false,9296225) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,44394295) and UseShaddollFusion() then
    GlobalCardMode=1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Rep,37445295,false,nil,nil,POS_FACEDOWN_DEFENCE,UseFalcon) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
  if HasID(Rep,04939890,false,nil,nil,POS_FACEDOWN_DEFENCE,UseHedgehog) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
  if HasID(Rep,30328508,false,nil,nil,POS_FACEDOWN_DEFENCE,UseSquamata) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
  if HasID(Rep,77723643,false,nil,nil,POS_FACEDOWN_DEFENCE,UseDragon) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
  if HasID(Rep,03717252,false,nil,nil,POS_FACEDOWN_DEFENCE,UseBeast) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
  if HasID(Rep,20366274,false,nil,nil,POS_FACEDOWN_DEFENCE) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
    if HasID(Rep,94977269,false,nil,nil,POS_FACEDOWN_DEFENCE) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end

  if HasID(Sum,41386308) and SummonMathShaddoll() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,24062258) and SummonDru() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,37445295) and SummonFalcon() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,04939890) and SummonHedgehog() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,30328508) and SummonSquamata() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,77723643) and SummonDragon() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,03717252) and SummonBeast() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  
  if HasID(Act,73176465) and UseFelis() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  
  if HasID(SetMon,37445295) and SetFalcon() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetMon,04939890) and SetHedgehog() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetMon,30328508) and SetSquamata() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end  
  if HasID(SetMon,77723643) and SetDragon() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetMon,03717252) and SetBeast() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  
  if HasID(SetST,77505534) and SetShadowGames() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  -- TODO: only for backwards compatibility
  if HasID(SetableST,85103922) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,20292186) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,12697630) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,12444060) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,29223325) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  return nil
end
function ElFusionTarget(cards,min)
end
function FalconTarget(cards)
  return Add(cards,PRIO_TOFIELD)
end
function HedgehogTarget(cards)
  return Add(cards)
end
function SquamataTarget(cards,c)
  if FilterLocation(c,LOCATION_ONFIELD) then
    return BestTargets(cards,1,true)
  else
    return Add(cards,PRIO_TOGRAVE)
  end
end
function DragonTarget(cards)
  return BestTargets(cards,1,TARGET_DESTROY)
end
function BeastTarget(cards)
  return Add(cards,PRIO_TOGRAVE)
end
function ShaddollFusionTarget(cards)
  local result=nil
  if GlobalCardMode == 1 then
    result = Add(cards,PRIO_TOFIELD)
  else
    result = Add(cards,PRIO_TOGRAVE)
  end
  GlobalCardMode = nil
  if result == nil then result = {math.random(#cards)} end
  SetMultiple(cards[1].id)
  return result
end
function ConstructTarget(cards,c)
  if FilterLocation(c,LOCATION_GRAVE) then
    return Add(cards)
  else
    return Add(cards,PRIO_TOGRAVE)
  end
end
function WindaTarget(cards)
  return Add(cards)
end
function CoreTarget(cards)
  return Add(cards)
end
function ShadowGamesTarget(cards,min,max)
  local result = nil
  if GlobalCardMode == nil then
    result = Add(cards,PRIO_TOGRAVE)
  else
    result={}
    for i=1,#cards do
      local id=cards[i].id
      if id==37445295 and UseFalcon() 
      or id==04939890 and UseHedgehog()
      or id==30328508 and UseSquamata()
      or id==77723643 and UseDragon2()
      or id==03717252 and UseBeast()
      then
        result[#result+1]=i
      end
    end
  end
  GlobalCardMode=nil
  if result == nil then result = {math.random(#cards)} end
  if #result>max then result = Add(cards,PRIO_TOGRAVE) end
  SetMultiple(cards[result[1]].id)
  return result
end
function ShaddollCard(cards,min,max,id,c)
  if id == 06417578 then
    return ElFusionTarget(cards,min)
  end
  if id == 37445295 then
    return FalconTarget(cards)
  end
  if id == 04939890 then
    return HedgehogTarget(cards)
  end
  if id == 30328508 then
    return SquamataTarget(cards,c)
  end
  if id == 77723643 then
    return DragonTarget(cards)
  end
  if id == 03717252 then
    return BeastTarget(cards)
  end
  if id == 44394295 then
    return ShaddollFusionTarget(cards)
  end
  if id == 20366274 then
    return ConstructTarget(cards,c)
  end
  if id == 20366274 then
    return WindaTarget(cards)
  end
  if id == 04904633 then
    return CoreTarget(cards)
  end
  if id == 77505534 then
    return ShadowGamesTarget(cards,min,max)
  end
  return nil
end
GlobalElFusionTargets=nil
function ChainElFusion(c)
  if RemovalCheckCard(c) then
    local targets = {}
    for i=1,#AIMon() do
      local c = AIMon()[i]
      if RemovalCheckCard(c) then
        targets[#targets+1]=c
      end
    end
    if #targets>0 then GlobalElFusionTargets=targets
      return true
    end
  end
  return false
end
function FalconCheck(c)
  return OPTCheck(37445295)
  and CardsMatchingFilter(AIGrave(),FalconFilter)==0
  and DualityCheck()
  and (WindaCheck() or not SpecialSummonCheck())
  and MacroCheck()
end
function ChainShadowGames(c)
  local result = false
  local e = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
  if RemovalCheckCard(c) then
    if e and e:GetHandler():GetCode()==12697630 then 
      return false
    end
    return true
  end
  if not UnchainableCheck(77505534) then
    return false
  end
  if RemovalCheck(37445295) and (UseFalcon() or FalconCheck()) then
    result = true
  end
  if RemovalCheck(04939890) and UseHedgehog() then
    result = true
  end
  if RemovalCheck(30328508) and UseSquamata() then
    result = true
  end
  if RemovalCheck(77723643) and UseDragon2() then
    result = true
  end
  if RemovalCheck(03717252) and UseBeast() then
    result = true
  end
  if Duel.GetCurrentPhase()==PHASE_END 
  and Duel.GetTurnPlayer()==1-player_ai
  and (HasID(AIDeck(),77723643,true) and DragonCond(PRIO_TOGRAVE) 
  or HasID(AIDeck(),04939890,true) and HedgehogCond(PRIO_TOGRAVE) 
  or HasID(AIMon(),37445295,true,FilterPosition,POS_FACEDOWN_DEFENCE) and FalconCheck()) 
  then
    result = true
  end
  if Duel.GetCurrentPhase()==PHASE_BATTLE 
  and Duel.GetTurnPlayer()==1-player_ai
  then
    local aimon,oppmon=GetBattlingMons()
    if aimon and oppmon
    and ShaddollMonsterFilter(oppmon) 
    and FilterPosition(aimon,POS_FACEDOWN_DEFENCE)
    and WinsBattle(oppmon,aimon)
    and (aimon:IsCode(77723643) and UseDragon2() 
    or aimon:IsCode(30328508) and UseSquamata()
    or aimon:IsCode(37445295) and FalconCheck())
    then
      result = true
    end
  end
  if result and e then
    c = e:GetHandler()
    result = (c and c:GetCode()~=12697630)
  end
  return result
end
function ChainCore()
  if Duel.GetCurrentPhase()==PHASE_BATTLE then
    local source=Duel.GetAttacker()
    return source and source:IsControler(1-player_ai) 
    and source:GetAttack()<=1950 and #AIMon()==0 
  end
end
function ChainClown(c)
  return (AI.GetPlayerLP(1)>1800 
  or HasIDNotNegated(AIMon(),17016362,true,FilterAttackMin,1001))
  and Duel.GetLocationCount(player_ai,LOCATION_MZONE)>0
end
function ChainJuggler(c)
  return false --TODO: everything
end

function ShaddollChain(cards)
  if HasIDNotNegated(cards,06417578,ChainElFusion) then
    return true
  end
  if HasID(cards,77505534,ChainShadowGames) then
    return {1,CurrentIndex}
  end
  if HasID(cards,37445295,false,nil,LOCATION_ONFIELD,UseFalcon) then
    OPTSet(37445295)
    return {1,CurrentIndex}
  end
  if HasID(cards,04939890,false,nil,LOCATION_ONFIELD,UseHedgehog) then
    OPTSet(04939890)
    return {1,CurrentIndex}
  end
  if HasID(cards,30328508,false,nil,LOCATION_ONFIELD,UseSquamata) then
    OPTSet(30328508)
    return {1,CurrentIndex}
  end
  if HasID(cards,77723643,false,nil,LOCATION_ONFIELD,UseDragon2) then -- Shaddoll Dragon
    OPTSet(77723643)
    return {1,CurrentIndex}
  end
  if HasID(cards,03717252,false,nil,LOCATION_ONFIELD,UseBeast) then
    OPTSet(03717252)
    return {1,CurrentIndex}
  end
  if HasID(cards,37445295,false,nil,LOCATION_GRAVE) then -- Falcon
    OPTSet(37445295)
    return {1,CurrentIndex}
  end
  if HasID(cards,04939890,false,nil,LOCATION_GRAVE) then -- Hedgehog
    OPTSet(04939890)
    return {1,CurrentIndex}
  end
  if HasID(cards,30328508,false,nil,LOCATION_GRAVE) then -- Squamata
    OPTSet(30328508) 
    return {1,CurrentIndex}
  end
  if HasID(cards,77723643,false,nil,LOCATION_GRAVE) and CardsMatchingFilter(OppST(),DestroyFilter)>0 then
    OPTSet(77723643)
    return {1,CurrentIndex}
  end
  if HasID(cards,03717252,false,nil,LOCATION_GRAVE) then -- Beast
    OPTSet(03717252)
    return {1,CurrentIndex}
  end
  if HasID(cards,20366274) then -- Construct
    return {1,CurrentIndex}
  end
  if HasID(cards,94977269) then -- Winda
    return {1,CurrentIndex}
  end
  if HasID(cards,04904633,false,nil,LOCATION_GRAVE) then -- Core
    return {1,CurrentIndex}
  end
  if HasID(cards,24062258) then -- Dru
    return {1,CurrentIndex}
  end
  if HasID(cards,04904633,ChainCore) then
    return {1,CurrentIndex}
  end
  return nil
end
function ShaddollEffectYesNo(id,card)
  local field = bit32.band(card.location,LOCATION_ONFIELD)>0
  local grave = bit32.band(card.location,LOCATION_GRAVE)>0
  if id == 37445295 and field and UseFalcon() then
    OPTSet(37445295)
    return 1
  end
  if id == 04939890 and field and UseHedgehog() then
    OPTSet(04939890)
    return 1
  end
  if id == 30328508 and field and UseSquamata() then
    OPTSet(30328508)
    return 1
  end
  if id == 77723643 and field then --Dragon
    OPTSet(77723643)
    return 1
  end
  if id == 03717252 and field and UseBeast() then
    OPTSet(03717252)
    return 1
  end
  if id == 37445295 and grave then -- Falcon
    OPTSet(37445295)
    return 1
  end
  if id == 04939890 and grave then -- Hedgehog
    OPTSet(04939890)
    return 1
  end
  if id == 30328508 and grave then -- Squamata
    OPTSet(30328508)
    return 1
  end
  if id == 77723643 and grave and CardsMatchingFilter(OppST(),DragonFilter)>0 then 
    OPTSet(77723643)
    return 1
  end
  if id == 03717252 and grave then -- Beast
    OPTSet(03717252)
    return 1
  end
  if id == 20366274 -- Construct
  or id == 94977269 -- Winda
  or id == 19261966 -- Anoyatilis
  or id == 04904633 -- Core
  or id == 24062258 -- Dru
  then
    return 1
  end
  return nil
end
function ShaddollYesNo(desc)
end
function ShaddollTribute(cards,min, max)
end
function ShaddollBattleCommand(cards,targets,act)
end
function ShaddollAttackTarget(cards,attacker)
end
function ShaddollAttackBoost(cards)
end
function ShaddollOption(options)
end
function ShaddollChainOrder(cards)
end
ShaddollAtt={
  94977269,48424886 -- Winda,Egrystal
}
ShaddollVary={
  74822425,04904633, -- Shekinaga,Core
}
ShaddollDef={
}
function ShaddollPosition(id,available)
  result = nil
  for i=1,#ShaddollAtt do
    if ShaddollAtt[i]==id 
    then 
      result=POS_FACEUP_ATTACK
    end
  end
  for i=1,#ShaddollVary do
    if ShaddollVary[i]==id 
    then 
      if BattlePhaseCheck() 
      and Duel.GetTurnPlayer()==player_ai 
      then 
        result=nil 
      else 
        result=POS_FACEUP_DEFENCE 
      end
    end
  end
  for i=1,#ShaddollDef do
    if ShaddollDef[i]==id 
    then 
      result=POS_FACEUP_DEFENCE 
    end
  end
  return result
end

