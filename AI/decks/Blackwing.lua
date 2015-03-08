function BlackwingPriority()
AddPriority({

[81105204] = {7,1,1,1,3,1,1,1,8,1,KrisCond},    -- Kris
[58820853] = {5,3,1,1,1,1,1,1,5,1,ShuraCond},   -- Shura
[49003716] = {4,1,1,1,4,1,1,1,8,1,BoraCond},    -- Bora
[14785765] = {3,1,1,1,6,4,1,1,1,1,ZephCond},    -- Zephyros
[85215458] = {9,4,1,1,3,1,1,1,5,1,KalutCond},   -- Kalut
[02009101] = {8,3,3,1,2,1,1,1,6,1,GaleCond},    -- Gale
[55610595] = {2,1,5,1,7,3,1,1,7,1,PinakaCond},  -- Pinaka
[28190303] = {10,1,1,1,4,1,1,1,7,1,GladiusCond},-- Gladius
[22835145] = {6,2,1,1,1,4,1,1,6,1,BlizzardCond},-- Blizzard
[73652465] = {11,1,1,1,4,1,1,1,7,1,OroshiCond}, -- Oroshi
[97268402] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Veiler

[91351370] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Black Whirlwind

[53567095] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Icarus
[72930878] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Black Sonic

[81983656] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Hawk Joe
[69031175] = {1,1,7,1,3,1,1,1,1,1,nil},         -- Armor Master
[73580471] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Black Rose
[95040215] = {1,1,8,1,2,1,1,1,1,1,nil},         -- Nothung
[98012938] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Vulcan
[73347079] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Force Strix
})
end
 
function BlackwingFilter(c,exclude)
  return IsSetCode(c.setcode,0x33) and (exclude == nil or c.id~=exclude)
end
function BlackwingTunerFilter(c,exclude)
  return BlackwingFilter(c,exclude) and FilterType(c,TYPE_TUNER)
end
function BlackwingNonTunerFilter(c,exclude)
  return BlackwingFilter(c,exclude) and not FilterType(c,TYPE_TUNER)
end
function BlackwingSynchroFilter(c,exclude)
  return BlackwingFilter(c,exclude) and FilterType(c,TYPE_SYNCHRO)
end
function HasWhirlwind()
  return HasIDNotNegated(AIST(),91351370,true,nil,nil,POS_FACEUP)
end
function SynchroCheck(level,nontunercount)
  local tuners={}
  local nontuners={}
  local levels={}
  for i=1,#AIMon() do
    local c = AIMon()[i]
    if c.level>0 then
      if FilterType(c,TYPE_TUNER) then
        tuners[#tuners+1]=c.level
      else
        nontuners[#nontuners+1]=c.level
      end
    end
  end
  if #tuners == 0 or #nontuners == 0 then
    return false
  end
  for i=1,#nontuners do
    for j=1,#nontuners do
      local a,b
      if i==j then
        a=0
        b=0
      else
        a=nontuners[i]
        b=nontuners[j]
      end
      levels[a+b]=true
    end
  end
  for i=1,#tuners do
    for j=1,#nontuners do
      levels[tuners[i]+nontuners[j]]=0
    end
  end
end

function CothTargetFilter(target,source)
  if not CothCheck(target) or target.id == 81105204 then
    return true
  end
  return false
end
-- favourable targets to return to the hand 
-- for Zephyros and Vulcan
function BounceTargets(cards,filter,opt)
  local result = 0
  for i=1,#cards do
    local c = cards[i]
    if c and (filter == nil 
    or (opt == nil and filter(c) 
    or filter(c,opt)))
    then
      if c.id == 50078509 and FilterPosition(c,POS_FACEUP) then
        result = result+1
      elseif c.id == 97077563 and FilterPosition(c,POS_FACEUP) 
      and CardsMatchingFilter(AIMon(),CothTargetFilter,c)==0
      then
        result = result+1
      end
    end
  end
  return result>0
end

function KrisCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AICards(),c.id,true)
    and FieldCheck(3,BlackwingTunerFilter)==1
  end
  return true
end
function ShuraCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AICards(),c.id,true)
  end
  return true
end
function BoraCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AICards(),c.id,true)
    and FieldCheck(3,BlackwingTunerFilter)==1
  end
  return true
end
function ZephCond(loc,c)
  return true
end
function KalutCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),c.id,true)
    and (Duel.GetTurnPlayer()==1-player_ai
    or Duel.GetCurrentPhase()==PHASE_END
    or HasID(AIMon(),58820853,true))
  end
  return true
end
function GaleCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AICards(),c.id,true)
    and (FieldCheck(4,BlackwingFilter)==1
    or FieldCheck(3,BlackwingNonTunerFilter)==1)
  end
  return true
end
function PinakaCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return FilterLocation(c,LOCATION_MZONE)
  end
  return true
end
function GladiusCond(loc,c)
  if loc == PRIO_TOHAND then
    return FieldCheck(3,FilterType,TYPE_TUNER)==1 
    and #AIMon()==1
  end
  return true
end
function BlizzardCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),c.id,true)
    and CardsMatchingFilter(AIGrave(),BlizzardFilter)>0
    and DualityCheck()
  end
  return true
end
function OroshiCond(loc,c)
  if loc == PRIO_TOHAND then
    return (HasID(AIMon(),95040215,true)
    or HasID(AIMon(),22835145,true))
    --or SynchroCheck(6))
    and HasID(AIExtra(),81983656,true)
    and Duel.GetTurnPlayer()==player_ai
    and not (Duel.GetCurrentPhase()==PHASE_END)
  end
  return true
end

function UseGale()
  return true
end
function SummonGale(mode)
  if mode == 2 and DualityCheck() 
  and (HasID(AIHand(),28190303,true)
  or HasWhirlwind() and HasID(AIDeck(),28190303,true))
  and #AIMon()==0
  then
    return true
  end
  if mode == 1 and OverExtendCheck(3)
  then
    return true
  end
  if mode == 3 and (FieldCheck(4)==1 
  or FieldCheck(3,BlackwingNonTunerFilter)==1)
  then
    return true
  end
  return false
end
function SummonShura(mode,c)
  ApplyATKBoosts({c})
  if mode == 1 
  and not HasID(AIMon(),58820853,true)
  and CanWinBattle(c,OppMon(),true)
  then
    return true
  end
  if mode == 2 
  and (OverExtendCheck(3) or HasWhirlwind())
  then
    return true
  end
  return false
end
function BlizzardFilter(c)
  return BlackwingFilter(c) and c.level==4
end
function SummonBlizzard()
  return CardsMatchingFilter(AIGrave(),BlizzardFilter)>0
  and DualityCheck() and WindaCheck()
  and not HasID(AIMon(),95040215,true)
end
function SummonPinaka(mode)
  if mode == 1 and DualityCheck() 
  and (HasID(AIHand(),28190303,true)
  or HasWhirlwind() and HasID(AIDeck(),28190303,true))
  and #AIMon()==0
  then
    return true
  end
  if mode == 2 and DualityCheck()
  and (HasID(AIHand(),81105204,true) 
  or HasID(AIHand(),49003716,true) 
  or FieldCheck(4)>0)
  then
    return true
  end
  return false
end
function SummonZephyros()
  return OverExtendCheck(3) or HasWhirlwind()
end
function SummonKris(mode)
  if mode == 1 and OverExtendCheck(3) then
    return true
  elseif mode == 2 and (OverExtendCheck(3) or HasWhirlwind()) then
    return true
  elseif mode == 3 and FieldCheck(3,BlackwingTunerFilter)==1 then
    return true
  end
  return false
end
function SummonGladius(mode)
  if mode == 1 and WindaCheck()
  and FieldCheck(3,FilterType,TYPE_TUNER)==1
  then
    return true
  elseif mode == 2 and DualityCheck()
  and FieldCheck(3,FilterType,TYPE_TUNER)==1
  then
    return true
  end
  return false
end
function SummonOroshi()
  return WindaCheck() and HasID(AIMon(),95040215,true)
  and HasID(AIExtra(),81983656,true)
end
function SummonNothung(mode)
  if mode == 1 
  and (not HasID(AIMon(),95040215,true)
  or AI.GetPlayerLP(2)<=800)
  then
    return true
  elseif mode == 2 then
    return true
  end
  return false
end
function HawkJoeFilter(c)
  return BlackwingSynchroFilter(c)
end
function SummonHawkJoe(mode)
  if mode == 1 and WindaCheck()
  and (CardsMatchingFilter(AIGrave(),HawkJoeFilter)>0
  or HasID(AIMon(),73652465,true) and HasID(AIMon(),95040215,true))
  then
    return true
  end
  return false
end
function SummonBora(mode)
  if mode == 1 and FieldCheck(3,BlackwingTunerFilter)==1
  then
    return true
  end
  if mode == 2 and OverExtendCheck(3)
  then
    return true
  end
  if mode == 3 and HasWhirlwind()
  then
    return true
  end
  return false
end
function SummonForceStrix()
  if TurnEndCheck() then
    return true
  end
  return false
end
function SummonKalut()
  if DualityCheck() 
  and (HasID(AIHand(),02009101,true)
  or HasWhirlwind() and HasID(AIDeck(),02009101,true))
  and #AIMon()==0
  and #OppMon()>0
  then
    return true
  end
  return false
end
function SummonArmorMaster()
  return MP2Check()
end
function BlackwingInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  if HasIDNotNegated(Act,91351370) and #Sum>0 then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,02009101) and UseGale() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,73347079) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,81983656) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSum,73652465) and SummonOroshi() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(SpSum,81983656) and SummonHawkJoe(1) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(SpSum,95040215) and SummonNothung(1) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,28190303) and SummonGladius(1) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,49003716) and SummonBora(1) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,02009101) and SummonGale(3) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Sum,22835145) and SummonBlizzard() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,58820853) and SummonShura(1,Sum[CurrentIndex]) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,28190303) and SummonGladius(2) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,55610595) and SummonPinaka(1) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,02009101) and SummonGale(2) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,55610595) and SummonPinaka(2) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,58820853) and SummonShura(2,Sum[CurrentIndex]) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,14785765) and SummonZephyros() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,81105204) and SummonKris(2) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,49003716) and SummonBora(3) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,49003716) and SummonBora(2) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,02009101) and SummonGale(1) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,81105204) and SummonKris(1) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(Sum,85215458) and SummonKalut() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(SpSum,95040215) and SummonNothung(2) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,73347079) and SummonForceStrix() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,69031175) and SummonArmorMaster() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  return nil
end
function HawkJoeTarget(cards)
  if LocCheck(cards,LOCATION_GRAVE) then
    return Add(cards,PRIO_TOFIELD)
  end
  return BestTargets(cards)
end
function ForceStrixTarget(cards)
  if LocCheck(cards,LOCATION_OVERLAY) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return Add(cards)
end
function BlizzardTarget(cards)
  return Add(cards,PRIO_TOFIELD,1,FilterLevel,4)
end
function IcarusTarget(cards,min)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return GlobalTargetGet(cards,true)
  elseif min==1 then
    return Add(cards,PRIO_TOGRAVE)
  else
    return BestTargets(cards,2,PRIO_DESTROY)
  end
end
function BlackwingCard(cards,min,max,id,c)
  if c then
    id = c.id
  end
  if id == 02009101 then 
    return BestTargets(cards,1,TARGET_OTHER)
  end
  if id == 95040215 then 
    return BestTargets(cards,1,TARGET_OTHER)
  end
  if id == 91351370 then
    return Add(cards)
  end
  if id == 55610595 then
    return Add(cards)
  end
  if id == 81983656 then
    return HawkJoeTarget(cards)
  end
  if id == 58820853 then
    return Add(cards,PRIO_TOFIELD)
  end
  if id == 73347079 then
    return ForceStrixTarget(cards)
  end
  if id == 22835145 then
    return BlizzardTarget(cards)
  end
  if id == 53567095 then
    return IcarusTarget(cards,min)
  end
  return nil
end
function ChainKalut()
  local aimon,oppmon=GetBattlingMons() 
  local count = CardsMatchingFilter(AIHand(),FilterID,85215458)
  if aimon and (AttackBoostCheck(1400*count) 
  or CanFinishGame(aimon,oppmon,aimon:GetAttack()+1400*count))
  and UnchainableCheck(85215458)
  then
    return true
  end
  return false
end
function BlackSonicFilter(c)
  return FilterPosition(c,POS_ATTACK)
  and Affected(c,TYPE_TRAP)
end
function ChainBlackSonic(c)
  if RemovalCheckCard(c) then
    return true
  end
  local targets = SubGroup(OppMon(),BlackSonicFilter)
  local targets2 = SubGroup(targets,PriorityTarget)
  local aimon,oppmon = GetBattlingMons()
  if (WinsBattle(oppmon,aimon) 
  or #targets>1
  or #target2>0)
  and UnchainableCheck(72930878)
  then
    return true
  end
end
function IcarusFilter(c)
  return DestroyCheck(c)
  and Targetable(c,TYPE_TRAP)
  and Affected(c,TYPE_TRAP)
end
function ChainIcarus(card)
  local targets = SubGroup(OppField(),IcarusFilter)
  local targets2 = SubGroup(targets,PriorityTarget)
  local removal = {}
  for i=1,#AIMon() do
    local c = AIMon()[i]
    if FilterRace(c,RACE_WINDBEAST) 
    and RemovalCheckCard(c)
    then
      removal[#removal+1]=c
    end
  end
  if (#removal>0 and UnchainableCheck(53567095)
  or RemovalCheckCard(card))
  and #targets>1
  then
    if #removal>0 then
      BestTargets(removal,1,TARGET_PROTECT)
      GlobalTargetSet(removal[1])
      GlobalCardMode=1
    end
    return true
  end
  if #targets2>0 and #targets>1 
  and UnchainableCheck(53567095) 
  then
    return true
  end
  if Duel.GetCurrentPhase()==PHASE_BATTLE 
  and Duel.GetTurnPlayer()==1-player_ai
  then
    local aimon,oppmon = GetBattlingMons()
    if WinsBattle(oppmon,aimon) and #targets>1 
    and UnchainableCheck(53567095)
    then
      return true
    end
  end
  return false
end
function BlackwingChain(cards)
  if HasID(cards,85215458) and ChainKalut() then 
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,91351370) then -- Black Whirlwind
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,95040215) then -- Nothung
    return {1,CurrentIndex}
  end
  if HasID(cards,55610595) then -- Pinaka
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,58820853) then -- Shura
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,22835145) then -- Blitzzard
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,72930878,nil,LOCATION_HAND,nil,nil,ChainBlackSonic) then 
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,72930878,nil,nil,nil,nil,ChainBlackSonic) then 
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,53567095,nil,nil,nil,nil,ChainIcarus) then 
    return {1,CurrentIndex}
  end
  return nil
end
function BlackwingEffectYesNo(id,card)
  local result = nil
  if id==85215458 and ChainKalut() then
    result = 1
  end
  if id==91351370 and NotNegated(card) then -- Black Whirlwind
    result = 1
  end
  if id==95040215 and NotNegated(card) then -- Nothung
    result = 1
  end
  if id==58820853 and NotNegated(card) then -- Shura
    result = 1
  end
  if id == 55610595 then -- Pinaka
    result = 1
  end
  if id == 22835145 and NotNegated(card) then -- Blizzard
    result = 1
  end
  return result
end

function BlackwingOption(options)
  return nil
end

BlackwingAtt={
81105204, -- Kris
58820853, -- Shura
49003716, -- Bora
14785765, -- Zephyros
85215458, -- Kalut
02009101, -- Gale
81983656, -- Hawk Joe
69031175, -- Armor Master
33698022, -- Moonlight Rose
95040215, -- Nothung
}
BlackwingDef={
28190303, -- Gladius
22835145, -- Blizzard
73652465, -- Oroshi
73347079, -- Force Strix
}
function BlackwingPosition(id,available)
  result = nil
  for i=1,#BlackwingAtt do
    if BlackwingAtt[i]==id 
    then 
      result=POS_FACEUP_ATTACK
    end
  end
  for i=1,#BlackwingDef do
    if BlackwingDef[i]==id 
    then 
      result=POS_FACEUP_DEFENCE 
    end
  end
  return result
end

