function BAFilter(c,exclude)
  return IsSetCode(c.setcode,0xb1) and (exclude == nil or c.id~=exclude)
end
function BAMonsterFilter(c,exclude,boss)
  return FilterType(c,TYPE_MONSTER) and BAFilter(c,exclude)
  and (FilterPosition(c,POS_FACEUP) or not FilterLocation(c,LOCATION_ONFIELD))
  and (not boss or FilterID(c,00601193) or FilterID(c,83531441))
end
function BASelfDestructFilter(c,exclude)
  return BAMonsterFilter(c,exclude) and not BAMonsterFilter(c,exclude,true)
  and NotNegated(c)
end
function NotBAMonsterFilter(c)
  return FilterType(c,TYPE_MONSTER) and not BAMonsterFilter(c)
end
function BAFloater(c,check)
  return c.id == 57143342 and (not check or OPTCheck(57143342) and CardsMatchingFilter(AIDeck(),BAMonsterFilter,20758643)>0)
      or c.id == 20758643 and (not check or OPTCheck(57143342) and CardsMatchingFilter(AIGrave(),BAMonsterFilter,20758643)>0)
      or c.id == 84764038 and (not check or OPTCheck(84764038) and CardsMatchingFilter(AIDeck(),ScarmDeckFilter)>0 and CardsMatchingFilter(AIGrave(),ScarmGraveFilter)==0)
      or c.id == 83531441 and (not check or CardsMatchingFilter(AIGrave(),BAMonsterFilter,83531441)>0)
end
function ScarmGraveFilter(c)
  return c.id == 84764038 and c.turnid == Duel.GetTurnCount()
end
function ScarmDeckFilter(c)
  return FilterLevel(c,3) and FilterAttribute(c,ATTRIBUTE_DARK)
  and FilterRace(c,RACE_FIEND) and c.id ~= 84764038
end
function ScarmCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists(AIHand(),AIMon()),84764038,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(84764038) and CardsMatchingFilter(AIGrave(),ScarmGraveFilter)==0
    and CardsMatchingFilter(AIDeck(),ScarmDeckFilter)>0
  end
  if loc == PRIO_TOGRAVE then
    return OPTCheck(84764038) and CardsMatchingFilter(AIGrave(),ScarmGraveFilter)==0
    and CardsMatchingFilter(AIDeck(),ScarmDeckFilter)>0
  end
  return true
end
function GraffCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists(AIHand(),AIMon()),20758643,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(20758643) and CardsMatchingFilter(AIDeck(),BAMonsterFilter,20758643)>0
    and not HasID(AIMon(),20758643,true)
  end
  if loc == PRIO_TOGRAVE then
    return OPTCheck(20758643) and CardsMatchingFilter(AIDeck(),BAMonsterFilter,20758643)>0
  end
  return true
end
function CirCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists(AIHand(),AIMon()),57143342,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(57143342) and CardsMatchingFilter(AIGrave(),BAMonsterFilter,57143342)>0
    and not HasID(AIMon(),57143342,true)
  end
  if loc == PRIO_TOGRAVE then
    return OPTCheck(57143342) and CardsMatchingFilter(AIGrave(),BAMonsterFilter,57143342)>0
  end
  return true
end
function AlichFilter(c)
  return FilterType(c,TYPE_MONSTER+TYPE_EFFECT) 
  and Targetable(c,TYPE_MONSTER)
  and Affected(c,TYPE_MONSTER,3)
  and FilterPosition(c,POS_FACEUP)
  and not FilterAffected(c,EFFECT_DISABLE_EFFECT)
end
function AlichCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists(AIHand(),AIMon()),47728740,true)
  end
  if loc == PRIO_TOFIELD then
    return not(FilterLocation(c,LOCATION_GRAVE))
  end
  if loc == PRIO_TOGRAVE then
    return OPTCheck(47728740) and CardsMatchingFilter(OppMon(),AlichFilter)>0
  end
  return true
end
function CalcabFilter(c)
  return FilterPosition(c,POS_FACEDOWN) 
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET) == 0
end
function CalcabCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists(AIHand(),AIMon()),73213494,true)
  end
  if loc == PRIO_TOFIELD then
    return not(FilterLocation(c,LOCATION_GRAVE))
  end
  if loc == PRIO_TOGRAVE then
    return OPTCheck(73213494) and CardsMatchingFilter(OppST(),CalcabFilter)>0
  end
  return true
end
function RubicCond(loc,c)
  if loc == PRIO_TOFIELD then
    return not(FilterLocation(c,LOCATION_GRAVE))
  end
  return true 
end
function FarfaFilter(c)
  return FilterType(c,TYPE_MONSTER) 
  and Targetable(c,TYPE_MONSTER)
  and Affected(c,TYPE_MONSTER,3)
end
function FarfaCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists(AIHand(),AIMon()),36551319,true)
  end
  if loc == PRIO_TOFIELD then
    return not(FilterLocation(c,LOCATION_GRAVE))
  end
  if loc == PRIO_TOGRAVE then
    return OPTCheck(36551319) and CardsMatchingFilter(OppMon(),FarfaFilter)>0
  end
  return true
end
function CagnaCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists(AIHand(),AIMon()),09342162,true)
  end
  if loc == PRIO_TOFIELD then
    return not(FilterLocation(c,LOCATION_GRAVE))
  end
  if loc == PRIO_TOGRAVE then
    return OPTCheck(09342162) and not (HasID(AIGrave(),62835876,true) 
    or HasID(UseLists(AIHand(),AIGrave(),AIST()),36006208,true) )
  end
  return true
end
function LibicFilter(c)
  return FilterSet(c,0xb1) and FilterType(c,TYPE_MONSTER) and FilterLevel(c,3)
end
function LibicCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists(AIHand(),AIMon()),62957424,true)
  end
  if loc == PRIO_TOFIELD then
    return not(FilterLocation(c,LOCATION_GRAVE))
  end
  if loc == PRIO_TOGRAVE then
    return OPTCheck(62957424) and CardsMatchingFilter(AIHand(),LibicFilter)>0
  end
  return true
end
function DanteCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return CardsMatchingFilter(AIGrave(),BAFilter)>0
  end
  return true
end
function VirgilCond(loc,c)
  return true
end
function ReleaserCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return not DeckCheck(DECK_BA) or HasID(AIHand(),00005497,true)
  end
  return true
end
function GECond(loc,c)
  if loc == PRIO_TOHAND then
    return HasID(AIHand(),00005497,true)
  end
  if loc == PRIO_TOGRAVE then
    --return not HasID(AIGrave(),62835876,true)
  end
  return true
end
function MalacodaCond(loc,c)
  if loc == PRIO_TOHAND then
    return HasID(AIHand(),62835876,true)
  end
  return true
end
function FireLakeCond(loc,c)
  if loc == PRIO_TOHAND then
    return GetMultiple(36006208)==0 
    and not HasID(GlobalTargetList,36006208,true)
    and not HasID(UseLists(AIHand(),AIST()),36006208,true)
  end
  return true
end
function SSBA(c)
  return #AIST()==0 and (c == nil or OPTCheck(c.id)) 
  and CardsMatchingFilter(AIMon(),NotBAMonsterFilter)==0 and DualityCheck()
  and (FieldCheck(3)==1 or FieldCheck(3)==0 and CardsMatchingFilter(AIHand(),BAMonsterFilter)>1 
  and not NormalSummonCheck(player_ai))
  and OverExtendCheck(3)
end
function TourguideFilter(c)
  return bit32.band(c.type,TYPE_MONSTER)>0 and bit32.band(c.race,RACE_FIEND)>0 and c.level==3
end
function SummonTourguide()
  return CardsMatchingFilter(UseLists({AIDeck(),AIHand()}),TourguideFilter)>1 and DualityCheck()
  and (DeckCheck(DECK_BA) and CardsMatchingFilter(AIMon(),BASelfDestructFilter)==0
  or not DeckCheck(DECK_BA) and HasID(AIExtra(),83531441,true))
end
function SummonCir()
  return  CardsMatchingFilter(AIMon(),NotBAMonsterFilter)==0 
  and OverExtendCheck(3) and (FieldCheck(3)==1 or CardsMatchingFilter(AIMon(),BAMonsterFilter)==1) 
  --and CardsMatchingFilter(AIGrave(),BAMonsterFilter,57143342)>0 and OPTCheck(57143342)
end
function SummonGraff()
  return  CardsMatchingFilter(AIMon(),NotBAMonsterFilter)==0 
  and OverExtendCheck(3) and (FieldCheck(3)==1 or CardsMatchingFilter(AIMon(),BAMonsterFilter)==1) 
  --and CardsMatchingFilter(AIDeck(),BAMonsterFilter,20758643)>0 and OPTCheck(20758643)
end
function SummonScarm()
  return CardsMatchingFilter(AIMon(),NotBAMonsterFilter)==0 
  and OverExtendCheck(3) and (FieldCheck(3)==1 or CardsMatchingFilter(AIMon(),BAMonsterFilter)==1) 
  --and CardsMatchingFilter(AIDeck(),ScarmDeckFilter)>0 and OPTCheck(84764038)
end
function SummonBA()
  return FieldCheck(3)==1 and CardsMatchingFilter(AIMon(),NotBAMonsterFilter)==0 
  and OverExtendCheck(3)
end
function SummonRubic()
  return FieldCheck(3)==1 and CardsMatchingFilter(AIMon(),NotBAMonsterFilter)==0 
  and not HasID(AIMon(),00734741,true) and SummonVirgil()
end
function VirgilFilter(c)
  return Targetable(c,TYPE_MONSTER) and Affected(c,TYPE_MONSTER,6) and FilterLocation(c,LOCATION_ONFIELD)
end
function SummonVirgil()
  return (CardsMatchingFilter(OppField(),VirgilFilter)>0 and CardsMatchingFilter(AIHand(),BAFloater)>0
  or HasID(AIMon(),83531441,true) and not HasID(AIGrave(),00601193,true))
  and not HasID(AIMon(),00601193,true)
end
function UseVirgil()
  local targets = CardsMatchingFilter(OppField(),VirgilFilter)
  return HasPriorityTarget(OppField(),false,VirgilFilter) or targets>0 and PriorityCheck(AIHand(),PRIO_TOGRAVE,1,BAFilter)>3
end
function SSGraff()
  return CardsMatchingFilter(AIMon(),NotBAMonsterFilter)==0 
  and CardsMatchingFilter(AIMon(),BAMonsterFilter)==1
end
function SSCir()
  return CardsMatchingFilter(AIMon(),NotBAMonsterFilter)==0 
  and CardsMatchingFilter(AIMon(),BAMonsterFilter)==1
end
function SSScarm()
  return CardsMatchingFilter(AIMon(),NotBAMonsterFilter)==0 
  and CardsMatchingFilter(AIMon(),BAMonsterFilter)==1
end
function SummonDanteBA()
  return true
end
function SetBA()
  return #AIMon() == 0
end
function SetCir()
  return SetBA() and CardsMatchingFilter(AIGrave(),BAMonsterFilter,57143342)>0
end
function UseGE()
  return PriorityCheck(AIHand(),PRIO_TOGRAVE,1,BAFilter)>3
end
function SummonGigaBrillant()
  return CardsMatchingFilter(AIMon(),BASelfDestructFilter)<3 and #AIMon()>3
  and GlobalBPAllowed and Duel.GetCurrentPhase == PHASE_MAIN1
end
function AlucardFilter(c)
  return FilterPosition(c,POS_FACEDOWN) and DestroyFilter(c)
end
function UseAlucard()
  return CardsMatchingFilter(OppField(),AlucardFilter)>0
end
function SummonAlucard()
  return CardsMatchingFilter(AIMon(),BASelfDestructFilter)<3 and UseAlucard()
end
function SummonLevia()
  return CardsMatchingFilter(AIMon(),BASelfDestructFilter)<4
end
function TemtempoFilter(c)
  return FilterType(c,TYPE_XYZ) and c.xyz_material_count>0 and Targetable(c,TYPE_MONSTER) and Affected(c,3)
end
function UseTemtempo()
  return CardsMatchingFilter(OppField(),TemtempoFilter)>0
end
function SummonTemtempo()
  return CardsMatchingFilter(AIMon(),BASelfDestructFilter)<3 and UseTemtempo()
end
function MuzurythmFilter(c)
  return c.attack>=2500 and c.attack<3000 
  and not FilterAffected(c,EFFECT_CANNOT_BE_BATTLE_TARGET)
  and not FilterAffected(c,EFFECT_INDESTRUCTABLE_BATTLE)
end
function SummonMuzurythm()
  return CardsMatchingFilter(AIMon(),BASelfDestructFilter)<3 and CardsMatchingFilter(OppMon(),MuzurythmFilter)>0
  and GlobalBPAllowed and Duel.GetCurrentPhase == PHASE_MAIN1
end
function SummonNightmareSharkFinish()
  return GlobalBPAllowed and Duel.GetCurrentPhase == PHASE_MAIN1 and AI.GetPlayerLP(2)<=2000
end
function SummonNightmareShark()
  return CardsMatchingFilter(AIMon(),BASelfDestructFilter)<3 
  and GlobalBPAllowed and Duel.GetCurrentPhase == PHASE_MAIN1 and AI.GetPlayerLP(2)<=4000
end
function UseNightmareShark()
  return GlobalBPAllowed and Duel.GetCurrentPhase == PHASE_MAIN1
end
function SummonDownerd()
  return CardsMatchingFilter(AIMon(),BASelfDestructFilter)==0 and HasID(AIMon(),83531441,true,nil,POS_FACEUP_ATTACK)
end
function SummonZenmaines()
  return false -- temp
end
function BAInit(cards)
  GlobalPreparation = nil
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  if HasID(SpSum,31320433) and SummonNightmareSharkFinish() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(Act,70368879) and not HasID(AIMon(),31320433,true) then -- Upstart
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,73680966) then -- The Beginning of the End
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,75367227) and UseAlucard() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,52558805) and UseTemtempo() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,00601193) and UseVirgil() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSum,00601193) and SummonVirgil() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,83531441) and SummonDanteBA() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,31320433) and SummonNightmareShark() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,47805931) and SummonGigaBrillant() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,75367227) and SummonAlucard() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,68836428) and SummonLevia() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,52558805) and SummonTemtempo() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
   if HasID(SpSum,26563200) and SummonMuzurythm() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(Act,62835876,false,nil,LOCATION_HAND) then -- Good & Evil
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Sum,10802915) and SummonTourguide() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Act,62835876,false,nil,LOCATION_GRAVE) and UseGE() then -- Good & Evil
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,81439173) then -- Foolish
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,00734741,false,nil,LOCATION_HAND) and SummonRubic() then -- Rubic
    OPTSet(00734741)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Sum,20758643) and SummonGraff() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,57143342) and SummonCir() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,84764038) and SummonScarm() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Act,73213494,false,nil,LOCATION_HAND) and SSBA(Act[CurrentIndex]) then -- Calcab
    OPTSet(73213494)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,47728740,false,nil,LOCATION_HAND) and SSBA(Act[CurrentIndex]) then -- Alich
    OPTSet(47728740)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,62957424,false,nil,LOCATION_HAND) and SSBA(Act[CurrentIndex]) then -- Libic
    OPTSet(62957424)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,09342162,false,nil,LOCATION_HAND) and SSBA(Act[CurrentIndex]) then -- Cagna
    OPTSet(09342162)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,36551319,false,nil,LOCATION_HAND) and SSBA(Act[CurrentIndex]) then -- Farfa
    OPTSet(36551319)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,00734741,false,nil,LOCATION_HAND) and SSBA(Act[CurrentIndex]) then -- Rubic
    OPTSet(00734741)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Sum,800734741) and SummonRubic() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,36551319) and SummonBA() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,09342162) and SummonBA() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,62957424) and SummonBA() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,873213494) and SummonBA() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,47728740) and SummonBA() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,00734741) and SummonBA() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Act,84764038,false,nil,LOCATION_HAND) and SSScarm(Act[CurrentIndex]) then
    OPTSet(84764038)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end  
  if HasID(Act,20758643,false,nil,LOCATION_HAND) and SSGraff(Act[CurrentIndex]) then
    OPTSet(20758643)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,57143342,false,nil,LOCATION_HAND) and SSCir(Act[CurrentIndex]) then
    OPTSet(57143342)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SSetMon,57143342) and SetCir() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetMon,20758643) and SetBA() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetMon,84764038) and SetBA()then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetMon,73213494) and SetBA() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetMon,36551319) and SetBA() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetMon,09342162) and SetBA() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetMon,62957424) and SetBA() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetMon,47728740) and SetBA() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetMon,00734741) and SetBA() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SSetMon,57143342) and SetBA() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SpSum,72167543) and SummonDownerd() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,78156759) and SummonZenmaines() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,16259549) and SummonFortuneTune() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(Act,47805931) then -- Giga-Brillant
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,31320433) and UseNightmareShark() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  return nil
end
function FireLakeTarget(cards,min,max)
  local count = 0
  for i=1,#cards do
    if CurrentOwner(cards[i])==1 and bit32.band(cards[i].setcode,0xb1)>0 then
      count = count +1
    end
  end 
  if count == #cards then
    return Add(cards,PRIO_TOGRAVE,max)
  else
    return BestTargets(cards,math.min(CardsMatchingFilter(cards,FireLakeFilter),max),TARGET_DESTROY)
  end
end
function PWWBTarget(cards)
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return BestTargets(cards)
end
function KarmaCutTarget(cards)
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return BestTargets(cards)
end
function VirgilTarget(cards)
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return BestTargets(cards,1,TARGET_TODECK,VirgilFilter)
end
function MalacodaTarget(cards,c)
  if FilterLocation(c,LOCATION_GRAVE) then
    return BestTargets(cards)
  end
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return BestTargets(cards)
end
function GETarget(cards,c)
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return Add(cards,PRIO_TOHAND)
end
function AlucardTarget(cards)
  if LocCheck(cards,LOCATION_OVERLAY) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return BestTargets(cards,TARGET_DESTROY)
end
function BACard(cards,min,max,id,c)
  if c then
    id = c.id
  end
  if id == 20758643 then
    return Add(cards,PRIO_TOFIELD)
  end
  if id == 57143342 then
    return Add(cards,PRIO_TOFIELD)
  end
  if id == 73213494 then
    return BestTargets(cards,1,TARGET_TOHAND)
  end
  if id == 47728740 then
    return BestTargets(cards)
  end
  if id == 84764038 then
    return Add(cards)
  end
  if id == 36006208 then
    return FireLakeTarget(cards,min,max)
  end
  if id == 63356631 then
    return PWWBTarget(cards)
  end
  if id == 71587526 then
    return KarmaCutTarget(cards)
  end
  if id == 00601193 then
    return VirgilTarget(cards)
  end
  if id == 36551319 then
    return BestTargets(cards) 
  end
  if id == 09342162 then
    return Add(cards,PRIO_TOGRAVE)
  end
  if id == 62957424 then
    return Add(cards,PRIO_TOFIELD)
  end
  if id == 00005497 then
    return MalacodaTarget(cards,c)
  end
   if id == 62835876 then
    return GETarget(cards,c)
  end
  if id == 47805931 or id == 81330115 
  or id == 31320433 or id == 26563200
  then
    return Add(cards,PRIO_TOGRAVE)
  end
  if id == 75367227 then
    return AlucardTarget(cards)
  end
  if id == 68836428 then
    return LeviaTarget(cards)
  end
  if id == 52558805 then
    return TemtempoTarget(cards)
  end
  if id == 16195942 then -- Dark Rebellion Dragon
    return BestTargets(cards,min)
  end
  return nil
end
function ChainAlich(c)
  return FilterLocation(c,LOCATION_GRAVE) and CardsMatchingFilter(OppMon(),AlichFilter)>0
end
function FireLakeFilter(c)
  return DestroyFilter(c,true) and Targetable(c,TYPE_TRAP) 
  and Affected(c,TYPE_TRAP) and CurrentOwner(c)==2
end
function FireLakeFilter2(c)
  return FireLakeFilter(c) and PriorityTarget(c,true)
end
function ChainFireLake()
  local targets = CardsMatchingFilter(OppField(),FireLakeFilter)
  local targets2 = CardsMatchingFilter(OppField(),FireLakeFilter2)
  if RemovalCheck(36006208) and targets>1 or targets2>0 then
    return true
  end
  if not UnchainableCheck(36006208) then
    return false
  end
  if targets>2 or targets2>1 or targets>1 and targets2>0 then
    return true
  end
  return false
end
function KarmaCutFilter(c)
  return Targetable(c,TYPE_TRAP) and Affected(c,TYPE_TRAP)
end
function KarmaCutFilter2(c)
  return KarmaCutFilter(c) and (PriorityTarget(c) or CardsMatchingFilter(OppGrave(),FilterID,c.id)>0)
end
function ChainKarmaCut()
  local targets = CardsMatchingFilter(OppMon(),KarmaCutFilter)
  local targets2 = CardsMatchingFilter(OppMon(),KarmaCutFilter2)
  local discard = PriorityCheck(AIHand(),PRIO_TOGRAVE,1)>3
  if RemovalCheck(71587526) and targets>0 then
    return discard
  end
  if not UnchainableCheck(71587526) then
    return false
  end
  if targets2>0 then
    return discard
  end
  return false
end
function PWWBFilter(c)
  return Targetable(c,TYPE_TRAP) and Affected(c,TYPE_TRAP)
end
function PWWBFilter2(c)
  return PWWBFilter(c) and PriorityTarget(c)
end
function ChainPWWB()
  local targets = CardsMatchingFilter(OppField(),PWWBFilter)
  local targets2 = CardsMatchingFilter(OppField(),PWWBFilter2)
  local discard = PriorityCheck(AIHand(),PRIO_TOGRAVE,1)>3
  if RemovalCheck(63356631) and targets>0 then
    return discard
  end
  if not UnchainableCheck(63356631) then
    return false
  end
  if targets2>0 then
    return discard
  end
  return false
end
function ChainFarfa()
  return CardsMatchingFilter(OppMon(),FarfaFilter)>0
end
function ChainLibic()
  return CardsMatchingFilter(AIHand(),FarfaFilter)>0
end
function BAChain(cards)
  if HasID(cards,57143342,false,nil,LOCATION_GRAVE) then -- Cir
    OPTSet(57143342)
    return {1,CurrentIndex}
  end
  if HasID(cards,20758643,false,nil,LOCATION_GRAVE) then -- Graff
    OPTSet(20758643)
    return {1,CurrentIndex}
  end
  if HasID(cards,73213494,false,nil,LOCATION_GRAVE) then -- Calcab
    OPTSet(73213494)
    return {1,CurrentIndex}
  end
  if HasID(cards,36551319,false,nil,LOCATION_GRAVE) and ChainFarfa() then -- Farfa
    OPTSet(36551319)
    return {1,CurrentIndex}
  end
  if HasID(cards,09342162,false,nil,LOCATION_GRAVE) then -- Cagna
    OPTSet(09342162)
    return {1,CurrentIndex}
  end
  if HasID(cards,62957424,false,nil,LOCATION_GRAVE) and ChainLibic() then -- Libic
    OPTSet(62957424)
    return {1,CurrentIndex}
  end
  if HasID(cards,00601193,false,nil,LOCATION_GRAVE) then -- Virgil
    return {1,CurrentIndex}
  end
  if HasID(cards,83531441,false,nil,LOCATION_GRAVE) then -- Dante
    return {1,CurrentIndex}
  end
  if HasID(cards,47728740,false,nil,LOCATION_GRAVE) and ChainAlich(cards[CurrentIndex]) then -- Calcab
    OPTSet(47728740)
    return {1,CurrentIndex}
  end
  if HasID(cards,36006208) and ChainFireLake() then
    return {1,CurrentIndex}
  end
  if HasID(cards,71587526) and ChainKarmaCut() then
    return {1,CurrentIndex}
  end
  if HasID(cards,63356631) and ChainPWWB() then
    return {1,CurrentIndex}
  end
  return nil
end

function BAEffectYesNo(id,card)
  local result = nil
  if id==57143342 and FilterLocation(card,LOCATION_GRAVE) then -- Cir
    OPTSet(57143342)
    result = 1
  end
  if id==20758643 and FilterLocation(card,LOCATION_GRAVE) then -- Graff
    OPTSet(20758643)
    result = 1
  end
  if id==73213494 and FilterLocation(card,LOCATION_GRAVE) then -- Calcab
    OPTSet(73213494)
    result = 1
  end
 if id==36551319 and FilterLocation(card,LOCATION_GRAVE) and ChainFarfa() then
    OPTSet(36551319)
    result = 1
  end
  if id==09342162 and FilterLocation(card,LOCATION_GRAVE) then -- Cagna
    OPTSet(09342162)
    result = 1
  end
  if id==62957424 and FilterLocation(card,LOCATION_GRAVE) and ChainLibic() then
    OPTSet(62957424)
    result = 1
  end
  if id==00601193 and FilterLocation(card,LOCATION_GRAVE) then -- Virgil
    result = 1
  end
  if id==83531441 and FilterLocation(card,LOCATION_GRAVE) then -- Dante
    result = 1
  end
  if id==47728740 and ChainAlich(card) then -- Alich
    OPTSet(47728740)
    result = 1
  end
  return result
end
BAAtt={
  00601193,26563200, -- Virgil,Muzurythm
  72167543, -- Downerd
  81330115,31320433,47805931, -- Acid, Nightmare Shark, Giga-Brillant
  75367227,68836428,52558805, -- Alucard, Levia, Temtempo
}
BAVary={
  57143342,73213494,09342162, -- Cir, Calcab, Cagna
  47728740,20758643,62957424, -- Alich, Graff, Libic
}
BADef={
  84764038,00734741,78156759, -- Scarm, Rubic, Zenmaines
  16259549,62957424,36551319,  -- Fortune Tune, Farfa
}

function BAPosition(id,available)
  result = nil
  for i=1,#BAAtt do
    if BAAtt[i]==id 
    then 
      result=POS_FACEUP_ATTACK
    end
  end
  for i=1,#BAVary do
    if BAVary[i]==id 
    then 
      if GlobalBPAllowed and Duel.GetTurnCount()>1 then result=nil else result=POS_FACEUP_DEFENCE end
    end
  end
  for i=1,#BADef do
    if BADef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  return result
end
