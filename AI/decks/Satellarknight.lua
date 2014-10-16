GlobalScepterOverride = 0
function SatellarknightFilter(c)
  return IsSetCode(c.setcode,0x9c) and bit32.band(c.type,TYPE_MONSTER)>0
end
function DenebCond(loc)
  if loc == PRIO_TOFIELD then
    return OPTCheck(75878039)
  end
  if loc == PRIO_TOHAND or loc == PRIO_TOGRAVE then
    return not HasAccess(75878039)
  end
  return true
end
function AltairCond(loc,loop)
  if loc == PRIO_TOFIELD then
    return OPTCheck(02273734)     
    and (loop==nil and HasID(AIGrave(),38667773,true) and VegaCond(PRIO_TOFIELD,true)
    or HasID(AIGrave(),75878039,true) and DenebCond(PRIO_TOFIELD)
    or HasID(AIGrave(),63274863,true) and SiriusCond(PRIO_TOFIELD))
  end
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),02273734,true)
  end
  return true
end
function VegaFilter(c)
  return SatellarknightFilter(c) and c.id~=38667773
end
function VegaCond(loc,loop)
  if loc == PRIO_TOFIELD then
    return OPTCheck(38667773) 
    and (HasID(AIHand(),75878039,true) and DenebCond(PRIO_TOFIELD)
    or   loop==nil and HasID(AIHand(),02273734,true) and AltairCond(PRIO_TOFIELD,true)
    or   HasID(AIHand(),63274863,true) and SiriusCond(PRIO_TOFIELD))
  end
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),38667773,true)
  end
  return true
end
function SiriusCond(loc)
  if loc == PRIO_TOHAND then
    return OPTCheck(63274863) and CardsMatchingFilter(AIGrave(),SatellarknightFilter)>=8
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(63274863) and CardsMatchingFilter(AIGrave(),SatellarknightFilter)>=6
  end
  return true
end
function ScepterCond(loc)
  if loc == PRIO_TOHAND then
    return HasID(AIHand(),91110378,true) and HasID(AIDeck(),91110378,true) and not HasID(AIHand(),38331564,true)
  end
  if loc == PRIO_TOFIELD then
    return HasID(AIHand(),91110378,true) and HasID(AIDeck(),91110378,true) and Duel.GetCurrentChain()==0
  end
  return true
end
function SovereignCond(loc)
  if loc == PRIO_TOHAND then
    return HasID(AIHand(),38331564,true) and HasID(AIDeck(),91110378,true) and not HasID(AIHand(),91110378,true)
  end
  if loc == PRIO_TOFIELD then
    return FieldCheck(4)==2 or FieldCheck(4)==1 and CardsMatchingFilter(AIHand(),function(c) return c.id==91110378 end)>1
  end
  return true
end
function HonestCond(loc)
  if loc == PRIO_TOFIELD then
    return HasID(AIGrave(),37742478,true)
  end
  return true
end
function NodenCond(loc)
  if loc == PRIO_TOFIELD then
    return Duel.GetCurrentChain()==0 and CardsMatchingFilter(AIGrave(),NodenFilter)>0
  end
  return true
end

function SatellarknightGetPriority(id,loc)
  local checklist = nil
  local result = 0
  if loc == nil then
    loc = PRIO_TOHAND
  end
  checklist = Prio[id]
  if checklist then
    if checklist[11] and not(checklist[11](loc)) then
      loc = loc + 1
    end
    result = checklist[loc]
  end
  return result
end
function SatellarknightAssignPriority(cards,loc,filter)
  local index = 0
  Multiple = nil
  for i=1,#cards do
    cards[i].index=i
    cards[i].prio=SatellarknightGetPriority(cards[i].id,loc)
    if filter and not filter(cards[i]) then
      cards[i].prio=-1
    end
    if loc==PRIO_TOFIELD and cards[i].location==LOCATION_DECK then
      cards[i].prio=cards[i].prio+2
    end
    if loc==PRIO_TOFIELD and cards[i].id==38667773 
    and CardsMatchingFilter(AIHand(),VegaFilter)>0 
    and #AIMon()==0
    then
      cards[i].prio=math.max(cards[i].prio,5)
    end
    --if loc==PRIO_GRAVE and cards[i].location==LOCATION_ONFIELD then
      --cards[i].prio=cards[i].prio-1
    --end
    SetMultiple(cards[i].id)
  end
end
function SatellarknightPriorityCheck(cards,loc,count,filter)
  if count == nil then count = 1 end
  if loc==nil then loc=PRIO_TOHAND end
  if cards==nil or #cards<count then return -1 end
  SatellarknightAssignPriority(cards,loc,filter)
  table.sort(cards,function(a,b) return a.prio>b.prio end)
  return cards[count].prio
end
function SatellarknightAdd(cards,loc,count,filter)
  local result={}
  if count==nil then count=1 end
  if loc==nil then loc=PRIO_TOHAND end
  local compare = function(a,b) return a.prio>b.prio end
  SatellarknightAssignPriority(cards,loc,filter)
  table.sort(cards,compare)
  for i=1,count do
    result[i]=cards[i].index
  end
  return result
end
function SeraphCheck()
  return (HasID(AIMon(),38331564,true) and CardsMatchingFilter(UseLists({OppMon(),OppST()}),ScepterFilter)>0) or HasID(AIMon(),91110378,true)
end
function DelterosFilter(c)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and not (DestroyBlacklist(c)
  and (bit32.band(c.position, POS_FACEUP)>0 
  or bit32.band(c.status,STATUS_IS_PUBLIC)>0))
end
function UseDelteros()
  return CardsMatchingFilter(UseLists({OppMon(),OppST()}),DelterosFilter)>0
end
function SummonDelteros()
  return (MP2Check() or SeraphCheck()) 
  and (UseDelteros() or HasID(UseLists({AIHand(),AIST()}),41510920,true))
end
function SummonTriveil()
  local result = 0
  local cards=UseLists({AIMon(),AIST()})
  for i=1,#cards do
    if SatellarknightFilter(cards[i]) and cards[i].level>0 
    or (bit32.band(cards[i].type,TYPE_CONTINUOUS)>0 and bit32.band(cards[i].position,POS_FACEUP)>0)
    then
      result = result + 1
    end
    if bit32.band(cards[i].type,TYPE_XYZ)>0 then
      result = result - 1
    end
  end
  cards=UseLists({OppMon(),OppST()})
  for i=1,#cards do
    if bit32.band(cards[i].type,TYPE_XYZ+TYPE_SYNCHRO+TYPE_RITUAL+TYPE_FUSION)>0 then
      result = result + 3
    elseif bit32.band(cards[i].type,TYPE_MONSTER)>0 and cards[i].level>4 then
      result = result + 2
    elseif bit32.band(cards[i].type,TYPE_CONTINUOUS)>0 and bit32.band(cards[i].position,POS_FACEUP)>0 then
      result = result - 1 
    elseif bit32.band(cards[i].type,TYPE_SPELL+TYPE_TRAP)>0 and bit32.band(cards[i].position,POS_FACEDOWN)>0 then
      result = result + 1
    else
      result = result + 1
    end
  end
  return result >= 8 or (AI.GetPlayerLP(2)<=2100 
  and Duel.GetCurrentPhase()==PHASE_MAIN1 and GlobalBPAllowed)
end 
function ScepterFilter(c)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and not DestroyBlacklist(c)
  and (bit32.band(c.position, POS_FACEUP)>0 
  or bit32.band(c.status,STATUS_IS_PUBLIC)>0)
end
function UseScepter()
  return CardsMatchingFilter(UseLists({OppMon(),OppST()}),ScepterFilter)>0 or HasID(AIMon(),91110378,true)
end
function UseOuroboros1()
  return #OppHand() > 0
end
function OuroborosFilter(c)
  return bit32.band(c.type,TYPE_XYZ+TYPE_SYNCHRO+TYPE_RITUAL+TYPE_FUSION)>0
end
function UseOuroboros2()
  return CardsMatchingFilter(UseLists({OppMon(),OppST()}),OuroborosFilter)>0
end
function UseOuroboros3()
  return #OppGrave > 0
end
function SummonOuroboros()
  return (MP2Check() or SeraphCheck())  and (UseOuroboros1() or UseOuroboros2())
end
function NodenFilter(c)
  return c.level==4 and c.id~=17412721
end
function UseInstantFusion2()
  return CardsMatchingFilter(AIGrave(),NodenFilter)>0 and (FieldCheck(4)==1 
  and OverExtendCheck() or #AIMon()==0) and not DeckCheck(DECK_SHADOLL)
end
function UseCotH2()
  return OverExtendCheck() and (SatellarknightPriorityCheck(AIGrave(),PRIO_TOFIELD,1)>4 
  or FieldCheck(4)<2 and SatellarknightPriorityCheck(AIGrave(),PRIO_TOFIELD,1)>0)
end
function RhongomiantFilter(c)
  return bit32.band(c.race,RACE_WARRIOR)>0 and bit32.band(c.position,POS_FACEUP)>0 and c.level==4
end
function SummonRhongomiant()
  return CardsMatchingFilter(AIMon(),RhongomiantFilter)>=4
end
function SummonRhapsody()
  local cards=AIMon()
  for i=1,#cards do
    if bit32.band(cards[i].type,TYPE_XYZ)>0 and cards[i].attack+1200 > OppGetStrongestAttack() and  #OppGrave()>=2 then
      return MP2Check()
    end
  end
  return false
end
function SummonSharkKnight1(cards)
  if not DeckCheck(DECK_TELLARKNIGHT) then return false end
  local targets=SubGroup(OppMon(),SharkKnightFilter)
  return #targets>0 and OPTCheck(48739166)
end
function SummonLavalvalChain1()
  return DeckCheck(DECK_TELLARKNIGHT) and MP2Check() and (not HasAccess(75878039) or OppGetStrongestAttack()<1800)
end
function SatellarknightOnSelectInit(cards, to_bp_allowed, to_ep_allowed)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  GlobalScepterOverride = 0
  if HasIDNotNegated(Activatable,37742478) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,63504681) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,56638325) and UseDelteros() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,42589641) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,48739166) then
    OPTSet(48739166)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,34086406,false,545382497) and not HasAccess(75878039) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,34086406,false,545382498) then
    GlobalCardMode = 2
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,93568288,false,1497092609) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,93568288,false,1497092608) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,82633039) and UseSkyblaster() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,38273745,false,612379921) and UseOuroboros2() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,38273745,false,612379922) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,38273745,false,612379923) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,38273745,false,612379921) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,32807846) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
if DeckCheck(DECK_TELLARKNIGHT) then
  if HasID(SpSummonable,63504681) and SummonRhongomiant() then
    GlobalSSCardID = 63504681
    GlobalSSCardType = TYPE_XYZ
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,42589641) and SummonTriveil() then
    GlobalSSCardID = 42589641
    GlobalSSCardType = TYPE_XYZ
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,56638325) and SummonDelteros() then
    GlobalSSCardID = 56638325
    GlobalSSCardType = TYPE_XYZ
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,38273745) and SummonOuroboros() then
    GlobalSSCardID = 38273745
    GlobalSSCardType = TYPE_XYZ
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,94380860) and SummonRagnaZero() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,46772449) and SummonBelzebuth() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,48739166) and SummonSharkKnight1() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,82633039) and SummonSkyblaster() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,93568288) and SummonRhapsody() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,34086406) and SummonLavalvalChain1() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,21501505) and SummonCairngorgon() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  SatellarknightAssignPriority(Summonable,PRIO_TOFIELD)
  table.sort(Summonable,function(a,b) return a.prio>b.prio end)
  if #Summonable>0 and (Summonable[1].prio > 4 or Summonable[1].prio > 0 and (HasBackrow(SetableST) or FieldCheck(4)==1))then
    return {COMMAND_SUMMON,Summonable[1].index}
  end
  if HasID(Activatable,01845204) and UseInstantFusion2() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,54447022) and UseSoulCharge() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
end
  return nil
end

function TriveilTarget(cards,c)
  if bit32.band(c.location,LOCATION_GRAVE)>0 then
    return SatellarknightAdd(cards,PRIO_TOFIELD)
  else
    return BestTargets(cards,1,TARGET_DESTROY)
  end
end
function DelterosTarget(cards,c)
  if bit32.band(c.location,LOCATION_GRAVE)>0 then
    return SatellarknightAdd(cards,PRIO_TOFIELD)
  else
    return BestTargets(cards,1,TARGET_DESTROY)
  end
end
function NodenTarget(cards)
  if HasID(cards,38331564) then
    return {CurrentIndex}
  else
    return SatellarknightAdd(cards,PRIO_TOFIELD)
  end
end
function SatellarknightOnSelectCard(cards, minTargets, maxTargets,triggeringID,triggeringCard)
  local ID 
  local result=nil
  if triggeringCard then
    ID = triggeringCard.id
  else
    ID = triggeringID
  end
  if GlobalScepterOverride>0 then
    GlobalScepterOverride = GlobalScepterOverride-1
    return BestTargets(cards,1,TARGET_DESTROY)
  end
  if ID == 75878039 then
    return SatellarknightAdd(cards)
  end
  if ID == 02273734 then
    return SatellarknightAdd(cards,PRIO_TOFIELD)
  end
  if ID == 38667773 then
    return SatellarknightAdd(cards,PRIO_TOFIELD)
  end
  if ID == 63274863 then
    return SatellarknightAdd(cards,PRIO_DISCARD,5)
  end
  if ID == 38331564 then
    return SatellarknightAdd(cards)
  end
  if ID == 32807846 then
    return Add(cards)
  end
  if ID == 01845204 then
    return SatellarknightAdd(cards,PRIO_TOFIELD)
  end
  if ID == 56638325 then
    return DelterosTarget(cards,triggeringCard)
  end
  if ID == 42589641 then
    return TriveilTarget(cards,triggeringCard)
  end
  if ID == 41510920 then
    return SatellarknightAdd(cards,PRIO_TOGRAVE)
  end
  if ID == 17412721 then
    return NodenTarget(cards)
  end
  if ID == 97077563 and DeckCheck(DECK_TELLARKNIGHT) then
    return SatellarknightAdd(cards,PRIO_TOFIELD)
  end
  if ID == 25789292 then
    return GlobalTarget(cards,GlobalPlayer)
  end
  if ID == 93568288 then
    return BestTargets(cards)
  end
  if ID == 21501505 then
    return BestTargets(cards)
  end
  if ID == 38273745 then
    return BestTargets(cards,1,TARGET_TOHAND)
  end
  return nil
end

function ChainFactor()
 local p = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_PLAYER)
 return (p and p ~= player_ai) 
end
function ChainCairngorgon()
 local p = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_PLAYER)
 return (p and p ~= player_ai)
end
function ChainCotH2()
  if not DeckCheck(DECK_TELLARKNIGHT) then
    return false
  end
  if RemovalCheck(97077563) and SatellarknightPriorityCheck(AIGrave(),PRIO_TOFIELD)>1 then
    return true
  end
  if Duel.GetCurrentPhase()==PHASE_END and Duel.CheckTiming(TIMING_END_PHASE) and Duel.GetTurnPlayer() == 1-player_ai then
    return OverExtendCheck() and SatellarknightPriorityCheck(AIGrave(),PRIO_TOFIELD)>4
  end
end
function ChainChalice()
  local e = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
	if e then
    c=e:GetHandler()
    if player_ai==nil then
      player=1
    else
      player=player_ai
    end
    if c and c:IsControler(1-player) and c:IsLocation(LOCATION_MZONE) 
    and NegateBlacklist(c:GetCode())==0 and c:IsCanBeEffectTarget()
    and not c:IsHasEffect(EFFECT_IMMUNE_EFFECT)
    and not c:IsHasEffect(EFFECT_DISABLE)
    and not c:IsHasEffect(EFFECT_DISABLE_EFFECT)
    then
      GlobalTargetID=c:GetCode()
      GlobalPlayer=2
      return true
    end
  end
  if c and (c:GetCode()==27243130 or c:GetCode()==37742478) then
    return false
  end
  local source = Duel.GetAttacker()
	local target = Duel.GetAttackTarget()
  if source and target then
    if source:IsControler(player_ai) then
      target = Duel.GetAttacker()
      source = Duel.GetAttackTarget()
    end
  end
  if Duel.GetCurrentPhase() == PHASE_DAMAGE and source and target then
    if source:GetAttack() >= target:GetAttack() 
    and source:GetAttack() <= target:GetAttack()+QliphortAttackBonus(target:GetCode(),target:GetLevel())+400 
    and source:IsPosition(POS_FACEUP_ATTACK) and target:IsPosition(POS_FACEUP_ATTACK) and target:IsControler(player_ai)
    and (not target:IsHasEffect(EFFECT_IMMUNE_EFFECT) or target:IsSetCard(0xaa) and target:GetCode()~=27279764)
    then
      GlobalTargetID=target:GetCode()
      GlobalPlayer=1
      return true
    end
  end
  return false
end
function SatellarknightOnSelectChain(cards,only_chains_by_player)
  for i=1,#cards do
    if SatellarknightFilter(cards[i]) and NotNegated(cards[i]) then
      OPTSet(cards[i].id)
      return {1,i}
    end
  end
  if HasIDNotNegated(cards,38331564) then   -- Scepter
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,91110378) then   -- Sovereign
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,17412721) then   -- Elder God Noden
    return {1,CurrentIndex}
  end
  --if HasID(cards,41510920) and ChainFactor() then
    --return {1,CurrentIndex}
  --end
  if HasID(cards,21501505) and ChainCairngorgon() then
    return {1,CurrentIndex}
  end
  if HasID(cards,97077563) and ChainCotH2() then
    return {1,CurrentIndex}
  end
  if HasID(cards,82732705) and ChainSkillDrain() then
    return {1,CurrentIndex}
  end
  if HasID(cards,25789292) and ChainChalice() then
    return {1,CurrentIndex}
  end
  return nil
end


function SatellarknightOnSelectEffectYesNo(id,card)
  local result = nil
  local field = bit32.band(card.location,LOCATION_ONFIELD)>0
  local grave = bit32.band(card.location,LOCATION_GRAVE)>0
  if GlobalScepterOverride>0 and UseScepter() then
    return 1
  end
  if SatellarknightFilter(card) and NotNegated(card) then
    OPTSet(card.id)
    result = 1
  end
  if id==38331564 and NotNegated(card) then
    result = 1
  end
  if id==91110378 and NotNegated(card) then
    result = 1
  end
  if id==17412721 and NotNegated(card) then
    result = 1
  end
  if id==21501505 and ChainCairngorgon() and NotNegated(card) then
    result = 1
  end
  return result
end


SatellarknightAtt={
  42589641,63504681,82633039,21501505
}
SatellarknightDef={
  91110378,38667773,17412721,93568288
}
function SatellarknightOnSelectPosition(id, available)
  result = nil
  for i=1,#SatellarknightAtt do
    if SatellarknightAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#SatellarknightDef do
    if SatellarknightDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  return result
end