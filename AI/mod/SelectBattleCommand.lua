--- OnSelectBattleCommand() ---
--
-- Called when AI can battle
-- 
-- Parameters:
-- cards = table of cards that can attack
--
-- Return (2): 
-- execute_attack = should AI attack or not
--		1 = yes
--		0 = no
-- index = index of the card to attack with

-- function to select attack targets. Redirected from SelectCard.lua
function AttackTargetSelection(cards,attacker)
  local id = attacker.id
  local result ={attacker}
  ApplyATKBoosts(result)
  result = {}
  ApplyATKBoosts(cards)
  --print("attack target selection")
  --print("specific attacker")
  local atk = attacker.attack
  if NotNegated(attacker) then
    
    -- High Laundsallyn
    if id == 83519853 and CanWinBattle(attacker,cards,true) then                 
      return BestAttackTarget(cards,attacker,false,FilterPendulum)
    end
    
    -- Shura
    if id == 58820853 and CanWinBattle(attacker,cards,true,true) then                 
      return BestAttackTarget(cards,attacker,true,FilterPendulum)
    end
    
    -- Shura with Kalut
    if id == 58820853 and CanWinBattle(attacker,cards,true) then                 
      return BestAttackTarget(cards,attacker,false,FilterPendulum)
    end
    
    -- FF Gorilla
    if id == 70355994 and CanWinBattle(attacker,cards,true) then                 
      return BestAttackTarget(cards,attacker)
    end
    
    -- FF Bear
    if id == 06353603 and CanDealBattleDamage(attacker,cards) then              
      return BestAttackTarget(cards,attacker,false,BattleDamageFilter,attacker)
    end
    
    -- BLS
    if id == 72989439 and CanWinBattle(attacker,cards,true) then                 
      return BestAttackTarget(cards,attacker)
    end
    
    -- Catastor
    if id == 26593852 and CardsMatchingFilter(cards,CatastorFilter)>0 then       
      return BestTargets(cards,1,TARGET_DESTROY,CatastorFilter,nil,true,attacker)
    end
    
    -- Shaddoll Construct
    if id == 20366274 and CardsMatchingFilter(cards,ConstructFilter)>0 then       
      return BestTargets(cards,1,TARGET_DESTROY,ConstructFilter,nil,true,attacker)
    end
    
    -- Lightpulsar Dragon
    if id == 99365553 and LightpulsarCheck() then                                 
      return BestAttackTarget(cards,attacker,false,HandFilter,atk)
    end
    
    -- Mermail Abysslinde
    if id == 23899727 and LindeCheck() then                                       
      return BestAttackTarget(cards,attacker,false,HandFilter,atk)
    end
    
    -- Fire Hand
    if id == 68535320 and FireHandCheck() then
      return BestAttackTarget(cards,attacker,false,HandFilter,atk)
    end
    
    -- Ice Hand
    if id == 95929069 and IceHandCheck() then
      return BestAttackTarget(cards,attacker,false,HandFilter,atk)
    end
    
    -- Gwen
    if HasGwen(attacker) and CardsMatchingFilter(cards,GwenFilter,atk) then
      return BestTargets(cards,1,TARGET_DESTROY,GwenFilter,atk)
    end
    
    -- Zenmaines
    if id == 78156759 and ZenmainesCheck(attacker,cards) then
      return BestAttackTarget(cards,attacker,false,ZenmainesFilter,attacker)
    end
    
    -- Armed Wing
    if id == 76913983 and ArmedWingCheck(attacker,cards) then
      return BestAttackTarget(cards,attacker,false,ArmedWingFilter,attacker)
    end
 
  end
  --print("generic attacker")
  return BestAttackTarget(cards,attacker)
end
function BestAttackTarget(cards,source,ignorebonus,filter,opt)
  --print("best attack target")
  local atk = source.attack
  if ignorebonus and source.bonus and source.bonus > 0 then
    atk = math.max(0,atk - source.bonus)
  end
  local result = nil
  for i=1,#cards do
    local c = cards[i]
    c.index = i
    if FilterPosition(c,POS_FACEUP_ATTACK) then
      if c.attack<atk or CrashCheck(source) and c.attack==atk then 
        c.prio = c.attack
      else
        c.prio = c.attack * -1
      end
    end
    if FilterPosition(c,POS_DEFENCE) then
      if FilterPublic(c) then
        if c.defense<atk then 
          c.prio = math.max(c.defense - 1,c.attack)
        else
          c.prio = atk - c.defense
        end
      end
    end
    if filter and (opt and not filter(c,opt) or opt==nil and  not filter(c)) then
      c.prio = -99999
    end
    if c.prio and c.prio>0 and not BattleTargetCheck(c,source) then
      c.prio = -4
    end
    if not AttackBlacklistCheck(c,source) then
      c.prio = -99999
    end
    if CanFinishGame(source,c) then
      c.prio=99999
    end
    if FilterPosition(c,POS_DEFENCE) and FilterPrivate(c) then
      if atk>=1500 then
        c.prio = -1
      else
        c.prio = -2
      end
    end
    if c.prio and c.prio>0 and FilterPublic(c) then
      if FilterType(c,TYPE_SYNCHRO+TYPE_RITUAL+TYPE_XYZ+TYPE_FUSION) then
        c.prio = c.prio + 1
      end
      if FilterType(c,TYPE_EFFECT) then
        c.prio = c.prio + 1
      end
      if c.level>4 then
        c.prio = c.prio + 1
      end
    end
    if CurrentOwner(c)==1 then
      c.prio = -1*c.prio
    end
  end  
  table.sort(cards,function(a,b) return a.prio > b.prio end)
  --print("table:")
  --print("attacker: "..source.id..", atk: "..atk)
  for i=1,#cards do
    --print(i..") id: "..cards[i].id.." index: "..cards[i].index.." prio: "..cards[i].prio)
  end
  result={cards[1].index}
  return result
end

function OnSelectBattleCommand(cards,activatable)
  --print("battle command selection")
  -- shortcut function that returns the proper attack index and sets some globals 
  -- needed for attack target selection
  local function Attack(index,direct)
    local i = cards[index].index
    if direct then
      GlobalAIIsAttacking = nil
    else
      GlobalCurrentAttacker = cards[index].cardid
      GlobalAIIsAttacking = true
    end
    return 1,i
  end
  
  local function SortByATK(cards,descending)
    local func = function(a,b) return a.attack > b.attack end
    if descending then func = function(a,b) return a.attack < b.attack end end
    for i=1,#cards do
      cards[i].index2 = cards[i].index
    end
    table.sort(cards,func)
    for i=1,#cards do
      cards[i].index = cards[i].index2
      cards[i].index2 = nil
    end
  end
	
  ApplyATKBoosts(cards)
  for i=1,#cards do
    cards[i].index = i
  end
  
  
  -- check for monsters, that cannot be attacked, or have to be attacked first.
  local targets = OppMon()
  local attackable = {}
  local mustattack = {}
  for i=1,#targets do
    if targets[i]:is_affected_by(EFFECT_CANNOT_BE_BATTLE_TARGET)==0 then
      attackable[#attackable+1]=targets[i]
    end
    if targets[i]:is_affected_by(EFFECT_MUST_BE_ATTACKED)>0 then
      mustattack[#mustattack+1]=targets[i]
    end
  end
  if #mustattack>0 then
    targets = mustattack
  else
    targets = attackable
  end
  ApplyATKBoosts(targets)
  
  -- First, attack with monsters, that get beneficial effects from destroying stuff
  --print("specific attackers")
  -- High Laundsallyn
  if HasIDNotNegated(cards,83519853) and CanWinBattle(cards[CurrentIndex],targets,true) then 
    return Attack(CurrentIndex)
  end
  
  -- Shura
  if HasIDNotNegated(cards,58820853) and CanWinBattle(cards[CurrentIndex],targets,true) then 
    return Attack(CurrentIndex)
  end
  
  -- BLS
  if HasIDNotNegated(cards,72989439) and CanWinBattle(cards[CurrentIndex],targets) then 
    return Attack(CurrentIndex)
  end
  
  -- Fire Fist Gorilla
  if HasIDNotNegated(cards,70355994) and CanWinBattle(cards[CurrentIndex],targets,true) then
    return Attack(CurrentIndex)
  end

  -- Fire Fist Bear
  if HasIDNotNegated(cards,06353603) and CanDealBattleDamage(cards[CurrentIndex],targets) then
    return Attack(CurrentIndex)
  end
  
  -- Lightpulsar Dragon
  if HasID(cards,99365553) and LightpulsarCheck() then 
    return Attack(CurrentIndex)
  end
  
  -- Fire Hand
  if HasID(cards,68535320) and FireHandCheck() then 
    return Attack(CurrentIndex)
  end
  
  -- Ice Hand
  if HasID(cards,95929069) and IceHandCheck() then 
    return Attack(CurrentIndex)
  end
  
  -- Shaddoll Construct
  if HasID(cards,20366274) and CardsMatchingFilter(OppMon(),ConstructFilter)>0 then 
    return Attack(CurrentIndex)
  end
  
  -- Catastor
  if HasID(cards,26593852) and CardsMatchingFilter(OppMon(),CatastorFilter)>0 then 
    return Attack(CurrentIndex)
  end
  
  -- Mermail Abysslinde
  if HasID(cards,23899727) and LindeCheck() then 
    return Attack(CurrentIndex)
  end
  
  -- Gwen
  for i=1,#cards do
    if HasGwen(cards[i]) and CardsMatchingFilter(OppMon(),GwenFilter,atk)>0 then
      return Attack(i)
    end
  end
  
  -- Bujin Susanowo
  if HasID(cards,75840616) and CanWinBattle(cards[CurrentIndex],targets,nil,true) then 
    return Attack(CurrentIndex)
  end
  
  if HasID(cards,75840616) and CanWinBattle(cards[CurrentIndex],targets) then 
    return Attack(CurrentIndex)
  end
  
  -- Zenmaines
  if HasID(cards,78156759) and ZenmainesCheck(cards[CurrentIndex],targets) then 
    return Attack(CurrentIndex)
  end
  
  -- Armed Wing
  if HasID(cards,76913983,ArmedWingCheck,targets) then 
    return Attack(CurrentIndex)
  end
  -- generic attacks
  --print("generic attackers")
  --print("for game")
  -- can attack for game on a certain target
  SortByATK(cards)
  if #targets>0 and #cards>0 then
    for i=1,#targets do
      if CanFinishGame(cards[1],targets[i]) then
        return Attack(1)
      end
    end
  end
  --print("without boost")
  -- can destroy a monster without additional attack boosting cards
  SortByATK(cards,true)
  if #targets>0 and #cards>0 then
    for i=1,#cards do
      if CanWinBattle(cards[i],targets,nil,true) then
        return Attack(i)
      end
    end
  end
  --print("with boost")
  -- can destroy a monster with additional boost
  SortByATK(cards,true)
  if #targets>0 and #cards>0 then
    for i=1,#cards do
      if CanWinBattle(cards[i],targets) then
        return Attack(i)
      end
    end
  end
  --print("face-down")
  -- can probably destroy an unknown face-down monster
  SortByATK(cards,true)
  if #targets>0 and #cards>0  then
    for i=1,#cards do
      for j=1,#targets do
        if FilterPosition(targets[j],POS_FACEDOWN_DEFENCE) and (cards[i].attack > 1500 
        or FilterPublic(targets[j]) and cards[i].attack > targets[j].defense)
        then
          return Attack(1)
        end
      end
    end
  end
  --print("battle damage")
  -- can deal battle damage (against battle-immune targets etc)
  SortByATK(cards,true)
  if #targets>0 and #cards>0 then
    for i=1,#cards do
      if CanDealBattleDamage(cards[i],targets,true) then
        return Attack(i)
      end
    end
  end
  --print("direct")
  -- direct attack
  SortByATK(cards,true)
  if #OppMon()==0 and #cards>0 then
    return Attack(1,true)
  end
  --print("forced")
  -- forced to attack
  SortByATK(cards)
  for i=1,#cards do
    if cards[i] and cards[i]:is_affected_by(EFFECT_MUST_ATTACK)>0 then
      return Attack(i)
    end
  end
  --print("not attack")
  
---
-- activate cards 
---
  
  if HasID(activatable,60202749) and UseSphereBP() then
    return 2,CurrentIndex
  end
  if HasID(activatable,97077563) and UseCotHBP() then
    return 2,CurrentIndex
  end
  if HasID(activatable,03580032) and UseMerlinBP() then
    return 2,CurrentIndex
  end

  -------------------------------------
  -- If it gets this far, don't attack.
  -------------------------------------
  return 0,0

end


  
