player_ai = nil
GlobalTargetID = nil
GlobalCheating = false
-- Sets up some variables for using card script functions
function set_player_turn()
	if player_ai == nil then
		player_ai = Duel.GetTurnPlayer()
    SaveState()
    if GlobalCheating then
      EnableCheats()
    end
	end
end
-- sets up cheats for the cheating AI
function EnableCheats()
  local e1=Effect.GlobalEffect()
  e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
  e1:SetCode(EVENT_PHASE+PHASE_DRAW)
  e1:SetCountLimit(1)
  e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==player_ai
  end)
  e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
    --AI.Chat("Oh yeah, cheating feels good.")
    Duel.Draw(player_ai,EXTRA_DRAW,REASON_RULE) 
    Duel.Recover(player_ai,LP_RECOVER,REASON_RULE) 
  end)
  Duel.RegisterEffect(e1,player_ai)
end
-- get the AI script owner from card script controler
function get_owner_by_controler(controler)
	if controler == player_ai then
		return 1
	else
		return 2
	end
end
-- chance from 0 to 100
function Chance(chance)
  return math.random(100)<=chance
end
-- returns true, if it finds the passed id in a list of cards + optional parameters)
function HasID(cards,id,skipglobal,desc,loc,pos,filter,opt)
  if type(skipglobal) == "function" then
    filter = skipglobal
    opt = desc
    skipglobal = nil
    desc = nil
  end
  if type(desc) == "function" then
    filter = desc
    opt = loc
    desc = nil
    loc = nil
  end
  if type(loc) == "function" then
    filter = loc
    opt = pos
    loc = nil
    pos = nil
  end  
  if type(pos) == "function" then
    opt = filter
    filter = pos
    pos = nil
  end
  local result = false;
  if cards then 
    for i=1,#cards do
      if cards[i].id == id 
      and (desc == nil or cards[i].description == desc) 
      and (loc == nil or bit32.band(cards[i].location,loc)>0)
      and (pos == nil or bit32.band(cards[i].position,pos)>0)
      and (filter == nil or (opt==nil and filter(cards[i]) or filter(cards[i],opt)))
      then
        if not skipglobal then CurrentIndex = i end
        result = true      
      end
    end
  end
  return result
end
-- same, but only returns true, if the card is not negated
function HasIDNotNegated(cards,id,skipglobal,desc,loc,pos,filter,opt)
  if type(skipglobal) == "function" then
    filter = skipglobal
    opt = desc
    skipglobal = nil
    desc = nil
  end
  if type(desc) == "function" then
    filter = desc
    opt = loc
    desc = nil
    loc = nil
  end
  if type(loc) == "function" then
    filter = loc
    opt = pos
    loc = nil
    pos = nil
  end  
  if type(pos) == "function" then
    opt = filter
    filter = pos
    pos = nil
  end
  local result = false
  if cards ~= nil then 
    for i=1,#cards do
      if cards[i].id == id 
      and (desc == nil or cards[i].description == desc) 
      and (loc == nil or bit32.band(cards[i].location,loc)>0)
      and (pos == nil or bit32.band(cards[i].position,pos)>0)
      and (filter == nil or (opt==nil and filter(cards[i]) or filter(cards[i],opt)))
      then
        if bit32.band(cards[i].type,TYPE_MONSTER)>0 
        and NotNegated(cards[i])
        then
          if not skipglobal then CurrentIndex = i end
          result = true  
        end
        if (FilterType(cards[i],TYPE_SPELL) 
        and not FilterType(cards[i],TYPE_QUICKPLAY)
        or FilterType(cards[i],TYPE_SPELL) 
        and FilterType(cards[i],TYPE_QUICKPLAY)
        and not FilterStatus(cards[i],STATUS_SET_TURN)
        or FilterType(cards[i],TYPE_TRAP)
        and not FilterStatus(cards[i],STATUS_SET_TURN))      
        and NotNegated(cards[i])
        then
          if not skipglobal then CurrentIndex = i end
          result = true 
        end
      end
    end
  end
  return result
end
--checks if the card is in cards and not in check
function NeedsCard(id,cards,check,skipglobal) 
  return not HasID(check,id,true) and HasID(cards,id,skipglobal)
end
-- returns true, if the AI has a card of this ID in hand, field, grave, or as an XYZ material
function HasAccess(id)
  for i=1,#AIMon() do
    local cards = AIMon()[i].xyz_materials
    if cards and #cards>0 then
      for j=1,#cards do
        if cards[j].id==id then return true end
      end
    end
  end
  return HasID(UseLists({AIHand(),AIField(),AIGrave()}),id,true) 
end
-- gets index of a card id in a card list
function IndexByID(cards,id)
  for i=1,#cards do
    if cards[i].id==id then return i end
  end
  return nil
end
function OppHasMonster()
  local cards=OppMon()
  return #cards>0
end
function AIGetStrongestAttack(skipbonus)
  local cards=AIMon()
  local result=0
  ApplyATKBoosts(cards)
  for i=1,#cards do
    if cards[i] and cards[i]:is_affected_by(EFFECT_CANNOT_ATTACK)==0 and cards[i].attack>result then
      result=cards[i].attack
      if skipbonus then
        result = result-cards[i].bonus
      end
    end
  end
  return result
end
function OppGetStrongestAttack(filter,opt)
  local cards=OppMon()
  local result=0
  ApplyATKBoosts(cards)
  for i=1,#cards do
    if cards[i] and (filter==nil or (opt==nil and filter(cards[i]) or filter(cards[i],opt))) 
    and cards[i].attack>result 
    then
      result=cards[i].attack-cards[i].bonus
    end
  end
  return result
end
function OppGetStrongestAttDef(filter,opt,loop)
  local cards=OppMon()
  local result=0
  if not loop then ApplyATKBoosts(cards) end
  for i=1,#cards do
    if cards[i] and (filter==nil or (opt==nil and filter(cards[i]) or filter(cards[i],opt))) then
      if bit32.band(cards[i].position,POS_ATTACK)>0 and cards[i].attack>result then
        result=cards[i].attack
        if cards[i].bonus then 
          result=result-cards[i].bonus
        end   
      elseif bit32.band(cards[i].position,POS_DEFENCE)>0 and cards[i].defense>result 
      and (bit32.band(cards[i].position,POS_FACEUP)>0 or bit32.band(cards[i].status,STATUS_IS_PUBLIC)>0)
      then
        result=cards[i].defense
      end
    end
  end
  return result
end
function OppGetWeakestAttDef()
  local cards=OppMon()
  local result=9999999
  ApplyATKBoosts(cards)
  if #cards==0 then return 0 end
  for i=1,#cards do
    if cards[i] and cards[i]:is_affected_by(EFFECT_CANNOT_BE_BATTLE_TARGET)==0 then
      if bit32.band(cards[i].position,POS_ATTACK)>0 and cards[i].attack<result then
        result=cards[i].attack-cards[i].bonus
      elseif bit32.band(cards[i].position,POS_DEFENCE)>0 and cards[i].defense<result 
      and (bit32.band(cards[i].position,POS_FACEUP)>0 or bit32.band(cards[i].status,STATUS_IS_PUBLIC)>0)
      then
        result=cards[i].defense
      end
    end
  end
  return result
end
function OppHasStrongestMonster(skipbonus)
  return #OppMon()>0 and ((AIGetStrongestAttack(skipbonus) <= OppGetStrongestAttDef()) 
  or HasID(AIMon(),68535320,true) and FireHandCheck() or HasID(AIMon(),95929069,true) and IceHandCheck())
end
function OppHasFacedownMonster()
  local cards=OppMon()
  for i=1,#cards do
    if bit32.band(cards[i].position,POS_FACEDOWN) > 0 then
      return true
    end
  end
  return false
end
function OppHasMonsterInMP2()
  return AI.GetCurrentPhase() == PHASE_MAIN2 and OppHasMonster()
end
-- returns count of cards matching a filter in a card list
function CardsMatchingFilter(cards,filter,opt)
  local result = 0
  for i=1,#cards do
    if opt and filter(cards[i],opt) or opt==nil and filter(cards[i]) then
      result = result + 1
    end
  end
  return result
end
-- returns random index of a card matching a filter in a list
function RandomIndexFilter(cards,filter,opt)
  result={}
  for i=1,#cards do
    if opt and filter(cards[i],opt) or opt==nil and filter(cards[i]) then
      result[#result+1]=i
    end
  end
  if #result>0 then return {result[math.random(#result)]} end
  return {0}
end
-- check, if the AI can wait for an XYZ/Synchro summon until Main Phase 2
function MP2Check()
  return AI.GetCurrentPhase() == PHASE_MAIN2 or not(GlobalBPAllowed)
  or OppHasStrongestMonster() and not(CanUseHand())
end
-- check how many monsters of a specific level are on the field. optional filter
function FieldCheck(level,filter,opt)
  local result=0
  for i=1,#AIMon() do
    local c=AIMon()[i]
    if c.level==level and FilterPosition(c,POS_FACEUP) 
    and (filter == nil or (opt == nil and filter(c) or filter(c,opt)))
    then
      result = result + 1
    end
  end
  return result
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
function ExtraDeckCheck(type,level)
  local cards=AIExtra()
  local result = 0
  for i=1,#cards do
    if bit32.band(cards[i].type,type)>0 
    and (cards[i].level==level or cards[i].rank==level) then
      result = result + 1
    end
  end
  return result
end
-- returns the cards in the list that match the filter
function SubGroup(cards,filter,opt)
  local result = {}
  if cards then
    if filter == nil then return cards end
    for i=1,#cards do
      if opt and filter(cards[i],opt) or opt==nil and filter(cards[i]) then
        result[#result+1]=cards[i]
      end
    end
  end
  return result
end
-- returns true, if the AI controls any backrow, either traps or setable bluffs
function HasBackrow(Setable)
  local cards=AIST()
  for i=1,#Setable do
    if SetBlacklist(Setable[i].id)==0 then
      return true
    end
  end
  for i=1,#cards do
    if bit32.band(cards[i].position,POS_FACEDOWN)>0 then
      return true
    end
  end
  return false
end
-- check, if the AI is already controlling the field, 
-- so it doesn't overcommit as much
function OverExtendCheck(limit)
  if limit == nil then limit = 2 end
  local cards = AIMon()
  local hand = AIHand()
  return OppHasStrongestMonster() or #cards < limit or #hand > 4 or AI.GetPlayerLP(2)<=800 and HasID(AIExtra(),12014404,true) -- Cowboy
end
-- checks, if a card the AI controls is about to be removed in the current chain
function RemovalCheck(id,category)
  if Duel.GetCurrentChain() == 0 then return false end
  local cat={CATEGORY_DESTROY,CATEGORY_REMOVE,CATEGORY_TOGRAVE,CATEGORY_TOHAND,CATEGORY_TODECK}
  if category then cat={category} end
  for i=1,#cat do
    for j=1,Duel.GetCurrentChain() do
      local ex,cg = Duel.GetOperationInfo(j,cat[i])
      if ex and CheckNegated(j) then
        if id==nil then 
          return cg
        end
        if cg and id~=nil and cg:IsExists(function(c) return c:IsControler(player_ai) and c:IsCode(id) end, 1, nil) then
          return true
        end
      end
    end
  end
  return false
end
function RemovalCheckCard(target,category,type,chainlink,filter,opt)
  if Duel.GetCurrentChain() == 0 then return false end
  local cat={CATEGORY_DESTROY,CATEGORY_REMOVE,
  CATEGORY_TOGRAVE,CATEGORY_TOHAND,
  CATEGORY_TODECK,CATEGORY_CONTROL}
  if card and filter and (opt and not filter(card,opt)
  or opt==nil and not filter(card))
  then
    return false
  end
  if category then cat={category} end
  local a=1
  local b=Duel.GetCurrentChain()
  if chainlink then
    a=chainlink
    b=chainlink
  end
  for i=1,#cat do
    for j=a,b do
      local ex,cg = Duel.GetOperationInfo(j,cat[i])
      local e = Duel.GetChainInfo(j,CHAININFO_TRIGGERING_EFFECT)
      if ex and CheckNegated(j) and (type==nil
      or e and e:GetHandler():IsType(type))
      then
        if target==nil then 
          return cg
        end
        if cg and target then
          local card=false
          cg:ForEach(function(c) 
            local c=GetCardFromScript(c,Field())
            if CardsEqual(c,target) then
              card=c
            end  end) 
          return card
        end
      end
    end
  end
  return false
end
function RemovalCheckList(cards,category,type,chainlink,filter,opt)
  if Duel.GetCurrentChain() == 0 then return false end
  local result = {}
  for i=1,#cards do
    local c = RemovalCheckCard(cards[i],category,type,chainlink,filter,opt)
    if c then result[#result+1]=c end
  end
  if #result>0 then
    return result
  end
  return false
end
function NegateCheckCard(target,type,chainlink,filter,opt)
  if Duel.GetCurrentChain() == 0 then return false end
  if card and filter and (opt and not filter(card,opt)
  or opt==nil and not filter(card))
  then
    return false
  end
  local a=1
  local b=Duel.GetCurrentChain()
  if chainlink then
    a=chainlink
    b=chainlink
  end
  for i=a,b do
    local e = Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
    local g = Duel.GetChainInfo(i,CHAININFO_TARGET_CARDS)
    if e and e:IsHasCategory(CATEGORY_DISABLE) 
    and CheckNegated(i) and (type==nil
    or e:GetHandler():IsType(type))
    then
      if target==nil then 
        return g
      end
      if g and target then
        local card=false
        g:ForEach(function(c) 
          local c=GetCardFromScript(c,Field())
          if CardsEqual(c,target) then
            card=c
          end 
        end) 
        return card
      end
    end
  end
  return false
end
function NegateCheckCardList(cards,type,chainlink,filter,opt)
  if Duel.GetCurrentChain() == 0 then return false end
  local result = {}
  for i=1,#cards do
    local c = NegateCheckCard(cards[i],type,chainlink,filter,opt)
    if c then result[#result+1]=c end
  end
  if #result>0 then
    return result
  end
end
-- checks, if a card the AI controls is about to be negated in the current chain
function NegateCheck(id)
  if Duel.GetCurrentChain() == 0 then return false end
  local ex,cg = Duel.GetOperationInfo(Duel.GetCurrentChain(),CATEGORY_DISABLE)
  if ex then 
    if id==nil then 
      return cg 
    end
    if cg and id~=nil and cg:IsExists(function(c) return c:IsControler(player_ai) and c:IsCode(id) end, 1, nil) then
      return true
    end
  end
  return false
end
function ExpectedDamageFilter(card)
  return card:IsControler(1-player_ai) and card:IsType(TYPE_MONSTER) and card:IsPosition(POS_FACEUP_ATTACK)
  and card:GetAttackedCount()==0 and not card:IsHasEffect(EFFECT_CANNOT_ATTACK_ANNOUNCE) and not card:IsHasEffect(EFFECT_CANNOT_ATTACK)
end
function ExpectedDamageFilter2(card)
  return card:IsControler(player_ai) and card:IsType(TYPE_MONSTER) and card:IsPosition(POS_FACEUP_ATTACK)
  and card:GetAttackedCount()==0 and not card:IsHasEffect(EFFECT_CANNOT_ATTACK_ANNOUNCE) and not card:IsHasEffect(EFFECT_CANNOT_ATTACK)
end
-- checks the damage the AI is expected to take or dish out during this turn
function ExpectedDamage(player)
  local result=0
  local g = nil
  if player and player == 2 then
    g=Duel.GetMatchingGroup(ExpectedDamageFilter2,player_ai,LOCATION_MZONE,0,nil,p) 
  else
    g=Duel.GetMatchingGroup(ExpectedDamageFilter,1-player_ai,LOCATION_MZONE,0,nil,p) 
  end
  local c=nil
  if g then c=g:GetFirst() end
  while c do
    result=result+c:GetAttack()
    c=g:GetNext()
  end
  return result
end
TARGET_OTHER    = 0
TARGET_DESTROY  = 1
TARGET_TOGRAVE  = 2
TARGET_BANISH   = 3
TARGET_TOHAND   = 4
TARGET_TODECK   = 5
TARGET_FACEDOWN = 6
TARGET_CONTROL  = 7
TARGET_BATTLE   = 8
TARGET_DISCARD  = 9
TARGET_PROTECT  = 10
-- returns a list of the best targets given the parameters
function BestTargets(cards,count,target,filter,opt,immuneCheck,source)
  local result = {}
  local AIMon=AIMon()
  local DestroyCheck = false
  if target == true then 
    target=TARGET_DESTROY 
  end
  if target == TARGET_BATTLE then 
    return BestAttackTarget(cards,source,false,filter,opt) 
  end
  if count == nil then count = 1 end
  ApplyATKBoosts(AIMon)
  local AIAtt=Get_Card_Att_Def(AIMon,"attack",">",nil,"attack")
  for i=1,#cards do
    local c = cards[i]
    c.index = i
    c.prio = 0
    if bit32.band(c.type,TYPE_MONSTER)>0 then
      if bit32.band(c.position, POS_FACEUP)>0
      or bit32.band(c.status,STATUS_IS_PUBLIC)>0
      then
        if c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)>0 and target==TARGET_DESTROY 
        or c:is_affected_by(EFFECT_IMMUNE_EFFECT)>0
        then
          c.prio = 1
        else
          c.prio = math.max(c.attack+1,c.defense)+5
          if c.owner==2 and c:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE)==0 then
            c.prio = math.max(5,c.prio-AIAtt*.75)
          end
        end
      else
        c.prio = 2
      end
    else
      if c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)>0 and target==TARGET_DESTROY
      or c:is_affected_by(EFFECT_IMMUNE_EFFECT)>0 
      or bit32.band(c.status,STATUS_LEAVE_CONFIRMED)>0
      then
        c.prio = 1
      else    
        if bit32.band(c.position, POS_FACEUP)>0 then
          c.prio = 4
        else
          c.prio = 3
        end
      end
    end
    if PriorityTarget(c) then
      c.prio = c.prio+2
    end
    if c.level>4 then
      c.prio = c.prio+1
    end
    if bit32.band(c.position, POS_FACEUP_ATTACK)>0 then
      c.prio = c.prio+1
    end
    if (bit32.band(c.position, POS_FACEUP)>0 or bit32.band(c.status,STATUS_IS_PUBLIC)>0)
    and (target == TARGET_TOHAND and (ToHandBlacklist(c.id)  
    or FilterType(c,TYPE_SPELL+TYPE_TRAP) and FilterPosition(c,POS_FACEUP))
    or target == TARGET_DESTROY and DestroyBlacklist(c)
    or target == TARGET_FACEDOWN and bit32.band(c.type,TYPE_FLIP)>0)
    then
      c.prio = -1
    end
    if FilterType(c,TYPE_PENDULUM) and HasIDNotNegated(OppST(),05851097,true,nil,nil,POS_FACEUP) then
      c.prio = -1
    end
    if immuneCheck and source and not Affected(c,source.type,source.level) then
      c.prio = -1
    end
    if CurrentOwner(c) == 1 then 
      c.prio = -1 * c.prio
    end
    if target == TARGET_PROTECT then 
      c.prio = -1 * c.prio
    end
    if filter and (opt == nil and not filter(c) or opt and not filter(c,opt)) then
      c.prio = -9999
    end
  end
  table.sort(cards,function(a,b) return a.prio > b.prio end)
  for i=1,#cards do
    --print("id: "..cards[i].id..", prio: "..cards[i].prio)
  end
  for i=1,count do
    result[i]=cards[i].index
  end
  return result
end
function GlobalTargetSet(c,cards)
  if cards == nil then
    cards = All()
  end
  if c.GetCode then
    c = GetCardFromScript(c,cards)
  end
  GlobalTargetID = c.cardid
  return GlobalTargetID
end
function GlobalTargetGet(cards,index)
  if cards == nil then
    cards = All()
  end
  local cardid = GlobalTargetID
  GlobalTargetID = nil
  local c = FindCard(cardid,cards,index)
  if c == nil then
    c = FindCard(cardid,All(),index)
  end
  if c == nil then
  end
  return c
end
function GlobalTarget(cards,player,original)
  for i=1,#cards do
    if (not original and cards[i].id==GlobalTargetID
    or original and cards[i].original_id==GlobalTargetID)
    and (player==nil or cards[i].owner==player) then
      GlobalTargetID = nil
      return {i}
    end
  end
  return {math.random(#cards)}
end
function IsMonster(card)
  return bit32.band(card.type,TYPE_MONSTER)>0
end
-- fool-proof check, if a card belongs to a specific archetype
function IsSetCode(card_set_code, set_code)
    local band = bit32.band
    local rshift = bit32.rshift
    local settype = band(set_code,0xfff);
    local setsubtype = band(set_code,0xf000);
    local setcode = card_set_code
    while setcode and setcode > 0 do
        if (band(setcode,0xfff) == settype and band(band(setcode,0xf000),setsubtype) == setsubtype) then
            return true
        end
        setcode = rshift(setcode,16);
    end
    return false;
end
OPT={}
-- functions to keep track of OPT clauses
-- pass an id for hard OPT clauses, 
-- pass the unique cardid for a simple OPT 
function OPTCheck(id)
  if type(id) == "table" and id.id then
    id = id.cardid
  end
  return OPTCount(id)==0 
end
function OPTCount(id)
  if type(id) == "table" and id.id then
    id = id.cardid
  end
  local result = OPT[id*100+Duel.GetTurnCount()]
  if result == nil then
    return 0
  end
  return result 
end
function OPTSet(id)
  if type(id) == "table" and id.id then
    id = id.cardid
  end
  local i = id*100+Duel.GetTurnCount()
  if OPT[i] == nil then
    OPT[i] = 1
  else
    OPT[i]=OPT[i]+1
  end
  return
end
-- used to keep track, if the OPT was reset willingly
-- for example if the card was bounced back to the hand
function OPTReset(id)
  OPT[id*100+Duel.GetTurnCount()]=nil
end
-- used to keep track of how many cards with the same id got a priority request
-- so the AI does not discard multiple Marksmen to kill one card, for example
Multiple = nil
function SetMultiple(id)
  if Multiple == nil then
    Multiple = {}
  end
  Multiple[#Multiple+1]=id
end
function GetMultiple(id)
  local result = 0
  if Multiple then
    for i=1,#Multiple do
      if Multiple[i]==id then
        result = result + 1
      end
    end
  end
  return result
end
-- shuffles a list
function Shuffle(t)
  local n = #t
  while n >= 2 do
    local k = math.random(n)
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
  return t
end
-- returns true, if the source is expected to win a battle against the target
function WinsBattle(source,target)
  return source and target 
  and FilterLocation(source,LOCATION_MZONE)
  and FilterLocation(target,LOCATION_MZONE)
  and (target:IsPosition(POS_FACEUP_ATTACK) 
  and source:GetAttack() >= target:GetAttack()
  or target:IsPosition(POS_FACEUP_DEFENCE)
  and source:GetAttack() >= target:GetDefence()) 
  and source:IsPosition(POS_FACEUP_ATTACK)
  and not target:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)
  and not source:IsHasEffect(EFFECT_CANNOT_ATTACK)
end
function NotNegated(c)
  local disabled = false
  local id
  local type
  local player
  if c==nil then
    print("warning: NotNegated null card")
    return true
  end
  if c.GetCode then
    disabled = (c:IsHasEffect(EFFECT_DISABLE) or c:IsHasEffect(EFFECT_DISABLE_EFFECT))
    id = c:GetCode()
    if c:IsControler(player_ai) then
      player = 1
    else
      player = 2
    end
  else
    disabled = c:is_affected_by(EFFECT_DISABLE)>0 or c:is_affected_by(EFFECT_DISABLE_EFFECT)>0
    id = c.id
    player = CurrentMonOwner(c.cardid)
  end
  if not GlobalNegatedLoop then
    GlobalNegatedLoop = true
    if FilterType(c,TYPE_SPELL) 
    and (HasIDNotNegated(Field(),84636823,true,nil,nil,POS_FACEUP) -- Spell Canceller
    or HasIDNotNegated(Field(),61740673,true,nil,nil,POS_FACEUP)   -- Imperial Order
    or HasIDNotNegated(OppMon(),33198837,true,nil,nil,POS_FACEUP)  -- Naturia Beast
    or HasIDNotNegated(OppMon(),99916754,true,nil,nil,POS_FACEUP)) -- Naturia Exterio
    then
      return false
    end
    if FilterType(c,TYPE_TRAP) 
    and (HasIDNotNegated(Field(),77585513,true,nil,nil,POS_FACEUP) -- Jinzo
    or HasIDNotNegated(Field(),51452091,true,nil,nil,POS_FACEUP)  -- Royal Decree
    or HasIDNotNegated(OppMon(),02956282,true,nil,nil,POS_FACEUP) and #OppGrave()>1 -- Naturia Barkion
    or HasIDNotNegated(OppMon(),99916754,true,nil,nil,POS_FACEUP)) -- Naturia Exterio
    or GlobalTrapStun == Duel.GetTurnCount()
    then
      return false
    end
    if FilterType(c,TYPE_MONSTER) 
    then
      if SkillDrainCheck() then
        return false
      end
      if HasIDNotNegated(Field(),33746252,true,nil,nil,POS_FACEUP) then -- Majesty's Fiend
        return false
      end
      if HasIDNotNegated(Field(),56784842,true,nil,nil,POS_FACEUP) then -- Angel 07
        return false
      end
      if HasIDNotNegated(Field(),53341729,true,nil,nil,POS_FACEUP) then -- Light-Imprisoning Mirror
        return not FilterAttribute(c,ATTRIBUTE_LIGHT)
      end
      if HasIDNotNegated(Field(),99735427,true,nil,nil,POS_FACEUP) then -- Shadow-Imprisoning Mirror
        return not FilterAttribute(c,ATTRIBUTE_DARK)
      end
      if FilterLocation(c,LOCATION_EXTRA) 
      and HasIDNotNegated(Field(),89463537,true,nil,nil,POS_FACEUP) -- Necroz Unicore
      then 
        return false
      end
    end
  end
  GlobalNegatedLoop=false
  return not disabled
end
function Negated(c)
  return not NotNegated(c)
end
function DestroyFilter(c,nontarget)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and (nontarget==true or c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0)
  and not (DestroyBlacklist(c)
  and (bit32.band(c.position, POS_FACEUP)>0 
  or bit32.band(c.status,STATUS_IS_PUBLIC)>0))
  and (filter == nil or (opt == nil and filter(c) or filter(c,opt)))
end
-- returns the amount of cards that can be safely destroyed in a list of cards
function DestroyCheck(cards,nontarget,filter,opt)
  return CardsMatchingFilter(cards,
  function(c) 
    return DestroyFilter(c,nontarget) and filter == nil 
    or filter and (opt == nil and filter(c) or opt and filter(c,opt))
  end)
end
function FilterAttribute(c,att)
  if c.GetCode then
    return FilterType(c,TYPE_MONSTER) and c:IsAttribute(att)
  else
    return FilterType(c,TYPE_MONSTER) and bit32.band(c.attribute,att)>0
  end
end
function FilterRace(c,race)
  return bit32.band(c.type,TYPE_MONSTER)>0 and bit32.band(c.race,race)>0
end
function FilterLevel(c,level)
  return bit32.band(c.type,TYPE_MONSTER)>0 and c.level==level
end
function FilterRank(c,rank)
  if c.GetCode then
    return FilterType(c,TYPE_XYZ) and c:GetRank()==rank
  else
    return FilterType(c,TYPE_XYZ) and c.rank==rank
  end
end
function FilterType(c,type) -- TODO: change all filters to support card script
  if c.GetCode then
    return c:IsType(type)
  else
    return bit32.band(c.type,type)>0
  end
end
function FilterAttackMin(c,attack)
  return bit32.band(c.type,TYPE_MONSTER)>0 and c.attack>=attack
end
function FilterAttackMax(c,attack)
  return bit32.band(c.type,TYPE_MONSTER)>0 and c.attack<=attack
end
function FilterDefenseMin(c,defense)
  return bit32.band(c.type,TYPE_MONSTER)>0 and c.defense<=defense
end
function FilterDefenseMax(c,defense)
  return bit32.band(c.type,TYPE_MONSTER)>0 and c.defense<=defense
end
function FilterID(c,id)
  return c.id==id
end
function FilterPosition(c,pos)
  if c.GetCode then
    return c:IsPosition(pos)
  else
    return bit32.band(c.position,pos)>0
  end
end
function FilterLocation(c,loc)
  if c.GetCode then
    return c:IsLocation(loc)
  else
    return bit32.band(c.location,loc)>0
  end
end
function FilterPreviousLocation(c,loc)
  return bit32.band(c.previous_location,loc)>0
end
function FilterStatus(c,status)
  if c.GetCode then
    return c:IsStatus(status)
  else
    return bit32.band(c.status,status)>0
  end
end
function FilterSummon(c,type)
  return bit32.band(c.summon_type,type)>0
end
function FilterAffected(c,effect)
  if c.GetCode then
    return c:IsHasEffect(effect)
  else
    return c:is_affected_by(effect)>0
  end
end
function FilterPublic(c)
  return FilterStatus(c,STATUS_IS_PUBLIC) or FilterPosition(c,POS_FACEUP)
end
function FilterPrivate(c)
  return not FilterPublic(c)
end
function FilterSet(c,code)
  return IsSetCode(c.setcode,code)
end
function FilterOPT(c,hard)
  if hard then 
    return OPTCheck(c.id)
  else
    return OPTCheck(c.cardid)
  end
end
function HasMaterials(c)
  return c.xyz_material_count>0
end
function HasEquips(c,opt)
  return opt == nil and c.equip_count>0
  or opt and c.equip_count==opt
end
function FilterPendulum(c)
  return not FilterType(c,TYPE_PENDULUM+TYPE_TOKEN) 
end
--[[function ScaleCheck(p)
  local cards=AIST()
  local result = 0
  local scale = {}
  if p==2 then
    cards=OppST()
  end
  for i=1,#cards do
    if bit32.band(cards[i].type,TYPE_PENDULUM)>0 then
      result = result + 1
      --scale[result]= --missing function?
    end
  end
  return result
end]]


GlobalTargetList = {}
-- function to prevent multiple cards to target the same card in the same chain
function TargetCheck(card)
  for i=1,#GlobalTargetList do
    if card and GlobalTargetList[i].cardid==card.cardid then
      return false
    end
  end
  return true
end
function TargetSet(card)
  GlobalTargetList[#GlobalTargetList+1]=card
end

function PendulumCheck(c)
  return bit32.band(c.type,TYPE_PENDULUM)>0 and bit32.band(c.location,LOCATION_SZONE)>0
end

function EffectCheck(player)
  -- function to check, if an effect is used in the current chain
  local p = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_PLAYER)
  local e = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
  local c = nil
  local id = nil
  if e and p and (p == player or player == nil) then
    c = e:GetHandler()
    if c then
      id = c:GetCode()
      return e,c,id
    end
  end
  return nil
end 

function FindCard(cardid,cards,index)
  if cards == nil then cards = All() end
  for i=1,#cards do
    if cards[i].cardid==cardid then
      if index then
        return {i}
      else
        return cards[i]
      end
    end
  end
  return nil
end

function FindID(id,cards,index,filter,opt)
  if cards == nil then cards = All() end
  for i=1,#cards do
    if cards[i].id == id 
    and (filter == nil
    or opt == nil and filter(cards[i])
    or filter(cards[i],opt))
    then
      if index then
        return {i}
      else
        return cards[i]
      end
    end
  end
  return nil
end


function AttackBoostCheck(bonus,malus,player,filter,cond)
  local source = Duel.GetAttacker()
  local target = Duel.GetAttackTarget()
  if bonus == nil then bonus = 0 end
  if malus == nil then malus = 0 end
  if player == nil then player = player_ai end
  if source and target 
  and source:IsLocation(LOCATION_MZONE) 
  and target:IsLocation(LOCATION_MZONE) 
  then
    if source:IsControler(player) then
      target = Duel.GetAttacker()
      source = Duel.GetAttackTarget()
    end
    if target:IsPosition(POS_FACEUP_ATTACK) 
    and (source:IsPosition(POS_FACEUP_ATTACK) 
    and source:GetAttack() >= target:GetAttack() 
    and source:GetAttack()-malus <= target:GetAttack()+bonus
    or source:IsPosition(POS_FACEUP_DEFENCE) 
    and source:GetDefence() >= target:GetAttack() 
    and source:GetDefence() <= target:GetAttack()+bonus)
    and not source:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)
    and (filter == nil 
    or opt == nil and filter(target)
    or opt and filter(target,opt))
    then
      return true
    end
  end
  return false
end

function LocCheck(cards,loc,all) -- checks the location of cards
  if not all then                -- for target functions etc
    return FilterLocation(cards[1],loc)
  end
  local result = #cards
  for i=1,#cards do
    if FilterLocation(cards[i],loc) then
      result = result-1
    end
  end
  return result == 0
end


function NormalSummonCheck(player)
  if player == nil then player = player_ai end
  -- wrapper for changed card script function
  if Duel.CheckNormalSummonActivity then
    return Duel.CheckNormalSummonActivity(player)
  else
    return Duel.GetActivityCount(player,ACTIVITY_NORMALSUMMON)>0
  end
end

function SpecialSummonCheck(player)
  if player == nil then player = player_ai end
  -- wrapper for changed card script function
  if Duel.CheckSpecialSummonActivity then
    return Duel.CheckSpecialSummonActivity(player)
  else
    return Duel.GetActivityCount(player,ACTIVITY_SPSUMMON)>0
  end
end
function TargetProtection(c,type)
  local id
  local mats
  if c.GetCode then
    id = c:GetCode()
    mats = c:GetMaterialCount()
  else
    id = c.id
    mats = c.xyz_material_count
  end
  if id == 16037007 or id == 58058134 then
    return NotNegated(c) and mats>0
    and FilterLocation(c,LOCATION_MZONE)
  end
  if id == 82044279 then
    return NotNegated(c) and bit32.band(type,TYPE_MONSTER)>0
    and FilterLocation(c,LOCATION_MZONE)
  end
  return false
end
function Targetable(c,type)
  local id
  local p
  local targetable
  if c.GetCode then
    id = c:GetCode()
    p = c:GetControler()
    targetable = not(c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET)) 
  else
    id = c.id
    p = CurrentOwner(c)
    if p==1 then
      p = player_ai
    else
      p = 1-player_ai
    end
    targetable = c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
  end
  if id == 08561192 then
    return Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==p
  end
  return targetable and not TargetProtection(c,type)
end
function AffectedProtection(id,type,level)
  return false
end
function Affected(c,type,level)
  local id
  local immune = false
  local atkdiff
  if c.GetCode then
    id = c:GetCode()
    immune = c:IsHasEffect(EFFECT_IMMUNE_EFFECT) 
    atkdiff = c:GetBaseAttack() - c:GetAttack()
  else
    id = c.id
    immune = c:is_affected_by(EFFECT_IMMUNE_EFFECT)>0
    atkdiff = c.base_attack - c.attack
  end
  if immune and atkdiff == 800 
  and bit32.band(type,TYPE_SPELL+TYPE_TRAP)==0
  then
    return true -- probably forbidden lance
  end
  return not immune
end
PriorityTargetList=
{
  82732705,30241314,81674782,47084486,  -- Skill Drain, Macro Cosmos, Dimensional Fissure, Vanity's Fiend
  72634965,59509952,58481572,45986603,  -- Vanity's Ruler, Archlord Kristya, Dark Law, Snatch Steal
}
PriorityGraveTargetList=
{
  34230233 -- Grapha
}
function PriorityTarget(c,destroycheck,loc,filter,opt) -- preferred target for removal
  local result = false
  if loc == nil then loc = LOCATION_ONFIELD end
  if loc == LOCATION_ONFIELD then
    if FilterType(c,TYPE_MONSTER) and (bit32.band(c.type,TYPE_FUSION+TYPE_RITUAL+TYPE_XYZ+TYPE_SYNCHRO)>0 
    or c.level>4 and c.attack>2000)
    and not (not FiendishCheck(c) and AIGetStrongestAttack()>c.attack)
    then
      result = true
    end
    for i=1,#PriorityTargetList do
      if PriorityTargetList[i]==c.id then
        result = true
      end
    end
    result = (result or not AttackBlacklistCheck(c))
  elseif loc == LOCATION_GRAVE then
    for i=1,#PriorityGraveTargetList do
      if PriorityGraveTargetList[i]==c.id then
        result = true
      end
    end
  end
  if result and (not destroycheck or DestroyCheck(c)) 
  and FilterPublic(c) and (filter == nil or (opt==nil and filter(c) or filter(c,opt)))
  then
    return true
  end
  return false
end
function HasPriorityTarget(cards,destroycheck,loc,filter,opt)
  if HasIDNotNegated(cards,05851097,true,nil,nil,POS_FACEUP,FilterPublic) then -- Vanity's Emptiness
    return true
  end
  local count = 0
  for i=1,#cards do
    if PriorityTarget(cards[i],destroycheck,loc,filter,opt) then
      count = count +1
    end
  end
  return count>0
end

-- Function to determine, if a player can special summon
-- true = player can special summon
GlobalDuality = 0
function DualityCheck(player)
  local cards = UseLists(AIField(),OppField())
  if player == nil then player = 1 end
  if player == 1 and Duel.GetTurnCount()==GlobalDuality then
    return false -- Pot of Duality
  end
  if HasIDNotNegated(cards,05851097,true,nil,nil,POS_FACEUP) then 
    return false -- Vanity's Emptiness
  end
  if HasIDNotNegated(cards,59509952,true,nil,nil,POS_FACEUP) then 
    return false -- Archlord Kristya
  end
  if HasIDNotNegated(cards,42009836,true,nil,nil,POS_FACEUP) then 
    return false -- Fossil Dyna Pachycephalo
  end
  if HasIDNotNegated(cards,41855169,true,nil,nil,POS_FACEUP) then 
    return false -- Jowgen the Spiritualist
  end
  if HasIDNotNegated(cards,47084486,true,nil,nil,POS_FACEUP) then 
    return false -- Vanity's Fiend
  end
  if player == 1 and HasIDNotNegated(OppMon(),72634965,true,nil,nil,POS_FACEUP) then 
    return false -- Vanity's Ruler
  end
  return true
end

-- Function to determine, if a player's cards are being banished 
-- instead of being sent to the grave
-- true = cards are not being banished
function MacroCheck(player)
  local cards = UseLists(AIField(),OppField())
  if player == nil then player = 1 end
  if HasIDNotNegated(cards,30459350,true,nil,nil,POS_FACEUP) then 
    return true -- Imperial Iron Wall, cancels everything below
  end
  if HasIDNotNegated(cards,30241314,true,nil,nil,POS_FACEUP) then 
    return false -- Macro Cosmos
  end
  if HasIDNotNegated(cards,81674782,true,nil,nil,POS_FACEUP) then 
    return false -- Dimensional Fissure
  end
  if player == 1 and HasIDNotNegated(OppMon(),58481572,true,nil,nil,POS_FACEUP) then
    return false -- Dark Law
  end
  return true
end

DestRep={
48739166,78156759,10002346, -- SHArk, Zenmaines, Gachi
99469936,23998625,01855932, -- Crystal Zero Lancer, Heart-eartH, Kagutsuchi
77631175,23232295,16259499, -- Comics Hero Arthur, Lead Yoke, Fortune Tune
}
-- function to determine, if a card has to be destroyed multiple times
-- true = can be destroyed properly
function DestroyCountCheck(c,type,battle)
  local id
  local mats
  local negated
  if c.GetCode then
    id = c:GetCode()
    mats = c:GetGetMaterialCount()
  else
    id = c.id
    mats = c.xyz_material_count
  end
  if id == 81105204 then
    return Negated(c) or bit32.band(type,TYPE_SPELL+TYPE_TRAP)==0
    or battle or c:is_affected_by(EFFECT_INDESTRUCTABLE_COUNT)==0
  end
  if Negated(c) then
    return c:is_affected_by(EFFECT_INDESTRUCTABLE_COUNT)==0
  end
  for i=1,#DestRep do
    if c.id==DestRep[i] then
      return false
    end
  end
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_COUNT)==0
end

AttBL={
78371393,04779091,31764700, -- Yubel 1,2 and 3
54366836,88241506,23998625, -- Lion Heart, Maiden with the Eyes of Blue, Heart-eartH
80344569,68535320,95929069, -- Grand Mole, Fire Hand, Ice Hand
74530899, -- Metaion
}
-- cards that should not be attacked without negating them first
-- (or under special circumstances) TODO: Define conditions
-- true = free to attack
function AttackBlacklistCheck(c,source)
  local id
  if c.GetCode then
    id=c:GetCode()
  else
    id=c.id
  end
  if Negated(c) then
    return true
  end
  for i=1,#AttBL do
    if id == AttBL[i] then
      return false
    end
  end
  return true
end
-- function to determine, if a card can be destroyed by battle
-- and should be attacked at all
function BattleTargetCheck(c,source)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE)==0
  and c:is_affected_by(EFFECT_CANNOT_BE_BATTLE_TARGET)==0
  and DestroyCountCheck(c,TYPE_MONSTER,true)
  and AttackBlacklistCheck(c,source)
end

function BattleDamageCheck(c,source)
  return not FilterAffected(source,EFFECT_NO_BATTLE_DAMAGE)
  and not FilterAffected(c,EFFECT_AVOID_BATTLE_DAMAGE)
  and not FilterAffected(c,EFFECT_REFLECT_BATTLE_DAMAGE)
  and AttackBlacklistCheck(c,source)
end

function BattleDamage(c,source,atk,oppatk,oppdef,pierce)
  if atk == nil  then
    atk = source.attack
  end
  if oppatk == nil then
    oppatk = c.attack
  end
  if oppdef == nil then
    oppdef = c.defense
  end
  if c == nil then
    if FilterAffected(source,EFFECT_CANNOT_DIRECT_ATTACK) then
      return 0
    else
      return atk
    end
  end
  if pierce == nil then
    pierce = FilterAffected(source,EFFECT_PIERCE) and NotNegated(source)
  end
  if BattleDamageCheck(c,source) then
    if FilterPosition(c,POS_FACEUP_ATTACK) then
      return atk-oppatk
    end
    if FilterPosition(c,POS_DEFENCE) and pierce then
      if FilterPublic(c) then
        return atk-oppdef
      end
      if FilterPrivate(c) then
        return atk-1500
      end
    end
  end
  return 0
end

function BattleDamageFilter(c,source)
  return BattleDamage(c,source)>0
end

CrashList={
83531441,00601193,23649496, -- Dante, Virgil,Plain-Coat
23693634,34230233, -- Colossal Fighter, Grapha
}
-- function to determine, if a card is allowed to 
-- crash into a card with the same ATK
function CrashCheck(c)
  local cards=AIMon()
  local StardustSparkCheck=false
  for i=1,#cards do
    if cards[i].id == 83994433 and NotNegated(cards[i]) and FilterPosition(cards[i],POS_FACEUP)
    and GlobalStardustSparkActivation[cards[i].cardid]~=Duel.GetTurnCount()
    then
      return Targetable(c,TYPE_MONSTER) and Affected(c,TYPE_MONSTER,8)
    end
  end
  if FilterAffected(c,EFFECT_INDESTRUCTABLE_BATTLE)then
    return true
  end
  if not DestroyCountCheck(c,TYPE_MONSTER,true) then
    return true
  end
  if FilterType(c,TYPE_PENDULUM) and ScaleCheck(1)==true then
    return true
  end
  if c.id == 99365553 and HasID(AIGrave(),88264978,true) then
    return true -- Lightpulsar
  end
  if c.id == 99234526 and HasID(AIDeck(),61901281,true) then
    return true -- Wyverbuster
  end
  if c.id == 61901281 and HasID(AIDeck(),99234526,true) then
    return true -- Collapserpent
  end
  if c.id == 05556499 and #OppField()>1 then
    return true -- Machina Fortress
  end
  if c.id == 94283662 and UseTrance(3) then
    return true -- Trance Archfiend
  end
  if CurrentMonOwner(c.cardid) ~= c.owner then
    return true
  end
  if #OppMon()==1 and #AIMon()>1 then
    --return true
  end
  for i=1,#CrashList do
    if CrashList[i]==c.id then
      return true
    end
  end
  return false
end

-- function to determine, if a card can win a battle against any of the targets, and if the 
-- target is expected to hit the graveyard (for effects that trigger on battle destruction)
function CanWinBattle(c,targets,tograve,ignorebonus,filter,opt)
  local sub = SubGroup(targets,filter,opt)
  local atk = c.attack
  sub = SubGroup(sub,BattleTargetCheck,c)
  if tograve == true then
    sub = SubGroup(sub,FilterPendulum)
    if not MacroCheck(1) then
      return false
    end
  end
  if ignorebonus and c.bonus and c.bonus > 0 then
    atk = math.max(0,atk - c.bonus)
  end
  for i=1,#sub do
    local oppatk = sub[i].attack
    local oppdef = sub[i].defense
    if ignorebonus and sub[i].bonus and sub[i].bonus < 0 then
      oppatk = oppatk - sub[i].bonus
    end
    if FilterPosition(sub[i],POS_FACEDOWN_DEFENCE) and not FilterPublic(sub[i]) then
      oppdef = 1500
    end
    if (FilterPosition(sub[i],POS_ATTACK) and (oppatk<atk
    or CrashCheck(c) and oppatk==atk)
    or FilterPosition(sub[i],POS_DEFENCE) and (oppdef<atk)
    and (FilterPosition(sub[i],POS_FACEUP) or FilterPublic(sub[i]))) 
    and BattleTargetCheck(sub[i],c) 
    then
      return true
    end
  end
  return false
end  

-- function to determine, if a card can deal battle damage to a targets
-- for search effects, or just to push damage against battle-immune targets
function CanDealBattleDamage(c,targets,ignorebonus,filter,opt)
  if #targets == 0 then
    return true
  end
  local atk = c.attack
  if ignorebonus and c.bonus and c.bonus > 0 then
    atk = math.max(0,atk - c.bonus)
  end
  local sub = CopyTable(targets)
  sub = SubGroup(sub,filter,opt)
  sub = SubGroup(sub,AttackBlacklistCheck,c)
  for i=1,#sub do
    local oppatk = sub[i].attack
    if ignorebonus and sub[i].bonus and sub[i].bonus > 0 then
      oppatk = math.max(0,oppatk - sub[i].bonus)
    end
    if BattleDamage(sub[i],c,atk,oppatk)>0 then 
      return true
    end
  end
  return false
end
    

-- function to determine, if a card can attack for game 
-- on an opponent's monster, or directly
function CanFinishGame(c,target,atk)
  if c == nil then
    return false
  end
  if atk == nil then 
    if c.GetCode then
      atk = c:GetAttack()
    else
      atk = c.attack
    end
  end  
  if target == nil or FilterAffected(c,EFFECT_DIRECT_ATTACK) then
    return AI.GetPlayerLP(2)<=atk
  end
  local oppatk, oppdef
  if c.GetCode then
    oppatk = target:GetAttack()
    oppdef = target:GetDefence()
  else
    oppatk = target.attack
    opdef = target.defense
  end
  if AttackBlacklistCheck(target,c) and BattleDamageCheck(target,c) then
    if FilterPosition(target,POS_FACEUP_ATTACK) then
      return AI.GetPlayerLP(2)<=atk-oppatk
    end
    if FilterPosition(target,POS_DEFENCE) and FilterAffected(c,EFFECT_PIERCE) then
      if FilterPublic(target) then
        return AI.GetPlayerLP(2)<=atk-oppatk
      else
        return AI.GetPlayerLP(2)<=atk-1500
      end
    end
  end
  return false
end

-- old, inaccurate way to convert card script cards 
-- to AI script. Still used for cards not on the field
function GetCardFromScriptOld(c,cards)
  local id = c:GetCode()
  local id2 = c:GetOriginalCode()
  local pos = c:GetPosition()
  local owner = c:GetOwner()
  local controller = c:GetControler()
  local loc = c:GetLocation()
  local result = nil
  local atk = 0
  local def = 0
  if FilterType(c,TYPE_MONSTER) then
    atk = c:GetAttack()
    def = c:GetDefence()
  end
  if cards == nil then
    cards = All()
  end
  if owner == player_ai then
    owner = 1
  else
    owner = 2
  end
  if controller == player_ai then
    controller = 1
  else
    controller = 2
  end
  for i=1,#cards do
    c=cards[i]
    if c.id == id and c.original_id == id2
    and c.position == pos and c.location == loc
    and c.owner == owner and CurrentOwner(c) == controller
    and c.attack == atk and c.defense == def 
    then
      result = c
    end
  end
  if result then 
    return result
  end
  return nil
end
-- accurate function to convert card script cards 
-- to AI script, only 100% accurate for cards on the field
function GetCardFromScript(c,cards)
  if c==nil then 
    print("Warning: Requesting null card conversion")
    return nil 
  end
  local seq = c:GetSequence()+1
  if c:IsLocation(LOCATION_MZONE) then
    if c:IsControler(player_ai) then
      cards = AI.GetAIMonsterZones()
    else
      cards = AI.GetOppMonsterZones()
    end
  elseif c:IsLocation(LOCATION_SZONE) then
    if c:IsControler(player_ai) then
      cards = AI.GetAISpellTrapZones()
    else
      cards = AI.GetOppSpellTrapZones()
    end
  else
    return GetCardFromScriptOld(c,cards)
  end
  return cards[seq]
end
-- the other way around, get a card script object
-- from an AI script card.
function GetScriptFromCard(c)
  local seq = Sequence(c)
  local type = c.type
  local p
  if CurrentOwner(c) == 1 then
    p = player_ai
  else
    p = 1-player_ai
  end
  local g = GetMatchingGroup(nil,nil,LOCATION_ONFIELD,LOCATION_ONFIELD,0,nil)
  local result = nil
  g:ForEach(function(c) 
    if c:GetSequence()==seq and c:IsType(type) and c:IsControler(p) then
      result = c
    end
  end)
  return result
end
function Surrender()
  AI.Chat("I give up!")
  Duel.Win(1-player_ai,REASON_RULE)
end
Exodia={44519536,08124921,07902349,70903634,33396948}
function SurrenderCheck()
  local cards = UseLists(AIDeck(),AIHand())
  if DeckCheck(DECK_EXODIA) then
    for i=1,#Exodia do
      if not HasID(cards,Exodia[i],true) then
        Surrender()
        return
      end
    end
  end
  return
end

function CopyTable(cards)
  local cards2 = {}
  for k,v in pairs(cards) do
    cards2[k] = v
  end
  return cards2
end

function GetBattlingMons()
  local source = Duel.GetAttacker()
  local target = Duel.GetAttackTarget()
  local oppmon = nil
  local aimon = nil
  if source and source:IsLocation(LOCATION_MZONE) then
    if Duel.GetTurnPlayer()==player_ai then
      aimon = source
    else
      oppmon = source
    end
  end
  if target and target:IsLocation(LOCATION_MZONE) then
    if Duel.GetTurnPlayer()==player_ai then
      oppmon = target
    else
      aimon = target
    end
  end
  return aimon,oppmon
end
function TurnEndCheck()
  return Duel.GetCurrentPhase()==PHASE_MAIN2 or not (GlobalBPAllowed 
  or Duel.GetCurrentPhase()==PHASE_DRAW or Duel.GetCurrentPhase()==PHASE_STANDBY)
end
function BattlePhaseCheck()
  return Duel.GetCurrentPhase()==PHASE_MAIN1 and GlobalBPAllowed
end
-- returns the zone a card occupies
function Sequence(c)
  local cards = {AI.GetAIMonsterZones(),AI.GetOppMonsterZones(),
  AI.GetAISpellTrapZones(),AI.GetOppSpellTrapZones(),}
  for i=1,#cards do
    for j=1,#cards[i] do
      if CardsEqual(c,cards[i][j]) then
        return j-1
      end
    end
  end
end