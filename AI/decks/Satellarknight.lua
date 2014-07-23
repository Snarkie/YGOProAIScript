Satellarknight = nil
GlobalScepterOverride = 0
function SatellarknightCheck()
  if Satellarknight == nil then
    Satellarknight = HasID(UseLists({AIDeck(),AIHand()}),75878039,true) -- check if the deck has Satellarknight Deneb
  end 
  return Satellarknight
end
function SatellarknightFilter(c)
  return IsSetCode(c.setcode,0x9c) and bit32.band(c.type,TYPE_MONSTER)>0
end
function NotNegated(card)
  return card:is_affected_by(EFFECT_DISABLE)==0 and card:is_affected_by(EFFECT_DISABLE_EFFECT)==0
end
function HasAccess(id)
  -- returns true, if the AI has a card of this ID in hand, field, grave, or as an XYZ material
  for i=1,#AIMon() do
    local cards = AIMon()[i].xyz_materials
    if cards and #cards>0 then
      for j=1,#cards do
        if cards[j].id==id then return true end
      end
    end
  end
  return HasID(UseLists({AIHand(),AIMon(),AIGrave()}),id,true) 
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
    and (not(loop) and HasID(AIGrave(),38667773,true) and VegaCond(PRIO_TOFIELD,true)
    or HasID(AIGrave(),75878039,true) and DenebCond(PRIO_TOFIELD)
    or HasID(AIGrave(),00109227,true) and SiriusCond(PRIO_TOFIELD))
  end
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),02273734,true)
  end
  return true
end
function VegaCond(loc,loop)
  if loc == PRIO_TOFIELD then
    return OPTCheck(38667773) 
    and (HasID(AIHand(),75878039,true) and DenebCond(PRIO_TOFIELD)
    or   not(loop) and HasID(AIHand(),02273734,true) and AltairCond(PRIO_TOFIELD,true)
    or   HasID(AIHand(),00109227,true) and SiriusCond(PRIO_TOFIELD))
  end
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),38667773,true)
  end
  return true
end
function SiriusCond(loc)
  if loc == PRIO_TOHAND then
    return OPTCheck(00109227) and CardsMatchingFilter(AIGrave(),SatellarknightFilter)>=8
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(00109227) and CardsMatchingFilter(AIGrave(),SatellarknightFilter)>=6
  end
  return true
end
function ScepterCond(loc)
  if loc == PRIO_TOFIELD then
    return HasID(AIHand(),91110378,true) and HasID(AIDeck(),91110378,true) and Duel.GetCurrentChain()==0
  end
  return true
end
function SovereignCond(loc)
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
SatellarknightPrio = {
[75878039] = {8,1,5,4,8,5,4,2,1,DenebCond},  -- Satellarknight Deneb
[02273734] = {6,4,7,3,3,1,6,1,1,AltairCond}, -- Satellarknight Altair
[38667773] = {5,3,8,2,4,1,5,1,1,VegaCond},   -- Satellarknight Vega
[00109227] = {7,2,6,1,6,1,1,1,1,SiriusCond}, -- Satellarknight Sirius
[38331564] = {8,4,9,4,3,1,1,1,1,ScepterCond},-- Star Seraph Scepter
[91110378] = {5,3,4,0,4,1,1,1,1,SovereignCond}, -- Star Seraph Sovereign
[37742478] = {6,4,5,0,1,1,1,1,1,HonestCond}, -- Honest

[32807846] = {9,3,1,1,1,1,1,1,1,nil},       -- RotA
[01845204] = {4,1,1,1,1,1,1,1,1,nil},       -- Instant Fusion
[14087893] = {3,1,1,1,1,1,1,1,1,nil},       -- Book of Moon
[54447022] = {5,1,1,1,1,1,1,1,1,nil},       -- Soul Charge
[05318639] = {3,1,1,1,1,1,1,1,1,nil},       -- MST
[25789292] = {3,1,1,1,1,1,1,1,1,nil},       -- Forbidden Chalice

[41510920] = {6,2,1,1,1,1,1,1,1,nil},       -- Celestial Factor
[97077563] = {4,1,1,1,1,1,1,1,1,nil},       -- Call of the Haunted
[34507039] = {3,1,1,1,1,1,1,1,1,nil},       -- Wiretap
[78474168] = {3,1,1,1,1,1,1,1,1,nil},       -- Breakthrough Skill
[94192409] = {3,1,1,1,1,1,1,1,1,nil},       -- Compulsory Evacuation Device
[29401950] = {3,1,1,1,1,1,1,1,1,nil},       -- Bottomless Trap Hole
[84749824] = {3,1,1,1,1,1,1,1,1,nil},       -- Solemn Warning
[53582587] = {3,1,1,1,1,1,1,1,1,nil},       -- Torrential Tribute

[63504681] = {1,1,1,1,1,1,1,1,1,nil},       -- Heroic Champion - Rhongomiant
[21044178] = {1,1,1,1,1,1,1,1,1,nil},       -- Abyss Dweller
[21501505] = {1,1,1,1,1,1,1,1,1,nil},       -- Cairngorgon, Antiluminescent Knight
[93568288] = {1,1,1,1,1,1,1,1,1,nil},       -- Number 80: Rhapsody in Berserk
[46772449] = {1,1,1,1,1,1,1,1,1,nil},       -- Evilswarm Exciton Knight
[94380860] = {1,1,1,1,1,1,1,1,1,nil},       -- Number 103: Ragnazero
[34076406] = {1,1,1,1,1,1,1,1,1,nil},       -- Lavalval Chain
[48739166] = {1,1,1,1,1,1,1,1,1,nil},       -- Number 101: Silent Honor ARK
[82633039] = {1,1,1,1,1,1,1,1,1,nil},       -- Castel the Avian Skyblaster
[02061963] = {1,1,1,1,1,1,1,1,1,nil},       -- Number 104: Masquerade
[00109254] = {1,1,1,1,6,2,8,1,1,nil},       -- Stellarknight Triveil
[56638325] = {1,1,1,1,8,8,7,1,1,nil},       -- Stellarknight Delteros
[17412721] = {1,1,7,1,1,1,1,1,1,nil},       -- Elder God Noden
}
--{hand,hand+,field,field+,grave,grave+,discard,discard+,banish} //discard = to deck

function SatellarknightGetPriority(id,loc)
  local checklist = nil
  local result = 0
  if loc == nil then
    loc = PRIO_TOHAND
  end
  checklist = SatellarknightPrio[id]
  if checklist then
    if checklist[10] and not(checklist[10](loc)) then
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
function DelterosFilter(c)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and not DestroyBlacklist(c.id)
end
function UseDelteros()
  return CardsMatchingFilter(UseLists({OppMon(),OppST()}),DelterosFilter)>0
end
function SummonDelteros()
  return MP2Check() and (UseDelteros() or HasID(UseLists({AIHand(),AIST()}),41510920,true))
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
      result = result + 2
    elseif bit32.band(cards[i].type,TYPE_CONTINUOUS)>0 and bit32.band(cards[i].position,POS_FACEUP)>0 then
      result = result - 1 
    elseif bit32.band(cards[i].type,TYPE_SPELL+TYPE_TRAP)>0 and bit32.band(cards[i].position,POS_FACEDOWN)>0 then
    else
      result = result + 1
    end
  end
  return result >= 6
end
function ScepterFilter(c)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and not DestroyBlacklist(c.id)
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
  return Duel.GetTurnCount()==1 or MP2Check() and (UseOuroboros1() or UseOuroboros2())
end
function NodenFilter(c)
  return c.level==4
end
function UseInstantFusion()
  return CardsMatchingFilter(AIGrave(),NodenFilter)>0 and (FieldCheck(4)==1 and OverExtendCheck() or #AIMon()==0)
end
function UseCotH2()
  return OverExtendCheck() and (SatellarknightPriorityCheck(AIGrave(),PRIO_TOFIELD,1)>4 
  or FieldCheck(4)<2 and SatellarknightPriorityCheck(AIGrave(),PRIO_TOFIELD,1)>0)
end
function RhongomiantFilter(c)
  return bit32.band(c.race,RACE_WARRIOR)>0 and bit32.band(c.position,POS_FACEUP)>0
end
function SummonRhongomiant()
  return CardsMatchingFilter(AIMon(),RhongomiantFilter)==5
end
function SummonRhapsody()
  local cards=AIMon()
  for i=1,#cards do
    if bit32.band(cards[i].type,TYPE_XYZ)>0 and cards[i].attack+1200 > OppGetStrongestAttack() and  #OppGrave()>=2 then
      return true
    end
  end
  return false
end
function SummonCairngorgon()
  return OppGetStrongestAttack()<2450 and MP2Check() and (#UseLists({AIMon(),AIST()})>4 or OppHasStrongestMonster())
end
function SummonSharkKnight1(cards)
  if not SatellarknightCheck() then return false end
  local targets=SubGroup(OppMon(),SharkKnightFilter)
  return #targets>0 
end
function SatellarknightOnSelectInit(cards, to_bp_allowed, to_ep_allowed)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  GlobalScepterOverride = 0
  if HasIDNotNegated(Activatable,46772449) and UseBelzebuth() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,63504681) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,56638325) and UseDelteros() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,00109254) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,48739166) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,34086406,false,545382497) then
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
  if HasID(SpSummonable,63504681) and SummonRhongomiant() then
    GlobalSSCardID = 63504681
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,00109254) and SummonTriveil() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,56638325) and SummonDelteros() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,38273745) and SummonOuroboros() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  
  if HasID(SpSummonable,94380860) and SummonRagnaZero() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,46772449) and SummonBelzebuth() then
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSummonable,46772449)}
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
  if HasID(SpSummonable,21501505) and SummonCairngorgon() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,34086406) and not HasAccess(75878039) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  
  SatellarknightAssignPriority(Summonable,PRIO_TOFIELD)
  table.sort(Summonable,function(a,b) return a.prio>b.prio end)
  if #Summonable>0 and (Summonable[1].prio > 4 or Summonable[1].prio > 0 and (HasBackrow(SetableST) or FieldCheck(4)==1))then
    return {COMMAND_SUMMON,Summonable[1].index}
  end
  
  if HasID(Activatable,01845204) and UseInstantFusion() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,54447022) and UseSoulCharge() then
    return {COMMAND_ACTIVATE,CurrentIndex}
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
  if ID == 00109227 then
    return SatellarknightAdd(cards,PRIO_DISCARD,5)
  end
  if ID == 38331564 then
    return SatellarknightAdd(cards)
  end
  if ID == 32807846 then
    return SatellarknightAdd(cards)
  end
  if ID == 01845204 then
    return SatellarknightAdd(cards,PRIO_TOFIELD)
  end
  if ID == 56638325 then
    return DelterosTarget(cards,triggeringCard)
  end
  if ID == 00109254 then
    return TriveilTarget(cards,triggeringCard)
  end
  if ID == 41510920 then
    return SatellarknightAdd(cards,PRIO_TOGRAVE)
  end
  if ID == 17412721 then
    return NodenTarget(cards)
  end
  if ID == 97077563 and SatellarknightCheck() then
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
  return nil
end

function ChainFactor()
 local p = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_PLAYER)
 return p and p ~= player_ai 
end
function ChainCairngorgon()
 local p = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_PLAYER)
 return p and p ~= player_ai 
end
function ChainCotH2()
  if not SatellarknightCheck() then
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
  local effect = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
	if effect then
    card=effect:GetHandler()
    if player_ai==nil then
      player=1
    else
      player=player_ai
    end
    if card and card:IsControler(1-player) and card:IsLocation(LOCATION_MZONE) 
    and NegateBlacklist(card:GetCode())==0 and card:IsCanBeEffectTarget()
    then
      GlobalTargetID=card:GetCode()
      GlobalPlayer=2
      return true
    end
  end
  if Duel.GetCurrentPhase() == PHASE_DAMAGE and source and target then
    if source:GetAttack() >= target:GetAttack() and source:GetAttack() <= target:GetAttack()+400 
    and source:IsPosition(POS_FACEUP_ATTACK) and target:IsPosition(POS_FACEUP_ATTACK) and target:IsControler(player_ai)
    and not target:IsHasEffect(EFFECT_IMMUNE_EFFECT) 
    then
      GlobalTargetID=source:GetCode()
      GlobalPlayer=2
      return true
    end
  end
  return false
end
function SatellarknightOnSelectChain(cards,only_chains_by_player)
  if GlobalScepterOverride>0 and UseScepter() then
    return {1,i}
  end
  for i=1,#cards do
    if SatellarknightFilter(cards[i]) and NotNegated(cards[i]) then
      return {1,i}
    end
  end
  if HasIDNotNegated(cards,38331564) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,91110378) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,17412721) then
    return {1,CurrentIndex}
  end
  if HasID(cards,41510920) and ChainFactor() then
    return {1,CurrentIndex}
  end
  if HasID(cards,21501505) and ChainCairngorgon() then
    return {1,CurrentIndex}
  end
  if HasID(cards,97077563) and ChainCotH2() then
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
  return result
end


SatellarknightAtt={
  00109254,63504681
}
SatellarknightDef={
  91110378,38667773,17412721
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