function HEROPriority()
AddPriority({

-- HERO

[69884162] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Neos Alius
[25259669] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Goblindbergh
[63060238] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Blazeman
[50720316] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Shadow Mist
[18063928] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Tin Goldfish
[00423585] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Summoner Monk
[79979666] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Bubbleman

[00213326] = {1,1,1,1,1,1,1,1,1,1,nil},         -- E-Call
[08949584] = {1,1,1,1,1,1,1,1,1,1,nil},         -- AHL
[18511384] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Fusion Recovery
[24094653] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Polymerization
[45906428] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Miracle Fusion
[55428811] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Fifth Hope
[21143940] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Mask Change
[84536654] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Form Change
[57728570] = {1,1,1,1,1,1,1,1,1,1,nil},         -- CCV
[83555666] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Ring of Destruction

[95486586] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Core
[03642509] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Great Tornado
[22093873] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Divine Wind
[01945387] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Nova Master
[22061412] = {1,1,1,1,1,1,1,1,1,1,nil},         -- The Shining
[29095552] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Acid
[33574806] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Escuridao
[40854197] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Absolute Zero
[50608164] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Koga
[58481572] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Dark Law
[16304628] = {1,1,1,1,1,1,1,1,1,1,nil},         -- Gaia


})
end

function HEROFilter(c,exclude)
  local id = c.id
  if exclude and type(exclude)=="table" then 
    id = c.cardid
    exclude = exclude.cardid
  end
  return IsSetCode(c.setcode,0x8) and (exclude == nil or id~=exclude)
end
function EHEROFilter(c,exclude)
  return IsSetCode(c.setcode,0x3008) and HEROFilter(c,exclude)
end
function MHEROFilter(c,exclude)
  return IsSetCode(c.setcode,0xa008) and HEROFilter(c,exclude)
end
OHero={
03642509, -- Great Tornado
01945387, -- Nova Master
22061412, -- The Shining
33574806, -- Escuridao
40854197, -- Absolute Zero
16304628, -- Gaia
}
function OmniHEROFilter(c,exclude) -- the Omni heroes, fusions which require 1 HERO and 1 attribute
  if not HEROFilter(c,exclude) then return false end
  for i=1,#OHero do
    if c.id == OHero[i] then
      return true
    end
  end
  return false
end
function FusionMaterialCheck(fusion,cards)
  if OmniHEROFilter(fusion) then
    for i=1,#cards do
      local c = cards[i]
      if FilterAttribute(c,fusion.attribute) 
      and CardsMatchingFilter(cards,HEROFilter,c)>0
      then
        return true
      end
    end
  end
  if fusion.id == 95486586 then
    return CardsMatchingFilter(cards,HEROFilter)>2
  end
  return false
end
function SummonAbZero(c,cards)
  return FusionMaterialCheck(c,cards)
end
function UsePoly(c)
  if HasID(AIExtra(),40854197,true,SummonAbZero,AICards()) 
  and not HasID(AIMon(),40854197,true)
  and OverExtendCheck(6,2)
  then
    return true
  end
  return false
end

function SummonHERO(c,mode)
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
  if mode == 4
  and (#AIHand()>5
  or c.attack>1600)
  then
    return true
  end
end
function UseRotaHero(c)
  return true
end
GlobalWaveMotionTurn={}
function WaveMotionDamage()
  local result = 0
  for i=1,#AIST() do
    local c = AIST()[i]
    if c.id == 38992735 
    and NotNegated(c)
    and FilterPosition(c,POS_FACEUP)
    and GlobalWaveMotionTurn[c.cardid]
    then
      result = result + 500 * (Duel.GetTurnCount() - GlobalWaveMotionTurn[c.cardid])
    end
  end
  return result
end
function UseWaveMotionCannon(c)
  if FilterLocation(c,LOCATION_HAND) or FilterPosition(c,POS_FACEDOWN) then
    GlobalWaveMotionTurn[c.cardid]=Duel.GetTurnCount()
    return true
  else
    return WaveMotionDamage()>=AI.GetPlayerLP(2)
  end
  return false
end
function UseShardOfGreed(c)
  if FilterLocation(c,LOCATION_HAND) or FilterPosition(c,POS_FACEDOWN) then
    return true
  end
  return c:get_counter(0xd)>=2
end
function UseSixSamUnited(c)
  if FilterLocation(c,LOCATION_HAND) or FilterPosition(c,POS_FACEDOWN) then
    return true
  end
  return c:get_counter(0x3003)>=2
end
function HEROInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  if HasIDNotNegated(Act,38992735,UseWaveMotionCannon) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,33904024,UseShardOfGreed) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,72345736,UseSixSamUnited) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  --print(FusionMaterialCheck(AICards(),40854197))
  if HasIDNotNegated(Act,24094653,UsePoly) then -- Polymerization
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,32807846,UseRotaHero) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  return nil
end
function RoDTarget(cards)
  if GlobalCardMode==1 then
    GlobalCardMode=nil
    return GlobalTargetGet(cards,true)
  end
  return BestTargets(cards,1,TARGET_DESTROY,RoDFilter)
end
function CCVTarget(cards)
  if GlobalCardMode==1 then
    GlobalCardMode=nil
    return GlobalTargetGet(cards,true)
  end
  return Add(cards,PRIO_TOGRAVE)
end
function HEROCard(cards,min,max,id,c)
  if id == 83555666 then
    return RoDTarget(cards)
  end
  if id == 57728570 then
    return CCVTarget(cards)
  end
  return nil
end

function RoDFilter(c)
  if c.GetCode then
    atk = c:GetAttack()
    textatk = c:GetBaseAttack()
  else
    atk = c.attack
    textatk = c.text_attack
  end
  return DestroyFilter(c)
  and FilterPosition(c,POS_FACEUP)
  and Targetable(c,TYPE_TRAP)
  and Affected(c,TYPE_TRAP)
  and atk<AI.GetPlayerLP(1)
  and textatk<AI.GetPlayerLP(2)
end
function ChainRoD(c)
  local targets = SubGroup(OppMon(),RoDFilter)
  local targets2 = SubGroup(targets,PriorityTarget,true)
  if RemovalCheckCard(c) and #targets>0 then
    return true
  end
  if #targets2>0 and UnchainableCheck(83555666) then
    BestTargets(targets2,1,TARGET_DESTROY)
    GlobalTargetSet(targets2[1])
    GlobalCardMode = 1
    return true
  end
  if Duel.GetCurrentPhase()==PHASE_BATTLE then
    local aimon,oppmon = GetBattlingMons()
    if WinsBattle(oppmon,aimon) 
    and RoDFilter(oppmon)
    and UnchainableCheck(83555666) 
    then
      GlobalTargetSet(oppmon)
      GlobalCardMode = 1
      return true
    end
  end
  if #OppMon()==1 and #targets==1 
  and Duel.GetCurrentPhase()==PHASE_END
  and ExpectedDamage(2)+targets[1].text_attack>AI.GetPlayerLP(2)
  and UnchainableCheck(83555666) 
  then
    return true
  end
  return false
end
function CCVFilter(c)
  local atk
  if c.GetCode then
    atk = c:GetAttack()
  else
    atk = c.attack
  end
  return FilterAttribute(c,ATTRIBUTE_DARK) and atk<=1000
end
function ChainCCV(card)
  local c = nil
  local targets = RemovalCheckList(AIMon(),nil,nil,nil,CCVFilter)
  if targets and #targets == 1 then
    GlobalTargetSet(targets[1])
    GlobalCardMode = 1
    return true
  elseif targets and #targets > 1 then
    return true
  end
  if RemovalCheckCard(card) then
    return true
  end
  if Duel.GetCurrentPhase()==PHASE_BATTLE then
    local aimon,oppmon=GetBattlingMons()
    if WinsBattle(oppmon,aimon) 
    and CCVFilter(aimon) 
    then
      GlobalTargetSet(aimon)
      GlobalCardMode = 1
      return true
    end
  end
  local count = 0
  for i=1,#OppMon() do
    local c = OppMon()[i]
    if DestroyFilter(c)
    and c.attack>=1500
    and (FilterPosition(c,POS_FACEUP)
    or FilterPublic(c))
    then
      count=count+1
    end
  end
  if count>2 or count>1 and #OppMon()+#OppHand()>3 then
    return true
  end
  return false
end
function HEROChain(cards)
  if HasID(cards,83555666,ChainRoD) then -- Ring of Destruction
    return {1,CurrentIndex}
  end
  if HasID(cards,57728570,ChainCCV) then -- Crush Card Virus
    return {1,CurrentIndex}
  end
  return nil
end
function HEROEffectYesNo(id,card)
  local result = nil
  if id == 19337371 -- Sign
  then
    OPTSet(19337371)
    result = 1
  end
  return result
end

function HEROOption(options)
  return nil
end

HEROAtt={
69884162, -- Neos Alius
95486586, -- Core
03642509, -- Great Tornado
22093873, -- Divine Wind
01945387, -- Nova Master
22061412, -- The Shining
29095552, -- Acid
33574806, -- Escuridao
40854197, -- Absolute Zero
50608164, -- Koga
58481572, -- Dark Law
16304628, -- Gaia
}
HERODef={
18063928, -- Tin Goldfish
25259669, -- Goblindbergh
00423585, -- Summoner Monk
79979666, -- Bubbleman
63060238, -- Blazeman
50720316, -- Shadow Mist
}
function HEROPosition(id,available)
  result = nil
  for i=1,#HEROAtt do
    if HEROAtt[i]==id 
    then 
      if Duel.GetCurrentPhase()==PHASE_BATTLE
      and Duel.GetTurnPlayer()~=player_ai
      then
        result=POS_FACEUP_DEFENCE
      else
        result=POS_FACEUP_ATTACK
      end
    end
  end
  for i=1,#HERODef do
    if HERODef[i]==id 
    then 
      result=POS_FACEUP_DEFENCE 
    end
  end
  return result
end

