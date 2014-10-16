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
  e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
    if Duel.GetTurnPlayer()==player_ai then 
      --AI.Chat("Oh yeah, cheating feels good.")
      Duel.Draw(player_ai,1,REASON_RULE) 
    end 
  end)
  Duel.RegisterEffect(e1,0)
  local e2=Effect.GlobalEffect()
  e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
  e2:SetCode(EVENT_PHASE+PHASE_DRAW)
  e2:SetCountLimit(1)
  e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
    if Duel.GetTurnPlayer()==player_ai then 
      Duel.Recover(player_ai,1000,REASON_RULE) 
    end 
  end)
  Duel.RegisterEffect(e2,0)
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
        and cards[i]:is_affected_by(EFFECT_DISABLE_EFFECT)==0 
        and cards[i]:is_affected_by(EFFECT_DISABLE)==0
        then
          if not skipglobal then CurrentIndex = i end
          result = true  
        end
        if bit32.band(cards[i].type,TYPE_SPELL+TYPE_TRAP)>0
        and bit32.band(cards[i].status,STATUS_SET_TURN)==0        
        and cards[i]:is_affected_by(EFFECT_CANNOT_TRIGGER)==0
        and cards[i]:is_affected_by(EFFECT_DISABLE)==0
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
function OppGetStrongestAttack()
  local cards=OppMon()
  local result=0
  ApplyATKBoosts(cards)
  for i=1,#cards do
    if cards[i] and cards[i].attack>result then
      result=cards[i].attack-cards[i].bonus
    end
  end
  return result
end
function OppGetStrongestAttDef(filter,loop)
  local cards=OppMon()
  local result=0
  if not loop then ApplyATKBoosts(cards) end
  for i=1,#cards do
    if cards[i] and (filter==nil or filter(cards[i])) then
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
  result = 0
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
  local cards=AIMon()
  for i=1,#cards do
    if cards[i].level==level and bit32.band(cards[i].position,POS_FACEUP)>0 
    and (filter == nil or filter(cards[i]) and opt == nil or filter(cards[i],opt))
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
  result = {}
  if cards then
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
function OverExtendCheck()
  local cards = AIMon()
  local hand = AIHand()
  return OppHasStrongestMonster() or #cards < 2 or #hand > 4 or AI.GetPlayerLP(2)<=800 and HasID(AIExtra(),12014404,true) -- Cowboy
end
-- checks, if a card the AI controls is about to be removed in the current chain
function RemovalCheck(id)
  local c={CATEGORY_DESTROY,CATEGORY_REMOVE,CATEGORY_TOGRAVE,CATEGORY_TOHAND,CATEGORY_TODECK}
  for i=1,#c do
    for j=1,Duel.GetCurrentChain() do
      local ex,cg = Duel.GetOperationInfo(j,c[i])
      if ex then
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
-- checks, if a card the AI controls is about to be negated in the current chain
function NegateCheck()
  local ex,cg = Duel.GetOperationInfo(Duel.GetCurrentChain(),CATEGORY_DISABLE)
  if ex then return cg end
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
    g=Duel.GetMatchingGroup(ExpectedDamageFilter2,p,LOCATION_MZONE,0,nil,p) 
  else
    g=Duel.GetMatchingGroup(ExpectedDamageFilter,p,LOCATION_MZONE,0,nil,p) 
  end
  local c=nil
  if g then c=g:GetFirst() end
  while c do
    result=result+c:GetAttack()
    c=g:GetNext()
  end
  return result
end

TARGET_DESTROY  = 1
TARGET_TOGRAVE  = 2
TARGET_BANISH   = 3
TARGET_TOHAND   = 4
TARGET_TODECK   = 5
TARGET_FACEDOWN = 6
-- returns a list of the best targets given the parameters
function BestTargets(cards,count,target,filter,immuneCheck)
  local result = {}
  local AIMon=AIMon()
  local DestroyCheck = false
  if target == true then 
    target=TARGET_DESTROY 
  end
  if count == nil then count = 1 end
  ApplyATKBoosts(AIMon)
  local AIAtt=Get_Card_Att_Def(AIMon,"attack",">",nil,"attack")
  for i=1,#cards do
    cards[i].index = i
    cards[i].prio = 0
    if bit32.band(cards[i].type,TYPE_MONSTER)>0 then
      if bit32.band(cards[i].position, POS_FACEUP)>0
      or bit32.band(cards[i].status,STATUS_IS_PUBLIC)>0
      then
        if cards[i]:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)>0 and target==TARGET_DESTROY 
        or cards[i]:is_affected_by(EFFECT_IMMUNE)>0
        then
          cards[i].prio = 1
        else
          cards[i].prio = math.max(cards[i].attack+1,cards[i].defense)+5
          if cards[i].owner==2 and cards[i]:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE)==0 then
            cards[i].prio = math.max(5,cards[i].prio-AIAtt*.75)
          end
        end
      else
        cards[i].prio = 2
      end
    else
      if cards[i]:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)>0 and target==TARGET_DESTROY
      or cards[i]:is_affected_by(EFFECT_IMMUNE)>0 
      or bit32.band(cards[i].status,STATUS_LEAVE_CONFIRMED)>0
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
    if bit32.band(cards[i].type,TYPE_FUSION+TYPE_RITUAL+TYPE_XYZ+TYPE_SYNCHRO)>0 then
      cards[i].prio = cards[i].prio+2
    end
    if cards[i].level>4 then
      cards[i].prio = cards[i].prio+1
    end
    if bit32.band(cards[i].position, POS_FACEUP_ATTACK)>0 then
      cards[i].prio = cards[i].prio+1
    end
    if (bit32.band(cards[i].position, POS_FACEUP)>0 or bit32.band(cards[i].status,STATUS_IS_PUBLIC)>0)
    and (target == TARGET_TOHAND and ToHandBlacklist(cards[i].id)   
    or target == TARGET_DESTROY and DestroyBlacklist(cards[i])
    or target==TARGET_FACEDOWN and bit32.band(cards[i].type,TYPE_FLIP)>0)
    then
      cards[i].prio = -1
    end
    if filter and not filter(cards[i]) then
      cards[i].prio = -1
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
  return OPT[id]~=Duel.GetTurnCount()
end
function OPTSet(id)
  OPT[id]=Duel.GetTurnCount()
end
-- used to keep track, if the OPT was reset willingly
-- for example if the card was bounced back to the hand
function OPTReset(id)
  OPT[id]=0
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
  and (target:IsPosition(POS_ATTACK) and source:GetAttack()>=target:GetAttack()
  or target:IsPosition(POS_DEFENCE) and source:GetAttack()>target:GetDefence())
  and not target:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)
end
function NotNegated(card)
  return card:is_affected_by(EFFECT_DISABLE)==0 and card:is_affected_by(EFFECT_DISABLE_EFFECT)==0
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
  return bit32.band(c.type,TYPE_MONSTER)>0 and bit32.band(c.attribute,att)>0
end
function FilterRace(c,race)
  return bit32.band(c.type,TYPE_MONSTER)>0 and bit32.band(c.race,race)>0
end
function FilterLevel(c,level)
  return bit32.band(c.type,TYPE_MONSTER)>0 and c.level==level
end
function FilterType(c,type)
  return bit32.band(c.type,type)>0
end
function FilterAttack(c,attack)
  return bit32.band(c.type,TYPE_MONSTER)>0 and c.attack>=attack
end
function FilterID(c,id)
  return c.id==id
end
function FilterPosition(c,pos)
  return bit32.band(c.position,pos)>0
end
function FilterLocation(c,loc)
  return bit32.band(c.location,loc)>0
end
function FilterStatus(c,status)
  return bit32.band(c.status,status)>0
end
function HasMaterials(c)
  return c.xyz_material_count>0
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
    if card and GlobalTargetList[i]==card.cardid then
      return false
    end
  end
  return true
end
function TargetSet(card)
  GlobalTargetList[#GlobalTargetList+1]=card.cardid
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