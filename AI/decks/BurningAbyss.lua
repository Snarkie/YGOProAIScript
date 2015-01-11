function BAFilter(c,exclude)
  return IsSetCode(c.setcode,0xb1) and (exclude == nil or c.id~=exclude)
end
function BAMonsterFilter(c,boss)
  return FilterType(c,TYPE_MONSTER) and BAFilter(c)
  and (not boss or FilterID(c,00601193) or FilterID(c,83531441))
end
function ScarmGraveFilter(c)
  return c.id == 84764038 and c.turnid == Duel.GetTurnCount()
end
function ScarmDeckFilter(c)
  return FilterLevel(c,3) and FilterAttribute(c,ATTRIBUTE_DARK)
  and FilterRace(c,RACE_FIEND) and not c.id == 84764038
end
function ScarmCond(c,loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(84764038) and CardsMatchingFilter(AIGrave(),ScarmGraveFilter)==0
    and CardsMatchingFilter(AIDeck(),ScarmDeckFilter)>0
  end
  return true
end
function GraffCond(c,loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(20758643) and CardsMatchingFilter(AIDeck(),BAFilter,20758643)>0
  end
  return true
end
function CirCond(c,loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(57143342) and CardsMatchingFilter(AIGrave(),BAFilter,57143342)>0
  end
  return true
end
function AlichFilter(c)
  return FilterType(c,TYPE_MONSTER+TYPE_EFFECT) 
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET) == 0
end
function AlichCond(c,loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(47728740) and CardsMatchingFilter(OppMon(),AlichFilter)>0
  end
  return true
end
function CalcabFilter(c)
  return FilterPosition(c,POS_FACEDOWN) 
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET) == 0
end
function CalcabCond(c,loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(73213494) and CardsMatchingFilter(OppST(),CalcabFilter)>0
  end
  return true
end
function RubicCond(c,loc)
  return true
end
function DanteCond(c,loc)
  if loc == PRIO_TOGRAVE then
    return CardsMatchingFilter(AIGrave(),BAFilter)>0
  end
  return true
end
function VirgilCond(c,loc)
  return true
end
function BAInit(cards)
  GlobalPreparation = nil
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  if HasID(Act,96729612) and UsePreparation() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  return nil
end
function BACard(cards,min,max,id,c)
  if c then
    id = c.id
  end
  if id == 99185129 then
    return ClausTarget(cards)
  end
  return nil
end

function BAChain(cards)
  if HasID(cards,79606837,false,nil,LOCATION_GRAVE) then -- Rainbow Herald
    return {1,CurrentIndex}
  end
  return nil
end

function BAEffectYesNo(id,card)
  local result = nil
  if id==79606837 and FilterLocation(card,LOCATION_GRAVE) then -- Rainbow Herald
    result = 1
  end
  return result
end
BAAtt={
  00601193,57143342,73213494, -- Virgil, Cir, Calcab
  47728740,20758643,72167543, -- Alich, Graff, Downerd
  81330115,31320433,47805931, -- Acid, Nightmare Shark, Giga-Brillant
  75367227,68836428,52558805, -- Alucard, Levia, Temtempo
}
BADef={
  84764038,00734714,78156759, -- Scarm, Rubic, Zenmaines
  16259549  -- Fortune tune
}
function BAPosition(id,available)
  result = nil
  for i=1,#BAAtt do
    if BAAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#BADef do
    if BADef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  return result
end
