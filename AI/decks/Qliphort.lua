function QliphortFilter(c,exclude)
  return IsSetCode(c.setcode,0xaa) and (exclude == nil or c.id~=exclude)
end
ScaleList={
[65518099] = 9,  -- Tool
[90885155] = 9,  -- Shell
[64496451] = 1,  -- Disk
[37991342] = 9,  -- Genome
[91907707] = 1,  -- Archive
[16178681] = 4,  -- Odd-Eyes
[43241495] = 4,  -- Trampolynx
}
function Scale(c)
  return ScaleList[c.id]
end
function ScaleCheck(p)
  local cards=AIST()
  local result = 0
  local count = 0
  if p == 2 then
    cards=OppST()
  end
  for i=1,#cards do
    if bit32.band(cards[i].type,TYPE_PENDULUM)>0 then
      result = Scale(cards[i])
      count = count + 1
    end
  end
  if count == 0 then
    return false
  elseif count == 1 then
    return result
  elseif count == 2 then
    return true
  end
  return nil
end
function QliphortAttackBonus(id,level)
  if level == 4 then
    if id == 90885155 or id == 64496451 then
      return 1000
    elseif id == 37991342 or id == 91907707 then
      return 600
    end
  end
  return 0
end
function TributeCheck(amount)
  if HasID(AIST(),17639150,true,nil,nil,nil,FilterPosition,POS_FACEUP) then
    amount = math.max(amount-1,1)
  end
  local result = PriorityCheck(AIMon(),PRIO_TOGRAVE,amount,QliphortFilter)
  if result == -1 then return false end
  return result
end
function SkillDrainCheck()
  return HasID(UseLists({AIST(),OppST()}),82732705,true,nil,nil,nil,FilterPosition,POS_FACEUP)
end

function ToolCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists({AIHand(),AIST()}),65518099,true)
  end
  return true
end
function SummonersCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists({AIHand(),AIST()}),65518099,true) and HasID(AIDeck(),65518099,true)
  end
  return true
end
function KillerCond(loc,c)
  if loc == PRIO_TOHAND then
    return TributeSummonKiller()
  end
  return true
end
function ShellCond(loc,c)
  if loc == PRIO_TOHAND then
    return TributeSummonShell() and not HasID(AIHand(),90885155,true)
  end
  if loc == PRIO_TOFIELD then
    return SkillDrainCheck()
  end
  return true
end
function DiskCond(loc,c)
  if loc == PRIO_TOHAND then
    return (TributeSummonDisk() or PendulumSummon(2))and not HasID(AIHand(),64496451,true)
  end
  if loc == PRIO_TOFIELD then
    return SkillDrainCheck()
  end
  return true
end
function GenomeCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists({AIHand(),AIMon(),AIExtra()}),37991342,true)
  end
  if loc == PRIO_TOFIELD then
    return CardsMatchingFilter(OppST(),DestroyFilter) 
    > CardsMatchingFilter(AIMon(),FilterID,37991342) + GetMultiple(37991342)
  end
  if loc == PRIO_TOGRAVE then
    return CardsMatchingFilter(OppST(),DestroyFilter) > GetMultiple(37991342)
  end
end
function ArchiveFilter(c)
  return c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0 and not ToHandBlacklist(c.id) 
end
function ArchiveCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists({AIHand(),AIMon(),AIExtra()}),91907707,true) or PendulumSummon(2)
  end
  if loc == PRIO_TOFIELD then
    return CardsMatchingFilter(OppMon(),ArchiveFilter) 
    > CardsMatchingFilter(AIMon(),FilterID,00706925) + GetMultiple(00706925)
  end
  if loc == PRIO_TOGRAVE then
    return CardsMatchingFilter(OppMon(),ArchiveFilter) > GetMultiple(00706925)
  end
  return true
end
function OddEyesCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists({AIHand(),AIST()}),65518099,true)
  end
  return true
end
function LynxCond(loc,c)
  if loc == PRIO_TOHAND then
    return HasID(UseLists({AIHand(),AIST()}),65518099,true)
  end
  return true
end
function SacrificeCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists({AIHand(),AIST()}),17639150,true) 
    and (PriorityCheck(AIHand(),PRIO_TOFIELD)>2 or CardsMatchingFilter(AIMon(),QliphortFilter)>0)
  end
  return true
end
function ApoCond(loc,c)
  if loc == PRIO_TOHAND then
    return HasID(AIExtra(),65518099,true)
  end
  return true
end

function UseTool(c)
  if bit32.band(c.location,LOCATION_HAND)>0 then
    return ScaleCheck() == false or ScaleCheck() < 8
  elseif bit32.band(c.location,LOCATION_SZONE)>0 then
    return AI.GetPlayerLP(1)>4000 or ScaleCheck() ~= true
  end
end
function UseSacrifice()
  return not HasID(AIST(),17639150,true,nil,nil,nil,FilterPosition,POS_FACEUP)
end
function PendulumSummon(count)
  if count == nil then count = 1 end
  return CardsMatchingFilter(AIExtra(),QliphortFilter)>=count
end
function TributeSummonShell()
  if TributeCheck(2) and (not SkillDrainCheck() or TributeCheck(2)>5)
  and not Duel.CheckNormalSummonActivity(player_ai) 
  then
    return true
  end
  return false
end
function TributeSummonDisk()
  if TributeCheck(2) and (not SkillDrainCheck() and DualityCheck() or TributeCheck(2)>5)
  and not Duel.CheckNormalSummonActivity(player_ai)
  then
    return true
  end
  return false
end
function TributeSummonKiller()
  if TributeCheck(3) and (not SkillDrainCheck() or TributeCheck(3)>5)
  and not Duel.CheckNormalSummonActivity(player_ai)
  then
    return true
  end
  return false
end
function TributeSummonArchive()
  if TributeCheck(1) and TributeCheck(1)>5 then
    return true
  end
  return false
end
function TributeSummonGenome()
  if TributeCheck(1) and TributeCheck(1)>5 then
    return true
  end
  return false
end
function SummonArchive()
  if OverExtendCheck() then
    return true
  end
  return false
end
function SummonGenome()
  if OverExtendCheck() then
    return true
  end
  return false
end
function SummonShell()
  if OverExtendCheck() then
    return true
  end
  return false
end
function SummonDisk()
  if OverExtendCheck() then
    return true
  end
  return false
end
function UseGenome()
  return ScaleCheck() and ScaleCheck()<9 and PendulumSummon()
end
function UseArchive()
  return ScaleCheck()==9 and PendulumSummon()
end
function UseDisk()
  return ScaleCheck()==9 and PendulumSummon() and not TributeSummonDisk()
end
function UseShell()
  return ScaleCheck() and ScaleCheck()<9 and PendulumSummon() and not TributeSummonShell()
end
function UseTrampolynx()
  return ScaleCheck()==9 and PendulumSummon()
end
function UseOddEyes()
  return (ScaleCheck()==9 and PendulumSummon() 
  or not HasID(UseLists({AIMon(),AIST()},65518099,true))
  or not HasID(UseLists({AIMon(),AIST()},43241495,true)))
  and not HasID(AIST(),16178681,true)
end
function QliphortInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  GlobalQliphortNormalSummon = nil
  for i=1,#SpSum do
    if PendulumCheck(SpSum[i]) and PendulumSummon() then
      GlobalPendulumSummoning = true
      return {COMMAND_SPECIAL_SUMMON,i}
    end
  end
  if HasID(Act,27279764) then -- Killer
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,79816536) then -- Summoners Art
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,17639150) and UseSacrifice() then 
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasID(Act,43241495) and UseTrampolynx() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,16178681) and UseOddEyes() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,91907707) and UseArchive() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,65518099,false,nil,nil,nil,FilterLocation,LOCATION_HAND) 
  and UseTool(Act[CurrentIndex]) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,65518099,false,nil,nil,nil,FilterLocation,LOCATION_SZONE) 
  and UseTool(Act[CurrentIndex]) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,37991342) and UseGenome() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,64496451) and UseDisk() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,90885155) and UseShell() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Sum,27279764) and TributeSummonKiller() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,64496451) and TributeSummonDisk() then
    GlobalQliphortNormalSummon = 1
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,90885155) and TributeSummonShell() then
    GlobalQliphortNormalSummon = 1
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,37991342) and TributeSummonGenome() then
    GlobalQliphortNormalSummon = 1
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,91907707) and TributeSummonArchive() then
    GlobalQliphortNormalSummon = 1
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,37991342) and SummonGenome() then
    GlobalQliphortNormalSummon = 2
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,91907707) and SummonArchive() then
    GlobalQliphortNormalSummon = 2
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,90885155) and SummonShell() then
    GlobalQliphortNormalSummon = 2
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,64496451) and SummonDisk() then
    GlobalQliphortNormalSummon = 2
    return {COMMAND_SUMMON,CurrentIndex}
  end
  return nil
end
function QliphortOption(options)
  local i = GlobalQliphortNormalSummon
  if i then
    GlobalQliphortNormalSummon = nil
    return(i)
  end
end
function QliphortTribute(cards,min,max)
  if DeckCheck(AI_QLIPHORT) then
    if HasID(AIST(),17639150,false,nil,nil,nil,FilterPosition,POS_FACEUP) then
      min = math.min(min-1,1)
    end
    return Add(cards,PRIO_TOGRAVE,min)
  end
  return nil
end
function SacrificeTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards,PRIO_TOGRAVE)
  end
  return Add(cards)
end
function ArchiveTarget(cards)
  local result = BestTargets(cards,1,TARGET_DESTROY,TargetCheck) 
  TargetSet(cards[1])
  return result
end
function GenomeTarget(cards)
  local result = BestTargets(cards,1,TARGET_TOHAND,TargetCheck) 
  TargetSet(cards[1])
  return result
end
function QliphortCard(cards,min,max,id,c)
  if c then
    id = c.id
  end
  if GlobalPendulumSummoning then
    GlobalPendulumSummoning = nil
    local x = CardsMatchingFilter(AIExtra(),QliphortFilter)
    if x<2 and CardsMatchingFilter(cards,QliphortFilter,65518099)>x then x = x+1 end
    if CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN)>0 then
      x = math.min(x,2)
    end
    return Add(cards,PRIO_TOFIELD,x)
  end
  if id == 65518099 then -- Tool
    return Add(cards)
  end
  if id == 79816536 then -- Summoners Art
    return Add(cards)
  end
  if id == 17639150 then
    return SacrificeTarget(cards)
  end
  if id == 91907707 then
    return ArchiveTarget(cards)
  end
  if id == 37991342 then
    return GenomeTarget(cards)
  end
  if id == 64496451 then -- Disk
    return Add(cards,PRIO_TOFIELD,2)
  end
  if id == 16178681 then -- Odd-Eyes
    return Add(cards)
  end
  if id == 04450854 then
    return Add(cards,PRIO_EXTRA,math.min(min,3))
  end
  return nil
end
function ChainArchive()
  return CardsMatchingFilter(OppMon(),ArchiveFilter)>0
end
function ChainGenome()
  return CardsMatchingFilter(OppST(),DestroyFilter)>0
end
function ChainApoqliphort()
  if RemovalCheck(04450854) then
    return true
  end
  return (Duel.GetCurrentPhase()==PHASE_END or Duel.GetTurnPlayer()==PLAYER_AI) 
  and PriorityCheck(AIExtra(),PRIO_EXTRA,3,QliphortFilter)>2
end
function ChainSkillDrain()
  local e = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
  if SkillDrainCheck() then
    return false
  end
	if e then
    local c=e:GetHandler()
    if c and c:IsControler(1-player_ai) and c:IsLocation(LOCATION_MZONE) 
    and NegateBlacklist(c:GetCode())==0 and not c:IsHasEffect(EFFECT_IMMUNE)
    and not c:IsHasEffect(EFFECT_DISABLE)and not c:IsHasEffect(EFFECT_DISABLE_EFFECT)
    then
      return true
    end
  end
  if Duel.GetCurrentPhase() == PHASE_BATTLE then
    if Duel.GetTurnPlayer()==player_ai 
    and not OppHasStrongestMonster() 
    and CardsMatchingFilter(OppMon(),NegateBPCheck)>0 
    then
      return true
    end
    local source = Duel.GetAttacker()
		local target = Duel.GetAttackTarget()
    if source and target then
      if source:IsControler(player_ai) then
        target = Duel.GetAttacker()
        source = Duel.GetAttackTarget()
      end
      if source:GetAttack() >= target:GetAttack() and target:IsControler(player_ai) 
      and source:GetAttack() <= target:GetAttack()+QliphortAttackBonus(target:GetCode(),target:GetLevel())
      and target:IsPosition(POS_FACEUP_ATTACK) 
      then
        return true
      end
    end
  end
  return false
end
function ChainVanity()
  for i=1,Duel.GetCurrentChain() do
    if Duel.GetOperationInfo(Duel.GetCurrentChain(), CATEGORY_SPECIAL_SUMMON) 
    and  Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_PLAYER)~=player_ai 
    then
      return true
    end
  end
  return false
end
function QliphortChain(cards)
  if HasID(cards,91907707) and ChainArchive() then
    return {1,CurrentIndex}
  end
  if HasID(cards,37991342) and ChainGenome() then
    return {1,CurrentIndex}
  end
  if HasID(cards,04450854) and ChainApoqliphort() then
    return {1,CurrentIndex}
  end
  if HasID(cards,82732705) and ChainSkillDrain() then
    return {1,CurrentIndex}
  end
  if HasID(cards,05851097) and ChainVanity() then
    return {1,CurrentIndex}
  end
  if HasID(cards,64496451) then -- Disk
    return {1,CurrentIndex}
  end
  if HasID(cards,16178681) then -- Odd-Eyes
    return {1,CurrentIndex}
  end
  if HasID(cards,43241495) then -- Trampolynx
    return {1,CurrentIndex}
  end
  if HasID(cards,17639150) then -- Sacrifice
    return {1,CurrentIndex}
  end
  return nil
end
function QliphortEffectYesNo(id,card)
  local result = nil
  if id==91907707 and ChainArchive() then
    result = 1
  end
  if id==37991342 and ChainGenome() then
    result = 1
  end
  if id==64496451 or id==16178681 --or id==43241495  -- Disk, Odd-Eyes,Trampolynx
  or id==17639150 -- Sacrifice
  then
    result = 1
  end
  return result
end
QliphortAtt={
  27279764,90885155,64496451, --Killer, Shell, Disk
  37991342,91907707 -- Genome, Archive
}
QliphortDef={
  65518099 -- Tool
}
function QliphortPosition(id,available)
  result = nil
  for i=1,#QliphortAtt do
    if QliphortAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#QliphortDef do
    if QliphortDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  return result
end
