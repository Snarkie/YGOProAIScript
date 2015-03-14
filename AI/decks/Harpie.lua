function HarpiePriority()
AddPriority({

-- Harpie

[75064463] = {7,1,6,1,3,1,1,1,1,1,QueenCond},   -- Harpie Queen
[80316585] = {4,1,4,1,5,1,1,1,1,1,CyberCond},   -- Cyber Harpie Lady
[56585883] = {8,1,8,1,8,1,1,1,1,1,HarpistCond}, -- Harpie Harpist
[90238142] = {9,4,9,1,1,1,1,1,1,1,ChannelerCond},-- Harpie Channeler
[91932350] = {3,1,5,1,4,1,1,1,1,1,Lady1Cond},   -- Harpie Lady #1
[68815132] = {6,1,7,1,2,1,1,1,1,1,DancerCond},  -- Harpie Dancer

[90219263] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Elegant Egotist
[19337371] = {1,1,1,1,9,1,1,1,1,1,SignCond},    -- Hysteric Sign
[15854426] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Divine Wind of Mist Valley
[75782277] = {5,1,1,1,3,1,1,1,1,1,nil},         -- Harpie's Hunting Ground

[77778835] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Hysteric Party

[85909450] = {1,1,1,1,1,1,1,1,1,1,nil},         -- HPPD
[86848580] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Zerofyne

[89399912] = {1,1,1,1,7,1,1,1,1,1,nil},         -- Tempest
[52040216] = {1,1,1,1,6,1,1,1,1,1,nil},         -- Pet Dragon
[94145683] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Swallow's

})
end

HarpieLady={
56585883, -- Harpie Harpist
75064463, -- Harpie Queen
80316585, -- Cyber Harpie Lady
91932350, -- Harpie Lady #1
76812113, -- Harpie Lady
90238142, -- Harpie Channeler
68815132, -- Harpie Dancer
}
function LadyFilter(c,negated)
  if negated then return c.id == 76812113 end
  for i=1,#HarpieLady do
    if c.original_id == HarpieLady[i] then 
      return true
    end
  end
  return false
end
function LadyCount(cards,negated,filter,opt)
  return CardsMatchingFilter(SubGroup(cards,filter,opt),LadyFilter,negated)
end
function HarpieFilter(c,exclude)
  return IsSetCode(c.setcode,0x64) and (exclude == nil or c.id~=exclude)
end
function HarpieCount(cards,filter,opt)
  return CardsMatchingFilter(SubGroup(cards,filter,opt),FilterID,76812113)
end
function QueenCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),c.original_id,true)
  end
  return true
end
function Lady1Cond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),c.original_id,true)
  end
  return true
end
function CyberCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),c.original_id,true)
  end
  return true
end
function DancerCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),c.original_id,true)
  end
  if loc == PRIO_TOFIELD then
    return not HasID(AIMon(),c.original_id,true)
    and OPTCheck(c.original_id)
    and GetMultiple(c.original_id)==0
  end
  return true
end
function HarpistGraveFilter(c)
  return c.original_id == 56585883 
  and c.turnid == Duel.GetTurnCount()
end
function HarpistSearchFilter(c)
  return FilterRace(c,RACE_WINDBEAST) 
  and c.level==4
  and c.attack<=1500
end
function HarpistCond(loc,c)
  if loc==PRIO_TOGRAVE then
    return OPTCheck(56585883) 
    and CardsMatchingFilter(AIGrave(),HarpistGraveFilter)==0
    and CardsMatchingFilter(AIDeck(),HarpistSearchFilter)>0
  end
  return true
end
function ChannelerCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),c.original_id,true)
  end
  if loc == PRIO_TOFIELD then
    return not HasID(AIMon(),c.original_id,true)
    and OPTCheck(c.original_id)
    and GetMultiple(c.original_id)==0
  end
  return true
end
function SignGraveFilter(c)
  return c.id == 19337371 and c.turnid == Duel.GetTurnCount()
end
function SignCheck(cards)
  return (cards == nil or HasID(cards,19337371,true))
  and OPTCheck(19337371)
  and CardsMatchingFilter(AIGrave(),SignGraveFilter)==0
end
function SignCond(loc,c)
  if loc==PRIO_TOGRAVE then
    return FilterLocation(c,LOCATION_ONFIELD+LOCATION_HAND)
    and SignCheck()
  end
  return true
end
function UseDivineWind(c,cards)
  return DualityCheck() and OPTCheck(68815132)
  and HasIDNotNegated(UseLists(cards,AIMon()),68815132,true)
  and (not HasID(AIST(),75782277,true) or DestroyCheck(OppST())==0)
end
function UseHHG(c,cards)
  return (DestroyCheck(OppST())>0 
  or SignCheck(AIST()))
  and CardsMatchingFilter(cards,LadyFilter,SkillDrainCheck())>0
end
function UseDancer(c)
  return HasIDNotNegated(AIST(),75782277,true)
  and DestroyCheck(OppST())>0
  or HasIDNotNegated(AIST(),15854426,true)
  and DualityCheck()
  or HasID(AIMon(),90238142,true)
  and LadyCount(AIHand())>0
end
function SummonDancer(c)
  return (HasIDNotNegated(AIST(),75782277,true)
  and DestroyCheck(OppST())>0
  or HasIDNotNegated(AIST(),15854426,true)
  and DualityCheck())
  and OPTCheck(68815132)
end
function UseQueen(c,cards)
  return not HasID(AICards(),75782277,true)
  and UseHHG(FindID(75782277,AIDeck()),cards)
end
function UseChanneler(c)
  return OverExtendCheck()
end
function SummonChanneler(c)
  if DualityCheck() and #AIMon()==0
  and CardsMatchingFilter(AIHand(),HarpieFilter)>1
  then
    return true
  end
  return false
end
function HarpistFilter(c)
   return PriorityTarget(c)
   and Affected(c,TYPE_MONSTER,4)
   and Targetable(c,TYPE_MONSTER)
end
function SummonHarpist(c)
  if ChainHarpist(c)
  then
    return true
  end
  return false
end
function SummonHarpie(c,mode)
  if mode == 1 and (FieldCheck(4)==1 
  or HasID(AICards(),90219263,true)  
  and LadyCount(AIDeck(),true)>0)
  and OverExtendCheck() and DualityCheck()
  then
    return true
  end
  if mode == 2 
  and (DestroyCheck(OppST())>0 or SignCheck(AIST()))
  and HasIDNotNegated(AIST(),75782277,true)
  and LadyFilter(c)
  then
    return true
  end
  if mode == 3 
  and OppHasStrongestMonster() 
  and c.attack>OppGetStrongestAttDef()
  then
    return true
  end
end
function UseParty(c,mode)
  if mode == 1 
  and Duel.GetLocationCount(player_ai,LOCATION_MZONE)>3
  and LadyCount(AIGrave())>3
  then
    return true
  end
  if mode == 2
  and OppHasStrongestMonster() 
  and (LadyCount(AIGrave())>1
  and SignCheck(AIHand())
  or LadyCount(AIHand())>0)
  then
    return true
  end
  return false
end
function UseSign(c,cards)
  return LadyCount(AIDeck(),true)>0
  and SignCheck()
  and ((FieldCheck(4,LadyFilter)==1
  or LadyCount(cards)>0)
  and OppHasStrongestMonster())
  or TurnEndCheck() and DiscardOutlets()==0
end
function UseEgotist(c)
  return OverExtendCheck()
end
function SetSign(c,cards)
  return (HasID(AIHand(),75782277,true)
  and LadyCount(cards)>0
  or HasID(AIHand(),75064463,true)
  and LadyCount(cards)>1)
  and SignCheck()
  and not HasID(AIST(),19337371,true)
end
function SummonHPPD(c)
  return AI.GetPlayerLP(2)<=4000
  and MP2Check()
end
function SummonZerofyne(c)
  return CardsMatchingFilter(Field(),FilterPosition,POS_FACEUP)>5
  and #OppMon()>0 and BattlePhaseCheck() and OppHasStrongestMonster()
end
function SummonZephyrosHarpie(c,mode)
  if not DeckCheck(DECK_HARPIE) then return false end
  if mode == 1 
  and (HasID(AIST(),19337371,true,nil,nil,POS_FACEUP) 
  and DiscardOutlets()>0
  or HasID(AIST(),77778835,true,nil,nil,POS_FACEUP) 
  and LadyCount(AIMon())==0)
  then
    return true
  end
  if mode == 2 
  and FieldCheck(4) == 1
  and CardsMatchingFilter(AIST(),FilterPosition,POS_FACEUP)>0
  and OverExtendCheck()
  then
    return true
  end
  if mode == 3 
  and FieldCheck(4) == 1
  and OverExtendCheck()
  then
    return true
  end
  return false
end
function HarpieInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  if HasID(SetST,19337371,SetSign,Sum) then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasIDNotNegated(Act,75782277,UseHHG,Sum) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,15854426,UseDivineWind,Sum) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,75064463,UseQueen,Sum) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,77778835,UseParty,1) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,68815132,UseDancer) then
    OPTSet(68815132)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,90238142,UseChanneler) then
    OPTSet(90238142)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Sum,68815132,SummonDancer) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Sum,90238142,SummonChanneler) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Sum,56585883,SummonHarpist) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Act,14785765) and SummonZephyros(1) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,86848580) then -- Zerofyne
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  for i=1,#HarpieLady do
    if HasID(Sum,HarpieLady[i],SummonHarpie,1) then
      return {COMMAND_SUMMON,CurrentIndex}
    end
  end
  for i=1,#HarpieLady do
    if HasID(Sum,HarpieLady[i],SummonHarpie,2) then
      return {COMMAND_SUMMON,CurrentIndex}
    end
  end
  for i=1,#HarpieLady do
    if HasID(Sum,HarpieLady[i],SummonHarpie,3) then
      return {COMMAND_SUMMON,CurrentIndex}
    end
  end
  if HasID(Sum,14785765) and SummonZephyros(2) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Act,90219263,UseEgotist) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,77778835,UseParty,2) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(SpSum,85909450,SummonHPPD) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(SpSum,86848580,SummonZerofyne) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Act,19337371,UseSign,Sum) then
    OPTSet(19337371)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,14785765) and SummonZephyros(2) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  return nil
end
function ChannelerTarget(cards)
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return Add(cards,PRIO_TOFIELD)
end
function HarpistTarget(cards)
  if LocCheck(cards,LOCATION_DECK) then
    return Add(cards)
  end
  if CurrentOwner(cards[1])==1 then
    return Add(cards,PRIO_TOHAND)
  end
  return BestTargets(cards,1,TARGET_TOHAND)
end
function DancerTarget(cards)
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_TOFIELD)
  end
  return Add(cards)
end
function PartyTarget(cards,min)
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return Add(cards,PRIO_TOFIELD,min)
end
function HHGTarget(cards)
  if HasID(cards,19337371) and SignCheck() then
    return {CurrentIndex}
  end
  return BestTargets(cards)
end
function HarpieCard(cards,min,max,id,c)
  if id == 76812113 then
    id = c.original_id
  end
  if id == 90238142 then
    return ChannelerTarget(cards)
  end
  if id == 56585883 then
    return HarpistTarget(cards)
  end
  if id == 68815132 then
    return DancerTarget(cards)
  end
  if id == 90219263 then -- Egotist
    return Add(cards,PRIO_TOFIELD)
  end
  if id == 19337371 then -- Sign
    return Add(cards)
  end
  if id == 15854426 then -- Divine Wind
    return Add(cards,PRIO_TOFIELD)
  end
  if id == 77778835 then
    return PartyTarget(cards,min)
  end
  if id == 85909450 then -- HPPD
    return Add(cards,PRIO_TOGRAVE)
  end
  if id == 86848580 then -- Zerofyne
    return Add(cards,PRIO_TOGRAVE)
  end
  if id == 75782277 then
    return HHGTarget(cards)
  end
  return nil
end
--
function ChainHarpist(c)
  if FilterLocation(c,LOCATION_MZONE) 
  and CardsMatchingFilter(AIMon(),FilterRace,RACE_WINDBEAST)>0
  and CardsMatchingFilter(OppMon(),HarpistFilter)>0
  and NotNegated(c)
  and OPTCheck(56585884)
  then
    OPTSet(56585884)
    return true
  end
  OPTSet(56585883)
  return true
end
function ChainParty(c)
  if Duel.GetCurrentPhase()==PHASE_END
  and Duel.GetTurnPlayer()~=player_ai
  and SignCheck(AIHand())
  then
    return true
  end
  return false
end
function HarpieChain(cards)
  if HasID(cards,19337371) then -- Sign
    return {1,CurrentIndex}
  end
  if HasID(cards,15854426) then -- Divine Wind
    return {1,CurrentIndex}
  end
  if HasID(cards,56585883,ChainHarpist) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,77778835,ChainParty) then
    return {1,CurrentIndex}
  end
  return nil
end
function HarpieEffectYesNo(id,card)
  local result = nil
  if id == 19337371 -- Sign
  or id == 15854426 -- Divine Wind 
  then
    result = 1
  end
  if id == 56585883 and ChainHarpist(card)
  then
    result = 1
  end
  return result
end

function HarpieOption(options)
  return nil
end

HarpieAtt={
76812113, -- Harpie Lady
75064463, -- Harpie Queen
80316585, -- Cyber Harpie Lady
56585883, -- Harpie Harpist
90238142, -- Harpie Channeler
91932350, -- Harpie Lady #1
--68815132, -- Harpie Dancer
86848580, -- Zerofyne
85909450, -- HPPD
}
HarpieDef={

}
function HarpiePosition(id,available)
  result = nil
  for i=1,#HarpieAtt do
    if HarpieAtt[i]==id 
    then 
      result=POS_FACEUP_ATTACK
    end
  end
  for i=1,#HarpieDef do
    if HarpieDef[i]==id 
    then 
      result=POS_FACEUP_DEFENCE 
    end
  end
  return result
end

