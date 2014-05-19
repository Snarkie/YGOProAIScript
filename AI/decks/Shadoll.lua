Shadoll = nil
function ShadollCheck()
  if Shadoll == nil then
    Shadoll = HasID(UseLists({AIDeck(),AIHand()}),44394295,true) -- check if the deck has Shadoll Fusion
  end 
  return Shadoll
end
function MoralltachFilter(c)
  return bit32.band(c.position,POS_FACEUP)>0 
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
end
function MoralltachCond(loc)
  if loc == PRIO_TOFIELD then 
    return CardsMatchingFilter(UseLists({OppMon(),OppST()}),MoralltachFilter)>0
  end
  return true
end
function BeagalltachCond(loc)
  if loc == PRIO_TOFIELD then 
    return MidrashCheck() and HasID(AIST(),85103922,true) and MoralltachCond(PRIO_TOFIELD)
  end
  return true
end
function ShadollFusionCond(loc)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),44394295,true)
  end
  return true
end
ShadollPrio = {
[37445295] = {1,1,1,1,1,1,1,1,1,nil}, -- Shadoll Falcon
[04939890] = {1,1,1,1,1,1,1,1,1,nil}, -- Shadoll Hedgehog
[30328508] = {1,1,1,1,1,1,1,1,1,nil}, -- Shadoll Lizard
[77723643] = {1,1,1,1,1,1,1,1,1,nil}, -- Shadoll Dragon
[03717252] = {1,1,1,1,1,1,1,1,1,nil}, -- Shadoll Beast
[85103922] = {1,1,6,5,2,2,1,1,1,MoralltachCond}, -- Artifact Moralltach
[12697630] = {1,1,7,4,3,3,1,1,1,BeagalltachCond}, -- Artifact Beagalltach
[24062258] = {1,1,1,1,1,1,1,1,1,nil}, -- Secret Sect Druid Dru

[05318639] = {1,1,1,1,1,1,1,1,1,nil}, -- Mystical Space Typhoon
[44394295] = {9,5,1,1,1,1,1,1,1,ShadollFusionCond}, -- Shadoll Fusion
[29223325] = {1,1,1,1,1,1,1,1,1,nil}, -- Artifact Ignition
[01845204] = {1,1,1,1,1,1,1,1,1,nil}, -- Instant Fusion
[77505534] = {1,1,1,1,1,1,1,1,1,nil}, -- Facing the Shadows
[04904633] = {1,1,1,1,1,1,1,1,1,nil}, -- Shadoll Roots
[53582587] = {1,1,1,1,1,1,1,1,1,nil}, -- Torrential Tribute
[29401950] = {1,1,1,1,1,1,1,1,1,nil}, -- Bottomless Trap Hole
[84749824] = {1,1,1,1,1,1,1,1,1,nil}, -- Solemn Warning
[94192409] = {1,1,1,1,1,1,1,1,1,nil}, -- Compulsory Evacuation Device
[12444060] = {1,1,1,1,1,1,1,1,1,nil}, -- Artifact Sanctum
[78474168] = {1,1,1,1,1,1,1,1,1,nil}, -- Breakthrough Skill

[20366274] = {1,1,1,1,1,1,1,1,1,nil}, -- El-Shadoll Nephilim
[94977269] = {1,1,1,1,1,1,1,1,1,nil}, -- El-Shadoll Midrash
[72959826] = {1,1,1,1,1,1,1,1,1,nil}, -- Panzer Dragon
[73964868] = {1,1,1,1,1,1,1,1,1,nil}, -- Constellar Pleiades
[29669359] = {1,1,1,1,1,1,1,1,1,nil}, -- Number 61: Volcasaurus
[82633039] = {1,1,1,1,1,1,1,1,1,nil}, -- Skyblaster Castel
[00581014] = {1,1,1,1,1,1,1,1,1,nil}, -- Daigusto Emeral
[33698022] = {1,1,1,1,1,1,1,1,1,nil}, -- Moonlight Rose Dragon
[88033975] = {1,1,1,1,1,1,1,1,1,nil}, -- Armades
[04779823] = {1,1,1,1,1,1,1,1,1,nil}, -- Michael, Lightsworn Ark
[31924889] = {1,1,1,1,1,1,1,1,1,nil}, -- Arcanite Magician
[08561192] = {1,1,1,1,1,1,1,1,1,nil}, -- Leoh, Keeper of the Sacred Tree
}
function ShadollGetPriority(id,loc)
  local checklist = nil
  local result = 0
  if loc == nil then
    loc = PRIO_TOHAND
  end
  checklist = ShadollPrio[id]
  if checklist then
    if checklist[10] and not(checklist[10](loc)) then
      loc = loc + 1
    end
    result = checklist[loc]
  end
  return result
end
function ShadollAssignPriority(cards,loc,filter)
  local index = 0
  --ShadollMultiple = nil
  for i=1,#cards do
    cards[i].index=i
    cards[i].prio=ShadollGetPriority(cards[i].id,loc)
    if filter and not filter(cards[i]) then
      cards[i].prio=-1
    end
  end
end
function ShadollPriorityCheck(cards,loc,count,filter)
  if count == nil then count = 1 end
  if loc==nil then loc=PRIO_TOHAND end
  if cards==nil or #cards<count then return -1 end
  ShadollAssignPriority(cards,loc,filter)
  table.sort(cards,function(a,b) return a.prio>b.prio end)
  return cards[count].prio
end
function ShadollAdd(cards,loc,count)
  local result={}
  if count==nil then count=1 end
  if loc==nil then loc=PRIO_TOHAND end
  local compare = function(a,b) return a.prio>b.prio end
  ShadollAssignPriority(cards,loc)
  table.sort(cards,compare)
  for i=1,count do
    result[i]=cards[i].index
    --ShadollTargets[#ShadollTargets+1]=cards[i].cardid
  end
  return result
end
function MidrashCheck()
  -- returns true, if there is no Midrash on the field
  return not HasIDNotNegated(UseLists({AIMon(),OppMon()}),94977269,true)
end

function ShadollOnSelectInit(cards, to_bp_allowed, to_ep_allowed)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  if HasID(SetableST,85103922) then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,12697630) then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,12444060) then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,29223325) then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  return nil
end
function SanctumTargetField(cards)
  return ShadollAdd(cards,PRIO_TOFIELD)
end
function SanctumTargetGrave(cards)
  return BestTargets(cards,1,true)
end
function BeagalltachTarget(cards)
  local result={}
  local targets=CardsMatchingFilter(UseLists({OppMon(),OppST()}),MoralltachFilter)
  for i=1,#cards do
    if cards[i].id == 85103922 and #result<math.min(targets,2) then
      result[#result+1]=i
    end
  end
  if #result==0 then result={math.random(#cards)} end
  return result
end
function IgnitionTarget(cards)
  local result = {}
  if GlobalCardMode == 2 then
    result = {IndexByID(cards,GlobalTargetID)}
  elseif GlobalCardMode == 1 then
    result = BestTargets(cards,1,true)
  else
    for i=1,#cards do
      if cards[i].id == 85103922 and #result<1 then
        result[#result+1]=i
      end
    end
  end 
  GlobalCardMode = nil
  if #result == 0 then result = {math.random(#cards)} end
  return result
end
function ShadollOnSelectCard(cards, minTargets, maxTargets,triggeringID,triggeringCard)
  local ID 
  local result=nil
  if triggeringCard then
    ID = triggeringCard.id
  else
    ID = triggeringID
  end
  if ID == 12697630 then
    return BeagalltachTarget(cards)
  end
  if ID == 12444060 and bit32.band(triggeringCard.location,LOCATION_ONFIELD)>0 then
    return SanctumTargetField(cards)
  end
  if ID == 12444060 and bit32.band(triggeringCard.location,LOCATION_GRAVE)>0 then
    return SanctumTargetGrave(cards)
  end
  if ID == 85103922 then
    return BestTargets(cards,1,true)
  end
  if ID == 29223325 then
    return IgnitionTarget(cards)
  end
  return nil
end
function ChainWireTap()
  local e = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
  if e then
    local c = e:GetHandler()
    return c and c:IsControler(1-player_ai)
  end
  return false 
end
function ChainBookOfMoon() 
  return false
end
function SanctumFilter(c)
  return (c.level>=5 or bit32.band(c.type,TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ)>0)
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 and bit32.band(c.position,POS_FACEUP)>0 
end
function ChainSanctum()
  if RemovalCheck(12444060) and (HasID(AIDeck(),85103922,true) or HasID(AIDeck(),12697630,true) and HasID(AIST(),85103922,true) and MidrashCheck())then
    GlobalCardMode = 1
    return true
  end
  local targets = CardsMatchingFilter(UseLists({OppMon(),OppST()}),SanctumFilter)
  if Duel.GetTurnPlayer()==1-player_ai and (HasID(AIDeck(),85103922,true) and targets > 0 
  or HasID(AIDeck(),12697630,true) and HasID(AIST(),85103922,true) and targets > 0 and MidrashCheck())
  then
    GlobalCardMode = 1
    return true
  end
  return nil
end
function SanctumYesNo()
  return CardsMatchingFilter(UseLists({OppMon(),OppST()}),IgnitionFilter)>0
end
function IgnitionFilter(c)
  return c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
end
function ChainIgnition()
  local targets=CardsMatchingFilter(OppST(),IgnitionFilter)
  local targets2=CardsMatchingFilter(UseLists({OppMon(),OppST()}),MoralltachFilter)
  if RemovalCheck(29223325) then
    if targets2 > 0 and HasID(AIST(),12697630,true) and HasID(AIDeck(),85103922,true) and MidrashCheck() then
      GlobalCardMode = 2
      GlobalTargetID = 12697630
      return true
    end
    if targets2 > 0 and HasID(AIST(),85103922,true) then
      GlobalCardMode = 2
      GlobalTargetID = 85103922
      return true
    end
    if targets > 0 then
      GlobalCardMode = 1
      return true
    end
  end
  return false
end
function ShadollOnSelectChain(cards,only_chains_by_player)
  if HasID(cards,34507039) and ChainWireTap() then
    return {1,CurrentIndex}
  end
  if HasID(cards,14087893) and ChainBookOfMoon() then
    return {1,CurrentIndex}
  end
  if HasID(cards,12444060,false,nil,LOCATION_ONFIELD) and ChainSanctum() then
    return {1,CurrentIndex}
  end
  if HasID(cards,12444060,false,nil,LOCATION_GRAVE) and SanctumYesNo() then
    return {1,CurrentIndex}
  end
  if HasID(cards,29223325) and ChainIgnition() then
    return {1,CurrentIndex}
  end
  return nil
end
function ShadollOnSelectEffectYesNo(id,triggeringCard)
  local result = nil
  if id == 85103922 then
    result = 1
  end
  if id == 12444060 and SanctumYesNo() then
    result = 1
  end
  return result
end
ShadollAtt={
  85103922 -- Moralltach
}
ShadollDef={
  12697630 -- Beagalltach
}
function ShadollOnSelectPosition(id, available)
  result = nil
  for i=1,#ShadollAtt do
    if ShadollAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#ShadollDef do
    if ShadollDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  return result
end