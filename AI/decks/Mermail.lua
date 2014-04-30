Mermail = nil
function MermailCheck()
  if Mermail == nil then
    Mermail = HasID(UseLists({AIDeck(),AIHand()}),21954587) -- check if the deck has Megalo
  end 
  return Mermail
end
function InfantryFilter(c)
  return bit32.band(c.position,POS_FACEUP)>0 and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0 --and c.owner==2
end
function InfantryCond(loc)
  if loc == PRIO_TOHAND then
    return CardsMatchingFilter(UseLists({OppMon(),OppST()}),InfantryFilter)
    > CardsMatchingFilter(AIHand(),function(c) return c.id==37104630 end)
  elseif loc == PRIO_DISCARD then
    return CardsMatchingFilter(UseLists({OppMon(),OppST()}),InfantryFilter)
    > MermailGetMultiple(37104630)
  end
  return true
end
function MarksmanFilter(c)
    return bit32.band(c.position,POS_FACEDOWN)>0 and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0 --and c.owner==2
end
function MarksmanCond(loc)
  if loc == PRIO_TOHAND then
    return CardsMatchingFilter(UseLists({OppMon(),OppST()}),MarksmanFilter)
    > CardsMatchingFilter(AIHand(),function(c) return c.id==00706925 end)
  elseif loc == PRIO_DISCARD then
    return CardsMatchingFilter(UseLists({OppMon(),OppST()}),MarksmanFilter)
    > MermailGetMultiple(00706925)
  elseif loc == PRIO_TOFIELD then
    return #OppMon()==0 and Duel.GetTurnCount()>0
  end
  return true
end
function GundeFilter(c)
  return bit32.band(c.type,TYPE_MONSTER)>0 and bit32.band(c.setcode,0x74)==0x74 and c.id~=69293721
end
function GundeCond(loc)
  if loc == PRIO_DISCARD then
    return CardsMatchingFilter(AIGrave(),GundeFilter)>0
    and OPTCheck(69293721)
    and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
  end
  return true
end
function PikeCond(loc)
  if loc == PRIO_TOFIELD then
    return (MermailPriorityCheck(AIHand(),PRIO_DISCARD) > 4 
    or MermailPriorityCheck(AIDeck(),PRIO_TOHAND) > 4
    and MermailPriorityCheck(AIHand(),PRIO_DISCARD) > 1 )
    and OPTCheck(58471134)
    and Duel.GetCurrentChain()<=1
  end
  return true
end
function TurgeFilter(c)
  return c.level<=3 and bit32.band(c.attribute,ATTRIBUTE_WATER)>0
end
function TurgeCond(loc)
  if loc == PRIO_TOFIELD then
    return (MermailPriorityCheck(AIHand(),PRIO_DISCARD) > 4 
    or MermailPriorityCheck(AIGrave(),PRIO_TOHAND) > 4
    and MermailPriorityCheck(AIHand(),PRIO_DISCARD) > 1 )
    and CardsMatchingFilter(AIGrave(),TurgeFilter)>0
    and OPTCheck(22076135)
    and Duel.GetCurrentChain()<=1
  end
  return true
end
function LindeCond(loc)
  local cards=UseLists({AIHand(),AIMon()})
  local check = not(HasID(cards,23899727,true) or (HasIDNotNegated(cards,23899727,true) and HasID(AIDeck(),23899727,true)))
  if loc == PRIO_TOHAND then 
    return check
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(23899727) and check
  end
  return true
end
function MegaloCond(loc)
  if loc == PRIO_TOHAND then
    return MermailPriorityCheck(AIHand(),PRIO_DISCARD,2)>5
  end
  return true
end
function TeusCond(loc)
  if loc == PRIO_TOHAND then
    return MermailPriorityCheck(AIHand(),PRIO_DISCARD)>5
  end
  return true
end
function LeedCond(loc)
  if loc == PRIO_TOHAND then
    return MermailPriorityCheck(AIHand(),PRIO_DISCARD,3)>5
    and CardsMatchingFilter(AIGrave(),function(c) return bit32.band(c.setcode,0x75)>0 and bit32.band(c.type,TYPE_SPELL+TYPE_TRAP)>0 end)>0 
  end
  return true
end
function TidalCond(loc)
  return true
end
MermailPrio = {}
MermailPrio[21954587] = {6,3,5,3,4,1,2,1,1,MegaloCond} -- Mermail Abyssmegalo
MermailPrio[22446869] = {7,3,4,2,2,1,1,1,1,TeusCond} -- Mermail Abyssteus
MermailPrio[37781520] = {7,1,6,4,6,1,3,1,1,LeedCond} -- Mermail Abyssleed
MermailPrio[58471134] = {4,2,7,2,2,1,1,1,1,PikeCond} -- Mermail Abysspike
MermailPrio[22076135] = {4,2,7,2,2,1,1,1,1,TurgeCond} -- Mermail Abyssturge
MermailPrio[69293721] = {7,5,0,0,0,0,7,1,0,GundeCond} -- Mermail Abyssgunde
MermailPrio[23899727] = {5,2,3,2,1,1,1,1,1,LindeCond} -- Mermail Abysslinde
MermailPrio[37104630] = {5,2,0,0,1,1,6,1,2,InfantryCond} -- Atlantean Heavy Infantry
MermailPrio[00706925] = {5,2,5,1,1,1,6,1,2,MarksmanCond} -- Atlantean Marksman
MermailPrio[74311226] = {7,5,2,1,1,1,6,4,2,nil} -- Atlantean Dragoons
MermailPrio[26400609] = {6,3,4,2,5,4,5,4,0,TidalCond} -- Tidal
MermailPrio[78868119] = {4,2,2,2,2,1,2,1,2,nil} -- Deep Sea Diva
PRIO_TOHAND = 1
PRIO_TOFIELD = 3
PRIO_TOGRAVE = 5
PRIO_DISCARD = 7
PRIO_BANISH = 9
OPT={}
function OPTCheck(id)
  return OPT[id]~=Duel.GetTurnCount()
end
function OPTSet(id)
  OPT[id]=Duel.GetTurnCount()
end
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
  if GlobalSummonLinde and id==23899727 
  and loc == PRIO_TOFIELD and OPTCheck(23899727) 
  then
    result = 10
  end
  return result
end
function MermailAssignPriority(cards,loc,filter)
  local index = 0
  MermailMultiple = nil
  for i=1,#cards do
    cards[i].index=i
    cards[i].prio=MermailGetPriority(cards[i].id,loc)
    if filter and not filter(cards[i]) then
      cards[i].prio=-1
    end
    MermailSetMultiple(cards[i].id)
  end
end
function MermailPriorityCheck(cards,loc,count,filter)
  if count == nil then count = 1 end
  if loc==nil then loc=PRIO_TOHAND end
  if cards==nil or #cards<count then return -1 end
  MermailAssignPriority(cards,loc,filter)
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
  return MermailPriorityCheck(AIHand(),PRIO_DISCARD)>4
end
function UseLeed(card)
  if bit32.band(card.location,LOCATION_HAND)>0 then
    return MermailPriorityCheck(AIHand(),PRIO_DISCARD,3)>5 
    and CardsMatchingFilter(AIGrave(),function(c) return bit32.band(c.setcode,0x75)>0 and bit32.band(c.type,TYPE_SPELL+TYPE_TRAP)>0 end)>0 
  end
end
function UsePike()
  return PikeCond(PRIO_TOFIELD)
end
function UseTurge()
  return TurgeCond(PRIO_TOFIELD)
end
function UseSalvage()
  return MermailPriorityCheck(AIGrave(),PRIO_TOHAND,2,function(c) return bit32.band(c.attribute,ATTRIBUTE_WATER)>0 and c.attack<=1500 end)>2
end
function MermailOnSelectInit(cards, to_bp_allowed, to_ep_allowed)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  MermailTargets = {}
  GlobalSummonLinde=nil
  if HasID(Activatable,70368879) then -- Upstart Goblin
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,96947648) and UseSalvage() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,21954587) and UseMegalo(Activatable[CurrentIndex]) then
    GlobalCardMode=1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,22446869) and UseTeus() then
    GlobalCardMode=1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,37781520) and UseLeed(Activatable[CurrentIndex]) then
    GlobalCardMode=1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Summonable,22076135) and (UseTurge() or FieldCheck(4)==1) then
    return {COMMAND_SUMMON,IndexByID(Summonable,22076135)}
  end
  if HasID(Summonable,58471134) and (UsePike() or FieldCheck(4)==1) then
    return {COMMAND_SUMMON,IndexByID(Summonable,58471134)}
  end
  if HasID(SetableMon,23899727) then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(Summonable,78868119) and OverExtendCheck() then
    return {COMMAND_SUMMON,IndexByID(Summonable,78868119)}
  end
  local check = MermailPriorityCheck(AIHand(),PRIO_DISCARD)>1 and OverExtendCheck()
  if HasID(Activatable,22446869) and check then
    GlobalCardMode=1
    return {COMMAND_ACTIVATE,IndexByID(Activatable,22446869)}
  end
  if HasID(Activatable,21954587) and MermailPriorityCheck(AIHand(),PRIO_DISCARD)>5  
  and MermailPriorityCheck(AIHand(),PRIO_DISCARD,2)>1 
  then
    GlobalCardMode=1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Summonable,22076135) and check then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,58471134) and check then
    return {COMMAND_SUMMON,CurrentIndex}
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
  local result=nil
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
  if ID == 58471134 or ID == 22076135 or ID == 21954587 
  or ID == 37781520 or ID == 22446869 or ID == 74311226
  then
    if GlobalCardMode==1 then
      count=1
      if ID == 21954587 then count = 2 end
      if ID == 37781520 then count = 3 end
      result=MermailAdd(cards,PRIO_DISCARD,count)
    else
      result=MermailAdd(cards,PRIO_TOHAND)
    end
    GlobalCardMode=nil
    if result==nil then result = {math.random(#cards)} end
    return result
  end
  if ID == 23899727 or ID == 60202749 or ID == 69293721 or ID == 78868119 then
    return MermailAdd(cards,PRIO_TOFIELD)
  end
  if ID == 96947648 then
    return MermailAdd(cards,PRIO_TOHAND,2)
  end
  return nil
end

function ChainSphere()
  local cg = RemovalCheck()
  if cg and cg:IsExists(function(c) return c:IsControler(player_ai) and c:IsCode(60202749) end, 1, nil) then
    return true
  end
  if Duel.GetCurrentPhase() == PHASE_MAIN2 and Duel.GetTurnPlayer() == 1-player_ai 
  and HasID(AIDeck(),23899727,true) and LindeCond(PRIO_TOFIELD) 
  then
    return true
  end
  if Duel.GetCurrentPhase() == PHASE_BATTLE and Duel.GetTurnPlayer() == 1-player_ai
  and HasID(AIDeck(),23899727,true) and LindeCond(PRIO_TOFIELD) 
  then
    return Duel.GetAttacker() and #AIMon()==0
  end
  return false
end
function ChainReckless()
  local cg = RemovalCheck()
  local cards = AIMon()
  if cg then
    return cg:IsExists(function(c) return c:IsControler(player_ai) and c:IsCode(37576645) end, 1, nil)
  end
  if Duel.GetCurrentPhase() == PHASE_END and Duel.GetTurnPlayer() == 1-player_ai
  and (#AIHand()<3 or Duel.IsPlayerAffectedByEffect(player_ai,EFFECT_SKIP_DP)) 
  then
    return true
  end
  return false
end
function MermailOnSelectChain(cards,only_chains_by_player)
  MermailTargets = {}
  if HasID(cards,37576645) and ChainReckless() then
    return {1,CurrentIndex}
  end
  if HasID(cards,58471134) and UsePike() then
    OPTSet(58471134)
    GlobalCardMode = 1
    return {1,CurrentIndex}
  end
  if HasID(cards,22076135) and UseTurge() then
    OPTSet(22076135)
    GlobalCardMode = 1
    return {1,CurrentIndex}
  end
  if HasID(cards,60202749) and ChainSphere() then
    GlobalSummonLinde=true
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
  if HasID(cards,69293721) then
    return {1,CurrentIndex}
  end
  if HasID(cards,23899727) then
    OPTSet(22076135)
    return {1,CurrentIndex}
  end
  return nil
end

function MermailOnSelectEffectYesNo(id)
  local result = nil
  if id==37781520 or id==21954587 or id==22446869 or id==69293721 or id==23899727 then
    OPTSet(id)
    result = 1
  end
  if id==58471134 and UsePike() then
    OPTSet(58471134)
    GlobalCardMode = 1
    result = 1
  end
  if id==22076135 and UseTurge() then
    OPTSet(22076135)
    GlobalCardMode = 1
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