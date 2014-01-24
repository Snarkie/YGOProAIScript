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


function OnSelectBattleCommand(cards)
  print("OnSelectBattleCommand")
  local execute_attack = 0
  local index = 1

  local function GetWeakestAttackerIndex()
    local LowestIndex = 0
    local LowestAttack = 99999999
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
    local HighestAttack = 0
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
  -----------------------------------------------------
  ApplyATKBoosts(cards)


  ------------------------------------------------
  -- Neo-Spacian Grand Mole, Exploder Dragon,
  -- Metaion, D.D. Warrior Lady, D.D Assailant, D.D Warrior
  -- should always attack first regardless
  -- of what monsters the opponent controls.
  ------------------------------------------------
  for i=1,#cards do
    if cards[i] ~= false then
      if cards[i].id == 80344569 or cards[i].id == 20586572 or -- Mole, Exp
         cards[i].id == 74530899 or cards[i].id == 07572887 or -- Metaion, D.D. Warrior Lady, 
         cards[i].id == 37043180 or cards[i].id == 70074904 then --D.D Assailant, D.D Warrior
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
   if cards[i] ~= false then
     if cards[i].id == 26593852 then 
	  if Get_Card_Count_ATT(OppMon(),"~=",ATTRIBUTE_DARK,POS_FACEUP_ATTACK) > 0 then
         GlobalCurrentATK = 99999999
         GlobalAIIsAttacking = 1
         GlobalAttackerID = cards[i].id
		return 1,i
       end
     end
   end
 end
 
  ---------------------------------------------------------------
  -- Always attack with "Toon" monsters if AI controls "Toon World" 
  -- and opponent does not control any "Toon" monsters.
  ---------------------------------------------------------------
  for i=1,#cards do
   if cards[i] ~= false then
	  if isToonUndestroyable(cards) == 1 and (Archetype_Card_Count(OppMon(),98,POS_FACEUP) == 0 and Archetype_Card_Count(OppMon(),4522082,POS_FACEUP) == 0) then 
        GlobalCurrentATK = 99999999
        GlobalAIIsAttacking = 1
         GlobalAttackerID = cards[i].id
		  return 1,i
        end
     end
  end
   
  ---------------------------------------------------------------
  -- If the opponent controls a monster, attack if the AI's
  -- strongest monster has more ATK than the opponent's monsters,
  -- or if any card that forces monsters to attack is activated.
  ---------------------------------------------------------------
  if Get_Card_Count(AI.GetOppMonsterZones()) > 0 then
    if #cards > 0 then
      local i = GetStrongestAttackerIndex()
      if i > 0 then
        if cards[i].attack > Get_Card_Att_Def_Pos(OppMon()) and cards[i].attack > 0 and 
		   Card_Count_Affected_By(EFFECT_INDESTRUCTABLE_BATTLE,OppMon()) > 0 or Global1PTAArchers == 1 then
          GlobalCurrentATK = cards[i].attack
          GlobalAIIsAttacking = 1
		  return 1,i
        end
      end
    end
  end


  -------------------------------------------------------
  -- If the opponent has a monster with more ATK than any
  -- of the AI's monsters, look for an opponent's monster
  -- closest in ATK to the AI's monster (but weaker), and
  -- attack that.
  -------------------------------------------------------
  if Get_Card_Count(AI.GetOppMonsterZones()) > 0 then
    if #cards > 0 then
      local i = GetStrongestAttackerIndex()
      if i > 0 then
        local OppMon = OppMon()
        local AttackTarget = 0
        local AttackValue = 0
        for x=1,#OppMon do
          if OppMon[x].position == POS_FACEUP_ATTACK and
             OppMon[x].attack >= AttackValue and cards[i]:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE) == 0 then
            if OppMon[x].attack < cards[i].attack then
                AttackTarget = x
                AttackValue = OppMon[x].attack
              end
            end
            if OppMon[x].position == POS_FACEUP_DEFENCE and
               OppMon[x].defense >= AttackValue and cards[i]:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE) == 0 then
              if OppMon[x].defense < cards[i].attack then
                AttackTarget = x
                AttackValue = OppMon[x].defense
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
end

  -----------------------------------------------------------
  -- If the opponent controls a facedown monster, and none of
  -- the opponent's other monsters are a good attack target,
  -- attack the facedown with the AI's strongest monster.
  -----------------------------------------------------------
  if Get_Card_Count(AI.GetOppMonsterZones()) > 0 then
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
  if Get_Card_Count(AI.GetOppMonsterZones()) == 0 then
   local i = GetStrongestAttackerIndex()  
	if #cards > 0 then
      if cards[i].attack > 0 then
	  GlobalCurrentATK = 1
      GlobalAIIsAttacking = 1
      return 1,GetWeakestAttackerIndex()
      end
    end
  end
  
  --print("execute_attack",execute_attack)
  -------------------------------------
  -- If it gets this far, don't attack.
  -------------------------------------
  return 0,0

end
