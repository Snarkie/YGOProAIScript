function NeclothFilter(c,exclude)
  return IsSetCode(c.setcode,0xb4) and (exclude == nil or c.id~=exclude)
end
function NeclothMonsterFilter(c,ritual)
  return FilterType(c,TYPE_MONSTER) and NeclothFilter(c)
  and (not ritual or FilterType(c,TYPE_RITUAL))
end
function CheckLvlSum(cards,level,lvlrestrict)
  local levels = {}
  local count = 0
  for i=1,#cards do
    if cards[i].level>0 and (cards[i].level<level 
    or cards[i].level==level and not lvlrestrict)
    then 
      levels[#levels+1] = cards[i].level
    end
  end
  for i=1,#levels do
    if levels[i]==level then
      count = count + 1
      if count > 1 then
        return true
      end
    end
  end
  levels[0]=0
  -- there is probably a better method to check all possible sums, but for now
  for i=1,#levels do
    for j=0,#levels do
      for k=0,#levels do
        if levels[i]>0 and i~=j and i~=k and j~=k then
          if levels[i]+levels[j]+levels[k] == level then
            return true
          end
        end
      end
    end
  end
  return false
end
function ExoFilter(c)
  return NeclothMonsterFilter(c) or c.id==08903700 -- Djinn Releaser
end
function RitualTributeCheck(level,mirror,lvlrestrict)
  local cards
  if mirror == 1 then -- Kaleidomirror 
    cards = UseLists(AIHand(),AIMon(),AIExtra())
    local result = false
    if not lvlrestrict then
      result = CardsMatchingFilter(cards,FilterLevel,level)>0
    end
    if level == 3 and HasID(AIGrave(),08903700,true) then -- Djinn Releaser
      result = true
    end
    return HasID(cards,90307777,true) or result
  elseif mirror == 2 then -- Exomirror
    cards = UseLists(AIHand(),AIMon(),SubGroup(AIGrave(),ExoFilter))
    local result = CheckLvlSum(cards,level,lvlrestrict)
    return HasID(cards,90307777,true) or result
  end
end
function RitualSpellCheck(cards)
  if cards == nil then cards = UseLists(AIHand(),AIST()) end
  return HasID(cards,14735698,true) or HasID(cards,51124303,true)
end
function ShritCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),52068432,true)
  end
  return true
end
function ClausCond(loc,c)
  if loc == PRIO_TOHAND then
    return (not RitualSpellCheck() or HasID(AIHand(),89463537,true)
    and not HasID(AIHand(),51124303,true))
    and UseClaus() and not HasID(AIHand(),99185129,true)
    and not GlobalPreparation
    and not (#AIMon()==0 and RitualSpellCheck(AIGrave()))
  end
  if loc == PRIO_FIELD then
    return false -- adjust for turn 1 releaser claus
  end
  return true
end
function UniCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),89463537,true)
    and HasID(AIHand(),51124303,true)
  end
  if loc == PRIO_FIELD then
    return false
  end
  return true
end
function BrioCond(loc,c)
  if loc == PRIO_TOHAND then
    return UseBrio()
  end
  if loc == PRIO_TOFIELD then
    return UseBrioField()
  end
  return true
end
function GungCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),13700028,true)
  end
  return true
end
function TrishCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),52068432,true)
  end
  if loc == PRIO_TOFIELD then
    return UseTrishula()
  end
  return true
end
function ArmorCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),88240999,true)
  end
  if loc == PRIO_TOFIELD then
    return UseArmor()
  end
  return true
end
function ExoCond(loc,c)
  if loc == PRIO_TOHAND then
    return not RitualSpellCheck() and OPTCheck(14735698)
    and not (#AIMon()==0 and RitualSpellCheck(AIGrave()))
  end
  return true
end
function KaleidoCond(loc,c)
  if loc == PRIO_TOHAND then
    return (not RitualSpellCheck() 
    or (HasID(AIHand(),89463537,true) or QuasarComboCheck(true))
    and not HasID(AIHand(),51124303,true)) and OPTCheck(51124303)
    and not (#AIMon()==0 and RitualSpellCheck(AIGrave()))
  end
  return true
end
function UseTrishula()
  return #OppHand()>0 and #OppField()>0 and #OppGrave()>0
  and OPTCheck(52068432)
end
function SummonTrishula(mirror)
  return DualityCheck() and RitualTributeCheck(9,mirror,true)
end
function SummonUnicore(mirror)
  return DualityCheck() and mirror == 1 
  and HasID(AIExtra(),79606837,true)
  --or RitualTributeCheck(4,mirror) 
  --and FieldCheck(4) == 1)
end
function ArmorFilter(c)
  return FilterPosition(c,POS_FACEDOWN) 
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
end
function UseArmor()
  return CardsMatchingFilter(OppField(),ArmorFilter)>0
end
function SummonArmor(mirror)
  return DualityCheck() and RitualTributeCheck(12,mirror,true)
end
function UseClaus()
  return (NeedsCard(51124303,AIDeck(),AIHand(),true) and OPTCheck(51124303)
       or NeedsCard(14735698,AIDeck(),AIHand(),true) and OPTCheck(14735698))
      and OPTCheck(99185129)
end
function UseBrio()
  return OPTCheck(26674724) and not QuasarComboCheck()
end
function BrioFilter(c)
  return FilterLocation(c,LOCATION_EXTRA) and FilterSummon(c,SUMMON_TYPE_SPECIAL)
  and FilterPosition(c,POS_FACEUP) and not FilterAffected(c,EFFECT_CANNOT_BE_EFFECT_TARGET)
  and CurrentOwner(c)==1
end
function UseBrioField()
  return OPTCheck(266747241) and CardsMatchingFilter(OppMon(),BrioFilter)>0
end
function UseUnicore()
  return not SummonUnicore(1) and OPTCheck(89463537)
end
function RitualSummonCheck(mirror)
  local cards = UseLists(AIHand(),AIField(),AIGrave())
  local result = false
   if HasID(AIHand(),89463537,true) 
  and SummonUnicore(mirror) 
  then
    result = true
  end
  if HasID(AIHand(),52068432,true) 
  and SummonTrishula(mirror)
  and (UseTrishula() or HasID(cards,08903700,true))
  then
    result = true
  end
  if HasID(AIHand(),88240999,true)
  and SummonArmor(mirror)
  and UseArmor()
  then
    result = true
  end
  return result
end
function SummonDenkou()
  return CardsMatchingFilter(AIST(),FilterPosition,POS_FACEDOWN)==0
  or FieldCheck(4)==1
end
GlobalPreparation = nil
function UsePreparation()
  if NeedsCard(51124303,AIGrave(),AIHand(),true) and OPTCheck(51124303)
  or NeedsCard(14735698,AIGrave(),AIHand(),true) and OPTCheck(14735698)
  then
    GlobalPreparation = true
    return true 
  end
  return CardsMatchingFilter(UseLists(AIMon(),AIHand()),NeclothMonsterFilter,true)==0
end
function SummonNyarla()
  return DualityCheck() and MP2Check()
  and HasID(AIExtra(),08809344,true)
  and HasID(AIGrave(),79606837,true)
  --and (Duel.GetTurnCount() == 1 
  --or CardsMatchingFilter(AIGrave(),FilterID,79606837)>0)
end
function SummonChainNecloth()
  return DualityCheck() and MP2Check()
  and HasID(AIExtra(),34086406,true)
  and HasID(AIDeck(),08903700,true)
  and CardsMatchingFilter(AIHand(),NeclothMonsterFilter,true)>0
  and RitualSpellCheck()
  and (Chance(50) or not SummonNyarla())
end
function SummonExaBeetle()
  return HasID(AIGrave(),35952884,true) and HasID(AIExtra(),44505297,true)
  and HasID(AIExtra(),24696097,true) and DualityCheck() and UseExaBeetle()
end
function ExaBeetleFilter(c)
  return FilterPosition(c,POS_FACEUP)
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
end
function UseExaBeetle()
  return CardsMatchingFilter(OppField(),ExaBeetleFilter)>0
end
function NeclothInit(cards)
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
  if HasID(Act,51124303,false,nil,LOCATION_GRAVE) then -- Kaleido grave
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,14735698,false,nil,LOCATION_GRAVE) then -- Exo grave
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end 
  if HasID(Act,32807846) and DeckCheck(DECK_NECLOTH) then  -- RotA
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,08809344) then -- Nyarla
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,99185129,false,nil,LOCATION_HAND) and UseClaus() then
    OPTSet(99185129)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,26674724,false,nil,LOCATION_HAND) and UseBrio() then
    OPTSet(26674724)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,26674724,false,nil,LOCATION_MZONE) and UseBrioField() then
    OPTSet(266747241)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,88240999,false,nil,LOCATION_MZONE) and UseArmor() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,89463537,false,nil,LOCATION_HAND) and UseUnicore() then
    OPTSet(89463537)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end  
  if HasID(Act,44505297) and UseExaBeetle() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Sum,23401839) then -- Senju
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,95492061) then -- Manju
    return {COMMAND_SUMMON,CurrentIndex}
  end 
  if HasID(Sum,13974207) and SummonDenkou() then 
    return {COMMAND_SUMMON,CurrentIndex}
  end   
  if HasID(SpSum,34086406) and SummonChainNecloth() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end    
  if HasID(SpSum,08809344) and SummonNyarla() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end  
  if HasID(SpSum,44505297) and SummonExaBeetle() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end  
  if HasID(Act,51124303,false,nil,LOCATION_HAND+LOCATION_SZONE) -- Kaleidomirror
  and (RitualSummonCheck(1) or QuasarComboCheck())
  then 
    OPTSet(51124303)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,14735698,false,nil,LOCATION_HAND+LOCATION_SZONE) -- Exomirror
  and RitualSummonCheck(2) 
  then
    OPTSet(14735698)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SetMon,08903700) then -- Djinn Releaser
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  return nil
end
function QuasarComboCheck(skipmirror)
  return HasID(AIExtra(),35952884,true) and HasID(AIExtra(),24696097,true)
  and HasID(AIExtra(),44505297,true) and CardsMatchingFilter(AIHand(),FilterID,26674724)==2
  and (skipmirror or HasID(AIHand(),51124303,true))
  and UseExaBeetle() and DualityCheck()
end

function QuasarTrishulaCheck()
  return HasID(AIExtra(),35952884,true) and HasID(AIHand(),99185129,true)
  and HasID(AIHand(),52068432,true) and DualityCheck() and UseTrishula()
end
GlobalKaleidoTarget = nil
GlobalExoTarget = nil
function KaleidoTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards,PRIO_BANISH)
  end
  if FilterLocation(cards[1],LOCATION_DECK) 
  and FilterType(cards[1],TYPE_SPELL) 
  then
    print("ritual spell from grave")
    return ClausTarget(cards)
  end
  local c = FindCard(GlobalKaleidoTarget)
  if c then
    return Add(cards,PRIO_TOFIELD)
  end
  local result = {math.random(#cards)}
  for i=1,#cards do
    if cards[i].id == 79606837 then
      return {i}
    end
    if cards[i].id == 35952884 
    and (QuasarComboCheck(true)
    or QuasarTrishulaCheck())
    then
      result = {i}
    end
    if cards[i].id == 90307777
    then
      result = {i}
    end
  end
  GlobalExoTarget = nil
  GlobalKaleidoTarget = cards[result[1]].cardid
  return result
end
function ExoTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards,PRIO_BANISH)
  end
  if FilterLocation(cards[1],LOCATION_DECK) 
  and FilterType(cards[1],TYPE_SPELL) 
  then
    print("ritual spell from grave")
    return ClausTarget(cards)
  end
  local result = Add(cards,PRIO_TOFIELD)
  GlobalKaleidoTarget = nil
  GlobalExoTarget = cards[result[1]].cardid
  return result
end
function NyarlaTarget(cards)
  local result = {}
  for i=1,#cards do
    if cards[i].id == 79606837 then
      return {i}
    elseif not NeclothFilter(cards[i]) then
      result = {i}
    end
  end
  if #result==0 then result = {math.random(#cards)} end
  return result
end
function ExaBeetleTarget(cards)
  local result = {}
  if FilterLocation(cards[1],LOCATION_GRAVE)  then 
    for i=1,#cards do
      if cards[i].id == 35952884 and cards[i].owner == 1 then 
        return {i}
      end
    end
    return {HighestATKIndexTotal(cards)}
  elseif FilterLocation(cards[1],LOCATION_OVERLAY) then 
    return Add(cards,PRIO_TOGRAVE)
  elseif CurrentOwner(cards[1])==1 then 
    for i=1,#cards do
      if cards[i].id == 35952884 then 
        return {i}
      end
    end
    return BestTargets(cards)
  else  
    return BestTargets(cards)
  end
end
function GungnirTarget(cards)
  local result = {}
  if GlobalTargetID then
    for i=1,#cards do
      if cards[i].id == GlobalTargetID then
        result = {i}
      end
    end
    GlobalTargetID = nil
  end
  if #result==0 then result = {math.random(#cards)} end
  return result
end
function ArmorTarget(cards)
  if FilterPosition(cards[1],POS_FACEDOWN) then
    return BestTargets(cards,1,PRIO_BANISH,ArmorFilter)
  else
    local result = {IndexByID(cards,GlobalTargetID)}
    GlobalTargetID = nil
    return result
  end
end
function ClausTarget(cards)
  print("claus target")
  if FilterLocation(cards[1],LOCATION_DECK) then
    if NeedsCard(51124303,cards,AIHand()) 
    and (HasID(AIHand(),89463537,true)  
    or CardsMatchingFilter(AIGrave(),NeclothMonsterFilter)<3
    and not HasID(AIGrave(),90307777,true))
    and OPTCheck(51124303) 
    then
      print("can use Kaleido")
      return {CurrentIndex}
    end
    if NeedsCard(14735698,cards,AIHand()) and OPTCheck(14735698)  then
      print("Exo")
      return {CurrentIndex}
    end
    if NeedsCard(51124303,cards,AIHand()) and OPTCheck(51124303) then
      print("Kaleido")
      return {CurrentIndex}
    end
    if NeedsCard(14735698,cards,AIHand()) then
      print("Exo leftover")
      return {CurrentIndex}
    end
    if NeedsCard(51124303,cards,AIHand()) then
      print("Kaleido leftover")
      return {CurrentIndex}
    end
  else
    -- todo: global target stuff
  end
  return {math.random(#cards)}
end
function BrioTarget(cards,max)
  if FilterLocation(cards[1],LOCATION_DECK) then
    return Add(cards)
  else
    local count = math.max(max,CardsMatchingFilter(cards,BrioFilter))
    return BestTargets(cards,count,TARGET_TOHAND)
  end
  return {math.random(#cards)}
end
function TrishTarget(cards)
  if FilterLocation(cards[1],LOCATION_HAND) then
    return {math.random(#cards)}
  end
  return BestTargets(cards,1,PRIO_BANISH)
end
function NeclothCard(cards,min,max,id,c)
  if GlobalNeclothExtra and GlobalNeclothExtra>0 then
    GlobalNeclothExtra = GlobalNeclothExtra - 1
    if GlobalNeclothExtra <=0 then GlobalNeclothExtra = nil end
    return Add(cards,PRIO_TOGRAVE,min)
  end
  if c then
    id = c.id
  end
  if id == 90307777 or id == 89463537   -- Shrit, Unicore
  or id == 95492061 or id == 23401839   -- Manju, Senju
  or id == 96729612 or id == 79606837   -- Preparation, Herald
  then
    return Add(cards,PRIO_TOHAND,max)
  end
  if id == 99185129 then
    return ClausTarget(cards)
  end
  if id == 26674724 then
    return BrioTarget(cards)
  end
  if id == 51124303 then
    return KaleidoTarget(cards)
  end
  if id == 14735698 then
    return ExoTarget(cards)
  end
  if id == 08809344 then
    return NyarlaTarget(cards)
  end
  if id == 44505297 then
    return ExaBeetleTarget(cards)
  end
  if id == 13700028 then
    return GungnirTarget(cards)
  end
  if id == 88240999 then
    return ArmorTarget(cards)
  end
  if id == 52068432 then
    return TrishTarget(cards)
  end
  return nil
end
function KaleidoSum(cards,sum,card)
end
function ExoSum(cards,sum,card)
  local result = {}
  local lvl = sum
  if HasID(cards,08903700) then 
    print("djinn")
    result[#result+1] = CurrentIndex
    lvl = lvl - cards[CurrentIndex].level
  end
  if HasID(cards,90307777,false,nil,LOCATION_GRAVE) and #result==0 then
    print("shrit grave, no djinn")
    return {CurrentIndex}
  end
  if HasID(cards,90307777) and #result==0 then
    print("shrit hand, no djinn")
    return {CurrentIndex}
  end
  print("fill")
  for j=1,5 do
    for i=1,#cards do
      if cards[i].id ~= 90307777 and cards[i].id ~= 08903700 
      and lvl == cards[i].level
      then
        j=5
        print("matching level")
        result[#result+1]= i
        return result
      end
    end
    for i=1,#cards do
      if cards[i].id ~= 90307777 and cards[i].id ~= 08903700 
      and lvl - cards[i].level > 2
      then
        print("lower level, fill")
        lvl = lvl - cards[i].level
        result[#result+1]= i
      end
    end
  end
  print("return")
  return result
end
function NeclothSum(cards,sum,card)
  local id = nil
  if card then
    id = card.id
  else
  end
  local c = FindCard(GlobalKaleidoTarget)
  if c then
    return KaleidoSum(cards,sum,card)
  end
  c = FindCard(GlobalExoTarget)
  if c then    
    return ExoSum(cards,sum,card)
  end
  return nil
end
function ChainTrishula(c)
  if FilterLocation(c,LOCATION_HAND) then
    local e,c,id 
    if EffectCheck(1-player_ai)~=nil then
      e,c,id = EffectCheck()
      return true
    end
    return false
  end
  return true
end
function ArmorAtkFilter(c)
  return c:IsSetCard(0xb4)
end
function ChainArmor()
  if Duel.GetCurrentPhase() == PHASE_DAMAGE then
    if AttackBoostCheck(1000,player_ai,ArmorAtkFilter) then
      if Duel.GetTurnPlayer() == player_ai then
        GlobalTargetID = Duel.GetAttacker():GetCode()
      else
        GlobalTargetID = Duel.GetAttackTarget():GetCode()
      end
      return true
    end
  end
  return false
end
function NeclothGungnirFilter(c,immune)
  return c:IsSetCard(0xb4) and c:IsPosition(POS_FACEUP) 
  and c:IsType(TYPE_MONSTER) 
  and not c:IsHasEffect(immune)
end
function ChainGungnir(c)
  if FilterLocation(c,LOCATION_HAND) then
    local cg = RemovalCheck(nil,CATEGORY_DESTROY)
    if cg then
      local tg = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TARGET_CARDS)
      if tg then 
        c=tg:Filter(NeclothGungnirFilter,nil,EFFECT_INDESTRUCTABLE_EFFECT)
        if c then c=c:GetMaxGroup(Card.GetAttack):GetFirst() end
      else
        c=cg:Filter(NeclothGungnirFilter,nil,EFFECT_INDESTRUCTABLE_EFFECT)
        if c then c=c:GetMaxGroup(Card.GetAttack):GetFirst() end
      end
      if c then
        GlobalTargetID=c:GetCode()
        return true
      end
    end
  end
  if Duel.GetCurrentPhase()==PHASE_BATTLE then
    local source = Duel.GetAttacker()
    local target = Duel.GetAttackTarget()
    if source and target then
      if source:IsControler(player_ai) then
        target = Duel.GetAttacker()
        source = Duel.GetAttackTarget()
      end
    end
    if WinsBattle(source,target) 
    and NeclothGungnirFilter(target,EFFECT_INDESTRUCTABLE_BATTLE) then
      GlobalTargetID=target:GetCode()
      return true
    end
  end
  return false
end
function NeclothChain(cards)
  if HasID(cards,79606837,false,nil,LOCATION_GRAVE) then -- Rainbow Herald
    return {1,CurrentIndex}
  end
  if HasID(cards,88240999) and ChainArmor() then
    return {1,CurrentIndex}
  end
  if HasID(cards,13700028) and ChainGungnir(cards[CurrentIndex]) then
    return {1,CurrentIndex}
  end
  if HasID(cards,52068432) and ChainTrishula(cards[CurrentIndex]) then
    return {1,CurrentIndex}
  end
  if HasID(cards,44505297) then -- Exa-Beetle
    return {1,CurrentIndex}
  end
  if HasID(cards,35952884,false,nil,LOCATION_GRAVE) then -- Quasar
    return {1,CurrentIndex}
  end
  if HasID(cards,95492061) then -- Manju
    return {1,CurrentIndex}
  end
  if HasID(cards,23401839) then -- Senju
    return {1,CurrentIndex}
  end
  if HasID(cards,90307777) then -- Shrit
    return {1,CurrentIndex}
  end
  return nil
end

function NeclothEffectYesNo(id,card)
  local result = nil
  if id==79606837 and FilterLocation(card,LOCATION_GRAVE) then -- Rainbow Herald
    result = 1
  end
  if id == 88240999 and ChainArmor() then 
    result = 1
  end
  if id == 13700028 and ChainGungnir(card) then 
    result = 1
  end
  if id == 52068432 and ChainTrishula(card) then 
    result = 1
  end
  if id == 44505297 then -- Exa-Beetle
    result = 1
  end
  if id == 35952884 and FilterLocation(card,LOCATION_GRAVE) then -- Quasar
    result = 1
  end
  if id == 95492061 then -- Manju
    result = 1
  end
  if id == 23401839 then -- Senju
    result = 1
  end
  if id == 90307777 then -- Shrit
    result = 1
  end
  return result
end
NeclothAtt={
89463537,26674724,13700028, -- Unicore, Brionac, Gungnir
52068432,88240999,24696097, -- Trishula, Decisive Armor, Shooting Star
95113856,44505297, -- Enterblathnir, Exa-Beetle
}
NeclothDef={
90307777,99185129,08903700, -- Shrit, Claus, Releaser
08809344, -- Nyarla
}
function NeclothPosition(id,available)
  result = nil
  for i=1,#NeclothAtt do
    if NeclothAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#NeclothDef do
    if NeclothDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  return result
end
