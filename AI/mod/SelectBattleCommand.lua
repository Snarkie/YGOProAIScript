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


function OnSelectBattleCommand(cards,activatable)
  local execute_attack = 0
  local index = 1
  local function GetWeakestAttackerIndex()
    local LowestIndex = 0
    local LowestAttack = 999999999
    for i=1,#cards do
      if cards[i].attack <= LowestAttack then
        LowestIndex = i
        LowestAttack = cards[i].attack
      end
    end
    return LowestIndex
  end
	
  local function GetStrongestAttackerIndex()
    local HighestIndex = 0
    local HighestAttack = -1
    for i=1,#cards do
      if cards[i].attack >= HighestAttack then
        HighestIndex = i
        HighestAttack = cards[i].attack
      end
    end
    return HighestIndex
  end
	
  -----------------------------------------------------
  -- Temporarily increase the ATK of monster cards that
  -- either have built-in ATK boosts while attacking or
  -- are affected that way by another card.
  -- Filter for cards that cannot be attack targets
  -----------------------------------------------------
  ApplyATKBoosts(cards)
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
  ------------------------------------------------
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
  -- Always attack with "Ally of Justice Catastor" if
  -- opponent controls any non dark type monster.
  ---------------------------------------------------------------
  for i=1,#cards do
    if cards[i].id == 26593852 and NotNegated(cards[i]) and CardsMatchingFilter(targets,CatastorFilter)>0 then 
      GlobalCurrentATK = cards[i].attack
      GlobalAIIsAttacking = 1
      GlobalAttackerID = cards[i].id
      return 1,i
    end
  end

  ---------------------------------------------------------------
  -- Always attack with "El-Shaddoll Nephilim" if
  -- opponent controls any special summoned monster.
  ---------------------------------------------------------------
  for i=1,#cards do
    if cards[i].id == 20366274 and NotNegated(cards[i]) and CardsMatchingFilter(targets,NephilimFilter)>0 then 
      GlobalCurrentATK = cards[i].attack
      GlobalAIIsAttacking = 1
      GlobalAttackerID = cards[i].id
      return 1,i
    end
  end
  
  ---------------------------------------------------------------
  -- Always attack with the Hands if they can get their effects
  ---------------------------------------------------------------
  for i=1,#cards do
    if cards[i].id == 68535320 and FireHandCheck()
    or cards[i].id == 95929069 and IceHandCheck()
    then 
      GlobalCurrentATK = cards[i].attack
      GlobalAIIsAttacking = 1
      GlobalAttackerID = cards[i].id
      return 1,i
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
  
  -------------------------------------------------------
  -- If the opponent has a monster with more ATK than any
  -- of the AI's monsters, look for an opponent's monster
  -- closest in ATK to the AI's monster (but weaker), and
  -- attack that.
  -------------------------------------------------------
  if #OppMon() > 0 and #cards > 0 then
    local i = GetStrongestAttackerIndex()
    if i > 0 then
      local OppMon = targets
      local AttackTarget = 0
      local AttackValue = -1
      for x=1,#OppMon do
        if OppMon[x].position == POS_FACEUP_ATTACK then
          if OppMon[x].attack >= AttackValue 
          and (OppMon[x].attack < cards[i].attack and OppMon[x]:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE) == 0 
          or OppMon[x].attack-OppMon[x].bonus < cards[i].attack-cards[i].bonus and OppMon[x]:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE) > 0 )
          then
            AttackTarget = x
            AttackValue = OppMon[x].attack
          end
        elseif OppMon[x].position == POS_FACEUP_DEFENCE then
          if OppMon[x].defense >= AttackValue 
          and OppMon[x].defense < cards[i].attack and OppMon[x]:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE) == 0 
          or OppMon[x].defense< cards[i].attack-cards[i].bonus and OppMon[x]:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE) > 0 
          then
            AttackTarget = x
            AttackValue = OppMon[x].attack
          end
        end
       end
      if AttackTarget > 0 then
        GlobalCurrentATK = cards[i].attack
        GlobalAIIsAttacking = 1
        return 1,i
       end
    end
  end

  -----------------------------------------------------------
  -- If the opponent controls a facedown monster, and none of
  -- the opponent's other monsters are a good attack target,
  -- attack the facedown with the AI's strongest monster.
  -----------------------------------------------------------
  if #OppMon() > 0 then
   local i = GetStrongestAttackerIndex() 
	if #cards > 0 then
      if cards[i].attack > 0 then
	  local OppMon = AI.GetOppMonsterZones()
      for i=1,#OppMon do
        if OppMon[i] ~= false then
          if OppMon[i].position == POS_FACEDOWN_DEFENCE then
            GlobalCurrentATK = 1
            GlobalAIIsAttacking = 2
			return 1,GetStrongestAttackerIndex()
          end
        end
      end
    end
  end
end

  --------------------------------------------------------
  -- If the opponent controls no monsters, attack with the
  -- weakest monster. Inflict as much damage as possible
  -- before a potential Gorz drop.
  --------------------------------------------------------
  if Get_Card_Count(AI.GetOppMonsterZones()) == 0 and #cards>0 then
   local i = GetWeakestAttackerIndex()
	 GlobalCurrentATK = cards[i].attack
   return 1,i
  end
  
  --------------------------------------------------------
  -- If a monster is forced to attack for some reason, 
  -- attack with the strongest monster fist to potentially
  -- clear the way for weaker ones.
  --------------------------------------------------------
  if #cards>0 then
    local i=GetStrongestAttackerIndex()
    if cards[i] and cards[i]:is_affected_by(EFFECT_MUST_ATTACK)>0 then
      return 1,i
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

  -------------------------------------
  -- If it gets this far, don't attack.
  -------------------------------------
  
  return 0,0

end
