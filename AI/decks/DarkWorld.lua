function DarkWorldPriority()
AddPriority({
[34230233] = {7,2,9,1,9,1,10,5,1,1,GraphaCond},       -- DW Grapha
[60228941] = {4,3,7,1,3,1,8,1,10,3,SnowwCond},        -- DW Snoww
[33731070] = {6,3,5,1,3,1,9,1,7,4,BeiigeCond},        -- DW Beiige
[94283662] = {3,2,8,1,3,1,5,1,4,3,TranceCond},        -- Trance Archfiend
[79126789] = {5,3,6,4,4,1,7,1,9,4,BrowwCond},         -- DW Broww

[16435215] = {1,1,1,1,1,1,1,1,1,1,DraggedCond},       -- Dragged Down
[74117290] = {7,1,1,1,1,1,1,1,1,1,DWDCond},           -- DWD
[33017655] = {8,1,1,1,1,1,1,1,1,1,GatesCond},         -- Gates

[54974237] = {1,1,1,1,1,1,1,1,1,1,DDVCond},           -- DDV
[41930553] = {1,1,1,1,1,1,1,1,1,1,SmogCond},          -- Dark Smog

[73445448] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Zombiestein
[01639384] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Felgrand
[10406322] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Sylvan Arusei
[66547759] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Lancelot
[88120966] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Giant Grinder
})
end
function DarkWorldFilter(c,exclude)
  return IsSetCode(c.setcode,0x6) and (exclude == nil or c.id~=exclude)
end
function DarkWorldMonsterFilter(c,exclude)
  return FilterType(c,TYPE_MONSTER) and DarkWorldFilter(c,exclude)
end
function GraphaCond(loc,c)
  if loc == PRIO_TOHAND then
    if FilterLocation(c,LOCATION_REMOVED) then
      return 10
    end
    return (CardsMatchingFilter(OppField(),DestroyFilter)>0 
    or not HasAccess(34230233)) 
    and DiscardOutlets()>0
    and not HasID(AIHand(),34230233,true)
  end
  if loc == PRIO_DISCARD then
    if Duel.GetTurnPlayer()==1-player_ai 
    and HasPriorityTarget(AIField(),true,nil) 
    and Duel.GetCurrentPhase()~=PHASE_END
    then
      return true
    end
    return CardsMatchingFilter(OppField(),DestroyFilter)>0
    or GlobalDragged
    or CardsMatchingFilter(AIMon(),DarkWorldMonsterFilter,34230233)>0
    or ((CardsMatchingFilter(AIHand(),DarkWorldMonsterFilter,34230233)>0
    or HasID(AIHand(),10802915,true) and SummonTourGuideDW(3))
    and not NormalSummonCheck()
    and not (HasID(AIHand(),60228941,true) 
    and (CardsMatchingFilter(AIHand(),DarkWorldMonsterFilter,34230233)>1
    or HasID(AIHand(),10802915,true) and SummonTourGuideDW(3))))
    or LeviairDWCheck()
  end
  if loc == PRIO_TOGRAVE then
    return true
  end
  return true
end
function SnowwCond(loc,c)
  if loc == PRIO_TOHAND then
    if FilterLocation(c,LOCATION_REMOVED) then
      return 8
    end
    return true
  end
  if loc == PRIO_DISCARD then
    return true
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function BrowwCond(loc,c)
  if loc == PRIO_TOHAND then
    return true
  end
  if loc == PRIO_TOFIELD then
    return SummonGraphaCheck(true)
    and not LeviairDWCheck(true)
    or HasID(AIHand(),34230233,true)
    and DiscardOutlets()>0
  end
  if loc == PRIO_DISCARD then
    return true
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function BeiigeCond(loc,c)
  if loc == PRIO_TOHAND then
    return (not NormalSummonCheck(player_ai) or DiscardOutlets()>0) 
    and SummonGraphaCheck(true)
    and not HasID(AIHand(),33731070,true)
  end
  if loc == PRIO_DISCARD then
    if SummonGraphaCheck(true)
    and Duel.GetLocationCount(player_ai,LOCATION_MZONE)>0
    and CardsMatchingFilter(AIGrave(),FilterID,34230233)>1
    and Duel.GetTurnPlayer()==player_ai
    then
      return 11
    end
    return (SummonGraphaCheck(true)
    and (CardsMatchingFilter(AIMon(),DarkWorldMonsterFilter,34230233)==0
    or NormalSummonCheck(player_ai))
    and not HasID(AIHand(),60228941,true)
    or CardsMatchingFilter(AIHand(),DarkWorldMonsterFilter,33731070)==0
    or GlobalDragged)
    and Duel.GetLocationCount(player_ai,LOCATION_MZONE)>0
  end
  if loc == PRIO_TOGRAVE then
    return true
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function GatesCond(loc,c)
  if loc == PRIO_TOHAND then
    return DiscardOutlets()==0 and (UseGates()
    or not HasID(UseLists(AIST(),AIHand()),33017655,true))
  end
  return true
end
function DWDCond(loc,c)
  if loc == PRIO_TOHAND then
    return DiscardOutlets()==0 and PriorityCheck(AIHand(),PRIO_DISCARD)>4
  end
  return true
end
function TranceCond(loc,c)
  if loc == PRIO_DISCARD then
    return #AIHand()>5 or CardsMatchingFilter(AIHand(),FilterID,94283662)>1
  end
  if loc == PRIO_TOFIELD then
    return DiscardOutlets()==0 and PriorityCheck(AIHand(),PRIO_DISCARD)>4
  end
  return true
end
function TranceFilter(c)
  return FilterLocation(c,LOCATION_MZONE) and OPTCheck(c.cardid)
  or FilterLocation(c,LOCATION_HAND) and not NormalSummonCheck()
end
function DraggedCheck()
  local check = true
  GlobalDragged = true
  for i=1,#AIHand() do
    local c = AIHand()[i]
    if not FilterType(c,TYPE_SPELL+TYPE_TRAP) 
    and GetPriority(c,PRIO_DISCARD)<4 
    then
      check = false
    end
  end
  local cards = UseLists(AIHand(),AIST())
  check = check and HasIDNotNegated(cards,16435215,true) and #OppHand()>0 
  and CardsMatchingFilter(cards,FilterID,33017655)<2
  and PriorityCheck(AIHand(),PRIO_DISCARD)>4
  GlobalDragged = nil
  return check
end
function GatesFilter(c)
  return FilterRace(c,RACE_FIEND) and GetPriority(c,PRIO_BANISH)>2
end
function DiscardOutlets()
  local cards = UseLists(AIHand(),AIMon(),AIST())
  local result = 0
  result = result + CardsMatchingFilter(cards,FilterID,74117290)
  if HasID(cards,33017655,true,nil,nil,nil,FilterOPT) 
  and CardsMatchingFilter(AIGrave(),GatesFilter)>0
  then
    result = result + 1
  end
  if HasID(cards,33017655,true,nil,nil,nil,TranceFilter) then
    result = result + 1
  end
  if HasID(cards,16435215,true) and DraggedCheck() then
    result = result + 1
  end
  if HasIDNotNegated(AIST(),41930553,true,nil,nil,nil,FilterOPT) 
  and CardsMatchingFilter(OppGrave(),FilterType,TYPE_MONSTER)>0
  then
    result = result + 1
  end
  return result
end

function LeviairDWFilter(c)
  return DarkWorldMonsterFilter(c) and c.level<5
  or c.id == 94283662 and PriorityCheck(AIHand(),PRIO_DISCARD,1,FilterRace,RACE_FIEND)>4
end
function LeviairDWCheck(skipmonsters)
  return (FieldCheck(3)>1 or skipmonsters) and CardsMatchingFilter(AIBanish(),LeviairDWFilter)>0
  and not SkillDrainCheck() and DualityCheck() and HasID(AIExtra(),95992081,true)
end
function UseGates()
  return CardsMatchingFilter(AIGrave(),GatesFilter)>0
  and PriorityCheck(AIHand(),PRIO_DISCARD,1,FilterRace,RACE_FIEND)>3
end
function UseDragged()
  local result = false
  GlobalDragged = true
  if PriorityCheck(AIHand(),PRIO_DISCARD,#AIHand())>4 and #OppHand()>0 then
    result = true
  end
  GlobalDragged = nil
  return result
end
function UseDWD()
  return PriorityCheck(AIHand(),PRIO_DISCARD)>3
end
function UseLeviairDW()
  return CardsMatchingFilter(AIBanish(),LeviairDWFilter)>0
end
function SummonTourGuideDW(mode)
  return DualityCheck() and not SkillDrainCheck()
  and MidrashCheck() and Duel.GetLocationCount(player_ai,LOCATION_MZONE)>1
  and (mode == 1 and LeviairDWCheck(true) 
  or mode == 2 and SummonGraphaCheck(true)
  or mode == 3 and CardsMatchingFilter(UseLists({AIDeck(),AIHand()}),TourguideFilter)>1)
end
function SummonGraphaCheck(skipmonster)
  return HasID(AIGrave(),34230233,true) 
  and (CardsMatchingFilter(AIMon(),DarkWorldMonsterFilter,34230233)>0 
  or skipmonster) and DualityCheck()
end
function SummonGrapha()
  return true
end
function UseTrance(mode)
  return (mode == 1 and SummonGraphaCheck(true) 
  and HasID(AIHand(),33731070,true)
  and CardsMatchingFilter(AIMon(),DarkWorldMonsterFilter,34230233)==0
  or mode == 2 and PriorityCheck(AIHand(),PRIO_DISCARD,1,FilterRace,RACE_FIEND)>4)
  and not SkillDrainCheck()
  or mode == 3 and CardsMatchingFilter(AIBanish(),FilterAttribute,ATTRIBUTE_DARK)>0
end
function SummonDW(level)
  return SummonGraphaCheck(true) 
  and CardsMatchingFilter(AIMon(),DarkWorldMonsterFilter,34230233) ==0
  and not (HasID(AIHand(),33731070,true) and DiscardOutlets()>0)
  or level and level>0 and FieldCheck(level) == 1 and OverExtendCheck(3)
  or level and level == 0 and #AIMon()==0
end
function UseAllureDW()
  return DeckCheck(DECK_DARKWORLD) 
  and PriorityCheck(AIHand(),PRIO_BANISH,1,FilterAttribute,ATTRIBUTE_DARK)>2
end
function UseDarkSmog()
  return PriorityCheck(AIHand(),PRIO_DISCARD)>4
  and CardsMatchingFilter(OppGrave(),FilterType,TYPE_MONSTER)>0
end

function DarkWorldInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  if HasIDNotNegated(Act,41142615) -- Cheerful Coffin, test
  and CardsMatchingFilter(AIHand(),DarkWorldMonsterFilter)>2 
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,95992081) and UseLeviairDW() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSum,95992081) and LeviairDWCheck() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,34230233) and SummonGrapha() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Act,94283662) and UseTrance(1) then
    OPTSet(Act[CurrentIndex].cardid)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Sum,10802915) and SummonTourGuideDW(1) then
    return {COMMAND_SUMMON,CurrentIndex} 
  end
  if HasID(Sum,94283662) and UseTrance(1) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,33731070) and SummonDW() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,79126789) and SummonDW() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,60228941) and SummonDW() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,10802915) and SummonTourGuideDW(2) then
    return {COMMAND_SUMMON,CurrentIndex} 
  end
  if DraggedCheck() and not UseDragged() then
    if HasID(Act,33017655,false,nil,LOCATION_HAND) then
      return {COMMAND_ACTIVATE,CurrentIndex}
    end
    if #SetST>0 then
      return {COMMAND_SET_ST,1}
    end
  end
  if HasIDNotNegated(Act,16435215,false) and UseDragged() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,33017655,false,nil,LOCATION_SZONE,POS_FACEDOWN) and UseGates() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,33017655,false,nil,LOCATION_SZONE,POS_FACEUP) and UseGates() then
    OPTSet(Act[CurrentIndex].cardid)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,33017655,false,nil,LOCATION_HAND) and UseGates() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,74117290,false,nil,LOCATION_SZONE) and UseDWD() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,74117290,false,nil,LOCATION_HAND) and UseDWD() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,94283662) and UseTrance(2) then
    OPTSet(Act[CurrentIndex].cardid)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Sum,94283662) and UseTrance(2) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Act,41930553) and UseDarkSmog() then
    OPTSet(Act[CurrentIndex].cardid)
    return {COMMAND_ACTIVATE,CurrentIndex} 
  end
  if HasIDNotNegated(Act,01475311) and UseAllureDW() then
    return {COMMAND_ACTIVATE,CurrentIndex} 
  end
  if HasID(Sum,94283662) and SummonDW(4) then
    return {COMMAND_SUMMON,CurrentIndex} 
  end
  if HasID(Sum,33731070) and SummonDW(4) then
    return {COMMAND_SUMMON,CurrentIndex} 
  end
  if HasID(Sum,60228941) and SummonDW(4) then
    return {COMMAND_SUMMON,CurrentIndex} 
  end
  if HasID(Sum,10802915) and SummonTourGuideDW(3) then
    return {COMMAND_SUMMON,CurrentIndex} 
  end
  if HasID(Sum,79126789) and SummonDW(3) then
    return {COMMAND_SUMMON,CurrentIndex} 
  end
  if HasID(SetMon,84764038) and SetScarm(DECK_DARKWORLD) then
    return {COMMAND_SET_MONSTER,CurrentIndex} 
  end
  if HasID(Sum,94283662) and UseTrance(3) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,33731070) and SummonDW(0) then
    return {COMMAND_SUMMON,CurrentIndex} 
  end
  if HasID(Sum,79126789) and SummonDW(0) then
    return {COMMAND_SUMMON,CurrentIndex} 
  end
  if HasID(Sum,85138716) then -- temp
    return {COMMAND_SUMMON,CurrentIndex} 
  end
  return nil
end

function TranceTarget(cards)
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_DISCARD)
  else
    return Add(cards,PRIO_TOHAND)
  end
end
function DWDTarget(cards)
  return Add(cards,PRIO_DISCARD)
end
function DraggedTarget(cards)
  if cards[1].owner == 1 then
    return Add(cards,PRIO_DISCARD)
  else
    return BestTargets(cards,1,TARGET_DISCARD)
  end
end
function GatesTarget(cards)
  if LocCheck(cards,LOCATION_GRAVE) then
    return Add(cards,PRIO_BANISH)
  else
    return Add(cards,PRIO_DISCARD)
  end
end
function SmogTarget(cards)
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_DISCARD)
  end
  if GlobalCardMode == 1 then 
    GlobalCardMode = nil
    return GlobalTargetGet(cards,true)
  end
  return BestTargets(cards,1,TARGET_BANISH)
end
function DarkWorldCard(cards,min,max,id,c)
  if c then
    id = c.id
  end
  if id == 94283662 then 
    return TranceTarget(cards)
  end
  if id == 60228941 then --Snoww
    return Add(cards)
  end
  if id == 74117290 then 
    return DWDTarget(cards)
  end
  if id == 16435215 then 
    return DraggedTarget(cards)
  end
  if id == 33017655 then
    return GatesTarget(cards)
  end
  if id == 41930553 then
    return SmogTarget(cards)
  end
  if id == 34230233 then --Grapha 
    return BestTargets(cards,1,TARGET_DESTROY)
  end
  if id == 41142615 then 
    return Add(cards,PRIO_DISCARD,3)
  end
  return nil
end
function ChainEEV()
  return true
end
function CheckTargetFilter(c,source,targeted,filter,opt)
  return c and source 
  and (not targeted or Targetable(c,source.type))
  and Affected(c,source.type,source.level)
  and NotNegated(source)
  and (filter == nil or opt == nil 
  and filter(c) or filter(c,opt))
end

function CheckTarget(source,cards,targeted,filter,opt)
-- for disrupting card effects that target specific cards
  print("checking for targets")
  for i=1,Duel.GetCurrentChain() do
    print("chain link: "..i)
    if CheckNegated(i) then
      print("not negated, proceed")
      local e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
      if e then
        print("effect exists, proceed")
        if player_ai==nil then 
          player_ai=1                
        end
        local p=e:GetOwnerPlayer()
        local tg = Duel.GetChainInfo(i, CHAININFO_TARGET_CARDS)
        print("owner: "..p)
        print("AI: "..player_ai)
        print(tg)
        if p and p == 1-player_ai and tg and tg:GetCount()>0 then
          print("enemy player and targets exist, proceed")
          tg=tg:Filter(CheckTargetFilter,nil,source,targeted,filter,opt)
          if tg then
            c=tg:GetFirst() 
            if c then
              print("target matches filters, proceed")
              c=GetCardFromScript(c,cards)
              if ListHasCard(cards,c) then
                print("found target, returning: "..c.id..", "..c.cardid)
                return c
              end
            end
          end
        end
      end
    end
  end
  return false
end
SSByOwnEffect={
53804307,26400609,89399912,90411554, -- the 4 Dragon Rulers
12538374, -- Treeborn
}
function CheckSSList(c)
  local id
  if c.GetCode then
    id = c:GetCode()
  else
    id = c.id
  end
  for i=1,#SSByOwnEffect do
    if SSByOwnEffect[i]==id then
      return true
    end
  end
  return false
end
function CheckSSFilter(c,source,targeted,filter,opt)
  return c and source 
  and (not targeted or Targetable(c,source.type))
  and Affected(c,source.type,source.level)
  and NotNegated(source)
  and CheckSSList(c)
  and (filter == nil or opt == nil 
  and filter(c) or filter(c,opt))
end
function CheckSS(source,cards,targeted,filter,opt)
-- for disrupting cards that Special Summon themselves by their own effects
  print("checking for cards that special summon themselves")
  for i=1,Duel.GetCurrentChain() do
    print("chain link: "..i)
    if CheckNegated(i) then
      print("not negated, proceed")
      local e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
      if e then
        print("effect exists, proceed")
        if player_ai==nil then 
          player_ai=1                
        end
        local p=e:GetOwnerPlayer()
        local c = e:GetHandler()
        print("owner: "..p)
        print("AI: "..player_ai)
        if p and p == 1-player_ai then
          print("enemy player, proceed")
          if c and CheckSSFilter(c,source,targeted,filter,opt) then
            print("card matches filter, proceed")
            c=GetCardFromScript(c,cards)
            if ListHasCard(cards,c) then
              print("found target, returning: "..c.id..", "..c.cardid)
              return c
            end
          end
        end
      end
    end
  end
  return false
end
function ChainDarkSmog(card)
  if RemovalCheckCard(card) 
  and PriorityCheck(AIHand(),PRIO_DISCARD,1,FilterRace,RACE_FIEND)>4 
  then
    return true
  end
  if UnchainableCheck(41930553) then
    return false
  end
  if Duel.GetCurrentPhase() == PHASE_END 
  and Duel.GetTurnPlayer() == 1-player_ai
  and PriorityCheck(AIHand(),PRIO_DISCARD,1,FilterRace,RACE_FIEND)>4 
  and CardsMatchingFilter(OppGrave(),FilterType,TYPE_MONSTER)>0
  then
    return UnchainableCheck(41930553)
  end
  local c=CheckTarget(card,OppGrave(),true,FilterType,TYPE_MONSTER)
  if c and PriorityCheck(AIHand(),PRIO_DISCARD,1,FilterRace,RACE_FIEND)>4 then
    GlobalCardMode=1
    GlobalTargetSet(c)
    return true
  end
  local c=CheckSS(card,OppGrave(),true,FilterType,TYPE_MONSTER)
  if c and PriorityCheck(AIHand(),PRIO_DISCARD,1,FilterRace,RACE_FIEND)>4 then
    GlobalCardMode=1
    GlobalTargetSet(c)
    return true
  end
  if HasPriorityTarget(OppField(),true) 
  and HasID(AIHand(),34230233,true)
  then
    return true
  end
  return false
end
function DarkWorldChain(cards)
  if HasID(cards,41930553,false,nil,nil,nil,ChainDarkSmog) then 
    if Duel.GetTurnPlayer() == player_ai then
      OPTSet(cards[CurrentIndex].cardid)
    end
    return {1,CurrentIndex}
  end
  if HasID(cards,54974237) and ChainEEV() then 
    return {1,CurrentIndex}
  end
  return nil
end

function DarkWorldEffectYesNo(id,card)
  local result = nil
  if id==94283662 then -- Trance
    result = 1
  end
  return result
end
DarkWorldAtt={
34230233,60228941,33731070,94283662,
73445448,01639384,66547759,
}
DarkWorldDef={
10406322,88120966,
}

function DarkWorldPosition(id,available)
  result = nil
  for i=1,#DarkWorldAtt do
    if DarkWorldAtt[i]==id 
    then 
      result=POS_FACEUP_ATTACK
    end
  end
  for i=1,#DarkWorldDef do
    if DarkWorldDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  return result
end
