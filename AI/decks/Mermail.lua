Mermail = nil
function MermailCheck()
  if Mermail == nil then
    Mermail = HasID(UseLists({AIDeck(),AIHand()}),21954587) -- check if the deck has Megalo
  end 
  return Mermail
end
function InfantryFilter(c)
  return c:IsPosition(POS_FACEUP) and c:IsCanBeEffectTarget() and not(c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT))
end
function InfantryCond(loc)
  if loc == PRIO_TOHAND then
    return Duel.GetMatchingGroup(InfantryFilter,1-player_ai,LOCATION_ONFIELD,0,nil):GetCount()
    > Duel.GetMatchingGroup(function(c) return c:IsCode(37104630) end,player_ai,LOCATION_HAND,0,nil):GetCount()
  elseif loc == PRIO_DISCARD then
    return Duel.GetMatchingGroup(InfantryFilter,1-player_ai, LOCATION_ONFIELD,0,nil):GetCount()
    > MermailGetMultiple(37104630)
  end
  return true
end
function MarksmanFilter(c)
  return c:IsPosition(POS_FACEDOWN) and c:IsCanBeEffectTarget() and not(c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT))
end
function MarksmanCond(loc)
  if loc == PRIO_TOHAND then
    return Duel.GetMatchingGroup(MarksmanFilter,1-player_ai,LOCATION_ONFIELD,0,nil):GetCount()
    > Duel.GetMatchingGroup(function(c) return c:IsCode(00706925) end,player_ai,LOCATION_HAND,0,nil):GetCount()
  elseif loc == PRIO_DISCARD then
    return Duel.GetMatchingGroup(MarksmanFilter,1-player_ai,LOCATION_ONFIELD,0,nil):GetCount()
    > MermailGetMultiple(00706925)
  elseif loc == PRIO_TOFIELD then
    return Duel.GetMatchingGroup(nil,1-player_ai,LOCATION_MZONE,0,nil):GetCount() == 0
  end
  return true
end
function GundeFilter(c)
  return c:IsSetCard(0x74) and c:GetCode()~=69293721
end
function GundeCond(loc)
  if loc == PRIO_DISCARD then
    return Duel.GetMatchingGroup(GundeFilter,player_ai,LOCATION_GRAVE,0,nil):GetCount()>0
    and Duel.GetFlagEffect(player_ai,69293721)==0
  end
  return true
end
function PikeCond(loc)
  if loc == PRIO_TOFIELD then
    return MermailPriorityCheck(AIHand(),PRIO_DISCARD) > 4
  end
  return true
end
function TurgeFilter(c)
  return c:GetLevel()<=3 and c:IsAttribute(ATTRIBUTE_WATER)
end
function TurgeCond(loc)
  if loc == PRIO_TOFIELD then
    return MermailPriorityCheck(AIHand(),PRIO_DISCARD) > 4 
    and Duel.GetMatchingGroup(TurgeFilter,player_ai,LOCATION_GRAVE,0,nil):GetCount()>0
  end
  return true
end
function LindeCond(loc)
  if loc == PRIO_TOFIELD then
    return Duel.GetFlagEffect(player_ai,23899727)==0
  end
  return true
end
MermailPrio = {}
MermailPrio[21954587] = {5,1,5,1,4,1,2,1,1,nil} -- Mermail Abyssmegalo
MermailPrio[22446869] = {6,1,4,1,2,1,1,1,1,nil} -- Mermail Abyssteus
MermailPrio[37781520] = {1,1,6,1,6,1,3,1,1,nil} -- Mermail Abyssleed
MermailPrio[37781520] = {4,2,3,2,2,1,1,1,1,PikeCond} -- Mermail Abysspike
MermailPrio[37781520] = {4,2,3,2,2,1,1,1,1,TurgeCond} -- Mermail Abyssturge
MermailPrio[69293721] = {7,5,0,0,0,0,7,1,0,GundeCond} -- Mermail Abyssgunde
MermailPrio[23899727] = {5,2,4,2,1,1,1,1,1,LindeCond} -- Mermail Abysslinde
MermailPrio[37104630] = {6,2,0,0,1,1,6,1,2,InfantryCond} -- Atlantean Heavy Infantry
MermailPrio[00706925] = {6,2,5,1,1,1,6,1,2,MarksmanCond} -- Atlantean Marksman
MermailPrio[74311226] = {7,5,2,1,1,1,6,4,2,nil} -- Atlantean Dragoons
MermailPrio[26400609] = {6,1,4,2,5,4,5,4,0,TidalCond} -- Tidal
PRIO_TOHAND = 1
PRIO_TOFIELD = 3
PRIO_TOGRAVE = 5
PRIO_DISCARD = 7
PRIO_BANISH = 9
function MermailGetPriority(id,loc)
  local checklist = nil
  local result = 0
  if loc == nil then
    loc = PRIO_TOHAND
  end
  checklist = MermailPrio[id]
  if checklist then
    if checklist[10] and not(checklist[10](loc)) then
      loc = loc + 1
    end
    result = checklist[loc]
  end
  return result
end
function MermailAssignPriority(cards,loc)
  local index = 0
  MermailMultiple = nil
  for i=1,#cards do
    cards[i].index=i
    cards[i].prio=MermailGetPriority(cards[i].id,loc)
    MermailSetMultiple(cards[i].id)
  end
end
function MermailPriorityCheck(cards,loc,count)
  if count == nil then count = 1 end
  if loc==nil then loc=PRIO_TOHAND end
  if #cards==0 then return -1 end
  MermailAssignPriority(cards,loc)
  table.sort(cards,function(a,b) return a.prio>b.prio end)
  return cards[count].prio
end
function MermailAdd(cards,loc,count)
  local result={}
  if count==nil then count=1 end
  if loc==nil then loc=PRIO_TOHAND end
  local compare = function(a,b) return a.prio>b.prio end
  MermailAssignPriority(cards,loc)
  table.sort(cards,compare)
  for i=1,count do
    result[i]=cards[i].index
  end
  return result
end

-- used to keep track of how many cards with the same id got a priority request
-- so the AI does not discard multiple Marksmen to kill one card, for example
MermailMultiple = nil
function MermailSetMultiple(id)
  if MermailMultiple == nil then
    MermailMultiple = {}
  end
  MermailMultiple[#MermailMultiple+1]=id
end
function MermailGetMultiple(id)
  local result = 0
  if MermailMultiple then
    for i=1,#MermailMultiple do
      if MermailMultiple[i]==id then
        result = result + 1
      end
    end
  end
  return result
end
function UseMegalo(card)
  if bit32.band(card.location,LOCATION_HAND)>0 then
    return MermailPriorityCheck(AIHand(),PRIO_DISCARD,2)>5
  end
end
function UseTeus()
  return MermailPriorityCheck(AIHand(),PRIO_DISCARD)>5
end
function UseLeed(card)
  if bit32.band(card.location,LOCATION_HAND)>0 then
    return MermailPriorityCheck(AIHand(),PRIO_DISCARD,3)>5 and Duel.GetMatchingGroup(function(c) return c:IsSetCard(0x75) and c:IsType(TYPE_SPELL+TYPE_TRAP) end,player_ai,LOCATION_GRAVE,0,nil):GetCount()>0 
  end
end
function MermailOnSelectInit(cards, to_bp_allowed, to_ep_allowed)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  MermailTargets = {}
  if HasID(Activatable,21954587) and UseMegalo(Activatable[CurrentIndex]) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,22446869) and UseTeus() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,37781520) and UseLeed(Activatable[CurrentIndex]) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  cards=AIHand()
  for i=1,#cards do
    --print(i..": ID: "..cards[i].id..", Prio: "..MermailGetPriority(cards[i].id))
  end
  --
  return nil
end
MermailTargets = {}
function MermailMultiTargetFilter(card) 
  local result = 0
  for i=1,#MermailTargets do
    if MermailTargets[i]==card.cardid then
      result = result+1
    end
  end
  return result==0
end
function BestTargetsMermail(cards,count)
  local result = BestTargets(cards,1,true,MermailMultiTargetFilter)
  local c = cards[1]
  MermailTargets[#MermailTargets+1]=c.cardid
  return {cards[1].index}
end
function MermailOnSelectCard(cards, minTargets, maxTargets,triggeringID,triggeringCard)
  local ID 
  if triggeringCard then
    ID = triggeringCard.id
  else
    ID = triggeringID
  end
  if ID == 37104630 then
    return BestTargetsMermail(cards,1)
  end
  if ID == 00706925 then
    return BestTargetsMermail(cards,1)
  end
  if ID == 58471134 then
    if GlobalCardMode==1 then
    else
    end
  end
  return nil
end
function ChainPike()
  return PikeCond(PRIO_TOFIELD)
end
function ChainTurge()
  return TurgeCond(PRIO_TOFIELD)
end
function MermailOnSelectChain(cards,only_chains_by_player)
  MermailTargets = {}
  if HasID(cards,58471134) and ChainPike() then
    return {1,CurrentIndex}
  end
  if HasID(cards,22076135) and ChainTurge() then
    return {1,CurrentIndex}
  end
  if HasID(cards,21954587) then
    return {1,CurrentIndex}
  end
  if HasID(cards,37781520) then
    return {1,CurrentIndex}
  end
  if HasID(cards,22446869) then
    return {1,CurrentIndex}
  end
  return nil
end

function MermailOnSelectEffectYesNo(id)
  local result = nil
  if id==37781520 or id==21954587 or id==22446869 then
    result = 1
  end
  if id==58471134 and ChainPike() then
    result = 1
  end
  if id==22076135 and ChainTurge() then
    result = 1
  end
  return result
end

MermailAtt={
  21954587 -- Megalo
}
MermailDef={
}
function MermailOnSelectPosition(id, available)
  result = nil
  for i=1,#MermailAtt do
    if MermailAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#MermailDef do
    if MermailDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  return result
end