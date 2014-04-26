function IsGadget(id)
  return id == 86445415 -- Red
      or id == 41172955 -- Green
      or id == 13839120 -- Yellow
end
function GadgetCount(cards)
  local count=0
  for i=1,#cards do
    if IsGadget(cards[i].id) then
      count=count+1
    end
  end
  return count
end
function GraveCheck(level)
  local result=0
  local cards=AIGrave()
  for i=1,#cards do
    if cards[i].level==level then
      result = result + 1
    end
  end
  return result
end
function HandCheck(level)
  local result=0
  local cards=AIHand()
  for i=1,#cards do
    if cards[i].level==level then
      result = result + 1
    end
  end
  return result
end
function SubGroup(cards,filter,opt)
  result = {}
  for i=1,#cards do
    if opt and filter(cards[i],opt) or opt==nil and filter(cards[i]) then
      result[#result+1]=cards[i]
    end
  end
  return result
end
function ExpectedDamageFilter(card)
  return card:IsControler(1-player_ai) and card:IsType(TYPE_MONSTER) and card:IsPosition(POS_FACEUP_ATTACK)
  and card:GetAttackedCount()==0 and not card:IsHasEffect(EFFECT_CANNOT_ATTACK_ANNOUNCE) and not card:IsHasEffect(EFFECT_CANNOT_ATTACK)
end
function ExpectedDamage()
  local result=0
  local g=Duel.GetMatchingGroup(ExpectedDamageFilter,1-player_ai,LOCATION_MZONE,0,nil)  
  local c=g:GetFirst()
  while c do
    result=result+c:GetAttack()
    c=g:GetNext()
  end
  return result
end
function BestTargets(cards,count,DestroyCheck,filter)
  local result = {}
  local AIMon=AIMon()
  if count == nil then count = 1 end
  ApplyATKBoosts(AIMon)
  local AIAtt=Get_Card_Att_Def(AIMon,"attack",">",nil,"attack")
  for i=1,#cards do
    cards[i].index = i
    cards[i].prio = 0
    if bit32.band(cards[i].type,TYPE_MONSTER)>0 then
      if bit32.band(cards[i].position, POS_FACEUP)>0 then
        if cards[i]:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)>0 and DestroyCheck
        or cards[i]:is_affected_by(EFFECT_IMMUNE)>0
        then
          cards[i].prio = 1
        else
          cards[i].prio = math.max(cards[i].attack+1,cards[i].defense)+5
          if cards[i].owner==2 and cards[i]:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE)==0 then
            cards[i].prio = math.max(0,cards[i].prio-AIAtt*.75)
          end
        end
      else
        cards[i].prio = 2
      end
    else
      if cards[i]:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)>0 and DestroyCheck
      or cards[i]:is_affected_by(EFFECT_IMMUNE)>0
      then
        cards[i].prio = 1
      else    
        if bit32.band(cards[i].position, POS_FACEUP)>0 then
          cards[i].prio = 4
        else
          cards[i].prio = 3
        end
      end
    end
    if filter and not filter(cards[i]) then
      cards[i].prio = 0
    end
    if cards[i].owner == 1 then 
      cards[i].prio = -1 * cards[i].prio
    end
  end
  table.sort(cards,function(a,b) return a.prio > b.prio end)
  for i=1,count do
    result[i]=cards[i].index
  end
  return result
end
function SetBanishPriority(cards)
  for i=1,#cards do
    local c=cards[i]
    c.index=i
    c.prio=1
    if c.location==LOCATION_GRAVE then
      c.prio=2
    else
      c.prio=1
    end
    if c.id==39284521 then
      if c.location==LOCATION_GRAVE then
        c.prio=3
      else
        c.prio=-1
      end
    end
    if c.id==05556499 then
      c.prio=-1
    end
    if c.id==18063928 or c.id==18964575
    or c.id==28912357
    then
      if c.location==LOCATION_GRAVE then
        c.prio=3
      else
        c.prio=1
      end
    end
    if c.id==39765958 or c.id==83994433 then
      c.prio=0
    end
    if BanishBlacklist(c.id)>0 then 
      c.prio=-1
    end
  end
end
function BanishCostCheck(cards,count)
  SetBanishPriority(cards)
  local result=-1
  if cards and #cards>=count then
    table.sort(cards,function(a,b)return a.prio>b.prio end)
    result=cards[count].prio
  end
  return result
end
function BanishCost(cards,count)
  local result=nil
  SetBanishPriority(cards)
  if cards and #cards>=count then
    table.sort(cards,function(a,b)return a.prio>b.prio end)
    result={}
    for i=1,count do
      result[i]=cards[i].index
    end
  end
  return result
end
function SetDiscardPriority(cards)
  for i=1,#cards do
    local c=cards[i]
    c.index=i
    c.prio=0
    if c.id==39284521 or c.id==90411554 then
      c.prio=-1
    end
    if c.id==05556499 then
      c.prio=3
    end
    if c.id==18964575 then
      c.prio=1
    end
    if c.id==86445415 or c.id==41172955
    or c.id==13839120
    then
      if GadgetCount(cards)>1 then
        c.prio=2
      else
        c.prio=0
      end
    end
  end
end
function DiscardCostCheck(cards,count)
  SetDiscardPriority(cards)
  local result=-1
  if cards and #cards>=count then
    table.sort(cards,function(a,b)return a.prio>b.prio end)
    result=cards[count].prio
  end
  return result
end
function DiscardCost(cards,count)
  SetDiscardPriority(cards)
  local result=nil
  if cards and #cards>=count then
    table.sort(cards,function(a,b)return a.prio>b.prio end)
    result={}
    for i=1,count do
      result[i]=cards[i].index
    end
  end
  return result
end
function SummonMachinaFortress(card)
  local result = false
  if card.location == LOCATION_GRAVE then
    result = HasID(AIHand(),39284521) or GadgetCount(AIHand())>1
  else
    result = HasID(AIHand(),18964575) or GadgetCount(AIHand())>1
    or Get_Card_Count_ID(AIHand(),05556499)>1
  end
  return result and (OverExtendCheck() or FieldCheck(7)==1)
end
function SummonGearGigant()
  return (Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack")< 2300 
  or Chance(70) or MP2Check()) and not (SummonRagnaZero() and HasID(AIExtra(),94380860))
end
function SummonDracossack()
  return MP2Check()
end
function SummonBigEye()
  return OppHasStrongestMonster() 
  and (Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack") > 2300
  or Get_Card_Att_Def(OppMon(),"defense",">",POS_FACEUP_DEFENSE,"defense") > 2300)
end
function SummonTinGoldfish()
  return GadgetCount(AIHand())>0 and FieldCheck(4)==0
end
function SummonGearframe()
  return HasID(AIHand(),94656263) or FieldCheck(4)==1
end
function SummonMaskedChameleon()
  return not(Get_Card_Count_Att_Def(AIGrave(),"==",nil,0,nil)>0 and not Duel.CheckSpecialSummonActivity(player_ai)) == (FieldCheck(4)==1)
end
function SummonGadget()
  return HasID(AIHand(),94656263) or FieldCheck(4)==1 
  --or HasIDNotNegated(AIST(),97077563) and GraveCheck(4)>0
end
function SummonNaturiaBeast()
  return Chance(50) and Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack") < 2200
end
function SummonArmades()
  return true
end
function SummonStardustSpark()
  return true
end
function SummonJeweledRDA(card)
  local OppAtt=Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack")
  return UseJeweledRDA(card,1) or OppAtt > 2500
end

function IsMonster(card)
  return bit32.band(card.type,TYPE_MONSTER)>0
end

function UseCotH(card)
  if HasID(AIGrave(),05556499) then
    return true
  end
  if GadgetCount(AIGrave())>0 and GadgetCount(AIHand())==0 then
    return true
  end
  if FieldCheck(4)==1 and CardsMatchingFilter(AIGrave(),function(c) return c.level==4 end)>0
  or FieldCheck(7)==1 and CardsMatchingFilter(AIGrave(),function(c) return c.level==7 end)>0
  then
    return true
  end
  if HandCheck(4)>0 and GraveCheck(4)>0 
  and not Duel.CheckNormalSummonActivity(player_ai)
  then
    return true
  end
  return false
end
function UseBigEye()
  return true
end
function OnSelectSum(cards, sum)
	local result = {}
	local num_levels = 0
  for i=1,#cards do
    cards[i].index = i
    cards[i].prio = 0
    if cards[i].id == 05556499 then
      cards[i].prio = 10
    end
    if cards[i].id == 39284521 then
      if HasID(cards,05556499) then
        cards[i].prio = 1
      else
        cards[i].prio = 9
      end
    end
    if cards[i].id == 18964575 and HasID(cards,05556499) then
      cards[i].prio = 8
    end
    if cards[i].id == 86445415 or cards[i].id == 41172955 or cards[i].id == 13839120 then
      if GadgetCount(cards)>0 then
        cards[i].prio = 7
      else
        cards[i].prio = 3
      end
    end
    if cards[i].id == 18964575 then
      cards[i].prio = 8
    end
    if cards[i].id == 42940404 then
      cards[i].prio = 3
    end
    if cards[i].id == 18063928 then
      cards[i].prio = 2
    end
  end
  table.sort(cards,function(a,b) return a.prio > b.prio end)
  for i=1,#cards do
    if i==1 or cards[i].level<sum then
      num_levels = num_levels + cards[i].level
      result[i]=cards[i].index
      if(num_levels >= sum) then
        break
      end
    end
  end
	return result
end
function RedoxFilter(card)
  return bit32.band(card.attribute,ATTRIBUTE_EARTH)>0
end
function RedoxFilter1(card,id)
  return card.id~=id and bit32.band(card.attribute,ATTRIBUTE_EARTH)>0
end
function UseRedox1(card)
  local cards=SubGroup(AIHand(),RedoxFilter1,card.cardid)
  if cards and #cards>0 then
    local check = DiscardCostCheck(cards,1)
    return check >= 0 and FieldCheck(7)==1 or check > 0
  end
  return false
end
function RedoxFilter2(card,id)
  return card.id~=id and (bit32.band(card.attribute,ATTRIBUTE_EARTH)>0 or bit32.band(card.race,RACE_DRAGON)>0)
end
function UseRedox2(card)
  local cards=SubGroup(UseLists({AIHand(),AIGrave()}),RedoxFilter2,card.cardid)
  if cards and #cards>0 then
    local check = BanishCostCheck(cards,2)
    local mon = AIMon()
    return check >= 0 and FieldCheck(7)==1 or check > 0 
    and AI.GetCurrentPhase()==PHASE_MAIN2 and #mon==0
  end
  return false
end
function UseGearframe(card)
  if bit32.band(card.type,TYPE_SPELL)>0 then
    return true
  else
    return AI.GetCurrentPhase()==PHASE_MAIN2
  end
end
function MPBTokenCount(cards)
  local count=0
  for i=1,#cards do
    if bit32.band(cards[i].type,TYPE_TOKEN)>0 and cards[i].setcode == 0x101b then
      count=count+1
    end
  end
  return count
end
function UseDracossack1(card)
  return MPBTokenCount(AIMon())<2 
end
function UseDracossack2(card)
  local oppcards=UseLists({OppMon(),OppST()})
  return MPBTokenCount(AIMon())>0 and (OppHasStrongestMonster() 
  or (AI.GetCurrentPhase()==PHASE_MAIN2 and #oppcards>0))
end
function JeweledRDAFilter(card,id)
  return card.cardid~=id and bit32.band(card.position,POS_FACEUP_ATTACK)>0 
  and card:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 and card:is_affected_by(EFFECT_IMMUNE)==0
end
function UseJeweledRDA(card,mod)
  local aimon=AIMon()
  local AITargets=SubGroup(aimon,JeweledRDAFilter,card.cardid)
  local OppTargets=SubGroup(OppMon(),JeweledRDAFilter,card.cardid)
  local diff=(#OppTargets+mod)-#AITargets
  if HasIDNotNegated(aimon,83994433) and GlobalStardustSparkActivation[aimon[CurrentIndex].cardid]~=Duel.GetTurnCount() then
    diff = diff+1
  end
  AITargets[#AITargets+1]=card
  ApplyATKBoosts(AITargets)
  ApplyATKBoosts(OppTargets)
  local AIAtt=Get_Card_Att_Def(AITargets,"attack",">",nil,"attack")
  local OppAtt=Get_Card_Att_Def(OppTargets,"attack",">",nil,"attack")
  return #AITargets==1 or diff>1 or (diff<=1 and AIAtt-OppAtt < diff*500)
end
function DarkHoleFilter(card)
  return card:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 and card:is_affected_by(EFFECT_IMMUNE)==0
end
function UseDarkHole(card)
  local aimon=AIMon()
  local AITargets=SubGroup(aimon,DarkHoleFilter)
  local OppTargets=SubGroup(OppMon(),DarkHoleFilter)
  local diff=#OppTargets-#AITargets
  if HasIDNotNegated(aimon,83994433) and GlobalStardustSparkActivation[aimon[CurrentIndex].cardid]~=Duel.GetTurnCount() then
    diff = diff+1
  end
  if HasIDNotNegated(AIST(),27243130) or HasID(AIHand(),27243130) then
    diff = diff+1
  end
  ApplyATKBoosts(AITargets)
  ApplyATKBoosts(OppTargets)
  local AIAtt=Get_Card_Att_Def(AITargets,"attack",">",nil,"attack")
  local OppAtt=Get_Card_Att_Def(OppTargets,"attack",">",nil,"attack")
  return (#AITargets==0 and OppAtt >= 2000) or diff>1 or (OppAtt >= 2000 and diff<=1 and AIAtt-OppAtt < diff*500)
end
function GadgetOnSelectInit(cards, to_bp_allowed, to_ep_allowed)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  if HasIDNotNegated(Activatable,28912357) then -- GGX
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,22110647,false,353770352) and UseDracossack1(Activatable[CurrentIndex]) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,22110647,false,353770353) and UseDracossack2(Activatable[CurrentIndex]) then
    GlobalCardMode=2
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,97077563) and UseCotH() and OverExtendCheck() then
    return {COMMAND_ACTIVATE,IndexByID(Activatable,97077563)}
  end
  if HasIDNotNegated(Activatable,80117527) and UseBigEye() then
    return {COMMAND_ACTIVATE,IndexByID(Activatable,80117527)}
  end
  if HasIDNotNegated(Activatable,39765958) and UseJeweledRDA(Activatable[CurrentIndex],0) then
    return {COMMAND_ACTIVATE,IndexByID(Activatable,39765958)}
  end
  if HasID(SpSummonable,80117527) and SummonBigEye() then
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSummonable,80117527)}
  end
  if HasID(SpSummonable,22110647) and SummonDracossack() then
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSummonable,22110647)}
  end
  if HasID(Activatable,42940404) and UseGearframe(Activatable[CurrentIndex]) then
    return {COMMAND_ACTIVATE,IndexByID(Activatable,42940404)}
  end
  if HasID(SpSummonable,33198837) and SummonNaturiaBeast() then
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSummonable,33198837)}
  end
  if HasID(SpSummonable,88033975) and SummonArmades() then
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSummonable,88033975)}
  end
  if HasID(Summonable,18063928) and SummonTinGoldfish() and OverExtendCheck() then
    return {COMMAND_SUMMON,IndexByID(Summonable,18063928)}
  end
  if HasID(Summonable,42940404) and SummonGearframe() then
    return {COMMAND_SUMMON,IndexByID(Summonable,42940404)}
  end
  if HasID(Summonable,53573406) and SummonMaskedChameleon() and OverExtendCheck() then
    return {COMMAND_SUMMON,IndexByID(Summonable,53573406)}
  end
  if HasID(Summonable,86445415) and SummonGadget() then --Red
    return {COMMAND_SUMMON,IndexByID(Summonable,86445415)}
  end
  if HasID(Summonable,41172955) and SummonGadget() then --Green
    return {COMMAND_SUMMON,IndexByID(Summonable,41172955)}
  end
  if HasID(Summonable,13839120) and SummonGadget() then --Yellow
    return {COMMAND_SUMMON,IndexByID(Summonable,13839120)}
  end
  if HasID(Summonable,42940404) then
    return {COMMAND_SUMMON,IndexByID(Summonable,42940404)}
  end
  if (HasID(Summonable,13839120) or HasID(Summonable,86445415)
  or HasID(Summonable,41172955)) and HasBackrow(SetableST) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,18063928) and (not(HandCheck(4)>1) == (FieldCheck(4)==1)) and OverExtendCheck() then
    return {COMMAND_SUMMON,IndexByID(Summonable,18063928)}
  end
  if HasID(Summonable,53573406) and HasID(AIHand(),94656263) and OverExtendCheck() then
    return {COMMAND_SUMMON,IndexByID(Summonable,53573406)}
  end
  if HasID(SpSummonable,05556499) and SummonMachinaFortress(SpSummonable[CurrentIndex]) then
    GlobalActivatedCardID=05556499
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSummonable,05556499)}
  end
  if HasID(Activatable,90411554,false,1446584866) and UseRedox1(Activatable[CurrentIndex]) and OverExtendCheck() then
    GlobalCardMode=1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,90411554,false,1446584864) and UseRedox2(Activatable[CurrentIndex]) then
    GlobalCardMode=2
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
end
function GadgetToHand(cards,count)
  if count==nil then count=1 end
  local result = {}
  local handcount=GadgetCount(AIHand())
  for i=1,#cards do
    local id=cards[i].id
    cards[i].index=i
    cards[i].prio=1
    if id==86445415 or id==41172955 or id==13839120 then
      if handcount==0 then
        cards[i].prio=5
      end
    end
    if id==42940404 and not HasID(AIHand(),42940404) 
    and not HasID(UseLists({AIHand(),AIMon(),AIGrave()}),05556499) 
    then
      cards[i].prio=4
    end
    if id==18063928 and not HasID(AIHand(),18063928) and handcount>0 then
      cards[i].prio=3
    end
    if cards[i].location==LOCATION_GRAVE then
      cards[i].prio=cards[i].prio-1
    end
  end
  
  table.sort(cards,function(a,b) return a.prio>b.prio end)
  for i=1,count do
    result[i]=cards[i].index
  end
  return result
end


function MachinaFortressTarget(cards)
  local result = nil
  local e=Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
  if e and e:GetActivateLocation()==LOCATION_GRAVE then 
    result = BestTargets(cards,1,true)
  end
  if result == nil then result={math.random(#cards)} end
  return result
end
function MaskedChameleonTarget(cards)
  local result = nil
  if HasID(cards,42940404) then
    result = CurrentIndex
  end
  if result == nil then result = math.random(#cards) end
  return {result}
end
function GearGigantTarget(cards)
  return GadgetToHand(cards)
end
function BigEyeTarget(cards)
  local result = nil
  if not Duel.GetFirstTarget() then
    result = BestTargets(cards,1,false)
  end
  if result == nil then result = {math.random(#cards)} end
  return result
end
function DracossackTarget(cards)
  local result = nil
  if GlobalCardMode==2 then
    GlobalCardMode=1
    for i=1,#cards do
      if bit32.band(cards[i].type,TYPE_TOKEN)>0 then
        result = {i}
      end
    end
  elseif GlobalCardMode==1 then
    GlobalCardMode = nil
    result = BestTargets(cards,1,true)
  end
  if result == nil then result = {math.random(#cards)} end
  return result
end
function TinGoldfishTarget(cards)
  local result = nil
  for i=1,#cards do
    local id = cards[i].id
    if id == 86445415 or id == 41172955 or id == 13839120 then
      result = {i}
    end
  end
  if result == nil then result = {math.random(#cards)} end
  return result
end
function RedoxTarget(cards)
  local result=nil
  if GlobalCardMode==2 then
    result=BanishCost(cards,2)
  elseif GlobalCardMode==1 then
    result=DiscardCost(cards,1)
  else
    result=CotHTarget(cards) 
  end
  GlobalCardMode=nil
  if result==nil then
    table.sort(cards,function(a,b) return Chance(50) end)
    result={}
    for i=1,minTargets do
      result[i]=cards[i].index
    end
  end
  return result
end
function CotHTarget(cards)
  local result=nil
  local compare = function(a,b) if a.prio==b.prio then return a.attack>b.attack end return a.prio>b.prio end
  for i=1,#cards do
    cards[i].index=i
    if FieldCheck(4)==1 and cards[i].level == 4 then
      if IsGadget(cards[i].id) then
        cards[i].prio=3
      else
        cards[i].prio=2
      end
    elseif FieldCheck(7)==1 and cards[i].level == 7 then
      if cards[i].id==05556499 then
        cards[i].prio=5
      else 
        cards[i].prio=4
      end
    elseif cards[i].id == 83994433 or cards[i].id == 39765958 then
      cards[i].prio=4
    else
      cards[i].prio=0
    end
    if bit32.band(cards[i].type,TYPE_XYZ)>0 then
      cards[i].prio=-1
    end
  end
  table.sort(cards,compare)
  result=cards[1].index
  if result == nil then result = math.random(#cards) end
  return {result}
end
function GearframeTarget(cards)
  local result = nil
  if HasID(cards,05556499) then
    result = {CurrentIndex}
  end
  if HasID(cards,39284521) and HasID(AIGrave(),05556499) then
    result = {IndexByID(cards,39284521)}
  end
  if result == nil then result = {math.random(#cards)} end
  return result
end
function FiendishChainTarget(cards)
  result = nil
  for i=1,#cards do
    if cards[i].owner==2 and cards[i].id==GlobalTargetID then
      result = i
    end
  end
  if result == nil then result = math.random(#cards) end
  return {result}
end
function StardustSparkTarget(cards)
  return {IndexByID(cards,GlobalTargetID)}
end
function GadgetOnSelectCard(cards, minTargets, maxTargets,ID,triggeringCard)
  if ID == 05556499 then
    return MachinaFortressTarget(cards)
  end
  if ID == 53573406 then
    return MaskedChameleonTarget(cards)
  end
  if ID == 28912357 then
    return GearGigantTarget(cards)
  end
  if ID == 80117527 then
    return BigEyeTarget(cards)
  end
  if ID == 22110647 then
    return DracossackTarget(cards)
  end
  if ID == 18063928 then
    return TinGoldfishTarget(cards)
  end
  if ID == 90411554 then
    return RedoxTarget(cards,minTargets)
  end
  if ID == 42940404 then
    return GearframeTarget(cards)
  end
  if ID == 97077563 then
    return CotHTarget(cards)
  end
  if ID == 50078509 then
    return FiendishChainTarget(cards)
  end
  if ID == 83994433 then
    return StardustSparkTarget(cards)
  end
  return nil
end
function ChainSwiftScarecrow(id)
  return UnchainableCheck(id) and ExpectedDamage() >= 0.35*AI.GetPlayerLP(1)
end
function ChainCotH()
  if Duel.GetCurrentPhase() == PHASE_BATTLE then
		local source = Duel.GetAttacker()
    local graveatt = Get_Card_Att_Def(AIGrave(),"attack",">",nil,"attack")
    local oppatt = Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack")
    local aiatt = Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP_ATTACK,"attack")
    local cards=AIMon()
    local e = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
    if e and e:GetHandler():GetCode()==97077563 then
      return false
    end
    if source and source:IsControler(1-player_ai) and (graveatt > source:GetAttack() 
    or HasID(AIGrave(),83994433) or source:GetAttack()>AI.GetPlayerLP(1)) then
      return #cards==0
    end
    if Duel.GetTurnPlayer()==player_ai then
      return oppatt > aiatt and graveatt > oppatt 
    end
  end
  return false
end
function ChainFiendish()
  local effect = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
	if effect then
    card=effect:GetHandler()
    if player_ai==nil then
      player=1
    else
      player=player_ai
    end
    if card and card:IsControler(1-player) and card:IsLocation(LOCATION_MZONE)
    and card:IsType(TYPE_EFFECT) and not card:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET) 
    and not card:IsHasEffect(EFFECT_IMMUNE_EFFECT) and NegateBlacklist(card:GetCode())==0
    then
      GlobalTargetID=card:GetCode()
      return true
    end
  end
  if Duel.GetCurrentPhase() == PHASE_BATTLE then
		local source = Duel.GetAttacker()
		local target = Duel.GetAttackTarget()
    if source and target then
      if target:IsControler(player_ai)
      and (source:GetAttack() >= target:GetAttack()  and source:IsPosition(POS_FACEUP_ATTACK) 
      or   source:GetAttack() >= target:GetDefence() and source:IsPosition(POS_FACEUP_DEFENCE))
      and target:IsPosition(POS_FACEUP_ATTACK)
      and source:IsType(TYPE_EFFECT) and not source:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET) 
      and not target:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) and not source:IsHasEffect(EFFECT_IMMUNE_EFFECT) 
      then
        GlobalTargetID=source:GetCode()
        return true
      end
    end
  end
end
function ChainNaturiaBeast()
  return false
end
function StardustSparkFilter(card,id)
  return card:IsControler(player_ai) and card:IsPosition(POS_FACEUP) 
  and not card:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT) 
  and not card:IsHasEffect(EFFECT_IMMUNE_EFFECT) 
  and not card:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET) 
  and (id == nil or card:GetCode()~=id)
end
function ChainStardustSpark()
  local cardtype = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_EXTTYPE)
  local ex,cg = Duel.GetOperationInfo(0, CATEGORY_DESTROY)
  local tg = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TARGET_CARDS)
  local e = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
  if e and e:GetHandler():GetCode()==83994433 then
    return false
  end
  if ex then
    if tg then
      local g = tg:Filter(StardustSparkFilter, nil):GetMaxGroup(Card.GetAttack)
      if g then
        GlobalTargetID = g:GetFirst():GetCode() 
      end
      return tg:IsExists(StardustSparkFilter, 1, nil)
    else
      local g = cg:Filter(StardustSparkFilter, nil):GetMaxGroup(Card.GetAttack)
      if g then
        GlobalTargetID = g:GetFirst():GetCode()
      end
      return cg:IsExists(StardustSparkFilter, 1, nil)
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
      and not target:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) and not target:IsHasEffect(EFFECT_IMMUNE_EFFECT) 
      then
        GlobalTargetID=target:GetCode()
        return true
      end
    end
  end
  local cg = RemovalCheck()
	if cg then
		if cg:IsExists(function(c) return c:IsControler(player_ai) and c:IsCode(83994433) end, 1, nil) then
      local g=Duel.GetMatchingGroup(StardustSparkFilter,player_ai,LOCATION_ONFIELD,0,nil,83994433):GetMaxGroup(Card.GetAttack)
      if g then
        GlobalTargetID = g:GetFirst():GetCode()
        return true
      end
    end	
  end
  cg = NegateCheck()
  if cg then
		if cg:IsExists(function(c) return c:IsControler(player_ai) and c:IsCode(83994433) end, 1, nil) then
      local g=Duel.GetMatchingGroup(StardustSparkFilter,player_ai,LOCATION_ONFIELD,0,nil):GetMaxGroup(Card.GetAttack)
      if g then
        GlobalTargetID = g:GetFirst():GetCode()
        return true
      end
    end	
  end
  return false
end
GlobalStardustSparkActivation={}
function GadgetOnSelectChain(cards,only_chains_by_player)
  if HasID(cards,18964575) and ChainSwiftScarecrow(18964575) then
    return {1,IndexByID(cards,18964575)}
  end
  if HasID(cards,19665973) and ChainSwiftScarecrow(19665973) then -- Battle Fader
    return {1,IndexByID(cards,19665973)}
  end
  if HasID(cards,97077563) and ChainCotH() then
    return {1,IndexByID(cards,97077563)}
  end
  if HasID(cards,50078509) and ChainFiendish() then
    return {1,IndexByID(cards,50078509)}
  end
  if HasID(cards,33198837) and ChainNaturiaBeast() then
    return {1,IndexByID(cards,33198837)}
  end
  if HasID(cards,83994433) and ChainStardustSpark() then
    GlobalStardustSparkActivation[cards[CurrentIndex].cardid]=Duel.GetTurnCount()
    return {1,CurrentIndex}
  end
  return nil
end

function GadgetOnSelectOption(options)
  return nil
end
GadgetAtt={
  05556499,42940404,28912357,88033975,33198837
}
GadgetDef={
  90411554
}

function GadgetOnSelectPosition(id, available)
  result = nil
  for i=1,#GadgetAtt do
    if GadgetAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#GadgetDef do
    if GadgetDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  if id==22110647 then
    if AI.GetCurrentPhase() == PHASE_MAIN2 or Duel.GetTurnCount() == 1 then
      result=POS_FACEUP_DEFENCE
    end
  end
  if id==22110648 then
    result=POS_FACEUP_DEFENCE
  end
  return result
end
