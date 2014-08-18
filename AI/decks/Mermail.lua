
function InfantryFilter(c)
  return bit32.band(c.position,POS_FACEUP)>0 and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0 --and c.owner==2
end
function InfantryCond(loc)
  if loc == PRIO_TOHAND then
    return CardsMatchingFilter(UseLists({OppMon(),OppST()}),InfantryFilter)
    > CardsMatchingFilter(AIHand(),function(c) return c.id==37104630 end)
  elseif loc == PRIO_DISCARD or loc == PRIO_TOGRAVE then
    return CardsMatchingFilter(UseLists({OppMon(),OppST()}),InfantryFilter)
    > GetMultiple(37104630)
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
  elseif loc == PRIO_DISCARD or loc == PRIO_TOGRAVE then
    return CardsMatchingFilter(UseLists({OppMon(),OppST()}),MarksmanFilter)
    > GetMultiple(00706925)
  elseif loc == PRIO_TOFIELD then
    return #OppMon()==0 and Duel.GetTurnCount()>1
  end
  return true
end
function GundeFilter(c)
  return bit32.band(c.type,TYPE_MONSTER)>0 and IsSetCode(c.setcode,0x74) and c.id~=69293721
end
function GundeCond(loc)
  if loc == PRIO_DISCARD then
    return CardsMatchingFilter(AIGrave(),GundeFilter)>0
    and OPTCheck(69293721)
    and Duel.GetLocationCount(player_ai,LOCATION_MZONE)>1
  end
  return true
end
function PikeCond(loc,c)
  if loc == PRIO_TOFIELD then
    return (c==nil or c:is_affected_by(EFFECT_DISABLE)==0 and c:is_affected_by(EFFECT_DISABLE_EFFECT)==0)
    and (MermailPriorityCheck(AIHand(),PRIO_DISCARD) > 4 
    and OPTCheck(58471134)
    and Duel.GetCurrentChain()<=1
    or FieldCheck(4)==1 and Duel.GetTurnPlayer()==player_ai)
  end
  return true
end
function TurgeFilter(c)
  return c.level<=3 and bit32.band(c.attribute,ATTRIBUTE_WATER)>0
end
function TurgeCond(loc,c)
  if loc == PRIO_TOFIELD then
    return (c==nil or c:is_affected_by(EFFECT_DISABLE)==0 and c:is_affected_by(EFFECT_DISABLE_EFFECT)==0)
    and (MermailPriorityCheck(AIHand(),PRIO_DISCARD) > 4 
    and CardsMatchingFilter(AIGrave(),TurgeFilter)>0
    and OPTCheck(22076135)
    and Duel.GetCurrentChain()<=1
    or FieldCheck(4)==1 and Duel.GetTurnPlayer()==player_ai)
  end
  return true
end
function LindeCond(loc)
  local cards=UseLists({AIHand(),AIMon()})
  local check = not(HasID(cards,23899727,true) 
  or (HasIDNotNegated(cards,23899727,true) and HasID(AIDeck(),23899727,true)))
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
    return MermailPriorityCheck(AIHand(),PRIO_DISCARD,2)>3 
    and not HasID(UseLists({AIHand(),AIMon()},21954587,true))
  end
  if loc == PRIO_DISCARD then
    return false-- CardsMatchingFilter(AIHand(),function(c) return c.id==21954587 end)>1
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
function TriteFilter(c)
  return bit32.band(c.type,TYPE_MONSTER)>0 and IsSetCode(c.setcode,0x74)
end
function TriteCond(loc)
  if loc == PRIO_TOFIELD then
    return CardsMatchingFilter(AIGrave(),TriteFilter)>0
  end
  return true
end
function KappaCond(loc)
  if loc == PRIO_TOFIELD then
    return MermailPriorityCheck(AIHand(),PRIO_DISCARD)>5 and #AIMon()>2
  end
  return true
end
function DineFilter(c)
  return c.level<=3 and IsSetCode(c.setcode,0x74)
end
function DineCond(loc)
  if loc == PRIO_TOHAND then
    return Duel.GetCurrentChain()<=1 
    and CardsMatchingFilter(AIMon(),DineFilter)>0
  end
  if loc == PRIO_TOFIELD then
    return Duel.GetCurrentChain()<=1 
    and CardsMatchingFilter(AIGrave(),DineFilter)>0
  end
  return true
end
function SquallFilter(c)
  return bit32.band(c.type,TYPE_MONSTER)>0 and IsSetCode(c.setcode,0x74)
end
function SquallCond(loc)
  if loc == PRIO_TOHAND then
    return CardsMatchingFilter(AIGrave(),SquallFilter)>3 or HasID(UseLists({AIHand(),AIST()},60202749,true))
  end
  return true
end
function DivaCond(loc)
  if loc == PRIO_TOHAND then
    return HasID(UseLists({AIHand(),AIST()}),60202749,true) or FieldCheck(4)>1 
    and Duel.GetTurnPlayer()==player_ai and not Duel.CheckNormalSummonActivity(player_ai)
  end
  return true
end
function UndineCond(loc)
  if loc == PRIO_TOHAND then
    return HasID(AIDeck(),68505803,true)
  end
  if loc == PRIO_DISCARD then
    return not HasID(AIDeck(),68505803,true)
  end
  return true
end
function ControllerCond(loc)
  return true
end

function MermailGetPriority(id,loc)
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
  if GlobalSummonNegated and id==23899727 
  and loc == PRIO_TOFIELD and OPTCheck(23899727) 
  then
    result = 10
    GlobalSummonNegated=nil
  end
  return result
end
function MermailAssignPriority(cards,loc,filter,opt)
  local index = 0
  Multiple = nil
  for i=1,#cards do
    cards[i].index=i
     if not MermailMultiTargetFilter(cards[i]) then
      cards[i].prio=-1
    else
      cards[i].prio=MermailGetPriority(cards[i].id,loc)
    end
    if filter and (opt==nil and not filter(cards[i]) 
    or opt and not filter(cards[i],opt)) 
    then
      cards[i].prio=-1
    end
    if loc==PRIO_BANISH and cards[i].location~=LOCATION_GRAVE then
      cards[i].prio=cards[i].prio-2
    end
    SetMultiple(cards[i].id)
  end
end
function MermailPriorityCheck(cards,loc,count,filter,opt)
  if count == nil then count = 1 end
  if loc==nil then loc=PRIO_TOHAND end
  if cards==nil or #cards<count then return -1 end
  MermailAssignPriority(cards,loc,filter,opt)
  table.sort(cards,function(a,b) return a.prio>b.prio end)
  return cards[count].prio
end
function MermailAdd(cards,loc,count,filter,opt)
  local result={}
  if count==nil then count=1 end
  if loc==nil then loc=PRIO_TOHAND end
  local compare = function(a,b) return a.prio>b.prio end
  MermailAssignPriority(cards,loc,filter,opt)
  table.sort(cards,compare)
  for i=1,count do
    result[i]=cards[i].index
    MermailTargets[#MermailTargets+1]=cards[i].cardid
  end
  return result
end
function UseMegalo(card)
  return bit32.band(card.location,LOCATION_HAND)>0 and OverExtendCheck()
  and MermailPriorityCheck(AIHand(),PRIO_DISCARD,2,FilterAttribute,ATTRIBUTE_WATER)>3
end
function MegaloFilter(c)
  return bit32.band(c.position,POS_FACEUP_ATTACK)>0 
  and bit32.band(c.attribute,ATTRIBUTE_WATER)>0 and c.level<5
end
function UseMegaloField(card)
  return bit32.band(card.location,LOCATION_ONFIELD)>0 
  and CardsMatchingFilter(AIMon(),MegaloFilter)>0
  and #OppMon()==0 and Duel.GetTurnCount()>1
  and Duel.GetCurrentPhase() == PHASE_MAIN1
  and card.attack>=2000
  and card:is_affected_by(EFFECT_CANNOT_ATTACK)==0
  and card:is_affected_by(EFFECT_CANNOT_ATTACK_ANNOUNCE)==0
  and bit32.band(card.position,POS_FACEUP_ATTACK)>0
end
function UseTeus()
  return MermailPriorityCheck(AIHand(),PRIO_DISCARD,1,FilterAttribute,ATTRIBUTE_WATER)>4
end
function UseLeed(card)
  return bit32.band(card.location,LOCATION_HAND)>0 and MermailPriorityCheck(AIHand(),PRIO_DISCARD,3,FilterAttribute,ATTRIBUTE_WATER)>5 
  and CardsMatchingFilter(AIGrave(),function(c) return bit32.band(c.setcode,0x75)>0 and bit32.band(c.type,TYPE_SPELL+TYPE_TRAP)>0 end)>0 
end
function LeedFilter(c)
  return bit32.band(c.position,POS_FACEUP_ATTACK)>0 
  and IsSetCode(c.setcode,0x74) and c.level<5
end
function UseLeedField(card)
  return bit32.band(card.location,LOCATION_ONFIELD)>0 
   and CardsMatchingFilter(AIMon(),LeedFilter)>0
   and #OppHand()>0 and (Duel.GetCurrentPhase() == PHASE_MAIN2 or Duel.GetTurnCount()==1)
end
function UsePike(c)
  return PikeCond(PRIO_TOFIELD,c)
end
function UseTurge(c)
  return TurgeCond(PRIO_TOFIELD,c)
end
function UseSalvage()
  return MermailPriorityCheck(AIGrave(),PRIO_TOHAND,2,function(c) return bit32.band(c.attribute,ATTRIBUTE_WATER)>0 and c.attack<=1500 end)>1
  and #AIHand()<6
end
function SummonBahamut()
  return OppGetStrongestAttDef()<2600
end
function UseBahamut()
  return Duel.GetCurrentPhase() == PHASE_MAIN2 or Duel.GetTurnCount()==1
end
function SummonGaios()
  return MP2Check() and OppGetStrongestAttDef()<2800
end
function SummonDiva1()
  return (HasIDNotNegated(AIST(),60202749,true) and Duel.GetLocationCount(player_ai,LOCATION_MZONE)>2 
  or FieldCheck(4)>1 and Duel.GetLocationCount(player_ai,LOCATION_MZONE)>1)
  and HasID(AIExtra(),70583986,true)
end
function SummonDiva2()
  return OverExtendCheck() and OppGetStrongestAttDef()<2300 and SummonArmades()
  and Duel.GetCurrentPhase() == PHASE_MAIN1 and GlobalBPAllowed and Duel.GetLocationCount(player_ai,LOCATION_MZONE)>1
end
function SummonDewloren()
  return MermailPriorityCheck(UseLists({AIMon(),AIST()}),PRIO_TOHAND,3)>1
  and HasID(AIExtra(),70583986,true)
end
function UseDewloren()
  return MP2Check() and MermailPriorityCheck(UseLists({AIMon(),AIST()}))>1
end
function UseSphere()
  if HasID(AIMon(),70583986,true) then
    GlobalSphere = 5
    return true
  end
  if HasID(AIMon(),78868119,true) then
    GlobalSphere = 4
    return true
  end
  if HasID(AIMon(),68505803,true) then
    GlobalSphere = 2
    return true
  end
  if FieldCheck(7) == 1 and OverExtendCheck() and ExtraDeckCheck(TYPE_XYZ,7)>0 then
    GlobalSphere = 7  
    return true
  end
  if FieldCheck(4) == 1 and OverExtendCheck() and ExtraDeckCheck(TYPE_XYZ,4)>0 then
    GlobalSphere = 4
    return true
  end
  return false
end
function GungnirFilter(c)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
end
function SummonGungnir()
  return UseGungnir() and HasID(AIExtra(),65749035,true)
end
function UseGungnir()
  return MermailPriorityCheck(AIHand(),PRIO_DISCARD,1)>4 and CardsMatchingFilter(UseLists({OppMon(),OppST()}),GungnirFilter)>0
end
function SummonSharkKnightMermail(cards)
  local targets=SubGroup(OppMon(),SharkKnightFilter)
  if DeckCheck(DECK_MERMAIL) and #targets > 0 and OPTCheck(48739166) then
    return true
  end
  return false
end
function SummonArmadesMermail()
  return Duel.GetCurrentPhase() == PHASE_MAIN1 and Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack") < 2300 
  and Duel.GetTurnCount()>1
end
function MermailOpenFieldCheck()
  return (#AIMon()==0 and #OppMon()==0 and not HasID(UseLists({AIHand(),AIST()}),60202749,true) 
  and (not HasID(AIHand(),23899727,true) or Duel.CheckNormalSummonActivity(player_ai)))
  or #OppMon()>1
end
function UseTidal()
  return false--MermailPriorityCheck(AIHand(),PRIO_DISCARD,2)>4 or HasID(AIHand(),69293721,true) 
  --and OPTCheck(69293721) and OverExtendCheck()
end
function SummonTidal()
  local check=MermailPriorityCheck(AIGrave(),PRIO_BANISH,2)
  return check>1 and OverExtendCheck() or check>0 and (FieldCheck(7)==1 
  and not HasID(AIMon(),68505803) or MermailOpenFieldCheck())
end
function UseSquall()
  if RemovalCheck(34707034) then
    return true
  end
  if Duel.GetTurnPlayer()==player_ai then
    if OverExtendCheck() then
      return true
    elseif HasID(AIMon(),70583986,true) then
      GlobalSummonToHand = true
      return true
    end
  end
  return false
end
function SetLinde()
return (Duel.GetCurrentPhase()==PHASE_MAIN2 or Duel.GetTurnCount()==1) and not HasID(AIMon(),23899727,true)
end
function UseUndine()
  return true
end
function SummonUndine()
  return HasID(AIDeck(),68505803,true)
end
function SummonController()
  local check = HasIDNotNegated(AIST(),60202749,true) and Duel.GetLocationCount(player_ai,LOCATION_MZONE)>1
  return (FieldCheck(3)>0 or check) and SummonDewloren() 
  or (FieldCheck(4)>0 or check) and SummonGungnir()
  or (FieldCheck(7)==1 or check) and ExtraDeckCheck(TYPE_SYNCHRO,10)>0
end
function SetController()
  return #AIMon()==0
end

function SummonMarksman()
  return Duel.GetCurrentPhase(PHASE_MAIN1) and GlobalBPAllowed 
  and #OppMon()==0 and OverExtendCheck() and Duel.GetLocationCount(player_ai,LOCATION_MZONE)>1
end
function SummonDine()
  return OverExtendCheck() and FieldCheck(3)==1
end
GlobalATK = nil
function MermailOnSelectInit(cards, to_bp_allowed, to_ep_allowed)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  MermailTargets = {}
  GlobalSummonNegated=nil
  GlobalSummonToHand=nil
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
  if HasIDNotNegated(Activatable,21954587) and UseMegaloField(Activatable[CurrentIndex]) then
    GlobalCardMode=2
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
  if HasIDNotNegated(Activatable,37781520) and UseLeedField(Activatable[CurrentIndex]) then
    GlobalCardMode=2
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,60202749) and UseSphere() then
    GlobalSummonNegated=true
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,00440556) and UseBahamut() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,70583986) and UseDewloren() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,65749035) and UseGungnir() then
    GlobalCardMode=1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(cards,34707034) and UseSquall() then
    GlobalSummonNegated=true
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Summonable,78868119) and SummonDiva1() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,04904812) and SummonUndine() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,68505803) and SummonController() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,58471134) and (UsePike() or FieldCheck(4)==1) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,22076135) and (UseTurge() or FieldCheck(4)==1) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,70583986) and SummonDewloren() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,65749035) and SummonGungnir() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,74371660) and SummonGaios() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,21044178) and SummonDweller() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
   if HasID(SpSummonable,00440556) and SummonBahamut() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,48739166) and SummonSharkKnightMermail(OppMon()) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,00706925) and SummonMarksman() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,74298287) and SummonDine() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(SetableMon,23899727) and SetLinde() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(Summonable,78868119) and SummonDiva2() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Activatable,26400609,false,422409746) and UseTidal() then
    GlobalCardMode = 2
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  local check = MermailPriorityCheck(AIHand(),PRIO_DISCARD)>1 and MermailOpenFieldCheck()
  if HasID(Activatable,22446869) and check then
    GlobalCardMode=1
    return {COMMAND_ACTIVATE,IndexByID(Activatable,22446869)}
  end
  if HasID(Activatable,21954587) and MermailPriorityCheck(AIHand(),PRIO_DISCARD)>5  
  and MermailPriorityCheck(AIHand(),PRIO_DISCARD,2)>1 and MermailOpenFieldCheck()
  then
    GlobalCardMode=1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Summonable,58471134) and MermailOpenFieldCheck() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,22076135) and MermailOpenFieldCheck() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Activatable,26400609,false,422409744) and SummonTidal() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SetableMon,68505803) and MermailOpenFieldCheck() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  cards=AIHand()
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
  local result = {}
  if count == nil then
    count = 1
  end
  BestTargets(cards,count,true,MermailMultiTargetFilter) 
  for i=1,count do
    MermailTargets[#MermailTargets+1]=cards[1].cardid
    result[i]=cards[i].index
  end
  return result
end
function SphereTarget(cards)
  if GlobalSphere == 1 then
    local id = GlobalSphereID
    GlobalSphere = nil
    GlobalSphereID = nil
    return MermailAdd(cards,PRIO_TOFIELD,1,FilterID,id)
  end
  if GlobalSphere == 2 then
    GlobalSphere = nil
    for i=1,#cards do
      if cards[i].level == 3 and SummonDewloren() then
        return {i}
      end
      if cards[i].level == 4 and SummonGungnir() then
        return {i}
      end
      if cards[i].level == 7 and SummonLeoh() then
        return {i}
      end
    end
  end
  if GlobalSphere == 3 then
    GlobalSphere = nil
    return MermailAdd(cards,PRIO_TOGRAVE,1,FilterAttack,AI.GetPlayerLP(2))
  end
  if GlobalSphere == 4 or GlobalSphere == 7 then
    local level = GlobalSphere
    GlobalSphere = nil
    return MermailAdd(cards,PRIO_TOGRAVE,1,FilterLevel,level)
  end
  if GlobalSphere == 5 then
    GlobalSphere = nil
    return MermailAdd(cards,PRIO_TOHAND)
  end
  return MermailAdd(cards,PRIO_TOFIELD)
end
function DewlorenTarget(cards,Min,Max)
  MermailAssignPriority(cards,PRIO_TOHAND)
  result = {}
  for i=1,#cards do
    if cards[i].prio>1 then
      result[#result+1]=i
    end
  end
  return result
end
function GungnirTarget(cards,Min,Max)
  local result = nil
  if GlobalCardMode == 1 then
    local count = math.min(CardsMatchingFilter(UseLists({AIMon(),AIST()}),GungnirFilter),2)
    if count > 1 and MermailPriorityCheck(AIHand(),PRIO_DISCARD,count)<4 then
      count = 1
    end
    result = MermailAdd(cards,PRIO_DISCARD,count)
  else
    result = BestTargetsMermail(cards,Min)
  end
  GlobalCardMode = nil
  if result == nil then result = {math.random(#cards)} end
  return result
end
function MechquippedTarget(cards)
  result = nil
  if GlobalCardMode == nil then
    result = {IndexByID(cards,GlobalTargetID)}
  end
  GlobalCardMode = nil
  if result == nil then result = {math.random(#cards)} end
  return result
end
function KappaTarget(cards)
  return MermailAdd(cards,PRIO_DISCARD)
end
function TidalTarget(cards)
  local result = nil
  if GlobalCardMode == 2 then
    GlobalCardMode=1
    result = MermailAdd(cards,PRIO_DISCARD)
  elseif GlobalCardMode == 1 then
    GlobalCardMode=nil
    result = MermailAdd(cards,PRIO_TOGRAVE)
  else
    result = MermailAdd(cards,PRIO_BANISH,2)
  end
  return result
end
function DivaTarget(cards)
  return MermailAdd(cards,PRIO_TOFIELD)
end
function MechquippedTarget(cards)
  local result = nil
  if GlobalCardMode==nil then
    result = IndexByID(cards,GlobalTargetID)
  end
  GlobalCardMode=nil
  if result == nil then result = {math.random(#cards)} end
  return result
end
function UndineTarget(cards)
  return MermailAdd(cards,PRIO_TOGRAVE)
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
    return BestTargetsMermail(cards)
  end
  if ID == 00706925 then
    return BestTargetsMermail(cards)
  end
  if ID == 58471134 or ID == 22076135 or ID == 21954587 
  or ID == 37781520 or ID == 22446869 or ID == 74311226
  then
    if GlobalCardMode==2 then
      result=BestTargetsMermail(cards)
    elseif GlobalCardMode==1 then
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
  if ID == 23899727 or ID == 69293721
  or ID == 37104630 or ID == 00440556 or ID == 59170782
  then
    return MermailAdd(cards,PRIO_TOFIELD)
  end
  if ID == 78868119 then
    return DivaTarget(cards)
  end
  if ID == 60202749 then
    return SphereTarget(cards)
  end
  if ID == 96947648 then
    return MermailAdd(cards,PRIO_TOHAND,2)
  end
  if ID == 70583986 then
    return DewlorenTarget(cards,minTargets,maxTargets)
  end
  if ID == 65749035 then
    return GungnirTarget(cards,minTargets,maxTargets)
  end
  if ID == 15914410 then
    GlobalCardMode=1
    return MechquippedTarget(cards)
  end
  if ID == 50789693 then
    return KappaTarget(cards)
  end
  if ID == 34707034 then
    return MermailAdd(cards,PRIO_TOFIELD,3)
  end
  if ID == 26400609 then
    return TidalTarget(cards)
  end
  if ID == 15914410 then
    return MechquippedTarget(cards)
  end
  if ID == 04904812 then
    return UndineTarget(cards)
  end
  return nil
end
function SphereFilter(c,dmg)
  return IsSetCode(c.setcode,0x74) and (dmg == nil or c.attack>=dmg) -- and c.attack>=dmg
end
function UseSphereBP()
  if Duel.GetTurnPlayer() == player_ai and #OppMon()==0 
  and CardsMatchingFilter(AIDeck(),SphereFilter,AI.GetPlayerLP(2))>0 and AI.GetPlayerLP(2)>ExpectedDamage(2)
  then
    GlobalSphere = 3
    return true
  end
end
function ChainSphere()
  if RemovalCheck(60202749) then
    return true
  end
  local effect = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
	if effect then
    local c=effect:GetHandler() 
    if c:IsCode(60202749) and c:IsControler(player_ai) then
      return false
    end
  end
  if Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.CheckTiming(TIMING_MAIN_END) and Duel.GetTurnPlayer() == 1-player_ai 
  and HasID(AIDeck(),23899727,true) and LindeCond(PRIO_TOFIELD) 
  then
    GlobalSphere = 1
    GlobalSphereID = 23899727
    return true
  end
  if Duel.GetCurrentPhase() == PHASE_BATTLE and Duel.GetTurnPlayer() == 1-player_ai
  --and HasID(AIDeck(),23899727,true) and LindeCond(PRIO_TOFIELD) 
  then
    if Duel.GetAttacker() and #AIMon()==0 then
      GlobalSphere = 1
      GlobalSphereID = 23899727
    end
  end
  return false
end
function ChainReckless()
  local cards = AIMon()
  if RemovalCheck(37576645) then
    return true
  end
  if Duel.GetCurrentPhase() == PHASE_END and Duel.GetTurnPlayer() == 1-player_ai
  and (#AIHand()<3 or Duel.IsPlayerAffectedByEffect(player_ai,EFFECT_SKIP_DP)) 
  then
    return true
  end
  return false
end
function MechquippedFilter(card,id)
  return card:IsControler(player_ai) 
  and card:IsType(TYPE_MONSTER)
  and card:IsPosition(POS_FACEUP_ATTACK) 
  and not card:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT) 
  and not card:IsHasEffect(EFFECT_IMMUNE_EFFECT) 
  and not card:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET) 
  and (id == nil or card:GetCode()~=id)
end
function ChainMechquipped()
  local cardtype = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_EXTTYPE)
  local ex,cg = Duel.GetOperationInfo(Duel.GetCurrentChain(), CATEGORY_DESTROY)
  local tg = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TARGET_CARDS)
  local e = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
  if ex then
    if tg then
      local g = tg:Filter(MechquippedFilter, nil):GetMaxGroup(Card.GetAttack)
      if g then
        GlobalTargetID = g:GetFirst():GetCode() 
      end
      return tg:IsExists(MechquippedFilter, 1, nil)
    else
      local g = cg:Filter(MechquippedFilter, nil):GetMaxGroup(Card.GetAttack)
      if g then
        GlobalTargetID = g:GetFirst():GetCode()
      end
      return cg:IsExists(MechquippedFilter, 1, nil)
    end
  end
  if Duel.GetCurrentPhase() == PHASE_BATTLE then
		local source = Duel.GetAttacker()
		local target = Duel.GetAttackTarget()
    if source and target then
      if source:IsControler(player_ai) then
        target = Duel.GetAttacker()
        source = Duel.GetAttackTarget()
      end
      if source:GetAttack() >= target:GetAttack() and target:IsControler(player_ai) 
      and target:IsPosition(POS_FACEUP_ATTACK)
      and not target:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)
      then
        GlobalTargetID=target:GetCode()
        return true
      end
    end
  end
  if RemovalCheck(15914410) then
    local g=Duel.GetMatchingGroup(MechquippedFilter,player_ai,LOCATION_ONFIELD,0,nil,15914410):GetMaxGroup(Card.GetAttack)
    if g then
      GlobalTargetID = g:GetFirst():GetCode()
      return true
    end
  end
  cg = NegateCheck()
  if cg then
		if cg:IsExists(function(c) return c:IsControler(player_ai) and c:IsCode(15914410) end, 1, nil) then
      local g=Duel.GetMatchingGroup(MechquippedFilter,player_ai,LOCATION_ONFIELD,0,nil):GetMaxGroup(Card.GetAttack)
      if g then
        GlobalTargetID = g:GetFirst():GetCode()
        return true
      end
    end	
  end
  return false
end
function ChainKappa()
  if Duel.GetCurrentPhase() == PHASE_BATTLE then
		local source = Duel.GetAttacker()
		local target = Duel.GetAttackTarget()
    if source and target then
      if source:IsControler(player_ai) then
        target = Duel.GetAttacker()
        source = Duel.GetAttackTarget()
      end
      if source:GetAttack() >= target:GetAttack() and target:IsControler(player_ai) 
      and not target:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) and not target:IsHasEffect(EFFECT_IMMUNE_EFFECT) 
      then
        return MermailPriorityCheck(AIHand(),PRIO_DISCARD)>4
      end
    end
  end
  return false
end

function ChainGaios()
local gaios=Duel.GetMatchingGroup(function(c) return c:IsCode(74371660) end,player_ai,LOCATION_MZONE,0,nil):GetFirst()
local effect = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
	if effect then
    card=effect:GetHandler()
    player=player_ai
    if card and card:IsControler(1-player) and card:IsLocation(LOCATION_MZONE) 
    and NegateBlacklist(card:GetCode())==0 and card:GetAttack()<gaios:GetAttack()
    then
      return true
    end
  end
  if Duel.GetCurrentPhase() == PHASE_BATTLE then
    if Duel.GetTurnPlayer()==player_ai then
      local cards=OppMon()
      for i=1,#cards do
        if VeilerTarget(cards[i]) and cards[i].attack<gaios:GetAttack()then
          return true
        end
      end
    end
  end
  return false
end
function ChainDweller()
  return true
end
function MermailOnSelectChain(cards,only_chains_by_player)
  MermailTargets = {}
  if HasID(cards,37576645) and ChainReckless() then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,58471134) and UsePike() then
    OPTSet(58471134)
    GlobalCardMode = 1
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,22076135) and UseTurge() then
    OPTSet(22076135)
    GlobalCardMode = 1
    return {1,CurrentIndex}
  end
  if HasID(cards,60202749) and ChainSphere() then
    GlobalSummonNegated=true
    return {1,CurrentIndex}
  end
  if HasID(cards,34707034) and UseSquall() then
    GlobalSummonNegated=true
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
    OPTSet(23899727)
    return {1,CurrentIndex}
  end
  if HasID(cards,74298287) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,04904812) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,15914410) and ChainMechquipped() then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,50789693) and ChainKappa() then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,74371660) and ChainGaios() then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,21044178) and ChainDweller() then
    return {1,CurrentIndex}
  end
  return nil
end

function MermailOnSelectEffectYesNo(id,triggeringCard)
  local result = nil
  if id==37781520 or id==21954587 or id==22446869 or id==69293721 or id==23899727 then
    OPTSet(id)
    result = 1
  end
  if id==58471134 then
    if UsePike(triggeringCard) then
      OPTSet(58471134)
      GlobalCardMode = 1
      result = 1
    else
      result = 0
    end
  end
  if id==22076135 then
    if UseTurge(triggeringCard) then
      OPTSet(22076135)
      GlobalCardMode = 1
      result = 1
    else
      result = 0
    end
  end
  if id==74298287 or id==59170782 or id == 78868119 
  or id==04904812 or id==00706925
  then
    result = 1
  end
  return result
end

MermailAtt={
  21954587,15914410,70583986, -- Megalo,Mechquipped Angineer,Dewloren
  74311226,00706925 -- Dragoons, Marksman
}
MermailDef={
  59170782,50789693,22446869,  -- Trite, Kappa,Teus
  23899727,37104630 -- Linde, Infantry
}
function MermailOnSelectPosition(id, available)
  result = nil
  for i=1,#MermailAtt do
    if MermailAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#MermailDef do
    if MermailDef[i]==id and not (Duel.GetCurrentPhase()==PHASE_BATTLE 
    and Duel.GetTurnPlayer()==player_ai) 
    then 
      result=POS_FACEUP_DEFENCE 
    end
  end
  return result
end