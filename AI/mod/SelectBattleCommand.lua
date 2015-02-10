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
function AttackTargetSelection(cards,attacker,atk)
  local id = attacker.id
  local result ={}
  ApplyATKBoosts(cards)
  attacker.attack=atk
  print("specific attack target selection")
  if NotNegated(attacker) then
    print("attacker not negated")
    
    -- High Laundsallyn
    if id == 83519853 and CanWinBattle(attacker,cards,true) then                 
      print("attacking with High Laundsallyn, selecting best valid target that will still grant a search")
      return BestAttackTarget(cards,attacker,FilterPendulum)
    end
    
    -- FF Gorilla
    if id == 70355994 and CanWinBattle(attacker,cards,true) then                 
      print("attacking with FF Gorilla, selecting best valid target to search")
      return BestAttackTarget(cards,attacker)
    end
    
    -- FF Bear
    if id == 06353603 and CanDealBattleDamage(attacker,cards) then              
      print("attacking with FF Bear, selecting best valid target to search")
      return BestAttackTarget(cards,attacker,BattleDamageFilter,attacker)
    end
    
    -- BLS
    if id == 72989439 and CanWinBattle(attacker,cards,true) then                 
      print("attacking with BLS, selecting best valid target that will grant a double attack")
      return BestAttackTarget(cards,attacker)
    end
    
    -- Catastor
    if id == 26593852 and CardsMatchingFilter(cards,CatastorFilter)>0 then       
      print("attacking with Catastor, selecting best valid target")
      return BestTargets(cards,1,TARGET_DESTROY,CatastorFilter,nil,true,attacker)
    end
    
    -- Shaddoll Construct
    if id == 20366274 and CardsMatchingFilter(cards,NephilimFilter)>0 then       
      print("attacking with Shaddoll Construct, selecting best valid target")
      return BestTargets(cards,1,TARGET_DESTROY,NephilimFilter,nil,true,attacker)
    end
    
    -- Lightpulsar Dragon
    if id == 99365553 and LightpulsarCheck() then                                 
      print("attacking with Lightpulsar Dragon, REDMD in grave, selecting best target to crash")
      return BestAttackTarget(cards,attacker,HandFilter,atk)
    end
    
    -- Mermail Abysslinde
    if id == 23899727 and LindeCheck() then                                       
      print("attacking with Linde, selecting best target to crash")
      return BestAttackTarget(cards,attacker,HandFilter,atk)
    end
    
    -- Fire Hand
    if id == 68535320 and FireHandCheck() then
      print("attacking with Fire Hand, selecting best valid target")
      return BestAttackTarget(cards,attacker,HandFilter,atk)
    end
    
    -- Ice Hand
    if id == 95929069 and IceHandCheck() then
      print("attacking with Ice Hand, selecting best valid target")
      return BestAttackTarget(cards,attacker,HandFilter,atk)
    end
    
  end
  print("continuing to generic attack target selection")
  return BestAttackTarget(cards,attacker)
end
function BestAttackTarget(cards,source,filter,opt)
  local atk = source.attack
  local result = nil
  print("attacker: "..source.id)
  print("attack: "..source.attack)
  print("assigning priorities")
  for i=1,#cards do
    local c = cards[i]
    c.index = i
    print("priority for: "..c.id)
    if FilterPosition(c,POS_FACEUP_ATTACK) then
      print("attack position")
      if c.attack<atk or CrashCheck(source) and c.attack==atk then 
        print("can win the battle, priority to "..c.attack)
        c.prio = c.attack
      else
        print("cannot win the battle, priority to "..c.attack*-1)
        c.prio = c.attack * -1
      end
    end
    if FilterPosition(c,POS_DEFENCE) then
      print("defense position")
      if FilterPublic(c) then
        print("public")
        if c.defense<atk then 
          print("can win the battle, priority to "..math.max(c.defense - 1,c.attack))
          c.prio = math.max(c.defense - 1,c.attack)
        else
          print("cannot win the battle, priority to "..atk - c.defense)
          c.prio = atk - c.defense
        end
      end
    end
    if filter and (opt and not filter(c,opt) or opt==nil and  not filter(c)) then
      print("not matching filter, priority to -99999")
      c.prio = -99999
    end
    if not BattleTargetCheck(c,source) then
      print("indestructable by battle etc, priority to -4")
      c.prio = -4
    end
    if not AttackBlacklistCheck(c,source) then
      print("on the attack blacklist, priority to -99999")
      c.prio = -99999
    end
    if CanFinishGame(source,c) then
      print("can probably finish the game with attack on this target, priority to 99999")
      c.prio=99999
    end
    if FilterPosition(c,POS_DEFENCE) and FilterPrivate(c) then
      print("unknown facedown monster")
      if atk>=1500 then
        print("strong attacker, priority to -1")
        c.prio = -1
      else
        print("weak attacker, priority to -2")
        c.prio = -2
      end
    end
    if c.prio>0 and FilterPublic(c) then
      print("target is known and valid for attacking, adjusting priority based on type")
      if FilterType(c,TYPE_SYNCHRO+TYPE_RITUAL+TYPE_XYZ+TYPE_FUSION) then
        print("synch/ritual/fusion/xyz: +1")
        c.prio = c.prio + 1
      end
      if FilterType(c,TYPE_EFFECT) then
        print("effect: +1")
        c.prio = c.prio + 1
      end
      if c.level>4 then
        print("high level: +1")
        c.prio = c.prio + 1
      end
    end
  end  
  table.sort(cards,function(a,b) return a.prio > b.prio end)
  print("selecting target: "..cards[1].id)
  print("priority: "..cards[1].prio)
  result={cards[1].index}
  return result
end

function OnSelectBattleCommand(cards,activatable)
 
  -- shortcut function that returns the proper attack index and sets some globals 
  -- needed for attack target selection
  local function Attack(index,direct)
    local i = cards[index].index
    if direct then
      GlobalCurrentAttacker = nil
      GlobalCurrentATK = nil
      GlobalAIIsAttacking = nil
    else
      GlobalCurrentAttacker = cards[i].cardid
      GlobalCurrentATK = cards[i].attack
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
  
  print("Battle Command Selection")
  -- First, attack with monsters, that get beneficial effects from destroying stuff
  
  -- High Laundsallyn
  if HasIDNotNegated(cards,83519853) and CanWinBattle(cards[CurrentIndex],targets,true) then 
    print("can probably get a search with High Laundsallyn, attack with him")
    return Attack(CurrentIndex)
  end
  
  -- BLS
  if HasIDNotNegated(cards,72989439) and CanWinBattle(cards[CurrentIndex],targets) then 
    print("can probably get a double attack with BLS attack with him")
    return Attack(CurrentIndex)
  end
  
  -- Fire Fist Gorilla
  if HasIDNotNegated(cards,70355994) and CanWinBattle(cards[CurrentIndex],targets,true) then
    print("can probably get a search with FF Gorilla, attack with him")
    return Attack(CurrentIndex)
  end

  -- Fire Fist Bear
  if HasIDNotNegated(cards,06353603) and CanDealBattleDamage(cards[CurrentIndex],targets) then
    print("can probably get a search with FF Bear, attack with him")
    return Attack(CurrentIndex)
  end
  
  -- Lightpulsar Dragon
  if HasID(cards,99365553) and LightpulsarCheck() then 
    print("can probably get the effect of Lightpulsar Dragon, attack")
    return Attack(CurrentIndex)
  end
  
  -- Fire Hand
  if HasID(cards,68535320) and FireHandCheck() then 
    print("can probably get the effect of Fire Hand, attack")
    return Attack(CurrentIndex)
  end
  
  -- Ice Hand
  if HasID(cards,95929069) and IceHandCheck() then 
    print("can probably get the effect of Ice Hand, attack")
    return Attack(CurrentIndex)
  end
  
  -- Mermail Abysslinde
  if HasID(cards,23899727) and LindeCheck() then 
    print("can probably get the effect of Mermail Abysslinde, attack")
    return Attack(CurrentIndex)
  end
  
  print("no specific attackers, proceed to generic")
  SortByATK(cards)
  if #targets>0 and #cards>0 then
    print("checking for game finisher")
    for i=1,#targets do
      if CanFinishGame(cards[1],targets[i]) then
        print("can finish game, attack")
        return Attack(1)
      end
    end
  end
  
  SortByATK(cards,true)
  if #targets>0 and #cards>0 then
    print("checking for generic attack possibilities")
    for i=1,#cards do
      if CanWinBattle(cards[i],targets) then
        print("can destroy a monster, attack")
        return Attack(i)
      end
    end
  end

  SortByATK(cards)
  if #targets>0 and #cards>0  then
    print("checking for facedown cards")
    for i=1,#targets do
      if FilterPosition(targets[i],POS_FACEDOWN_DEFENCE) and (cards[i].attack > 1500 
      or FilterPublic(targets[i]) and cards[i].attack > targets[i].defense)
      then
        print("has a strong enough attacker, attack")
        return Attack(1)
      end
    end
  end

  SortByATK(cards,true)
  if #OppMon()==0 and #cards>0 then
    print("attacking directly")
    return Attack(1,true)
  end
  
  SortByATK(cards)
  for i=1,#cards do
    if cards[i] and cards[i]:is_affected_by(EFFECT_MUST_ATTACK)>0 then
      print("forced to attack")
      return Attack(i,true)
    end
  end
  
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
  print("don't attack")
  return 0,0

end

 --[[----------------------------------------------
  -- Neo-Spacian Grand Mole, Exploder Dragon,
  -- Metaion, D.D. Warrior Lady, D.D Assailant, D.D Warrior
  -- should always attack first regardless
  -- of what monsters the opponent controls.
  ------------------------------------------------
  for i=1,#cards do
    if cards[i] ~= false then
      if (cards[i].id == 80344569 or cards[i].id == 20586572 or -- Mole, Exp
         cards[i].id == 74530899 or cards[i].id == 07572887 or  -- Metaion, D.D. Warrior Lady, 
         cards[i].id == 37043180 or cards[i].id == 70074904)    --D.D Assailant, D.D Warrior
         and NotNegated(cards[i]) then 
        GlobalCurrentATK = 99999999
        GlobalAIIsAttacking = 1
        return 1,i
      end
    end
  end

  
  ---------------------------------------------------------------
  -- Always attack with "Toon" monsters if AI controls "Toon World" 
  -- and opponent does not control any "Toon" monsters.
  ---------------------------------------------------------------
  for i=1,#cards do
   if cards[i] ~= false then
	  if isToonUndestroyable(cards) == 1 and (Archetype_Card_Count(targets,98,POS_FACEUP) == 0 and Archetype_Card_Count(targets,4522082,POS_FACEUP) == 0) then 
        GlobalCurrentATK = 99999999
        GlobalAIIsAttacking = 1
         GlobalAttackerID = cards[i].id
		  return 1,i
        end
     end
  end
]]
  
