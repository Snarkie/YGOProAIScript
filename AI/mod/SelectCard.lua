--- OnSelectCard ---
--
-- Called when AI has to select a card. Like effect target or attack target
-- Example card(s): Caius the Shadow Monarch, Chaos Sorcerer, Elemental HERO The Shining
-- 
-- Parameters:
-- cards = table of cards to select
-- minTargets = how many you must select min
-- maxTargets = how many you can select max
-- triggeringID = id of the card that is responsible for the card selection
--
-- Return: 
-- result = table containing target indices
function OnSelectCard(cards, minTargets, maxTargets, triggeringID)
  local result = {}
  
-------------------------------------------------
-- **********************************************
-- General purpose functions, for selecting 
-- targets when XYZ summoning, attacking etc.
-- **********************************************
-------------------------------------------------

local result = FireFistCard(cards, minTargets, maxTargets, triggeringID)
if result ~= nil then
  return result
end
result = HeraldicOnSelectCard(cards, minTargets, maxTargets, triggeringID)
if result ~= nil then
  return result
end
result = {}

  --------------------------------------------
  -- Attack any non dark type monster regardless 
  -- of it's attack.
  --------------------------------------------   
  if GlobalAIIsAttacking and GlobalAttackerID == 26593852 then
   if AI.GetCurrentPhase() == PHASE_BATTLE then
     GlobalAIIsAttacking = false
	 for i=1,#cards do
       if cards[i] ~= false then
         if cards[i].position == POS_FACEUP_ATTACK and 
		   IsUndestroyableByBattle(cards[i].id) == 0 and cards[i].attribute ~= ATTRIBUTE_DARK then
			 GlobalAttackerID = 0
			 result[1]=i
             return result
             end
          end
       end
    end
 end
  
  ------------------------------------------------------
  -- This is assuming the AI is attacking.
  --
  -- Obtain the index of the opponent's monster with the
  -- highest ATK/DEF that is below that of the currently
  -- attacking monster, and return that.
  ------------------------------------------------------
  if GlobalAIIsAttacking and GlobalAttackerID ~= 26593852 then
	if AI.GetCurrentPhase() == PHASE_BATTLE then	
    ApplyATKBoosts(cards)
		GlobalAIIsAttacking = false
		local FaceUpDestructibleGroup = {}
		local FaceUpAttackPositionIndestructibleGroup = {}
		local FaceDownDefensePositionGroup = {}
		local c = 1
		local m = 1
		local n = 1
		-- divide selectable attack targets into 3 groups
		for i = 1, #cards do
			-- 1st group
			if bit32.band(cards[i].position,POS_FACEUP) > 0 and cards[i]:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE) == 0 
      and cards[i].attack < GlobalCurrentATK then
				FaceUpDestructibleGroup[c] = cards[i]
				FaceUpDestructibleGroup[c].index = i
				FaceUpDestructibleGroup[c].attack_or_defense = bit32.band(cards[i].position,POS_ATTACK) > 0 and cards[i].attack or cards[i].defense
				-- give priority to each selectable target based on its type(s):
				-- synchro effect -> xyz effect -> ritual effect -> fusion effect -> (just) effect -> others
				if bit32.band(cards[i].type,TYPE_EFFECT) > 0 then
					if bit32.band(cards[i].type,TYPE_SYNCHRO) > 0 then
						FaceUpDestructibleGroup[c].priority = 1
					elseif bit32.band(cards[i].type,TYPE_XYZ) > 0 then
						FaceUpDestructibleGroup[c].priority = 2
					elseif bit32.band(cards[i].type,TYPE_RITUAL) > 0 then
						FaceUpDestructibleGroup[c].priority = 3
					elseif bit32.band(cards[i].type,TYPE_FUSION) > 0 then
						FaceUpDestructibleGroup[c].priority = 4
					else
						FaceUpDestructibleGroup[c].priority = 5
					end
				else
					FaceUpDestructibleGroup[c].priority = 6
				end
				c = c + 1
			-- 2nd group
			elseif bit32.band(cards[i].position,POS_FACEUP_ATTACK) > 0 and cards[i]:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE) > 0 then
				FaceUpAttackPositionIndestructibleGroup[m] = cards[i]
				FaceUpAttackPositionIndestructibleGroup[m].index = i
				m = m + 1
			-- 3rd group
			elseif bit32.band(cards[i].position,POS_FACEDOWN_DEFENCE) > 0 then
				FaceDownDefensePositionGroup[n] = cards[i]
				FaceDownDefensePositionGroup[n].index = i
				n = n + 1
			end
		end
		-- by default, select an attack target from the 1st group
		if #FaceUpDestructibleGroup > 0 then
			local function compare_1st_group(x,y)
				-- compare selectable attack targets by their ATK then priorities
				-- if both of them have ATK higher than or equal to that of AI's attacker
				if x.attack >= GlobalCurrentATK and y.attack >= GlobalCurrentATK then
					if x.attack ~= y.attack then
						return x.attack > y.attack
					else
						return x.priority < y.priority
					end
				-- selectable attack target with ATK higher than or equal to that of AI's attacker
				-- should always come before one with ATK lower
				elseif x.attack >= GlobalCurrentATK and y.attack < GlobalCurrentATK then
					return x.attack > y.attack
				-- compare selectable attack targets by their ATK or DEF depending on their positions then priorities
				-- if both of them have ATK lower than that of AI's attacker
				elseif x.attack < GlobalCurrentATK and y.attack < GlobalCurrentATK then
					if x.attack_or_defense ~= y.attack_or_defense then
						return x.attack_or_defense > y.attack_or_defense
					else
						return x.priority < y.priority
					end
				end
			end
			table.sort(FaceUpDestructibleGroup,compare_1st_group)
			for i = 1,#FaceUpDestructibleGroup do
				if FaceUpDestructibleGroup[i].attack_or_defense < GlobalCurrentATK then
					result[1] = FaceUpDestructibleGroup[i].index
					return result
				end
			end
		-- otherwise, select an attack target from the 2nd group
		elseif #FaceUpAttackPositionIndestructibleGroup > 0 then
			local function compare_2nd_group(x,y)
				return x.attack < y.attack
			end
			table.sort(FaceUpAttackPositionIndestructibleGroup,compare_2nd_group)
			if FaceUpAttackPositionIndestructibleGroup[1].attack < GlobalCurrentATK then
				result[1] = FaceUpAttackPositionIndestructibleGroup[1].index
				return result
			end
		-- otherwise, select an attack target from the 3rd group
		elseif #FaceDownDefensePositionGroup > 0 then
			result[1] = FaceDownDefensePositionGroup[1].index
			return result
		end
	end
 end 
  GlobalAIIsAttacking = false  
  
  --------------------------------------------
  -- Select minimum number of valid XYZ material monsters,   
  -- with lowest attack as tributes.
  --------------------------------------------   
 if GlobalSSCardID ~= nil and GlobalSSCardID ~= 91949988 
  and GlobalSSCardType ~= nil and GlobalSSCardType > 0 
  or (PtolemySSMode == 1 and GlobalSSCardID == 38495396 and GlobalSSCardType == nil) then
	local function compare(a,b)
      return a.attack < b.attack
    end
    if GlobalSSCardID == 44505297 then    --Inzektor Exa-Beetle
      GlobalActivatedCardID = GlobalSSCardID
    end
    GlobalSSCardID = nil
    GlobalSSCardType = nil
	PtolemySSMode = nil
	local list = {}
    for i=1,#cards do
      if cards[i] and bit32.band(cards[i].type,TYPE_MONSTER) > 0 
      and IsTributeException(cards[i].id) == 0
      then   
        cards[i].index=i
        list[#list+1]=cards[i]
      end
    end
    table.sort(list,compare)
    result={}
    for i=1,minTargets do
      result[i]=list[i].index
    end
    return result
  end
  
  --------------------------------------------
  -- Select valid tribute targets when tribute 
  -- summoning a "Toon" monster.
  --------------------------------------------   
 if GlobalSSCardSetcode ~= nil and GlobalSSCardSetcode == 98 or
  GlobalSSCardSetcode == 4522082 then
  local result = {}
  local preferred = {}
  local valid = {}
  local function compare(a,b)
    return a.attack < b.attack
  end
  GlobalSSCardSetcode = nil
  for i=1,#cards do
    if cards[i].owner == 2 or TributeWhitelist(cards[i].id) > 0 or bit32.band(cards[i].type,TYPE_TOKEN) > 0 then
	  cards[i].index=i
	  preferred[#preferred+1]=cards[i]
	elseif cards[i].rank == 0 and cards[i].level <= GlobalSSCardLevel and 
      cards[i].attack < GlobalSSCardAttack and IsTributeException(cards[i].id) == 0 then
	  cards[i].index=i
	  valid[#valid+1]=cards[i]
    end
  end
  for i=1,minTargets do
    if preferred[i] then
      table.sort(preferred,compare)
	   result[i]=preferred[i].index
    else
      table.sort(valid,compare)
	  result[i]=valid[i-#preferred].index
      end
   end
   return result
  end
  
-------------------------------------------------
-- **********************************************
-- Functions to select targets when only one 
-- target is required at time.
-- **********************************************
-------------------------------------------------
  
  --------------------------------------------
  -- Select index of highest attack point 
  -- face up monster type card.
  --------------------------------------------   
  if GlobalActivatedCardID == 90374791 or -- Armed Changer
     GlobalActivatedCardID == 00242146 or -- Ballista of Rampart Smashing
     GlobalActivatedCardID == 61127349 or -- Big Bang Shot
     GlobalActivatedCardID == 65169794 or -- Black Pendant      
     GlobalActivatedCardID == 69243953 or -- Butterfly Dagger - Elma
	 GlobalActivatedCardID == 22046459 or -- Megamorph 
	 GlobalActivatedCardID == 05183693 or -- Amulet of Ambition
	 GlobalActivatedCardID == 46910446 or -- Chthonian Alliance 
	 GlobalActivatedCardID == 40619825 then -- Axe of Despair    
     GlobalActivatedCardID = nil
	 return Get_Card_Index(cards, 1, "Highest", TYPE_MONSTER, POS_FACEUP)
  end
      
  --------------------------------------------     
  -- Inzektor Exa-Beetle
  -- 4 different selections
  -- *Select strongest available monster to equip from grave
  -- *Select random material to detach
  -- *Select own card to destroy. Prefer equipped monster, then
  --  any spell/traps or himself, otherwise random available card
  -- *Select strongest enemy monster to destroy
  -------------------------------------------- 
  
  if GlobalActivatedCardID == 44505297 then -- Inzektor Exa-Beetle
    if GlobalCardMode == nil then
      GlobalActivatedCardID = nil
      return {HighestATKIndexTotal(cards)}
    end
    GlobalCardMode = GlobalCardMode - 1
    if GlobalCardMode <= 1 then
      GlobalActivatedCardID = nil
      GlobalCardMode = nil
    end
    if GlobalCardMode == 2 then
      return {math.random(#cards)}
    elseif GlobalCardMode == 1 then
      for i=1,#cards do
        if bit32.band(cards[i].type,TYPE_MONSTER) > 0 and cards[i].location == LOCATION_SZONE then 
          return {i}
        end
        if bit32.band(cards[i].type,TYPE_SPELL) > 0 or bit32.band(cards[i].type,TYPE_TRAP) > 0
        or cards[i].id == 44505297
        then
          result[#result+1]=i
        end
      end 
      if #result==0 then result=cards end
      return {result[math.random(#result)]}
    else
      return Get_Card_Index(cards, 2, "Highest", nil, POS_FACEUP)
    end
  end
  
  --------------------------------------------     
  -- Detach any material for Tiras's, Keeper of Genesis
  -- effect cost.
  --------------------------------------------   
  if triggeringID == 31386180 then -- Tiras, Keeper of Genesis
   local material = Get_Mat_Table(31386180)
   for i=1,#cards do
	 if cards[i].cardid == material[i].cardid then
	   return {1}
      end
   end
end 
  
  --------------------------------------------     
  -- Select Players strongest monster, if he controls any
  -- stronger monsters than AI, or select any spell or trap card player controls (for now)
  --------------------------------------------   
  if triggeringID == 31386180 then -- Tiras, Keeper of Genesis
	if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") then 
      return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
	  else
       return getRandomSTIndex(cards, 2)
      end
   end

  --------------------------------------------     
  -- Select Players strongest monster, if he controls any
  -- stronger monsters than AI, or select any spell or trap card player controls (for now)
  --------------------------------------------   
  if triggeringID == 34230233 then -- Grapha, Dragon Lord of Dark World
	if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") then 
      return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
	  else
       return getRandomSTIndex(cards, 2)
      end
   end
  
  --------------------------------------------     
  -- Check for banished blacklist, 
  -- select the first not on it
  -- TODO: Maybe sort by level or attack, not sure
  --------------------------------------------   
  if GlobalActivatedCardID == 01475311 then -- Allure of Darkness
    for i=1,#cards do
      if cards[i] and BanishBlacklist(cards[i].id) == 0 then 
        result[1]=i
        GlobalActivatedCardID = nil
       return result
      end
    end
  end
  
  --------------------------------------------     
  -- Check, if there are boss monsters in the
  -- grave to return to the hand, otherwise 
  -- bounce the strongest enemy
  -- (currently just checks the banish blacklist
  -- which includes the bosses)
  --------------------------------------------   
  if triggeringID == 38495396 then    -- Constellar Ptolemy M7
    if GlobalCardMode == 1 then
        GlobalCardMode = nil
    else
      if Card_Count_From_List(BanishBlacklist,AIGrave(),"==") > 0 then
        for i = 1,#cards do
          if cards[i] and BanishBlacklist(cards[i].id) > 0 and 
           cards[i].owner == 1 and cards[i].location == LOCATION_GRAVE then 
              result[1] = i
              GlobalActivatedCardID = nil
              return result
          end
        end
      else
        GlobalActivatedCardID = nil
        return Index_By_Loc(cards,2,"Highest",TYPE_MONSTER,nil,"==",LOCATION_MZONE)
      end
    end
    return {math.random(#cards)}
  end
  
  --------------------------------------------     
  -- Constellar Ptolemy M7.
  --------------------------------------------   
  if GlobalSSCardID == 38495396 then -- Constellar Ptolemy M7
   if PtolemySSMode == 2 then  
	PtolemySSMode = nil
	for i=1,#cards do
      if cards[i] ~= false then 
        if bit32.band(cards[i].type,TYPE_XYZ)> 0 and cards[i].setcode == 83 and cards[i].xyz_material_count == 0 then 
		 result[1] = i
          GlobalSSCardID = nil
          return Index
          end
		end
	  end
    end
  end

  
  --------------------------------------------     
  -- Select Players strongest face-up monster by attack points on the field.
  -- If there are none, select a random face-down of the player 
  -- (only relevant for BLS)
  --------------------------------------------   
  if (GlobalActivatedCardID == 09596126 or GlobalActivatedCardID == 72989439) -- Chaos Sorcerer, BLS
    and GlobalCardMode == nil then 
    GlobalActivatedCardID = nil
    if OppHasFaceupMonster(0) then 
      return Get_Card_Index(cards, 2, "Highest", nil, POS_FACEUP)
    else
      for i=1,#cards do
        if cards[i] and (cards[i].owner == Owner or CurrentMonOwner(cards[i].cardid) == Owner) then 
          result[#result+1]=i
        end
      end
    end
    return {result[math.random(#result)]}
  end	
  
  --------------------------------------------     
  -- Select AI's weakest monster by attack points in hand.
  --------------------------------------------   
  if GlobalActivatedCardID == 04178474 or   -- Raigeki Break 
     GlobalActivatedCardID == 70231910 then -- Dark Core
   if GlobalCardMode == 1 then
	  GlobalCardMode = nil 
      return Get_Card_Index(cards, 1, "Lowest", nil, nil)
     end
  end
  
  
  --------------------------------------------     
  -- Select Players strongest monster, if he controls any
  -- stronger monsters than AI, or select any spell or trap card player controls (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 04178474 then -- Raigeki Break
   if GlobalCardMode == nil then
   for i=1,#cards do
      if cards[i] ~= false then 
        if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") then 
		 GlobalActivatedCardID = nil 
		 return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
		  else
          GlobalActivatedCardID = nil
		  return getRandomSTIndex(cards, 2)
         end
       end
     end
   end
  return Index
end
 
  ------------------------------------------------------------
  -- Tribute lowest attack monster.
  ------------------------------------------------------------
  if GlobalActivatedCardID == 41426869 then -- Black Illusion Ritual
	 GlobalActivatedCardID = nil
     return Get_Card_Index(cards, 1, "Lowest", nil, nil)
   end

  --------------------------------------------
  -- Select Players random Spell or Trap card
  --------------------------------------------   
  if GlobalActivatedCardID == 05318639 or -- Mystical Space Typhoon 
	 GlobalActivatedCardID == 71413901 then -- Breaker the Magical Warrior 
	 GlobalActivatedCardID = nil
     --print("MST target selection")
     return getRandomSTIndex(cards, 2)
   end
     
  --------------------------------------------     
  -- Select Players strongest monster, if he controls any
  -- stronger monsters than AI or only monsters, 
  -- if not select any spell or trap card player controls
  --------------------------------------------   
  if GlobalActivatedCardID == 09748752 then -- Caius the Shadow Monarch
    for i=1,#cards do
      if cards[i] ~= false then 
        if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack")  or Get_Card_Count(OppST())== 0 then 
          result = Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
          GlobalActivatedCardID = nil 
        else
          result = getRandomSTIndex(cards, 2)
          GlobalActivatedCardID = nil
        end
        return result
      end
    end
  end
   
  --------------------------------------------     
  -- Select Players random Spell or Trap card
  --------------------------------------------   
  if GlobalActivatedCardID == 70908596 then -- Constellar Kaust
   local HighestLVL = 0
	for i=1,#cards do
      if cards[i] ~= false then 
	   if GlobalKaustActivated == nil or Get_Card_Count_ID(AIMon(), 70908596, nil) > 1 or
	      Card_Count_Specified(AIMon(),nil, nil, nil, "==", 6, nil, 83, nil, nil) > 0 then
		if bit32.band(cards[i].type,TYPE_MONSTER) > 0 and cards[i].level < 6 and cards[i].setcode == 83 and
		cards[i].level >= HighestLVL and cards[i].position ==(POS_FACEUP_ATTACK or POS_FACEUP_DEFENCE) and cards[i].owner == 1 then
		 GlobalKaustActivated = 1
		 HighestLVL = cards[i].level
		 result = i
		  end
        end
      end	
    end
   for i=1,#cards do
     if cards[i] ~= false then 
	  if Card_Count_Specified(AIMon(), nil, nil, nil, "==", 4, nil, 83, nil, nil) > 0 then
	   if bit32.band(cards[i].type,TYPE_MONSTER) > 0 and cards[i].level < 5 and cards[i].setcode == 83 and
		  cards[i].level >= HighestLVL and cards[i].position ==(POS_FACEUP_ATTACK or POS_FACEUP_DEFENCE) and cards[i].owner == 1 then
		 GlobalKaustActivated = 1
		 HighestLVL = cards[i].level
		 result = i
          end
        end
      end	
    end
   return {result}
 end	
  
  --------------------------------------------     
  -- Select Players random Spell or Trap card
  --------------------------------------------   
  if GlobalActivatedCardID == 44635489 then -- Constellar Siat
   for i=1,#cards do
      if cards[i] ~= false then 
		if Card_Count_Specified(AIMon(), nil, nil, nil, "==", 6, nil, 83, nil, nil) > 0 then
		  if cards[i].level == 6 then
		  result[1] = i
		   GlobalActivatedCardID = nil
		  return result
        end
      end
    end	
  end
  for i=1,#cards do
      if cards[i] ~= false then 
		if Card_Count_Specified(AIMon(), nil, nil, nil, "==", 5, nil, 83, nil, nil) > 0 then
		  if cards[i].level == 5 then
		  result[1] = i
		  GlobalActivatedCardID = nil
		  return result
          end
        end
      end	
    end
  for i=1,#cards do
      if cards[i] ~= false then 
		if Card_Count_Specified(AIMon(), nil, nil, nil, "==", 4, nil, 83, nil, nil) > 0 then
		  if cards[i].level == 4 then
		  result[1] = i
		  GlobalActivatedCardID = nil
		  return result
          end
        end
      end	
    end
  end 
  
   
  --------------------------------------------     
  -- Select one of the following cards
  --------------------------------------------   
  if GlobalActivatedCardID == 78486968 then -- Constellar Sheratan
	for i=1,#cards do
      if cards[i] ~= false then 
        if cards[i].id == 70908596 or cards[i].id == 78364470 or 
		   cards[i].id == 41269771 then 
		  GlobalActivatedCardID = nil 
		  result[1] = i
		  return result
        end
      end
    end	
  end
  
  --------------------------------------------     
  -- Select one of the following cards
  --------------------------------------------   
  if GlobalActivatedCardID == 41269771 then -- Constellar Algiedi
	GlobalActivatedCardID = nil
	for i=1,#cards do
      if cards[i] ~= false then 
        if cards[i].id == 70908596 or cards[i].id == 78364470 or cards[i].id ~= 41269771 then 
		  result[1] = i
		  return result
        end
      end
    end	
  end
  
  --------------------------------------------     
  -- Select monster not of a BanishBlacklist
  --------------------------------------------   
  if GlobalActivatedCardID == 33347467 then -- Ghost Ship
	for i=1,#cards do
      if cards[i] ~= false then 
        if BanishBlacklist(cards[i].id) == 0 then
		 result[1] = i
		  GlobalActivatedCardID = nil
		  return result
        end
      end
    end	
  end
    
  --------------------------------------------     
  -- Select Players strongest monster, if he controls any
  -- stronger monsters than AI, or select any spell or trap card player controls (for now)
  --------------------------------------------   
  if triggeringID == 78156759 then -- Wind-Up Zenmaines
    if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") then 
	  return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
		 else
          return getRandomSTIndex(cards, 2)
        end
     end
  
  --------------------------------------------     
  -- Select any material to detach.
  --------------------------------------------   
  if GlobalActivatedCardID == 73964868 then -- Constellar Pleiades
    if GlobalCardMode == 1 then
	GlobalCardMode = nil
	for i=1,#cards do
      if cards[i] ~= false then 
         result[1] = i
		  return result
         end
       end
     end	
   end	
  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 73964868 then -- Constellar Pleiades
    if GlobalCardMode == nil then 
       GlobalActivatedCardID = nil
       return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
      end
   end

  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 74131780 or GlobalActivatedCardID == 80117527 then -- Exiled Force, No. 11 Big Eye 
     GlobalActivatedCardID = nil
     return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
    end
   
  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if triggeringID == 54652250 then -- Man-Eater Bug
     if Get_Card_Count(OppMon()) > 0 then 
        GlobalActivatedCardID = nil
		return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
        end
     end
	 for i=1,#cards do
       if Get_Card_Count(OppMon()) == 0 then 
		 if cards[i].id == 54652250 then
		  return {i}
        end
      end
    end

  
  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 64631466 then -- Relinquished
     GlobalActivatedCardID = nil
     return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
   end

  
  --------------------------------------------     
  -- Detach Battlin' Boxer Switchitter first if possible
  -------------------------------------------- 
  if GlobalActivatedCardID == 34086406 then  -- Lavalval Chain
   if GlobalCardMode == 1 then
   for i=1,#cards do
        if cards[i].id == 68144350 then -- Battlin' Boxer Switchitter 
		  GlobalCardMode = nil
		  return {i}
         end
       end
     end	
   end 
 
  --------------------------------------------     
  -- Discard Glassjaw first if possible
  -------------------------------------------- 
  if GlobalActivatedCardID == 34086406 then  -- Lavalval Chain
   if GlobalCardMode == nil then
   for i=1,#cards do
        if cards[i].id == 05361647 then -- Battlin' Boxer Glassjaw 
		  GlobalActivatedCardID = nil
		  return {i}
         end
       end
     end	
   end 
 
  --------------------------------------------     
  -- Select "Battlin' Boxer Glassjaw" if possible
  --------------------------------------------   
  if GlobalActivatedEffectID == 68144350 or  -- Battlin' Boxer Switchitter
     GlobalActivatedEffectID == 79867938 or  -- Battlin' Boxer Headgeared
	 GlobalActivatedCardID == 36916401  then -- Burnin' Boxin' Spirit
	GlobalActivatedEffectID = nil
	for i=1,#cards do
      if cards[i].id == 05361647 then -- Battlin' Boxer Glassjaw   
		 return {i}
        end
      end
    end	
  
  --------------------------------------------     
  -- Select AI's random spell/trap card in hand
  --------------------------------------------   
  if GlobalActivatedCardID == 00423585 then -- Summoner Monk
    if GlobalCardMode == 1 then   
	   GlobalCardMode = nil	  
       return {math.random(#cards)}
      end
   end

  
  --------------------------------------------     
  -- Select Battlin' Boxer Switchitter in AI's deck to summon
  --------------------------------------------   
  if GlobalActivatedCardID == 00423585 then -- Summoner Monk
    if GlobalCardMode == nil then   
       GlobalActivatedCardID = nil
       return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 68144350)
      end
   end

  
  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 25774450 then -- Mystic Box
   if GlobalCardMode == 1 then   
      GlobalCardMode = nil
      return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
    end
  end

  
  --------------------------------------------     
  -- Select AI'S weakest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 25774450 then -- Mystic Box
   if GlobalCardMode == nil then   
      GlobalActivatedCardID = nil  
      return Get_Card_Index(cards, 1, "Lowest", nil, nil)
     end
  end	
  
  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 87880531 then -- Diffusion Wave-Motion
   local HighestATK = 0
   local HighestIndex = 1
    for i=1,#cards do
      if bit32.band(cards[i].type,TYPE_MONSTER) == TYPE_MONSTER and cards[i].owner == 1 and cards[i].race == RACE_SPELLCASTER and
		 cards[i].level >= 7 and cards[i].attack > HighestATK then
          HighestIndex = i
          HighestATK = cards[i].attack        
	      return HighestIndex
	      end
       end
    end

  
  --------------------------------------------     
  -- Select any material to detach.
  --------------------------------------------   
  if GlobalActivatedCardID == 29669359 then -- Number 61: Volcasaurus
    if GlobalCardMode == 1 then
	   GlobalCardMode = nil
       return {1}	
      end
   end

  
  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 29669359 then -- Number 61: Volcasaurus 
    if GlobalCardMode == nil then
       GlobalActivatedCardID = nil
       return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
      end
   end

  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 18807108 then -- Spellbinding Circle 
     GlobalActivatedCardID = nil 
     return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
   end

    
  --------------------------------------------     
  -- Select Players strongest lvl 5+ monster ot the field, or ritual summoned monster.
  --------------------------------------------   
  if GlobalActivatedCardID == 94192409 then -- Compulsory Evacuation Device 
     GlobalActivatedCardID = nil
     return GetHighestATKMonByLevelOrSS(cards,TYPE_MONSTER+TYPE_RITUAL, 5, POS_FACEUP_ATTACK or POS_FACEUP_DEFENCE, 2)
   end
 	  
  --------------------------------------------     
  -- Select AI's weakest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedEffectID == 40619825 then -- Axe of Despair
   if GlobalCardMode == 1 then
      GlobalActivatedEffectID = nil
	  GlobalCardMode = nil
      return Get_Card_Index(cards, 1, "Lowest", nil, nil)
      end
   end
  
  --------------------------------------------     
  -- Select AI's weakest monster by attack points on the field.
  --------------------------------------------   
  if SpSummonedCardID == 34230233 then -- Grapha, Dragon Lord of Dark World
     SpSummonedCardID = nil
     return Get_Card_Index(cards, 1, "Lowest", nil, nil)
   end

  --------------------------------------------     
  -- Select AI's weakest monster by attack points in hand.
  --------------------------------------------   
  if GlobalActivatedCardID == 70231910 then -- Dark Core 
   if GlobalCardMode == 1 then
	  GlobalCardMode = nil 
      return Get_Card_Index(cards, 1, "Lowest", nil, nil)
      end
   end
  
  --------------------------------------------     
  -- Select Players strongest monster by attack points on field.
  --------------------------------------------   
  if GlobalActivatedCardID == 70231910 then -- Dark Core 
   if GlobalCardMode == nil then
	  GlobalActivatedCardID = nil
      return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, nil)	
      end
   end

  --------------------------------------------     
  -- Select AI's strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 83746708 then -- Mage Power 
     GlobalActivatedCardID = nil
     return Get_Card_Index(cards, 1, "Highest", TYPE_MONSTER, nil)
   end

  
  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 68005187 then -- Soul Exchange 
     GlobalActivatedCardID = nil
     return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
    end

  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 55713623 then -- Shrink 
     GlobalActivatedCardID = nil
     return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
    end
	
  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 98045062 then -- Enemy Controller 
     GlobalActivatedCardID = nil
     return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
    end

  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 51945556 then -- Zaborg the Thunder Monarch 
     GlobalActivatedCardID = nil
     return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
    end
	
  --------------------------------------------     
  -- Select AI's monster by level in hand
  --------------------------------------------   
  if GlobalActivatedCardID == 23265313 then -- Cost Down 
     GlobalActivatedCardID = nil  
     return Index_By_Level(cards,1,"Lowest",TYPE_MONSTER,nil,"<=",4)
    end
	
  
  --------------------------------------------     
  -- Chaos summons, check the cards to banish
  -- with the banish blacklist
  -- Check Lightpulsar Dragon separately when
  -- summoned from grave and discard cards
  -- that work well in the graveyard
  --------------------------------------------   
  if(GlobalActivatedCardID == 72989439      -- BLS
  or GlobalActivatedCardID == 09596126      -- Chaos Sorcerer
  or GlobalActivatedCardID == 99365553)     -- Lightpulsar Dragon
    and GlobalCardMode ~= nil then
    local discarding = 0
    if GlobalCardMode > 2 then
      discarding = 1
    end
    GlobalCardMode = GlobalCardMode - 1
    if GlobalCardMode <= 0 or GlobalCardMode == 2 then
      GlobalCardMode = nil 
      GlobalActivatedCardID = nil 
    end
    for i=1,#cards do
      if cards[i] and BanishBlacklist(cards[i].id) == 0 then 
        if discarding > 0 then
          if (cards[i].id == 09411399 and Get_Card_Count_ID(AIGrave(),cards[i].id,nil) == 0)    -- Destiny Hero - Malicious
          or cards[i].id == 33420078 or cards[i].id == 51858306             -- Plaguespreader Zombie, Eclipse Wyvern
          then
            return {i}
          end
        else
          if BanishWhitelist(cards[i].id) > 0 then
            return {i}
          end
        end
        result[#result+1] = i
      end
    end
    return {result[math.random(#result)]}
  end
  
  --------------------------------------------     
  -- Always put Destiny Hero - Malicious back in the deck
  -- if able. Otherwise one at random.
  --------------------------------------------   
  if GlobalActivatedCardID == 33420078 then -- Plaguespreader Zombie 
     GlobalActivatedCardID = nil
    if Get_Card_Count_ID(AIHand(),09411399,nil) > 0 and Get_Card_Count_ID(AIGrave(),09411399,nil) > 0 then
      for i=1,#cards do
        if cards[i] and cards[i].id == 09411399 then -- Destiny Hero - Malicious
          return {i}
        end
     end
    else
    return {math.random(#cards)}
   end
end

  --------------------------------------------     
  -- Select Players strongest face-up monster 
  -- otherwise select a random one
  --------------------------------------------   
  if GlobalActivatedCardID == 15561463 then -- Gauntlet Launcher
    if GlobalCardMode == nil then
       GlobalCardMode = 1
      return {math.random(#cards)}
    end
    GlobalActivatedCardID = nil
    GlobalCardMode = nil
    if Get_Card_Count_Pos(OppMon(), POS_FACEUP) > 0 then
      return Get_Card_Index(cards, 2, "Highest", nil, POS_FACEUP)
    else
      for i=1,#cards do
        if cards[i] and (cards[i].owner == 2 or CurrentMonOwner(cards[i].cardid) == 2) then
          result[#result+1]=i
        end
      end
      return {result[math.random(#result)]}
    end
  end	

  --------------------------------------------
  -- For the banish, try to avoid monsters, that
  -- work well in the grave and check the banish blacklist
  --
  -- For the destruction, select players strongest monster, if 
  -- he controls any stronger monsters than AI or only monsters, 
  -- otherwise select any spell or trap card player controls
  --------------------------------------------   
  if GlobalActivatedCardID == 65192027 then -- Dark Armed Dragon
    if GlobalCardMode == 1 then  --banish from grave
      for i=1,#cards do
        if cards[i] then
          if BanishBlacklist(cards[i].id)==0 and cards[i].id ~= 33420078  -- Plaguespreader Zombie
            and (cards[i].id ~= 09411399 or Get_Card_Count_ID(AIDeck(),cards[i].id,nil) == 0) -- Destiny Hero - Malicious 
          then
            result[#result+1]=i
          end
        end
      end
      if #result <= 0 then
        for i=1,#cards do
          if cards[i] and BanishBlacklist(cards[i].id)==0 then
            result[#result+1]=i
          end
        end
      end
      result = {result[math.random(#result)]}
      GlobalCardMode = nil
      return result
    else              --destroy player card
      for i=1,#cards do
        if cards[i] ~= false then 
          if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") or Get_Card_Count(OppST()) == 0 then
            return Get_Card_Index(cards, 2, "Highest", nil, POS_FACEUP)
          else
            return getRandomSTIndex(cards, 2)
          end
          GlobalActivatedCardID = nil
        end
      end
    end
  end

 --------------------------------------------     
  -- Select monsters that work well in the grave, 
  -- otherwise just check for bosses
  -------------------------------------------- 
  if GlobalActivatedCardID == 14536035 then -- Dark Grepher
    local preferred={}
    for i=1,#cards do
      if cards[i] then
        if cards[i].id == 09411399 and Get_Card_Count_ID(AIGrave(),cards[i].id,nil) == 0 or    -- Destiny Hero - Malicious
           cards[i].id == 33420078 and Get_Card_Count_ID(AIGrave(),cards[i].id,nil) == 0       -- Plaguespreader Zombie
        then 
          preferred[#preferred+1]=i
        end
        if BanishBlacklist(cards[i].id) == 0 then
          result[#result+1]=i
        end
      end
    end
    if #preferred > 0 then 
      result = preferred 
    end
    if GlobalCardMode == 2 then
      GlobalCardMode = 1
    else
      GlobalActivatedCardID = nil
      GlobalCardMode = nil
    end
    result={result[math.random(#result)]}
    return result
  end

  --------------------------------------------------------
  -- For the banish on summon, check for banish blacklist, 
  -- select random valid target. Try to avoid XYZ dragons
  -- who still have materials, but use them if you have to.
  -- For the summoned dragon, prefer Lightpulsar (he can
  -- revive REDMD when destroyed) otherwise select at random
  --------------------------------------------------------
  if GlobalActivatedCardID == 88264978 then     -- Red-Eyes Darkness Metal Dragon
    GlobalActivatedCardID = nil
    if GlobalCardMode == 1 then
      for i=1,#cards do
        if BanishBlacklist(cards[i].id) == 0 and cards[i].xyz_material_count == 0 then
          result[#result+1]=i
        end
      end
      if #result == 0 then
        for i=1,#cards do
          if BanishBlacklist(cards[i].id) == 0 then
            result[#result+1]=i
          end
        end
      end
      GlobalCardMode = nil
      return {result[math.random(#result)]}
    else
      for i=1,#cards do
        if cards[i] and cards[i].id == 99365553 then --Lightpulsar Dragon
          return {i}
        end
      end
      return {math.random(#cards)}
    end
  end
  
  --------------------------------------------     
  -- Detach first 2 materials
  -- Destroy strongest face-up enemy monster
  -- Destroy random spell/trap card
  --------------------------------------------   
  if GlobalActivatedCardID == 75253697 then -- Number 72: Line Monster Chariot Hishna
    if GlobalCardMode == nil then
      GlobalCardMode = 1
      return {1,2}
    elseif GlobalCardMode == 1 then
      GlobalCardMode = 2
      return {Get_Card_Index(cards, 2, "Highest", nil, POS_FACEUP)}
    elseif GlobalCardMode == 2 then
      GlobalCardMode = nil
      return {math.random(#cards)}
    end
  end	

  -------------------------------------------- 
  -- Make Hieratic Dragon King of Atum always 
  -- summon Red Eyes Darkness Metal Dragon, if possible
  --------------------------------------------   
  if GlobalActivatedCardID == 27337596 then -- Hieratic Dragon King of Atum
    if GlobalCardMode == nil then
      GlobalCardMode = 1
      return {math.random(#cards)}
    end
    GlobalCardMode = nil
    for i=1,#cards do
      if cards[i] and cards[i].id == 88264978 then -- Red-Eyes Darkness Metal Dragon
        return {i}
      end
    end
    return {math.random(#cards)}
  end		
  
 --------------------------------------------     
  -- Search Tefnuit, if he is not in hand already
  -- otherwise, search Su. 
  -- If it doesn't find either, pick at random
  --------------------------------------------   
  if GlobalActivatedCardID == 25377819 then -- Hieratic Seal of Convocation
    GlobalActivatedCardID = nil
    local id = 77901552 -- Hieratic Dragon of Tefnuit
	if Get_Card_Count_ID(AIHand(),id,nil) > 0 then
      id = 03300267 -- Hieratic Dragon of Su
    end
    for i=1,#cards do
      if cards[i] and cards[i].id == id then
        return {i}
      end
    end
    return {math.random(#cards)}
  end
  
  --------------------------------------------     
  -- Select Players strongest monster by attack points on the field.
  --------------------------------------------   
  if GlobalActivatedCardID == 29267084 then -- Shadow Spell 
     GlobalActivatedCardID = nil
     return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
    end

  --------------------------------------------
  -- Make sure Ai uses power up cards only on his own monsters,
  -- select Ai's normal type monster with strongest attack (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 50078509 then -- Fiendish Chain   
     GlobalActivatedCardID = nil
     return Get_Card_Index(cards, 1, "Highest", TYPE_MONSTER + TYPE_EFFECT, POS_FACEUP)
    end
	
  
  --------------------------------------------
  -- Make sure Ai uses equip cards with negative effects
  -- only on opponents monsters
  -- select Ai's specified type monster with strongest attack (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 91595718 or -- Book of Secret Arts
     GlobalActivatedCardID == 53610653 then -- Bound Wand
     GlobalActivatedCardID = nil
     return Index_By_Race(cards, 1,"Highest",TYPE_MONSTER,POS_FACEUP,"==",RACE_SPELLCASTER)
    end

  
  --------------------------------------------
  -- Make sure Ai uses equip cards with negative effects
  -- only on opponents monsters
  -- select Ai's specified type monster with strongest attack (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 46009906 then -- Beast Fangs
     GlobalActivatedCardID = nil
     return Index_By_Race(cards, 1,"Highest",TYPE_MONSTER,POS_FACEUP,"==",RACE_BEAST)
    end

  
  --------------------------------------------
  -- Make sure Ai uses equip cards with negative effects 
  -- only on opponents monsters
  -- select Ai's specified type monster with strongest attack (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 88190790 then -- Assault Armor
     GlobalActivatedCardID = nil
     return Index_By_Race(cards, 1,"Highest",TYPE_MONSTER,POS_FACEUP,"==",RACE_WARRIOR)
    end
  
  --------------------------------------------
  -- Make sure Ai uses equip cards with negative effects
  -- only on opponents monsters
  -- select Ai's specified type monster with strongest attack (for now)
  --------------------------------------------   
   if GlobalActivatedCardID == 86198326 or  -- 7 Completed
      GlobalActivatedCardID == 63851864 then -- Break! Draw!
      GlobalActivatedCardID = nil
      return Index_By_Race(cards, 1,"Highest",TYPE_MONSTER,POS_FACEUP,"==",RACE_MACHINE)
    end
   
  --------------------------------------------
  -- Make sure Ai uses equip cards with negative effects
  -- only on opponents monsters
  -- select Ai's specified type monster with strongest attack (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 18937875 then -- Burning Spear
     GlobalActivatedCardID = nil
     return Index_By_ATT(cards,1,"Highest",TYPE_MONSTER,POS_FACEUP,"==",ATTRIBUTE_FIRE)
    end
  
  --------------------------------------------
  -- Make sure Ai uses equip cards with negative effects
  -- only on opponents monsters
  -- select Ai's specified type monster with strongest attack (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 39897277 or GlobalActivatedCardID == 82878489 then -- Elf's Light, Shine Palace
     GlobalActivatedCardID = nil
     return Index_By_ATT(cards,1,"Highest",TYPE_MONSTER,POS_FACEUP,"==",ATTRIBUTE_LIGHT)
    end
 
  --------------------------------------------
  -- Make sure Ai uses power up cards only on his own monsters,
  -- select Ai's monster of specified id with strongest attack (for now)
  --------------------------------------------   
   if GlobalActivatedCardID == 53586134 then -- Bubble Blaster   
       GlobalActivatedCardID = nil		  
       return Index_By_ID(cards,1,"Highest",nil,POS_FACEUP,"==",79979666)
      end

  --------------------------------------------
  -- select any face down card controlled by player (for now)
  --------------------------------------------   
   if GlobalActivatedCardID == 93554166 then -- Dark World Lightning 
    if GlobalCardMode == 1 then
	   GlobalCardMode = nil
       return Get_Card_Index(cards,2,"Highest", nil,POS_FACEDOWN) 
      end 
   end
	  
  --------------------------------------------
  -- Make sure Ai uses power up cards only on his own monsters,
  -- select Ai's monster of specified id with strongest attack (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 00303660 then -- Amplifier 
     GlobalActivatedCardID = nil  
     return Index_By_ID(cards,1,"Highest",nil,POS_FACEUP,"==",77585513)
    end

  --------------------------------------------
  -- Make sure Ai uses power up cards only on his own monsters,
  -- select Ai's monster of specified id with strongest attack (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 40830387 or -- Ancient Gear Fist
     GlobalActivatedCardID == 37457534 then -- Ancient Gear Tank 
     GlobalActivatedCardID = nil		 
     return Index_By_SetCode(cards,1,"Highest",nil,POS_FACEUP,"==",7)
    end
  
  --------------------------------------------
  -- Make sure Ai uses power up cards only on his own monsters,
  -- select Ai's monster of specified id with strongest attack (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 79965360 then -- Amazoness Heirloom 
     GlobalActivatedCardID = nil		 
      return Index_By_SetCode(cards,1,"Highest",nil,POS_FACEUP,"==",4)
    end

  
  --------------------------------------------
  -- Make sure Ai uses power up cards only on his own monsters,
  -- select Ai's monster of specified id with strongest attack (for now)
  --------------------------------------------   
   if GlobalActivatedCardID == 19596712 or -- Abyss-scale of Cetus
      GlobalActivatedCardID == 72932673 or -- Abyss-scale of the Mizuchi
      GlobalActivatedCardID == 08719957 then -- Abyss-scale of the Kraken       
      GlobalActivatedCardID = nil		 
      return Index_By_SetCode(cards,1,"Highest",nil,POS_FACEUP,"==",7667828)
    end
   
  --------------------------------------------
  -- Make sure Ai uses power up cards only on his own monsters,
  -- select Ai's monster of specified id with strongest attack (for now)
  --------------------------------------------   
   if GlobalActivatedCardID == 59385322 then -- Core Blaster       
      GlobalActivatedCardID = nil		 
      return Index_By_SetCode(cards,1,"Highest",nil,POS_FACEUP,"==",29)
    end

  --------------------------------------------
  -- Make sure Ai uses power up cards only on his own monsters,
  -- select Ai's attack pos monster with strongest attack, 
  -- whos attack is equal or below 1000 (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 84740193 then -- Buster Rancher    
     GlobalActivatedCardID = nil 
     return Index_By_Attack(cards,1,"Highest",nil,POS_FACEUP,"<=",1000)
    end
   
  --------------------------------------------
  -- Make sure Ai uses equip cards with negative effects
  -- only on opponents monsters
  -- select Opp's attack pos monster with strongest attack (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 41587307 or -- Broken Bamboo Sword
     GlobalActivatedCardID == 46967601 or -- Cursed Bill
     GlobalActivatedCardID == 56948373 or -- Mask of the accursed  
     GlobalActivatedCardID == 75560629 then -- Flint     
     GlobalActivatedCardID = nil
     return Get_Card_Index(cards,2,"Highest",nil,POS_FACEUP_ATTACK)
    end

  --------------------------------------------
  -- Make sure Ai uses equip cards with negative effects
  -- only on opponents monsters
  -- select Opp's non machine type monster with strongest attack (for now)
  --------------------------------------------   
  if GlobalActivatedCardID == 24668830 or -- Germ Infection
     GlobalActivatedCardID == 50152549 then -- Paralyzing Potion
     GlobalActivatedCardID = nil
     return Index_By_Race(cards,2,"Highest",TYPE_MONSTER,POS_FACEUP,"~=",RACE_MACHINE)
    end
  
  --------------------------------------------
  -- Discard all possible monster type cards
  --------------------------------------------   
  if GlobalActivatedCardID == 41142615 then -- The Cheerful Coffin 
	local DiscardCount= 1
	for i=1,#cards do
      if bit32.band(cards[i].type,TYPE_MONSTER) == TYPE_MONSTER and cards[i].setcode == 6 then
      result[DiscardCount]= i;
	  GlobalActivatedCardID = nil
	   if (DiscardCount<maxTargets) then DiscardCount=DiscardCount+1 else break end
      end
   end
  return result
end
  
  --------------------------------------------
  -- Discard all possible "Dark world" monster cards 
  --------------------------------------------   
  if GlobalActivatedCardID == 47217354 then -- Fabled Raven
	local DiscardCount= 1
	for i=1,#cards do
      if bit32.band(cards[i].type,TYPE_MONSTER) == TYPE_MONSTER and cards[i].setcode == 6 then
      result[DiscardCount]= i;
	  GlobalActivatedCardID = nil
	   if (DiscardCount<maxTargets) then DiscardCount=DiscardCount+1 else break end
      end
   end
  return result
end
  
  --------------------------------------------
  -- Banish monster's from AI's grave only, and select max available count
  --------------------------------------------   
  if GlobalActivatedCardID == 05758500 then -- Soul Release 
	local BanishCount= 1
	for i=1,#cards do
      if bit32.band(cards[i].type,TYPE_MONSTER) == TYPE_MONSTER and cards[i].owner == 1 then
	  result[BanishCount]= i;
	  GlobalActivatedCardID = nil
	   if (BanishCount<maxTargets) then BanishCount=BanishCount+1 else break end
      end
   end
  return result
end
  	
	--------------------------------------------
  -- Banish monster's from AI's grave only, and select max available count
  --------------------------------------------   
  if GlobalActivatedCardID == 43973174 then -- The Flute of Summoning Dragon 
	local SummonCount= 1
	local HighestATK   = 0
	for i=1,#cards do
      if (bit32.band(cards[i].type,TYPE_MONSTER) == TYPE_MONSTER and cards[i].race == RACE_DRAGON) and cards[i].attack >= HighestATK then	  
	  HighestATK = cards[i].attack
	  result[SummonCount]= i;
	  GlobalActivatedCardID = nil
	   if (SummonCount<maxTargets) then SummonCount=SummonCount+1 else break end
      end
   end
  return result
end
	
  -----------------------------------------------------------
  -- If the AI activates Monster Reborn, Call of the Haunted,
  -- or other special-summon cards (to be added later), let
  -- it choose the monster with the highest ATK for now.
  -----------------------------------------------------------
  if GlobalActivatedCardID == 83764718 or   -- Reborn
     GlobalActivatedCardID == 97077563 or   -- Call
     GlobalActivatedCardID == 88264978 or   -- REDMD
     GlobalActivatedCardID == 78868119 or   -- Diva
     GlobalActivatedCardID == 09622164 or   -- D.D.R.
     GlobalActivatedCardID == 71453557 or   -- Autonomous Action Unit
	 GlobalActivatedCardID == 42534368 or   -- Silent Doom
	 GlobalActivatedCardID == 43434803 or   -- The Shallow Grave
	 GlobalActivatedCardID == 93431518 or   -- Gateway to Dark World
	 GlobalActivatedCardID == 37694547 then -- Geartown    
	local HighestATK = 0
    local HighestIndex = 1
    for i=1,#cards do
        if cards[i].attack > HighestATK then
          HighestIndex = i
          HighestATK = cards[i].attack
        end
    end
    GlobalActivatedCardID = nil
    result[1] = HighestIndex
    return result
  end
  
  
  -------------------------------------------------------
  -- If the AI activates Tour Guide from the Underworld's
  -- effect, attempt to special summon something other
  -- than another Tour Guide.
  -------------------------------------------------------
  if GlobalActivatedCardID == 10802915 then
     GlobalActivatedCardID = nil          
     return Index_By_ID(cards, 1,"Highest",TYPE_MONSTER,nil,"~=",10802915)
    end

  -----------------------------------------------------
  -- When Monster Reincarnation resolves, the AI should
  -- always choose the monster with the highest ATK
  -- that isn't an extra deck monster.
  -----------------------------------------------------
  if GlobalActivatedCardID == 74848038 then
    if GlobalCardMode == nil then
       GlobalActivatedCardID = nil 
       return Get_Card_Index(cards,1,"Highest",TYPE_MONSTER+TYPE_EFFECT,nil)
      end
   end

  -----------------------------------------------------------
  -- When Lumina, Lightsworn Summoner resolves, the AI should
  -- always choose the monster with the highest ATK for now.
  --
  -- To do: choose the right monster depending on the situation.
  -- (Wulf/Jain for ATK, Lyla for S/T, Ehren for DEF monsters,
  --  Garoth for draw power if no threats are present, more?)
  -----------------------------------------------------------
  if GlobalActivatedCardID == 95503687 then
    if GlobalCardMode == nil then
       GlobalActivatedCardID = nil
       return Get_Card_Index(cards,1,"Highest",TYPE_MONSTER+TYPE_EFFECT,nil)
     end
   end
 
  ------------------------------------------------------------
  -- For the Monster Reincarnation discard cost, the AI should
  -- simply discard the lowest ATK monster card in hand.
  ------------------------------------------------------------
  if GlobalActivatedCardID == 74848038 then
    if GlobalCardMode == 1 then
       GlobalCardMode = nil
       return Get_Card_Index(cards, nil, "Lowest", nil, nil)
      end
   end

  ----------------------------------------------------------------
  -- For Lumina, Lightsworn Summoner's discard cost, the AI should
  -- discard the lowest ATK monster whose level is 5 or lower.
  ----------------------------------------------------------------
  if GlobalActivatedCardID == 95503687 then
    if GlobalCardMode == 1 then
       GlobalCardMode = nil
       return Index_By_Level(cards,1,"Lowest",TYPE_MONSTER,nil,"<=",5)
      end 
   end

  ----------------------------------------------------------------
  -- For Mecha Phantom Beast Dracossack's tributing cost
  -- tribute only his summoned Mecha Tokens.
  ----------------------------------------------------------------
  if GlobalActivatedCardID == 22110647 then 
	if GlobalCardMode == 1 then
       GlobalCardMode = nil
     for i=1,#cards do
      if cards[i].id ~= 22110647 and cards[i].attack == 0 then
         result[1] = i
         return result
        end
      end
    end
  end
   
  ----------------------------------------------------------------
  -- Target Player's monster with highest attack when 
  -- Mecha Phantom Beast Dracossack's card destroy effect is used.
  ----------------------------------------------------------------
   if GlobalActivatedCardID == 22110647 then
	if GlobalCardMode == nil then
       GlobalActivatedCardID = nil
	   return Get_Card_Index(cards, 2, "Highest", TYPE_MONSTER, POS_FACEUP)
	  end
    end

  -------------------------------------------------------
  -- Charge of the Light Brigade: The AI should never add
  -- Wulf, Lightsworn Beast to hand. Anything else is OK.
  -------------------------------------------------------
  if GlobalActivatedCardID == 94886282 then
     GlobalActivatedCardID = nil
     return Index_By_ID(cards,1,"Highest",TYPE_MONSTER, nil,"~=",58996430)
    end

  ---------------------------------------------------------
  -- When the effect of Tanngnjostr of the Nordic Beasts is
  -- activated, try to special summon a tuner or a level 3
  -- Nordic Beast monster.
  ---------------------------------------------------------
  if GlobalActivatedCardID == 14677495 then
    for i=1,#cards do
      if IsNordicTuner(cards[i].id) == 1 or
         cards[i].level == 3 then
         GlobalActivatedCardID = nil
         return {i}
        end
      end
    end
    
  -------------------------------------------------
  -- When activating Toon Table of Contents, search
  -- another copy of Toon Table to thin the deck.
  -------------------------------------------------
  if GlobalActivatedCardID == 89997728 then
    for i=1,#cards do
      if cards[i].id == 89997728 then
         GlobalActivatedCardID = nil
         return {i}
        end
      end
    end

  --------------------------------------------------------
  -- After activating Dark World Dealings, the AI should
  -- look for and discard a Dark World monster if one
  -- exists in hand. If not, then discard another monster.
  --------------------------------------------------------
  if GlobalActivatedCardID == 74117290 then
     for i=1,#cards do
		if Get_Card_Count_ID(AIHand(),34230233,nil) > 0 then
		   GlobalActivatedCardID = nil
		  return Index_By_ID(cards,1,"Highest",TYPE_MONSTER, nil,"~=",34230233)
        end
     end
	 for i=1,#cards do
		if IsDiscardEffDWMonster(cards[i].id) == 1 then
          GlobalActivatedCardID = nil
		  return {i}
        end
     end
     for i=1,#cards do
        if bit32.band(cards[i].type,TYPE_MONSTER) > 0 then
           GlobalActivatedCardID = nil
		  return {i}
        end
      end
    end


  ----------------------------------------------------------
  -- When paying the banish cost of The Gates of Dark World,
  -- the AI should choose to banish something other than
  -- Grapha, Dragon Lord of Dark World.
  --
  -- To do: Restrict this to level 4 or lower monsters?
  ----------------------------------------------------------
  if GlobalActivatedCardID == 33017655 then
    if GlobalCardMode == 1 then
      GlobalCardMode = nil
      return Index_By_ID(cards, 1, "Lowest", nil, nil, "~=", 34230233)
      end
   end

  -------------------------------------------------
  -- When Snoww's effect activates 
  -- search The Gates of Dark World if
  -- the AI doesn't already control it or has it 
  -- in hand. Search Dark World Dealings if no
  -- Gates in hand, field, or deck. Otherwise add
  -- the highest ATK monster.
  -------------------------------------------------
  if triggeringID == 60228941 then -- Snoww, Unlight of Dark World
      if Get_Card_Count_ID(AIST(),33017655,POS_FACEUP) == 0 and
         Get_Card_Count_ID(AIHand(),33017655,nil) == 0 and 
         Get_Card_Count_ID(AIDeck(),33017655,nil) > 0  then 
			return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 33017655)
          end
        if Get_Card_Count_ID(AIDeck(),74117290,nil) > 0 then
		    return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 74117290)
        end
     local HighestAttack = 0
     local Index  = 1  
	 for i=1,#cards do
		if cards[i].attack > HighestAttack then
          HighestAttack = cards[i].attack
          Index = i
		  end
       end
      result[1] = Index
      return result
   end                                                        
  
  --------------------------------------------
  -- For Worm Xex's effect, the AI should look
  -- for and send Worm Yagan to the grave.
  --------------------------------------------
  if GlobalActivatedCardID == 11722335 then
     GlobalActivatedCardID = nil 
     return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 47111934)
    end


  -------------------------------------
  -- The AI should tribute a card other
  -- than Worm King for its effect!
  -------------------------------------
  if GlobalActivatedCardID == 10026986 then
    if GlobalCardMode == 1 then
       GlobalCardMode = nil
       return Index_By_ID(cards, 1, "Lowest", nil, nil, "~=", 10026986)
      end
   end
    
  -----------------------------------------------
  -- When "Worm Cartaros" is flipped AI should add Xex if
  -- possible. Otherwise add the first occurring
  -- monster (for now, anyway).
  -----------------------------------------------
  if triggeringID == 51043243 then -- Worm Cartaros
     return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 11722335) 
    end

  -----------------------------------------------
  -- If every selectable card is a "Battlin' Boxer"
  -- card, the activated Card ID isn't known, and
  -- the minimum and maximum targets are both 1 then it's most likely 
  -- "Battlin' Boxer Glassjaw's" add card effect, try to add 
  -- "Battlin' Boxer Switchitter" if possible.
  -----------------------------------------------
  if triggeringID == 05361647 then
     return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 68144350) -- Battlin' Boxer Switchitter
    end
 
  -----------------------------------------------
  -- The Gates of Dark World logic.
  -----------------------------------------------
  if GlobalActivatedCardID == 54031490 then   -- The Gates of Dark World	
	if Get_Card_Count_ID(AIHand(),83039729,nil) > 0 then
       GlobalActivatedCardID = nil
	  return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 65685470)
    end
    if Get_Card_Count_ID(AIHand(),02511717,nil) > 0 then
       GlobalActivatedCardID = nil
	  return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 01498130)
    end
    if Get_Card_Count_ID(AIHand(),01498130,nil) > 0 then
       GlobalActivatedCardID = nil
	  return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 02511717)
    end
    if Get_Card_Count_ID(AIHand(),49721904,nil) > 0 then
      GlobalActivatedCardID = nil
	  return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 01498130)
    end
    if Get_Card_Count_ID(AIHand(),27821104,nil) > 0 then
       GlobalActivatedCardID = nil
	  return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 61737116)
    end
	if Get_Card_Count_ID(AIHand(),65685470,nil) > 0 then 
       GlobalActivatedCardID = nil
	   return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 02511717)
      end
   end
  
  -----------------------------------------------
  -- Certain cards should discard the correct
  -- Dark World monster for the situation.
  -- If the opp controls a card, discard Grapha.
  -- If a monster, discard Kahkki. S/T, Gren.
  -- If no Gates in hand or field, Snoww.
  -- If not that, the first effective DW monster.
  -- Otherwise the first card found.
  -----------------------------------------------
  if GlobalActivatedCardID == 33017655 or   -- The Gates of Dark World
	 GlobalActivatedCardID == 93554166 and  -- Dark World Lightning          
	 GlobalCardMode == nil             or 
	 GlobalActivatedCardID == 74117290 or   -- Dark World Dealings
     GlobalActivatedCardID == 94283662 or   -- Trance Archfiend
	 GlobalActivatedCardID == 81439173 then   -- Foolish Burial   
	if Get_Card_Count(AIMon()) > 0 or Get_Card_Count(OppST()) > 0 then
       GlobalActivatedCardID = nil
	   return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 34230233)
     end
	if Get_Card_Count(OppMon()) > 0 then
       GlobalActivatedCardID = nil
	   return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 25847467)
     end
    if Get_Card_Count(OppST()) > 0 then 
       GlobalActivatedCardID = nil
	   return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 51232472)
     end
    if Get_Card_Count_ID(AIST(),33017655,POS_FACEUP) == 0 and
       Get_Card_Count_ID(AIHand(),33017655,nil) == 0 then
       GlobalActivatedCardID = nil
	   return Index_By_ID(cards, 1, "Highest", nil, nil, "==", 60228941)
     end
    for i=1,#cards do
      if IsDiscardEffDWMonster(cards[i].id) then
        GlobalActivatedCardID = nil
        return {i}
      end
    end
  end


  --------------------------------------------
  -- Reset these variable if it gets this far.
  --------------------------------------------
  GlobalActivatedCardID = nil
  GlobalCardMode = nil
  GlobalAIIsAttacking = false
  GlobalSSCardID = nil
  GlobalSSCardSetcode = nil
  
  -- Example implementation: always choose the mimimum amount of targets and select the index of the first available targets
  for i=1,minTargets do
        result[i]=i
  end


  for i=1,minTargets do
    ----print(result[i]..'')
  end


  return result 
end

