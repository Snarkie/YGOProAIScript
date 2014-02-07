--- OnSelectInitCommand() ---
--
-- Called when the system is waiting for the AI to play a card.
-- This is usually in Main Phase or Main Phase 2
-- 
--
-- Parameters (3):
-- cards = a table containing all the cards that the ai can use
-- 		cards.summonable_cards = for normal summon
-- 		cards.spsummonable_cards = for special special summon
-- 		cards.repositionable_cards = for changing position
-- 		cards.monster_setable_cards = monster cards for setting
-- 		cards.st_setable_cards = spells/traps for setting
-- 		cards.activatable_cards = for activating
-- to_bp_allowed = is entering battle phase allowed?
-- to_ep_allowed = is entering end phase allowed?
--
--[[
Each "card" object has the following fields:
card.id
card.original_id --original ----printed card id. Example: Elemental HERO Prisma can change id, but the original_id will always be 89312388
card.type --Refer to /script/constant.lua for a list of card types
card.attack
card.defense
card.base_attack
card.base_defense
card.level
card.base_level
card.rank
card.race --monster type
card.attribute
card.position
card.setcode --indicates the archetype
card.location --Refer to /script/constant.lua for a list of locations
card.xyz_material_count --number of material attached
card.xyz_materials --table of cards that are xyz material
card.owner --1 = AI, 2 = player
card.status --Refer to /script/constant.lua for a list of statuses
card:is_affected_by(effect_type) --Refer to /script/constant.lua for a list of effects
card:get_counter(counter_type) --Checks how many of counter_type this card has. Refer to /strings.conf for a list of counters

Sample usage

if card:is_affected_by(EFFECT_CANNOT_CHANGE_POSITION) then
	--this card cannot change position
end
if card:is_affected_by(EFFECT_CANNOT_RELEASE) then
	--this card cannot be tributed
end
if card:is_affected_by(EFFECT_DISABLE) or card:is_affected_by(EFFECT_DISABLE_EFFECT) then
	--this card's effect is currently negated
end

if card:get_counter(0x3003) > 0 then
	--this card has bushido counters
end

if(cards.activatable_cards[i].xyz_material_count > 0) then
local xyzmat = cards.activatable_cards[i].xyz_materials
	for j=1,#xyzmat do
		----print("material " .. j .. " = " .. xyzmat[j].id)
	end
end


-- Return:
-- command = the command to execute
-- index = index of the card to use
-- 
-- Here are the available commands
]]
COMMAND_LET_AI_DECIDE  = -1
COMMAND_SUMMON         = 0
COMMAND_SPECIAL_SUMMON = 1
COMMAND_CHANGE_POS     = 2
COMMAND_SET_MONSTER    = 3
COMMAND_SET_ST         = 4
COMMAND_ACTIVATE       = 5
COMMAND_TO_NEXT_PHASE  = 6
COMMAND_TO_END_PHASE   = 7


function OnSelectInitCommand(cards, to_bp_allowed, to_ep_allowed)
  
  ------------------------------------------
  -- The first time around, it sets the AI's
  -- turn (only if the AI is playing first).
  ------------------------------------------
  if GlobalAIPlaysFirst == nil then
    if Duel.GetTurnCount() == 1 then
      GlobalIsAIsTurn = 1
      GlobalAIPlaysFirst = 1
      Globals()
	  ResetOncePerTurnGlobals()
	 end
    end

  ---------------------------------------
  -- Don't do anything if the AI controls
  -- a face-up Light and Darkness Dragon.
  ---------------------------------------
  if Get_Card_Count_ID(AIMon(), 47297616, POS_FACEUP) > 0 then
    return COMMAND_TO_NEXT_PHASE,1
  end
  
  --------------------------------------------------
  -- Storing these lists of cards in local variables
  -- for faster access and gameplay.
  --------------------------------------------------
  local ActivatableCards = cards.activatable_cards
  local SummonableCards = cards.summonable_cards
  local SpSummonableCards = cards.spsummonable_cards
  local RepositionableCards = cards.repositionable_cards
  
  
  --------------------------------------------
  -- Activate Heavy Storm only if the opponent
  -- controls 2 more S/T cards than the AI.
  --------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 19613556 and
       Get_Card_Count(OppST()) >= Get_Card_Count(AIST()) + 2 then
      return COMMAND_ACTIVATE,i
    end
  end

  -------------------------------------
  -- Activate Mystical Space Typhoon if
  -- the opponent has any existing S/T.
  -------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 05318639 and
       Get_Card_Count(OppST()) > 0 then
	   GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
    end
  end
  
  ------------------------------------------
  -- Activate Dark Hole only if the opponent
  -- controls at least 2 more monsters than
  -- the AI.
  ------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 53129443 and
       Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") then
      return COMMAND_ACTIVATE,i
    end
  end
  

 -------------------------------------------------
-- **********************************************
--        Functions for specific decks
-- **********************************************
-------------------------------------------------

local DeckCommand = FireFistInit(cards, to_bp_allowed, to_ep_allowed)
if DeckCommand ~= nil then 
    return DeckCommand[1],DeckCommand[2]
end
DeckCommand = HeraldicOnSelectInit(cards, to_bp_allowed, to_ep_allowed)
if DeckCommand ~= nil then 
    return DeckCommand[1],DeckCommand[2]
end

  
-------------------------------------------------
-- **********************************************
--   Activate these cards before anything else :O
-- **********************************************
-------------------------------------------------

  -----------------------------------------------------
  -- Activate Hieratic Seal of Convocation 
  -- whenever it's possible.
  -----------------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 25377819 then  -- Hieratic Seal of Convocation
       GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
    end
  end  
  
  --------------------------------------------------
  -- Special Summon Hieratic Dragon of Tefnuit
  -- whenever it's possible.
  --------------------------------------------------  
  for i=1,#SpSummonableCards do 
    if SpSummonableCards[i].id == 77901552 then  -- Hieratic Dragon of Tefnuit
      return COMMAND_SPECIAL_SUMMON,i
    end
  end

  --------------------------------------------------
  -- Special Summon Hieratic Dragon of Su
  -- whenever possible, triggering the effect
  -- of other Hieratics
  --------------------------------------------------  
  for i=1,#SpSummonableCards do 
    if SpSummonableCards[i].id == 03300267 then  -- Hieratic Dragon of Su
      return COMMAND_SPECIAL_SUMMON,i
    end
  end
  
  ------------------------------------------
  -- Always activate the Mini Dragon Rulers'
  -- effects if in hand and if possible.
  ------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 27415516 or   -- Stream
       ActivatableCards[i].id == 53797637 or   -- Burner
       ActivatableCards[i].id == 89185742 or   -- Lightning
       ActivatableCards[i].id == 91020571 then -- Reactan
       GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
    end
  end
  
  ----------------------------------------------------
  -- Always try to turn a defense-position Tanngnjostr
  -- to attack position to trigger its effect.
  ----------------------------------------------------
  for i=1,#RepositionableCards do
    if RepositionableCards[i].id == 14677495 then
      if RepositionableCards[i].position == POS_FACEUP_DEFENCE or
         RepositionableCards[i].position == POS_FACEDOWN_DEFENCE then
         GlobalActivatedCardID = RepositionableCards[i].id
        return COMMAND_CHANGE_POS,i
      end
    end
  end
  
  -----------------------------------------
  -- Always try to summon Lead Yoke when possible
  -----------------------------------------
  for i=1,#SpSummonableCards do
    if SpSummonableCards[i].id == 23232295 then -- Battlin' Boxer Lead Yoke
		GlobalSSCardType = bit32.band(SpSummonableCards[i].type,TYPE_XYZ)
		GlobalSSCardID = SpSummonableCards[i].id
	   return COMMAND_SPECIAL_SUMMON,i
      end
   end
  
-------------------------------------------------
-- **********************************************
--            Spell card activation :D
-- **********************************************
-------------------------------------------------
  

    
  ----------------------------------
  -- Activate any search cards here.
  ----------------------------------
  for i=1,#ActivatableCards do
    if CardIsASearchCard(ActivatableCards[i].id) == 1 then
       GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
    end
  end

  -----------------------------------------------------
  -- If the AI controls a set Field Spell, activate it.
  -----------------------------------------------------
  for i=1,#ActivatableCards do
  if ActivatableCards[i].location == LOCATION_SZONE then 
	if ActivatableCards[i].type == TYPE_SPELL + TYPE_FIELD and
       ActivatableCards[i].position == POS_FACEDOWN then
       GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end

  -----------------------------------------------
  -- Activate The Gates of Dark World if there is
  -- a Fiend-type monster in the graveyard other
  -- than Grapha, Dragon Lord of Dark World.
  -----------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].location == LOCATION_SZONE then
      if ActivatableCards[i].type == TYPE_SPELL + TYPE_FIELD then
        if ActivatableCards[i].id == 33017655 then
          local AIGrave = AIGrave()
          for x=1,#AIGrave do
            if AIGrave[x].race == RACE_FIEND and
               AIGrave[x].id ~= 34230233 then
               GlobalActivatedCardID = ActivatableCards[i].id
               GlobalCardMode = 1
              return COMMAND_ACTIVATE,i
            end
          end
        end
      end
    end
  end

  -----------------------------------
  -- Activate a face-up field spell
  -- effect if possible.
  -----------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].location == LOCATION_SZONE then
      if ActivatableCards[i].type == TYPE_SPELL + TYPE_FIELD then
        if CardId == 33017655 then
           GlobalActivatedCardID = ActivatableCards[i].id
          return COMMAND_ACTIVATE,i
        end
      end
    end
  end
  
  ---------------------------------------------------------
  -- Set a field spell if the AI doesn't currently control
  -- a field spell (with the exception of Geartown).
  --
  -- Also, when given a choice, the AI should always choose
  -- to set Geartown before other field spells.
  ---------------------------------------------------------
  local AIField = AI.GetAISpellTrapZones()
  local AIFieldExists = 0
  for i=1,#AIField do
    if AIField[i] ~= false then
      if AIField[i].type == TYPE_SPELL + TYPE_FIELD then
        AIFieldExists = 1
      end
    end
  end
  if AIFieldExists == 0 or Get_Card_Count_ID(UseLists({AIMon(), AIST()}), 37694547, POS_FACEUP) > 0 then
    for i=1,#cards.st_setable_cards do
      if cards.st_setable_cards[i].id == 37694547 then
        return COMMAND_SET_ST,i
      end
    end
    for i=1,#cards.st_setable_cards do
      if cards.st_setable_cards[i].type == TYPE_FIELD + TYPE_SPELL and 
	    AIFieldExists == 0 then
        return COMMAND_SET_ST,i
      end
    end
  end     

  ------------------------------------------
  -- Activate Allure of Darkness only
  -- if the AI has cards in hand it can banish
  ------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 01475311 then	  
	  local DarkMonsters = Sort_List_By(AIHand(),nil,ATTRIBUTE_DARK,nil,">",TYPE_MONSTER)
      if Card_Count_From_List(BanishBlacklist,DarkMonsters,"~=") > 0 then
		GlobalActivatedCardID = ActivatableCards[i].id
        return COMMAND_ACTIVATE,i
      end
    end
  end
    
  ------------------------------------------------
  -- Activate Soul Exchange only in Main Phase 1
  -- and if the AI has a level 5+ monster in hand.
  ------------------------------------------------
  if AI.GetCurrentPhase() == PHASE_MAIN1 then
    for i=1,#ActivatableCards do
      if ActivatableCards[i].id == 68005187 then -- Soul Exchange
        local AIHand = AIHand()
		for x=1,#AIHand do
          if AIHand[x].level >= 5 and Get_Card_Count(AI.GetOppMonsterZones()) > 0 then
			if AIMonCountLowerLevelAndAttack(AIHand[x].level,AIHand[x].attack) +1 >= AIMonGetTributeCountByLevel(AIHand[x].level) and GlobalSummonedThisTurn == 0 then
			   GlobalActivatedCardID = ActivatableCards[i].id
               GlobalAdditionalTributeCount = GlobalAdditionalTributeCount + 1
			   GlobalSoulExchangeActivated = 1
			  return COMMAND_ACTIVATE,i
             end
           end
         end
       end
     end
   end

  ------------------------------------------------
  -- Activate Change of Heart only in Main Phase 1
  -- and if the AI has a level 5+ monster in hand.
  ------------------------------------------------
  if AI.GetCurrentPhase() == PHASE_MAIN1 then
    for i=1,#ActivatableCards do
      if ActivatableCards[i].id == 04031928 then
        local AIHand = AI.GetAIHand()
        for x=1,#AIHand do
          if AIHand[x] ~= false then
            if AIHand[x].level >= 5 then
              GlobalActivatedCardID = ActivatableCards[i].id
              return COMMAND_ACTIVATE,i
            end
          end
        end
      end
    end
  end

  -------------------------------------------------------------
  -- Activate Creature Swap only if the opponent and AI control
  -- 1 monster each, and the opponent's monster is stronger.
  -------------------------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 31036355 then
      if Get_Card_Count(AI.GetOppMonsterZones()) == 1 and Get_Card_Count(AIMon()) == 1 then
        if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") then
           GlobalActivatedCardID = ActivatableCards[i].id
          return COMMAND_ACTIVATE,i
        end
      end
    end
  end

  ----------------------------------------------------------
  -- Activate Monster Reincarnation only if the monster with
  -- the highest ATK in the AI's graveyard is stronger than
  -- the monsters in the AI's hand, and the AI has at least
  -- 1 monster in hand.
  --
  -- To do: Make an exception for Honest and other cards.
  ----------------------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 74848038 then
     if Get_Card_Count_ID(UseLists({AIMon(),AIST(),OppMon(),OppST()}), 47355498, POS_FACEUP) ==  0 then 
	  local AIHand = AIHand()
      local AIGrave = AIGrave()
      local GraveHighestATK = 0
      local HandHighestATK = 0
      for x=1,#AIGrave do
         if AIGrave[x].attack > GraveHighestATK then
            GraveHighestATK = AIGrave[x].attack
          end
       end
      for x=1,#AIHand do
         if AIHand[x].attack > HandHighestATK then
            HandHighestATK = AIHand[x].attack
          end
       end
     if GraveHighestATK > HandHighestATK then
        GlobalCardMode = 1
        GlobalActivatedCardID = ActivatableCards[i].id
        return COMMAND_ACTIVATE,i
       end
     end
   end
 end

  ---------------------------------------------
  -- Elf's Light, Shine Palace : activate only  
  -- if AI has one or more light attribute
  -- monster on the field. 
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 39897277 or ActivatableCards[i].id == 82878489 then -- Elf's Light, Shine Palace
    if Get_Card_Count_ATT(AIMon(),"==",ATTRIBUTE_LIGHT,POS_FACEUP) > 0 then
       GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end
 end   
  
  ---------------------------------------------
  -- Burning Spear: activate only if AI has one or more 
  -- fire attribute monster on the field 
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 18937875 then -- Burning Spear
    if Get_Card_Count_ATT(AIMon(),"==",ATTRIBUTE_FIRE,POS_FACEUP) > 0 then
       GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end   
 end    
   
  ---------------------------------------------
  -- 7 Completed, Break! Draw! :activate only  
  -- if AI has one or more machine race
  -- monster on the field. 
  ---------------------------------------------
   for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 86198326 or  -- 7 Completed
      ActivatableCards[i].id == 63851864 then -- Break! Draw!
    if Get_Card_Count_Race(AIMon(),"==",RACE_MACHINE,POS_FACEUP) > 0 then
       GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end   
 end  
  
  ---------------------------------------------
  -- Assault Armor: activate only if AI has one or more 
  -- warrior race monster on the field 
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 88190790 then -- Assault Armor
    if Get_Card_Count_Race(AIMon(),"==",RACE_WARRIOR,POS_FACEUP) > 0 then
       GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end     
 end  
  
  ---------------------------------------------
  -- Beast Fangs: activate only if AI has one or more 
  -- beast race monster on the field 
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 46009906 then -- Beast Fangs
    if Get_Card_Count_Race(AIMon(),"==",RACE_BEAST,POS_FACEUP) > 0 then
       GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end 
 end
  
  ---------------------------------------------
  -- Book of Secret Arts, Bound Wand: activate only  
  -- if AI has one or more machine race
  -- monster on the field. 
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 91595718 or -- Book of Secret Arts
      ActivatableCards[i].id == 53610653 then -- Bound Wand
    if Get_Card_Count_Race(AIMon(),"==",RACE_SPELLCASTER,POS_FACEUP) > 0 then
       GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end 
 end 
  
  ---------------------------------------------
  -- Activate Abyss-scale of Cetus, Abyss-scale of the Kraken, 
  -- Abyss-scale of the Mizuchi only if 
  -- AI controls 1 or more "Mermail" monster.
  --------------------------------------------- 
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 19596712 or -- Abyss-scale of Cetus
      ActivatableCards[i].id == 72932673 or -- Abyss-scale of the Mizuchi
      ActivatableCards[i].id == 08719957 then -- Abyss-scale of the Kraken      
    if Archetype_Card_Count(AIMon(), 7667828, POS_FACEUP) > 0 then
       GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end      
 end

 ---------------------------------------------
  -- Activate Core Blaster only if 
  -- AI controls 1 or more "Koa'ki Meiru" monster
  -- and Player controls any light or dark attribute monsters.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 59385322 then -- Core Blaster   
    if Archetype_Card_Count(AIMon(), 29, POS_FACEUP) > 0 then  
       GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end      
 end
 
  ---------------------------------------------
  -- Activate Amazoness Heirloom only if 
  -- AI controls 1 or more "Amazoness"  monster.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 79965360 then -- Amazoness Heirloom
    if Archetype_Card_Count(AIMon(), 4, POS_FACEUP) > 0 then  
       GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end   
 end   
 
  ---------------------------------------------
  -- Activate Ancient Gear Fist, Ancient Gear Tank only if 
  -- AI controls 1 or more "Ancient Gear"  monster.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 40830387 or -- Ancient Gear Fist
      ActivatableCards[i].id == 37457534 then -- Ancient Gear Tank
    if Archetype_Card_Count(AIMon(), 7, POS_FACEUP) > 0 then  
       GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end    
 end
  
  ---------------------------------------------
  -- Activate Amplifier only if 
  -- AI controls 1 or more "Jinzo" monster.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if Get_Card_Count_ID(AIST(),ActivatableCards[i].id, POS_FACEUP) == 0 then 
    if ActivatableCards[i].id == 00303660 then -- Amplifier 
     if Get_Card_Count_ID(UseLists({AIMon(),AIST()}),77585513, POS_FACEUP) > 0 then -- Jinzo      
        GlobalActivatedCardID = ActivatableCards[i].id
	   return COMMAND_ACTIVATE,i
      end
    end
  end   
end 
  
  ---------------------------------------------
  -- Activate Bubble Blaster only if 
  -- AI controls 1 or more "Elemental Hero Bubbleman" monster.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 53586134 then -- Bubble Blaster
    if Get_Card_Count_ID(UseLists({AIMon(),AIST()}),79979666, POS_FACEUP) > 0 then -- Elemental Hero Bubbleman      
       GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end  
 end
  
  ---------------------------------------------
  -- Activate Amulet of Ambition only if 
  -- AI controls 1 or more normal monsters.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 05183693 then -- Amulet of Ambition
    if Get_Card_Count_Type(AIMon(), TYPE_MONSTER, "==",POS_FACEUP) > 0 then      
       GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end      
 end
  
  ---------------------------------------------
  -- AI Will activate Bait Doll only if player
  -- has any spell or trap cards on the field
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 07165085 then -- Bait Doll
    if Get_Card_Count_Pos(OppST(), POS_FACEDOWN) > 0 then
       GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end 
  
  ---------------------------------------------
  -- Activate Buster Rancher only if 
  -- AI controls 1 or more monsters with attack points of
  -- 1000 or below.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 84740193 then -- Buster Rancher
    if Get_Card_Count_Att_Def(AIMon(), "<=", 1000, nil, POS_FACEUP) > 0 then      
       GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end      
 end
  
  ---------------------------------------------
  -- AI should activate: Broken Bamboo Sword, 
  -- Cursed Bill, Mask of the accursed, Flint 
  -- only if player has any face up attack position monsters on the field
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if Get_Card_Count_ID(AIST(),ActivatableCards[i].id, POS_FACEUP) == 0 then
    if ActivatableCards[i].id == 41587307 or -- Broken Bamboo Sword
       ActivatableCards[i].id == 46967601 or -- Cursed Bill
       ActivatableCards[i].id == 56948373 or -- Mask of the accursed  
       ActivatableCards[i].id == 75560629 then -- Flint 
     if Get_Card_Count_Pos(OppMon(), POS_FACEUP_ATTACK) > 0 then
        GlobalActivatedCardID = ActivatableCards[i].id
	   return COMMAND_ACTIVATE,i
      end
	end
  end
end
  
  ---------------------------------------------
  -- AI should activate: Armed Changer, Axe of Despair,
  -- Ballista of Rampart Smashing, Big Bang Shot, Black Pendant
  -- 
  -- only if he has any face up position monsters on the field
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 90374791 or -- Armed Changer
      ActivatableCards[i].id == 00242146 or -- Ballista of Rampart Smashing
      ActivatableCards[i].id == 61127349 or -- Big Bang Shot
      ActivatableCards[i].id == 65169794 or -- Black Pendant      
      ActivatableCards[i].id == 69243953 or -- Butterfly Dagger - Elma
	  ActivatableCards[i].id == 40619825 then -- Axe of Despair   
    if Get_Card_Count_Pos(AIMon(), POS_FACEUP) > 0 and SpSummonableCards[i] == nil and SummonableCards[i] == nil then
	   GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end
    
  ---------------------------------------------
  -- AI should activate: Germ Infection, Paralazying Poison 
  -- only if player has any face up monsters non machine race monsters on the field
  ---------------------------------------------
 for i=1,#ActivatableCards do  
  if Get_Card_Count_ID(AIST(),ActivatableCards[i].id, POS_FACEUP) == 0 then
    if ActivatableCards[i].id == 24668830 or -- Germ Infection
       ActivatableCards[i].id == 50152549 then -- Paralyzing Potion
	 if Get_Card_Count_Race(OppMon(),"~=",RACE_MACHINE,POS_FACEUP) > 0 then
        GlobalActivatedCardID = ActivatableCards[i].id
       return COMMAND_ACTIVATE,i
      end
	end
  end
end 
    
  ---------------------------------------------
  -- AI should activate: Chthonian Alliance, 
  -- only if player has face up monsters with same name 
  -- TODO: For now we will check for same id's
  ---------------------------------------------
  for i=1,#ActivatableCards do  
    if ActivatableCards[i].id == 46910446 then -- Chthonian Alliance 
     if MonCountSameID() > 0 then
       GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end
 end
  
  ---------------------------------------------
  -- AI should activate: Dark Core, 
  -- only if player has face up monsters with 1700 
  -- or more attack points.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 70231910 then -- Dark Core 
    if Get_Card_Count_Att_Def(OppMon(), ">=", 1700, nil, POS_FACEUP) > 0 then
       GlobalActivatedCardID = ActivatableCards[i].id
       GlobalCardMode = 1
	  return COMMAND_ACTIVATE,i
     end
   end
 end
   
  ---------------------------------------------
  -- AI should activate: Soul Release, 
  -- only if AI has 4 or more monster cards in graveyard
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 05758500 then -- Soul Release 
    if Get_Card_Count_Type(AIGrave(),TYPE_MONSTER,">",nil) >= 3 then
       GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end
 end
  
  ---------------------------------------------
  -- AI should activate: Cost Down, 
  -- only if AI has level 5 or 6 monster in hand
  ---------------------------------------------
   for i=1,#ActivatableCards do  
    if ActivatableCards[i].id == 23265313 and AI.GetCurrentPhase() == PHASE_MAIN1 then -- Cost Down
     local AIHand = AIHand()
      for x=1,#AIHand do
		if AIHand[x].level > 6 and Card_Count_Specified(AIHand, nil, nil, nil, nil, "<=", 4, nil, nil, nil) > 0 then
		  if AIMonCountLowerLevelAndAttack(AIHand[i].level,AIHand[i].attack) > 0 and GlobalSummonedThisTurn == 0 then
		    GlobalActivatedCardID = ActivatableCards[i].id
		    GlobalCostDownActivated = 1
		   return COMMAND_ACTIVATE,i
		   end
        end
	   for x=1,#AIHand do
		 if AIHand[x].level == 5 or AIHand[x].level == 6 and 
		    Card_Count_Specified(AIHand, nil, nil, nil, nil, "<=", 4, nil, nil, nil) > 0 then
		    GlobalActivatedCardID = ActivatableCards[i].id
		    GlobalCostDownActivated = 1
		   return COMMAND_ACTIVATE,i
          end
		end
      end
    end
  end 

  ---------------------------------------------
  -- AI should activate: Shrink, 
  -- only if AI's strongest monster's attack points are 
  -- lower than players strongest attack pos monster's points
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 55713623 then -- Shrink
    if Get_Card_Count_Pos(AIMon(), POS_FACEUP) > 0 then
	 if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") and 
	    Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") / 2 and 
	    Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") >= 1400 then
        GlobalActivatedCardID = ActivatableCards[i].id
       return COMMAND_ACTIVATE,i
      end
    end
  end
end
  
  ---------------------------------------------
  -- AI should activate: Megamorph, 
  -- only if AI's strongest monster's attack points are 
  -- 1500 or higher and AI's lp is lower than player's
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 22046459 then -- Megamorph
    if Get_Card_Count_Pos(AIMon(), POS_FACEUP) > 0 then
	 if AI.GetPlayerLP(1) < AI.GetPlayerLP(2) and Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") >= 1500 then
        GlobalActivatedCardID = ActivatableCards[i].id
       return COMMAND_ACTIVATE,i
      end
    end
  end
end
  
  ---------------------------------------------
  -- AI should activate: Enemy Controller, 
  -- only if AI's strongest monster's attack points are 
  -- lower than player's, and player's strongest monster's 
  -- def points are lower than AI's strongest monster's attack.
  ---------------------------------------------
 for i=1,#ActivatableCards do  
  if ActivatableCards[i].id == 98045062 then -- Enemy Controller
	if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") and 
	   Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(OppMon(), "attack", ">", POS_FACEUP_ATTACK, "defense") then
	   GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end
 end
  
  ---------------------------------------------
  -- AI should activate: The Flute of Summoning Dragon, 
  -- only if AI has any dragon type monsters in hand.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 43973174 then -- The Flute of Summoning Dragon
    if Get_Card_Count_Race(AIHand(),RACE_DRAGON,nil) > 0 then
       GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end
 end
    
  ---------------------------------------------
  -- AI should activate: Foolish Burial, if he 
  -- has "Grapha, Dragon Lord of Dark World" in deck.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 81439173 then -- Foolish Burial
    if Get_Card_Count_ID(AIDeck(),34230233,nil) > 0 then
	   GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end
  
  ---------------------------------------------
  -- AI should activate: Dark World Dealings,
  -- if he has any "Dark World" monsters in hand
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 74117290 then -- Dark World Dealings
    if Get_Card_Count_ID(AIHand(),34230233,nil) > 0 or Get_Card_Count_ID(AIHand(),33731070,nil) > 0
	or Get_Card_Count_ID(AIHand(),79126789,nil) > 0 or Get_Card_Count_ID(AIHand(),32619583,nil) > 0 then
       GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end
  
  ---------------------------------------------
  -- AI should activate: Dark World Lightning, 
  -- only if Player controls any face down cards.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 93554166 then -- Dark World Lightning
    if Get_Card_Count_Pos(OppMon(), POS_FACEDOWN) > 0 or Get_Card_Count_Pos(OppST(), POS_FACEDOWN) > 0 then
       GlobalCardMode = 1
	   GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end
  
  ---------------------------------------------
  -- AI should activate: Dragged Down into the Grave, 
  -- only if AI has no other cards then "Dark World" monsters in hand
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 16435215 then -- Dragged Down into the Grave
    if Card_Count_From_List(IsDiscardEffDWMonster,AIHand(),"~=") == 0 then
	   GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end
  
  ---------------------------------------------
  -- AI should activate: Card Destruction, 
  -- only if AI has no other spell or trap cards in hand.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 72892473 then -- Card Destruction
    if Get_Card_Count_Type(AIHand(), TYPE_TRAP, ">") == 0 and 
	   Get_Card_Count_Type(AIHand(), TYPE_SPELL, ">") == 0 then
	   GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end
         
  ---------------------------------------------
  -- AI should activate: Mystic Box, 
  -- only if AI has monster with 1400 attack or lower
  -- and opponent controls a strong monster. 
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 25774450 then -- Mystic Box
    if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") and 
	   Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") >= 2000 and Get_Card_Att_Def(OppMon(), "attack", ">", POS_FACEUP_ATTACK, "defense") <= 1400 then
	   GlobalCardMode = 1
	   GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end
  
  ---------------------------------------------
  -- AI should activate: Mage Power, 
  -- only if AI's monster can become stronger than
  -- any player's monster as result.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 83746708 then -- Mage Power
    if (Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") + 500 * (Get_Card_Count(AIST()) +1)) >= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") and
	    Get_Card_Count_Pos(AIMon(), POS_FACEUP) > 0 and SummonableCards[i] == nil and SpSummonableCards[i] == nil then 
	    GlobalActivatedCardID = ActivatableCards[i].id
	   return COMMAND_ACTIVATE,i
     end
   end
 end
  
  ---------------------------------------------
  -- AI should activate: Swords of Revealing Light, 
  -- only if AI has nothing to summon and player
  -- controls stronger monsters.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 72302403 or ActivatableCards[i].id == 58775978 then -- Swords of Revealing Light, Nightmare's Steelcage
    if Get_Card_Count_ID(UseLists({AIMon(),AIST()}),72302403, POS_FACEUP) == 0 and 
	   Get_Card_Count_ID(UseLists({AIMon(),AIST()}),58775978,POS_FACEUP) == 0 then  
      if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def_Pos(AIMon()) or 
         Get_Card_Count(AIMon()) == 0 and Get_Card_Count_Pos(AIMon(), POS_FACEUP_ATTACK) > 0 then
	     GlobalActivatedCardID = ActivatableCards[i].id
	    return COMMAND_ACTIVATE,i
       end
     end
   end
 end 
 
  ---------------------------------------------
  -- AI should activate: Card Destruction, 
  -- only if AI has no other spell or trap cards in hand.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 87880531 then -- Diffusion Wave-Motion
    if Card_Count_Specified(AIMon(), nil, nil, nil, nil, ">=", 7, RACE_SPELLCASTER, nil, nil) > 0 and 
	   ActivatableCards[i].attack > Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") and
	   Get_Card_Count(OppMon()) >= 2 then
	   GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end
  
  ---------------------------------------------
  -- AI should activate: Burnin' Boxin' Spirit, 
  -- if he has any "Battlin' Boxer" monsters on field
  -- or in hand.
  ---------------------------------------------          
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 36916401 then  -- Burnin' Boxin' Spirit
	if Archetype_Card_Count(AIHand(),132,nil) > 0 or 
	   Archetype_Card_Count(AIMon(),132,POS_FACEUP) > 0 then 
	   GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end
    	    
  ---------------------------------------------
  -- AI should activate: Black Illusion Ritual, 
  -- if opponent controls any cards.
  ---------------------------------------------      
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 41426869 then -- Black Illusion Ritual
      if Get_Card_Count(AI.GetOppMonsterZones()) > 0 then
        return COMMAND_ACTIVATE,i
      end
    end
  end
  
  ---------------------------------------------
  -- AI should activate: Toon World, Toon Kingdom
  -- if he doesn't control one of these cards already
  ---------------------------------------------   
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 15259703 or ActivatableCards[i].id == 500000090 then -- Toon World, Toon Kingdom
      if Get_Card_Count_ID(AIST(),15259703, POS_FACEUP) == 0 and Get_Card_Count_ID(AIST(),500000090, POS_FACEUP) == 0 then
		return COMMAND_ACTIVATE,i
      end
    end
  end
  
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 54031490 then -- Shien's Smoke Signal
      if Get_Card_Count_ID(AIHand(),83039729,nil) > 0 or 
         Get_Card_Count_ID(AIHand(),02511717,nil) > 0 or
		 Get_Card_Count_ID(AIHand(),01498130,nil) > 0 or
		 Get_Card_Count_ID(AIHand(),49721904,nil) > 0 or
		 Get_Card_Count_ID(AIHand(),27821104,nil) > 0 or
		 Get_Card_Count_ID(AIHand(),65685470,nil) > 0  then
		GlobalActivatedCardID = ActivatableCards[i].id
		return COMMAND_ACTIVATE,i
      end
    end
  end
    
  -- for i=1,#ActivatableCards do
    -- if ActivatableCards[i].id == 27970830 then -- Gateway of the Six
     -- if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") and 
	    -- Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") < GetAIMonstersHighestATK()+500 or
		-- Archetype_Card_Count(SetCode, AI.GetAIGraveyard(), AI.GetAIMainDeck())
   
-------------------------------------------------
-- **********************************************
--         Trap card activation :P
-- **********************************************
-------------------------------------------------
  
  ---------------------------------------------
  -- AI should activate: Zero Gravity, 
  -- only if Player is about to attack or attacked.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 83133491 then  -- Zero Gravity
    if Get_Card_Count_ID(UseLists({AIMon(),AIST()}), 83133491, POS_FACEUP) ==  0 and AI.GetCurrentPhase() == PHASE_DAMAGE and GlobalIsAIsTurn == 0 then
	   GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end
 end

  ---------------------------------------------
  -- AI should activate: Spellbinding Circle, 
  -- only if AI has no other spell or trap cards in hand.
  ---------------------------------------------
  for i=1,#ActivatableCards do   
   if ActivatableCards[i].id == 18807108 then -- Spellbinding Circle
    if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") and 
	   Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(OppMon()," attack", ">", POS_FACEUP_ATTACK, "defense") and 
	   Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") >= 1700 then
	   GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end
 
  ---------------------------------
  -- Activate Raigeki Break only if
  -- the opponent controls a card.
  ---------------------------------
  for i=1,#ActivatableCards do 
   if ActivatableCards[i].id == 04178474 then -- Raigeki B
     if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") or 
	    Get_Card_Count(OppST()) > 0 then
        GlobalActivatedCardID = ActivatableCards[i].id
        GlobalCardMode = 1
	   return COMMAND_ACTIVATE,i
      end
    end
  end	
  
  ---------------------------------------------
  -- AI should activate: Return from the Different Dimension,
  -- only if AI can bring out strong tribute monster as result, 
  -- or if player or AI has 0 monsters on the field (just in case)
  ---------------------------------------------
  for i=1,#ActivatableCards do
   if ActivatableCards[i].id == 27174286 then -- Return from the Different Dimension
   local AIHand = AIHand()
   local HandHighestATK = 0
   local Result = 0
  if AI.GetCurrentPhase() == PHASE_BATTLE and GlobalIsAIsTurn == 0 and 
     Get_Card_Count_Type(AIBanish(),TYPE_MONSTER,">",nil) >= 3 and Get_Card_Count(AIMon()) == 0 then 
   return 1,i
  end
 if AI.GetCurrentPhase() == PHASE_MAIN1 and Get_Card_Count_Type(AIBanish(),TYPE_MONSTER,">",nil) >= 3 and GlobalIsAIsTurn == 1 and Get_Card_Count(AIMon()) == 0 then	
  for x=1,#AIHand do
    if AIHand[x].attack > HandHighestATK then
       HandHighestATK = AIHand[x].attack       
      if AIHand[x].level >= 5 and
         HandHighestATK >= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") then
	      return COMMAND_ACTIVATE,i
	      end
        end
      end
    end
  end 
end
   
-------------------------------------------------
-- **********************************************
--       Monster card effect activation :B
-- **********************************************
-------------------------------------------------  
   
  -----------------------------------------------------
  -- Activate Lumina, Lightsworn Summoner's effect only
  -- if there's at least 1 level 5 or lower monster in
  -- hand to discard.
  -----------------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 95503687 then
      local AIHand = AIHand()
      for x=1,#AIHand do
        if AIHand[x].level <= 5 then
           GlobalCardMode = 1
           GlobalActivatedCardID = ActivatableCards[i].id
           return COMMAND_ACTIVATE,i
         end
       end
     end
   end
  
  
 ---------------------------------------------------
  -- Activate Chaos Sorcerer's effect if the opponent
  -- controls a stronger monster than the AI
  -- or if its Main Phase 2 and he has a faceup monster
  ---------------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 09596126 then
      if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") <= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack") or
       AI.GetCurrentPhase() == PHASE_MAIN2 and OppHasFaceupMonster(0) > 0 then
        GlobalActivatedCardID = ActivatableCards[i].id
        return COMMAND_ACTIVATE,i
      end
    end
  end
  
  
  ----------------------------------------------------------------------------------------
  -- Mecha Phantom Beast Dracossack: Actrivate it's effect 
  -- only if any "Mecha Phantom" tokens are on field, or if we can detach any xyz materials.
  ----------------------------------------------------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 22110647 then
     if ActivatableCards[i].xyz_material_count > 0 or Get_Card_Count_ID(UseLists({AIMon(),AIST()}),31533705, POS_FACEUP) > 0 or 
	    Get_Card_Count_ID(UseLists({AIMon(),AIST()}),22110648, POS_FACEUP) > 0 and 
	    Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") <= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") then
	    GlobalCardMode = 1  
	    GlobalActivatedCardID = ActivatableCards[i].id
	   return COMMAND_ACTIVATE,i
      end
    end
  end
  
  ----------------------------------------------------------
  -- Activate Lyla, Lightsworn Summoner's S/T destroy effect
  -- only if it hasn't already been attempted this turn.
  -- That's to prevent infinite loops from Skill Drain, etc.
  ----------------------------------------------------------
  if Global1PTLylaST ~= 1 then
    for i=1,#ActivatableCards do
      if ActivatableCards[i].id == 22624373 then
         Global1PTLylaST = 1
         GlobalActivatedCardID = ActivatableCards[i].id
        return COMMAND_ACTIVATE,i
      end
    end
  end

  ------------------------------------------------------------
  -- Activate Number 8: Heraldic King Genom-Heritage's effect
  -- only if it hasn't already been attempted this turn.
  -- Targeting an opponent's Genom-Heritage causes a potential
  -- infinite loop for the AI.
  ------------------------------------------------------------
  if Global1PTGenom ~= 1 then
    for i=1,#ActivatableCards do
      if ActivatableCards[i].id == 47387961 then
         Global1PTGenom = 1
         GlobalActivatedCardID = ActivatableCards[i].id
        return COMMAND_ACTIVATE,i
      end
    end
  end

  --------------------------------------------
  -- Activate Honest's "bounce to hand" effect
  -- only if the AI didn't already try to
  -- activate it already this turn.
  --------------------------------------------
  if Global1PTHonest ~= 1 then
	for i=1,#ActivatableCards do
      if ActivatableCards[i].id == 37742478 then
         Global1PTHonest = 1
         GlobalActivatedCardID = ActivatableCards[i].id
        return COMMAND_ACTIVATE,i
      end
    end
  end


  ------------------------------------------
  -- Activate Malefic Truth Dragon's special
  -- summon effect only if Skill Drain or a
  -- field spell is face-up.
  ------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 37115575 then
      if Get_Card_Count_ID(UseLists({AIMon(),AIST(),OppMon(),OppST()}), 82732705, POS_FACEUP) > 0 or 
	     Get_Card_Count_Type(UseLists ({AIST(),OppST()}), TYPE_FIELD + TYPE_SPELL, "==", POS_FACEUP) > 0 then
        GlobalActivatedCardID = ActivatableCards[i].id
        return COMMAND_ACTIVATE,i
      end
    end
  end
  
    --------------------------------------------------------
  -- Activate Trance Archfiend's discard effect only if
  -- the AI has an appropriate Dark World monster in hand.
  --------------------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 94283662 then
      local AIHand = AI.GetAIHand()
      for x=1,#AIHand do
        if IsDiscardEffDWMonster(AIHand[x].id) then
           GlobalActivatedCardID = ActivatableCards[i].id
          return COMMAND_ACTIVATE,i
        end
      end
    end
  end

  ---------------------------------------------
  -- Activate Worm King's effect only if the AI
  -- controls a "Worm" monster other than King
  -- and the opponent controls at least 1 card.
  ---------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 10026986 then
      if Get_Card_Count(OppMon()) > 0 or Get_Card_Count(OppST()) > 0 then
        local AIMons = AIMon()
        for x=1,#AIMons do
          if AIMons[x].id ~= 10026986 and
             AIMons[x].setcode == 62 then
             GlobalActivatedCardID = ActivatableCards[i].id
             GlobalCardMode = 1
            return COMMAND_ACTIVATE,i
           end
         end
       end
     end
   end
  
  -----------------------------------------------------
  -- Activate BLS Envoy's banish effect if the opponent
  -- controls a stronger monster than the AI
  -- or if its Main Phase 2 and he has any monster
  -----------------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 72989439 then
      if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") <= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") or 
         AI.GetCurrentPhase() == PHASE_MAIN2 and Get_Card_Count(AI.GetOppMonsterZones()) > 0 
      then
        GlobalActivatedCardID = ActivatableCards[i].id
        return COMMAND_ACTIVATE,i
      end
    end
  end
  
  ---------------------------------------------
  -- AI should activate:  Cocoon of Evolution, 
  -- only if AI controls face up Petit Moth.
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 40240595 then  -- Cocoon of Evolution
	if Get_Card_Count_ID(UseLists({AIMon(),AIST()}),58192742,POS_FACEUP) > 0 and  
	   Get_Card_Count_ID(UseLists({AIMon(),AIST()}),40240595,POS_FACEUP) ==  0 then -- Petit Moth	 
	   GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end
 end
 
  ---------------------------------------------
  -- AI should activate: Number 61: Volcasaurus effect only if 
  -- Player controls stronger monster than any of AI's
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 29669359 then -- Number 61: Volcasaurus
	if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") then 
	   GlobalActivatedCardID = ActivatableCards[i].id
	   GlobalCardMode = 1
	  return COMMAND_ACTIVATE,i
     end
   end
 end 
 
  ---------------------------------------------
  -- AI should activate: Breaker the Magical Warrior's 
  -- effect only if opponent controls any spell or trap cards
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 71413901 then  -- Breaker the Magical Warrior
    if Get_Card_Count(OppST()) > 0 then
	   GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end
 end
 
  ---------------------------------------------
  -- AI should activate: Kuriboh's effect only if
  -- his about to take 1500 or more points of battle damage
  ---------------------------------------------
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 40640057 then  -- Kuriboh
    if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") - Get_Card_Att_Def(AIMon(),attack,">",POS_FACEUP_ATTACK,attack) >= 1500 then
	   return COMMAND_ACTIVATE,i
      end
    end
  end
 
  ---------------------------------------------
  -- AI should activate: Summoner Monk, 
  -- only if AI has "Battlin' Boxer Switchitter"
  -- in deck.
  ---------------------------------------------  
  for i=1,#ActivatableCards do  
    if ActivatableCards[i].id == 00423585 then  -- Summoner Monk
    if Get_Card_Count_ID(AIDeck(),68144350,nil) > 0 then -- Battlin' Boxer Switchitter
       GlobalCardMode = 1
      GlobalActivatedCardID = ActivatableCards[i].id
      return COMMAND_ACTIVATE,i
     end
   end
 end
 
  ---------------------------------------------
  -- AI should activate: Lavalval Chain, 
  -- only if AI has "Battlin' Boxer Glassjaw"
  -- in deck.
  --------------------------------------------- 
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 34086406 then  -- Lavalval Chain
    if Get_Card_Count_ID(AIDeck(),05361647,nil) > 0 then -- Battlin' Boxer Glassjaw
       GlobalCardMode = 1
	   GlobalActivatedCardID = ActivatableCards[i].id
	  return COMMAND_ACTIVATE,i
     end
   end
 end
 
   ---------------------------------------------
  -- AI should activate: Gagaga Gunman, 
  -- only if opponent has face up card's on field
  -- and "Spar" wasn't special summoned this turn
  ---------------------------------------------  
  for i=1,#ActivatableCards do  
   if ActivatableCards[i].id == 12014404 then  -- Gagaga Gunman
	if Global1PTSparSSed ~= 1 and Get_Card_Count_Pos(OppMon(), POS_FACEUP) > 0 
  or AI.GetPlayerLP(2)<=800
  then  
	   GlobalActivatedCardID = ActivatableCards[i].id
	   Global1PTGunman = 1
	  return COMMAND_ACTIVATE,i
     end
   end
 end
 
  -------------------------------------------------------  
  -- AI should activate "Exiled Force" if players
  -- strongest attack position monster has more attack points than AI's.
  -------------------------------------------------------
   for i=1,#ActivatableCards do  
	if ActivatableCards[i].id == 74131780 then -- Exiled Force
      if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") and 
	     Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") >= 1900 then
		 GlobalActivatedCardID = ActivatableCards[i].id
		return COMMAND_ACTIVATE,i
       end
     end
   end
 
  -------------------------------------------------------  
  -- AI should activate "Fabled Raven","The Cheerful Coffin" 
  -- if AI has any "Dark world" monsters in hand.
  -------------------------------------------------------
   for i=1,#ActivatableCards do  
	if ActivatableCards[i].id == 47217354 or ActivatableCards[i].id == 41142615 then -- Fabled Raven
      if Archetype_Card_Count(AIHand(),6,nil) > 0 then
	     GlobalActivatedCardID = ActivatableCards[i].id
		return COMMAND_ACTIVATE,i
       end
     end
   end
   
  -------------------------------------------------------
  -- AI should activate "Constellar Kaust" if players
  -- strongest attack position monster has more attack points than AI's.
  -------------------------------------------------------
 for i=1,#ActivatableCards do  
	if ActivatableCards[i].id == 70908596 then -- Constellar Kaust
	  if Card_Count_Specified(AIMon(), nil, nil, nil, "==", 5, nil, 83, nil, nil) > 1 or 
	     Card_Count_Specified(AIMon(), nil, nil, nil, "==", 6, nil, 83, nil, nil) > 0 and  
	     Card_Count_Specified(AIMon(), nil, nil, nil, "==", 5, nil, 83, nil, nil) > 0 then
	   if GlobalKaustActivated == nil or 
		  Card_Count_Specified(AIMon(), nil, nil, nil, "==", 6, nil, 83, nil, nil) > 0 or 
		  Get_Card_Count_ID(AIMon(), 70908596, POS_FACEUP) > 1 then 
		  GlobalActivatedCardID = ActivatableCards[i].id
		  return COMMAND_ACTIVATE,i
         end
       end
     end
   end
   for i=1,#ActivatableCards do  
	if ActivatableCards[i].id == 70908596 then -- Constellar Kaust
	  if Card_Count_Specified(AIMon(), nil, nil, POS_FACEUP, "==", 4, nil, 83, 3, nil) > 0 or
	     Card_Count_Specified(AIMon(), nil, nil, POS_FACEUP, "==", 5, nil, 83, 3, nil) > 0 and
		 Card_Count_Specified(AIMon(), nil, nil, POS_FACEUP, "==", 4, nil, 83, 3, nil) > 0 then
		 GlobalActivatedCardID = ActivatableCards[i].id
		return COMMAND_ACTIVATE,i
       end
     end
   end
   
  -------------------------------------------------------
  -- AI should activate "Constellar Siat" if players
  -- strongest attack position monster has more attack points than AI's.
  -------------------------------------------------------
   for i=1,#ActivatableCards do  
	 if ActivatableCards[i].id == 44635489 then -- Constellar Siat
	  if Card_Count_Specified(UseLists({AIMon(),AIGrave()}),nil,nil,nil, "==", 6, nil, 83, nil, nil) > 0 and 
	     Card_Count_Specified(AIMon(),nil,nil,nil, "==", 6, nil, 83, nil, nil) > 0 or 
	     Card_Count_Specified(UseLists({AIMon(),AIGrave()}),nil,nil,nil, "==", 5, nil, 83, nil, nil) > 0 and 
	     Card_Count_Specified(AIMon(),nil,nil,nil, "==", 5, nil, 83, nil, nil) > 0 or 
	     Card_Count_Specified(UseLists({AIMon(),AIGrave()}),nil,nil,nil, "==", 4, nil, 83, nil, nil) > 0 and 
	     Card_Count_Specified(AIMon(),nil,nil,nil, "==", 4, nil, 83, nil, nil) > 0 then
		 GlobalActivatedCardID = ActivatableCards[i].id
		return COMMAND_ACTIVATE,i
       end
     end
   end
   
  ------------------------------------------
  -- Activate "Constellar Ptolemy M7"
  -- if the AI has boss monsters in the graveyard
  -- or the enemy has a stronger monster
  ------------------------------------------
  for i=1,#ActivatableCards do
   if ActivatableCards[i].id == 38495396 then  
     if Card_Count_From_List(BanishBlacklist, AIGrave(),"==") > 0 or 
	    Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") >= Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") then
        GlobalCardMode = 1
       return COMMAND_ACTIVATE,i
      end
    end
  end
  
  ------------------------------------------
  -- Activate "Constellar Pleiades"
  -- if the enemy has a stronger monster
  ------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 73964868 then  
	  if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") >= Get_Card_Att_Def(AIMon(),"defense",">",POS_FACEUP,"defense") then
         GlobalActivatedCardID = ActivatableCards[i].id
         GlobalCardMode = 1
        return COMMAND_ACTIVATE,i
      end
    end
  end
  
  -----------------------------------------------------
  -- Activate Plaguespreader Zombie only, if a synchro 
  -- summon can be performed.
  -----------------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 33420078 then
      if Get_Card_Count_ID(AIGrave(),09411399,nil) > 0 and Cards_Available(AIExtra(), TYPE_SYNCHRO, 8) > 0 -- can activate Destiny Hero - Malicious to perform a lvl 8 synchro
      and (Get_Card_Count_ID(AIDeck(),09411399,nil) > 0 or Get_Card_Count_ID(AIHand(),09411399,nil) > 0)  -- (if he is in hand, the effect of Plaguespreader will put him back into the deck)
      then                                                              
        GlobalActivatedCardID = ActivatableCards[i].id
        return COMMAND_ACTIVATE,i
      end
      local AIMons=AIMon()
      for j=1,#AIMons do
        if bit32.band(AIMons[j].position,POS_FACEUP)> 0 then
          local lvl = AIMons[j].level
          if Cards_Available(AIExtra(),TYPE_SYNCHRO,AIMons[j].level+2) > 0 then
            GlobalActivatedCardID = ActivatableCards[i].id
            return COMMAND_ACTIVATE,i
          end
        end
      end
    end
  end
  
   -----------------------------------------------------
  -- Activate Destiny Hero - Malicious only, if a lvl
  -- 6 monster or a tuner is faceup on the field
  -----------------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 09411399 then
      local AIMons=AI.GetAIMonsterZones()
      for j=1,#AIMons do
        if AIMons[j] and bit32.band(AIMons[j].position,POS_FACEUP)> 0 and
          (AIMons[j].level == 6 or bit32.band(AIMons[j].type,TYPE_TUNER)>0) then
          GlobalActivatedCardID = ActivatableCards[i].id
          return COMMAND_ACTIVATE,i
        end
      end
    end
  end
  
  -----------------------------------------------------
  -- Activate Gauntlet Launcher, if the opponent has monsters
  -----------------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 15561463 then
      if Get_Card_Count(AI.GetOppMonsterZones()) > 0 then
        GlobalActivatedCardID = ActivatableCards[i].id
        return COMMAND_ACTIVATE,i
      end
    end
  end

  ------------------------------------------
  -- Activate Dark Armed Dragon only, if the
  -- player has backrow or stronger monsters
  -- than the AI and the AI has non-boss DARK 
  -- monsters in the graveyard
  ------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 65192027 then
      local DarkMonsters = Sort_List_By(AIGrave(),nil,ATTRIBUTE_DARK,nil,">",TYPE_MONSTER)
	  if (Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") >= Get_Card_Att_Def_Pos(AIMon()) or
        Get_Card_Count(OppST()) > 0) and Card_Count_From_List(BanishBlacklist,DarkMonsters,"~=") > 0 
      then
        GlobalActivatedCardID = ActivatableCards[i].id
        GlobalCardMode = 1
        return COMMAND_ACTIVATE,i
      end
    end
  end
  
  ------------------------------------------
  -- Activate Dark Grepher only if the AI has 
  -- non-boss DARK monsters in hand
  ------------------------------------------
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 14536035 then
      local DarkMonsters = Sort_List_By(AIHand(),nil,ATTRIBUTE_DARK,nil,">",TYPE_MONSTER)
	  if Card_Count_From_List(BanishBlacklist,DarkMonsters,"~=") > 0 then
        GlobalActivatedCardID = ActivatableCards[i].id
        GlobalCardMode = 2
        return COMMAND_ACTIVATE,i
      end
    end
  end
  
  ---------------------------------------------
  -- AI should activate: Relinquished, 
  -- if opponent controls any cards.
  ---------------------------------------------      
  for i=1,#ActivatableCards do
    if ActivatableCards[i].id == 64631466 then -- Relinquished
      if Get_Card_Count(AI.GetOppMonsterZones()) > 0 then
         GlobalActivatedCardID = ActivatableCards[i].id
		return COMMAND_ACTIVATE,i
      end
    end
  end
   
   
  ---------------------------------------------------------
  -- ***************************************************** 
  -- Activate anything else that isn't scripted above
  -- *****************************************************
  ---------------------------------------------------------
  for i=1,#ActivatableCards do
   if Get_Card_Count_ID(AIST(),ActivatableCards[i].id, POS_FACEUP) == 0 then
    if (isUnactivableWithNecrovalley(ActivatableCards[i].id) == 1 and Get_Card_Count_ID(UseLists({AIMon(),AIST(),OppMon(),OppST()}), 47355498, POS_FACEUP) ==  0) or
	   isUnactivableWithNecrovalley(ActivatableCards[i].id) == 0 then -- Check if card shouldn't be activated when Necrovalley is on field 
	if ActivatableCards[i].type ~= TYPE_SPELL + TYPE_FIELD then                  
	  if CardIsScripted(ActivatableCards[i].id) == 0 then -- Check if card's activation is already scripted above
		  GlobalActivatedCardID = ActivatableCards[i].id
		  return COMMAND_ACTIVATE,i
          end
        end
      end
    end
  end
  
  -----------------------------------------------------
  -- Temporarily increase the ATK of monster cards that
  -- either have built-in ATK boosts while attacking or
  -- are affected that way by another card.
  -----------------------------------------------------
  ApplyATKBoosts(RepositionableCards)

  
-------------------------------------------------
-- **********************************************
-- Cards whose position should be changed before 
-- summoning/special summoning >_>
-- **********************************************
-------------------------------------------------
  
  --------------------------------------------------
  -- If AI will be able to XYZ summon a monster, turn required material monsters 
  -- to face up position if they are face down on the field
  --------------------------------------------------   
	for i=1,#RepositionableCards do
	  if ChangePosToXYZSummon(cards, SummonableCards, RepositionableCards) == 1 then -- Check if any XYZ can be summoned
		if RepositionableCards[i].position == POS_FACEDOWN_DEFENCE then -- Only change position of face down monsters
		  if isMonLevelEqualToRank(RepositionableCards[i].level,RepositionableCards[i].id) == 1 then -- Check if monster's level is equal to XYZ monsters rank        
		  return COMMAND_CHANGE_POS,i
         end
       end
     end
   end  
  
  -----------------------------------------------------
  -- Flip up Ryko only if the opponent controls a card.
  -----------------------------------------------------
  for i=1,#RepositionableCards do
    if RepositionableCards[i].id == 21502796 then
      if RepositionableCards[i].position == POS_FACEDOWN_DEFENCE then
        if Get_Card_Count(AI.GetOppMonsterZones()) > 0 or Get_Card_Count(OppST()) > 0 then
          return COMMAND_CHANGE_POS,i
         end
       end
     end
   end

  -------------------------------------------
  -- Flip up Swarm of Locusts if the opponent
  -- controls a Spell or Trap card.
  -------------------------------------------
  for i=1,#RepositionableCards do
    if RepositionableCards[i].id == 41872150 then
      if RepositionableCards[i].position == POS_FACEDOWN_DEFENCE then
        if Get_Card_Count(OppST()) > 0 then
          return COMMAND_CHANGE_POS,i
        end
      end
    end
  end

  -------------------------------------------
  -- Flip up certain monsters if the opponent
  -- controls a Monster.
  -------------------------------------------
  for i=1,#RepositionableCards do
    if RepositionableCards[i].id == 15383415 or   -- Swarm of Scarabs
       RepositionableCards[i].id == 54652250 or   -- Man-Eater Bug
	   RepositionableCards[i].id == 52323207 then -- Golem Sentry
      if RepositionableCards[i].position == POS_FACEDOWN_DEFENCE then
        if Get_Card_Count(OppST()) > 0 then
          return COMMAND_CHANGE_POS,i
        end
      end
    end
  end

  --------------------------------------
  -- Always flip up certain set monsters
  -- regardless of the situation.
  --------------------------------------
  for i=1,#RepositionableCards do
    if RepositionableCards[i].id == 02326738 or   -- Des Lacooda
       RepositionableCards[i].id == 03510565 or   -- Stealth Bird
       RepositionableCards[i].id == 33508719 or   -- Morphing Jar
	   RepositionableCards[i].id == 44811425 then -- Worm Linx
	  if RepositionableCards[i].position == POS_FACEDOWN_DEFENCE then
        return COMMAND_CHANGE_POS,i
      end
    end
  end
  
-------------------------------------------------
-- **********************************************
--          Card Special summoning ^_^
-- **********************************************
-------------------------------------------------
  
  --------------------------------------------------
  -- Special Summon a Malefic monster if and only if
  -- there's a face-up field spell or Skill Drain.
  --------------------------------------------------
  if Get_Card_Count_ID(UseLists({AIMon(),AIST(),OppMon(),OppST()}), 82732705, POS_FACEUP) > 0 or 
     Get_Card_Count_Type(UseLists ({AIST(),OppST()}), TYPE_FIELD + TYPE_SPELL, "==", POS_FACEUP) > 0 then
    for i=1,#SpSummonableCards do
      if SpSummonableCards[i].id == 01710476 then -- Sin End
        return COMMAND_SPECIAL_SUMMON,i
      end
    end
    for i=1,#SpSummonableCards do
      if SpSummonableCards[i].id == 00598988 then -- Sin Bow
        return COMMAND_SPECIAL_SUMMON,i
      end
    end
    for i=1,#SpSummonableCards do
      if SpSummonableCards[i].id == 09433350 then -- Sin Blue
        return COMMAND_SPECIAL_SUMMON,i
      end
    end
    for i=1,#SpSummonableCards do
      if SpSummonableCards[i].id == 36521459 then -- Sin Dust
        return COMMAND_SPECIAL_SUMMON,i
      end
    end
    for i=1,#SpSummonableCards do
      if SpSummonableCards[i].id == 55343236 then -- Sin Red
        return COMMAND_SPECIAL_SUMMON,i
      end
    end
  end


  ----------------------------------------------------
  -- Xyz Summon Leviair the Sea Dragon only if there's
  -- a Level 4 or lower monster currently banished.
  ----------------------------------------------------
  for i=1,#SpSummonableCards do
    if SpSummonableCards[i].id == 95992081 then
      local AIBanished = AI.GetAIBanished()
      local OppBanished = AI.GetOppBanished()
      for i=1,#AIBanished do
        if AIBanished[i] ~= false then
          if AIBanished[i].level <= 4 then
            return COMMAND_SPECIAL_SUMMON,i
          end
        end
      end
      for i=1,#OppBanished do
        if OppBanished[i] ~= false then
          if OppBanished[i].level <= 4 then
            return COMMAND_SPECIAL_SUMMON,i
          end
        end
      end
    end
  end

  -----------------------------------------
  -- Special Summon Number 11: Big Eye only
  -- if the opponent controls a monster.
  -----------------------------------------
  for i=1,#SpSummonableCards do
    if SpSummonableCards[i].id == 80117527 then
      if Get_Card_Count(AI.GetOppMonsterZones()) > 0 then
        return COMMAND_SPECIAL_SUMMON,i
      end
    end
  end

  -------------------------------------------------------  
  -- AI should summon Perfectly Ultimate Great Moth only if he 
  -- controls cocoon of evolution  at it's 6th stage of evolution.
  -------------------------------------------------------
  for i=1,#SpSummonableCards do   
	if SpSummonableCards[i].id == 48579379 then -- Perfectly Ultimate Great Moth.
	 if Get_Card_Count_ID(UseLists({AIMon(),AIST()}), 40240595, POS_FACEUP) > 0 and GlobalCocoonTurnCount >= 6 then -- Cocoon of Evolution     
	   return COMMAND_SPECIAL_SUMMON,i
      end
    end
  end
  
  -----------------------------------------
  -- Special Summon: Grapha, Dragon Lord of Dark World
  -- if AI controls weaker monster.
  -----------------------------------------
  for i=1,#SpSummonableCards do
    if SpSummonableCards[i].id == 34230233 then -- Grapha, Dragon Lord of Dark World
      if Get_Card_Att_Def(OppMon(), "attack", ">", POS_FACEUP_ATTACK, "defense") < SpSummonableCards[i].attack then
        SpSummonedCardID = SpSummonableCards[i].id
		return COMMAND_SPECIAL_SUMMON,i
      end
    end
  end
    
  -------------------------------------------------------  
  -- AI should summon "Constellar Pollux" if he
  -- has any "Constellar" monsters in hand
  -------------------------------------------------------
  for i=1,#SpSummonableCards do
	if SpSummonableCards[i].id == 70908596 then -- Constellar Kaus
	   if Archetype_Card_Count(AIMon(),83,POS_FACEUP) > 0 then 
		return COMMAND_SPECIAL_SUMMON,i
        end
      end
    end
    
  -----------------------------------------------------
  -- Summon "Ghost Ship" if valid monsters can be banished
  -----------------------------------------------------
  for i=1,#SpSummonableCards do
    if SpSummonableCards[i].id == 33347467 then -- Ghost Ship
	  if Card_Count_From_List(BanishBlacklist, AIGrave(),"~=") > 0 then
		GlobalActivatedCardID = SpSummonableCards[i].id
		return COMMAND_SPECIAL_SUMMON,i
        end
      end
    end
  
  --------------------------------------------------
  -- Special Summon: Lavalval Chain if AI controls
  -- "Battlin' Boxer Switchitter" and "Summoner Monk"
  --------------------------------------------------
  for i=1,#SpSummonableCards do
    if SpSummonableCards[i].id == 34086406 then -- Lavalval Chain
      if Get_Card_Count_ID(UseLists({AIMon(),AIST()}),00423585,POS_FACEUP) > 0 and Get_Card_Count_ID(UseLists({AIMon(),AIST()}),68144350,POS_FACEUP) > 0 then
		return COMMAND_SPECIAL_SUMMON,i
      end
    end
  end
  
  -----------------------------------------
  -- Set Global1PTSparSSed variable to 1 when spar is special summoned
  -----------------------------------------
  for i=1,#SpSummonableCards do
    if SpSummonableCards[i].id == 32750341 then -- Battlin' Boxer Spar
        Global1PTSparSSed = 1 
		return COMMAND_SPECIAL_SUMMON,i
      end
   end
  
  -------------------------------------------------------  
  -- Gaia Dragon, the Thunder Charger
  -------------------------------------------------------
  for i=1,#SpSummonableCards do   
    if SpSummonableCards[i].id == 91949988 then -- Gaia Dragon, the Thunder Charger
      if AIXyzMonsterMatCount(5,0) > 0 or AIXyzMonsterMatCount(6,0) > 0 then
         GlobalActivatedCardID = id
		return COMMAND_SPECIAL_SUMMON,i
      end
    end
  end
  
  --------------------------------------------------
  -- Special summon Dark Grepher only, if there
  -- are non-boss lvl 5+ DARK cards in your hand
  --------------------------------------------------  
    for i=1,#SpSummonableCards do
      local id = SpSummonableCards[i].id
      if id == 14536035 then          --Dark Grepher
        local DarkMonsters = Sort_List_By(AIHand(),nil,ATTRIBUTE_DARK,nil,">",TYPE_MONSTER)
        for j=1,#DarkMonsters do
          if DarkMonsters[j].level > 5 and BanishBlacklist(DarkMonsters[j].id) == 0 then
            GlobalActivatedCardID = id
            return COMMAND_SPECIAL_SUMMON,i
          end
        end
      end
    end
  
  --------------------------------------------------
  -- Summon Chaos monsters only, if there are
  -- valid targets to banish. For summoning 
  -- Lightpulsar Dragon from the grave, 
  -- check the hand instead
  --------------------------------------------------
    for i=1,#SpSummonableCards do
      local id = SpSummonableCards[i].id
      if id == 72989439 or id == 09596126 or id == 99365553 -- BLS, Chaos Sorcerer, Lightpulsar Dragon
      then 
        local cards = AI.GetAIGraveyard()
        if id == 99365553 and SpSummonableCards[i].location == LOCATION_GRAVE then
          cards = AI.GetAIHand()
        end
        local DarkMonsters = Sort_List_By(cards,nil,ATTRIBUTE_DARK,nil,">",TYPE_MONSTER)
        local LightMonsters = Sort_List_By(cards,nil,ATTRIBUTE_LIGHT,nil,">",TYPE_MONSTER)
        if Card_Count_From_List(BanishBlacklist,DarkMonsters,"~=") > 0 and Card_Count_From_List(BanishBlacklist,LightMonsters,"~=") > 0 then		  
		  GlobalActivatedCardID = id
          GlobalCardMode = 2
          if id == 99365553 and SpSummonableCards[i].location == LOCATION_GRAVE then
            GlobalCardMode = 4
          end
          return COMMAND_SPECIAL_SUMMON,i
        end
      end
    end
  
  --------------------------------------------------
  -- Special Summon Red-Eyes Darkness Metal Dragon
  -- only, if there are valid targets to banish
  --------------------------------------------------   
    for i=1,#SpSummonableCards do
      if SpSummonableCards[i].id == 88264978 then     -- Red-Eyes Darkness Metal Dragon       		
		local dragons = Sort_List_By(AIMon(),nil,nil,RACE_DRAGON,">",TYPE_MONSTER)
        if Card_Count_From_List(BanishBlacklist,dragons,"~=") > 0 then         
			GlobalActivatedCardID = SpSummonableCards[i].id
	    GlobalCardMode = 1
            return COMMAND_SPECIAL_SUMMON,i
        end
      end
    end
    
  -------------------------------------------------------  
  -- Constellar Ptolemy M7 74168099
  -------------------------------------------------------
  for i=1,#SpSummonableCards do   
	if SpSummonableCards[i].id == 38495396 then -- Constellar Ptolemy M7  
	  local AIMons = AIMon()
       local Result = 0
        for x=1,#AIMons do
          if bit32.band(AIMons[x].type,TYPE_XYZ)> 0 and AIMons[x].setcode == 83 and AIMons[x].xyz_material_count == 0 then
		  PtolemySSMode = 2
		  GlobalSSCardID = SpSummonableCards[i].id
		  return COMMAND_SPECIAL_SUMMON,i
          end
       end
    end
    for i=1,#SpSummonableCards do   
	 if SpSummonableCards[i].id == 38495396 then -- Constellar Ptolemy M7   
	  local AIMons = AIMon()
       local Result = 0
		if Get_Card_Count_Level(AIMon(), 6, "==", POS_FACEUP)  >= GetXYZRequiredMatCount()
    and (not HasID(AIMon(),74168099) or AI.GetCurrentPhase() == PHASE_MAIN2) then
		  PtolemySSMode = 1
		  GlobalSSCardID = SpSummonableCards[i].id
		  return COMMAND_SPECIAL_SUMMON,i
          end
        end
      end
    end
  
  -------------------------------------------------------
  -- *************************************************
  -- XYZ and Synchro summon all cards not specified above
  -- *************************************************
  -------------------------------------------------------   
   for i=1,#SpSummonableCards do
	 CalculatePossibleSummonAttack(SpSummonableCards)
	  if SpSummonableCards[i].rank > 0 and SpecialSummonBlacklist(SpSummonableCards[i].id) == 0 then 
	   if SpSummonableCards[i].id ~= 38495396 then
		if AIMonOnFieldMatCount(SpSummonableCards[i].rank) >= GetXYZRequiredMatCount() then 
		  GlobalSSCardLevel = SpSummonableCards[i].level
          GlobalSSCardAttack = SpSummonableCards[i].attack
		  GlobalSSCardType = bit32.band(SpSummonableCards[i].type,TYPE_XYZ)
		  GlobalSSCardID = SpSummonableCards[i].id
		   return COMMAND_SPECIAL_SUMMON,i
           end
         end
       end
     end

  -------------------------------------------------------
  -- "Toon" monster tribute summoning logic
  -------------------------------------------------------   
   for i=1,#SpSummonableCards do	  
	 if SpSummonableCards[i].setcode == 4522082 or SpSummonableCards[i].setcode == 98 then
	  if SpSummonableCards[i].level >= 5 and NormalSummonBlacklist(SpSummonableCards[i].id) == 0 and 
	   (AIMonCountLowerLevelAndAttack(SpSummonableCards[i].level,SpSummonableCards[i].attack) + GlobalAdditionalTributeCount) >= AIMonGetTributeCountByLevel(SpSummonableCards[i].level) then
        if SpSummonableCards[i].type ~= TYPE_MONSTER + TYPE_EFFECT + TYPE_FLIP and 
           (SpSummonableCards[i].attack >= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") and SpSummonableCards[i].attack > Get_Card_Att_Def(OppMon(), attack, ">", POS_FACEUP_ATTACK, defense)) or 
		   CanChangeOutcome(cards, SpSummonableCards, cards.activatable_cards) == 1 then   
		  GlobalSSCardSetcode = SpSummonableCards[i].setcode
		  GlobalSSCardLevel = SpSummonableCards[i].level
		  GlobalSSCardAttack = SpSummonableCards[i].attack
		  GlobalAdditionalTributeCount = GlobalAdditionalTributeCount-1
		  return COMMAND_SPECIAL_SUMMON,i
          end
        end
      end
    end
 	 
  ---------------------------------------------------
  -- *************************************************
  -- Special Summon anything else not specified above
  -- *************************************************
  ---------------------------------------------------
  for i=1,#SpSummonableCards do
    if SpSummonableCards[i].rank <= 0 or SpSummonableCards[i].rank == nil then
      if (SpSummonableCards[i].setcode ~= 4522082 and SpSummonableCards[i].setcode ~= 98) or SpSummonableCards[i].level < 5 then 
        if SpecialSummonBlacklist(SpSummonableCards[i].id)==0 then
          return COMMAND_SPECIAL_SUMMON,i
        end
      end
    end
  end  
  
  
-------------------------------------------------
-- **********************************************
--       Normal summon and set cards D:
-- **********************************************
-------------------------------------------------
  
  -------------------------------------------
  -- Set trap cards in Main Phase 1 if
  -- AI has "Cardcar D" in hand.
  -------------------------------------------
  if #cards.st_setable_cards > 0 and Get_Card_Count_ID(AIHand(),45812361,nil) > 0 then
    local setCards = cards.st_setable_cards
    for i=1,#setCards do
      if bit32.band(setCards[i].type,TYPE_TRAP) > 0 or bit32.band(setCards[i].type,TYPE_SPELL) > 0 then
        return COMMAND_SET_ST,i
      end
    end
  end

  -------------------------------------------
  -- Try to summon monster who requires a tribute
  -- when "Soul Exchange" is activated.
  -------------------------------------------
  if GlobalSoulExchangeActivated == 1 then
   for i=1,#SummonableCards do
	 CalculatePossibleSummonAttack(SummonableCards)
	   if SummonableCards[i].level >= 5 and NormalSummonBlacklist(SummonableCards[i].id) == 0 and 
	     (AIMonCountLowerLevelAndAttack(SummonableCards[i].level,SummonableCards[i].attack) + GlobalAdditionalTributeCount) >= AIMonGetTributeCountByLevel(SummonableCards[i].level) then
        if SummonableCards[i].type ~= TYPE_MONSTER + TYPE_EFFECT + TYPE_FLIP and 
           (SummonableCards[i].attack >= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") and SummonableCards[i].attack > Get_Card_Att_Def(OppMon(), "attack", ">", POS_FACEUP_ATTACK, "defense")) or 
		   CanChangeOutcome(cards, SummonableCards, cards.activatable_cards) == 1 then   
		   GlobalActivatedCardLevel = SummonableCards[i].level
           GlobalActivatedCardAttack = SummonableCards[i].attack
		   GlobalSummonedCardID = SummonableCards[i].id
		   GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		   GlobalSoulExchangeActivated = 0
		  return COMMAND_SUMMON,i
        end
      end
    end
  end  
  
  -------------------------------------------
  -- Summon monster of level 6 or 5 when 
  -- "Cost Down" is activated
  -------------------------------------------
  if GlobalCostDownActivated == 1 then 
   for i=1,#SummonableCards do
	 if SummonableCards[i].base_level == 6 or SummonableCards[i].base_level == 5 then   
	   GlobalCostDownActivated = 0
	   GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
	    return COMMAND_SUMMON,i
        end
      end
    end
  
  --------------------------------------------
  -- AI should always summon "Cardcar D" 
  -- if he has a backrow.
  --------------------------------------------
  for i=1,#SummonableCards do
    if SummonableCards[i].id == 45812361 then -- Cardcar D
     if Get_Card_Count(AIST()) > 1 then
	    GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
	   return COMMAND_SUMMON,i
      end
    end
  end
  
  --------------------------------------------
  -- Certain monsters are best normal summoned
  -- when the opponent controls Spells/Traps.
  --------------------------------------------
  for i=1,#SummonableCards do
    if SummonableCards[i].id == 71413901 or   -- Breaker
       SummonableCards[i].id == 22624373 then -- Lyla
      if Get_Card_Count(OppST()) > 0 then
        GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SUMMON,i
      end
    end
  end

  --------------------------------------------
  -- Certain monsters are best normal summoned
  -- when the opponent controls Spells/Traps.
  --------------------------------------------
  for i=1,#SummonableCards do
    if SummonableCards[i].id == 71413901 or   -- Breaker
       SummonableCards[i].id == 22624373 then -- Lyla
      if Get_Card_Count(OppST()) > 0 then
        GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SUMMON,i
      end
    end
  end

  -------------------------------------------------------  
  -- Synchron Explorer should only be summoned when there
  -- is a Synchron tuner monster in the graveyard.
  -------------------------------------------------------
  for i=1,#SummonableCards do
    if SummonableCards[i].id == 36643046 then
      local AIGrave = AI.GetAIGraveyard()
      for x=1,#AIGrave do
        if IsSynchronTunerMonster(AIGrave[x].id) then
          GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		  return COMMAND_SUMMON,i
        end
      end
    end
  end

  -------------------------------------------------------  
  -- AI should summon Zaborg the Thunder Monarch only if
  -- player controls any monsters.
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 51945556 then -- Zaborg the Thunder Monarch.
	  if Get_Card_Count(AI.GetOppMonsterZones()) > 0 and AIMonCountLowerLevelAndAttack(SummonableCards[i].level,SummonableCards[i].attack) + GlobalAdditionalTributeCount >= 
	     AIMonGetTributeCountByLevel(SummonableCards[i].level) then
		 GlobalActivatedCardID = SummonableCards[i].id
         GlobalActivatedCardAttack = SummonableCards[i].attack
         GlobalActivatedCardLevel = SummonableCards[i].level
		 GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SUMMON,i
       end
     end
   end
  
  -------------------------------------------------------  
  -- AI should summon Caius the Shadow Monarch only if
  -- player controls any cards.
  -------------------------------------------------------
  for i=1,#SummonableCards do   
    if SummonableCards[i].id == 09748752 then -- Caius the Shadow Monarch
      if Get_Card_Count(AI.GetOppMonsterZones()) + Get_Card_Count(OppST()) > 0 and 
         AIMonCountLowerLevelAndAttack(SummonableCards[i].level,SummonableCards[i].attack) +
         GlobalAdditionalTributeCount >= AIMonGetTributeCountByLevel(SummonableCards[i].level) then
         GlobalActivatedCardID = SummonableCards[i].id
         GlobalActivatedCardAttack = SummonableCards[i].attack
         GlobalActivatedCardLevel = SummonableCards[i].level
         GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SUMMON,i
      end
    end
  end
  
  -------------------------------------------------------  
  -- AI should summon Lord of D. if he can use The Flute of Summoning Dragon
  -- to summon dragon type monster to the field.
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 17985575 then -- Lord of D.
     if Get_Card_Count_ID(UseLists({AIMon(),AIHand(),AIST()}), 43973174, nil) > 0 then -- The Flute of Summoning Dragon
        GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
	   return COMMAND_SUMMON,i
      end
    end
  end
  
  -------------------------------------------------------  
  -- AI should summon Tour Guide From the Underworld if he
  -- has any level 3 fiend type monsters in deck or hand.
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 10802915 then -- Tour Guide From the Underworld
	 if Card_Count_Specified(AI.GetAIMainDeck(), AI.GetAIHand(), nil, nil, nil, "==", 3, RACE_FIEND, nil, nil) > 0 then
        GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
	   return COMMAND_SUMMON,i
      end
    end
  end
  
  -------------------------------------------------------  
  -- AI should summon Winged Kuriboh if he
  -- has no monsters on field, and player has attack position monsters on field
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 57116033 then -- Winged Kuriboh
     if Get_Card_Count_Pos(OppMon(), POS_FACEUP) > 0 and Get_Card_Count(AIMon()) == 0 then
        GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
	   return COMMAND_SET_MONSTER,i
      end
    end
  end
  
  -------------------------------------------------------  
  -- AI should always summon "Summoner Monk" instead of setting.
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 00423585 then -- Summoner Monk
       GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SUMMON,i
       end
     end 
  
  -------------------------------------------------------  
  -- AI should summon Winged "Fabled Raven" if he
  -- has any "Dark world" monsters in hand
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 47217354 then -- Fabled Raven
       if Archetype_Card_Count(AIHand(),6,nil) > 0 then 
		GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
	    return COMMAND_SUMMON,i
        end
      end
    end
  
  -------------------------------------------------------  
  -- AI should summon "Battlin' Boxer Headgeared" if he
  -- has "Battlin' Boxer Glassjaw" in deck and "Battlin' Boxer Switchitter" in hand.
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 79867938 then -- Battlin' Boxer Headgeared
      if Get_Card_Count_ID(AIDeck(),05361647,nil) > 0 and Get_Card_Count_ID(AIHand(),68144350,nil) > 0 then -- Battlin' Boxer Glassjaw, Battlin' Boxer Switchitter 
		GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SUMMON,i
       end
     end
   end
   
  -------------------------------------------------------
	-- AI should normal summon Battlin' Boxer Switchitter
	-- if he has a Battlin' Boxer monster in his graveyard,
	-- and Battlin' Boxer Lead Yoke in his extra deck.
	-------------------------------------------------------
	for i = 1,#SummonableCards do
		if SummonableCards[i].id == 68144350 then
			local AIGrave = AI.GetAIGraveyard()
			local AIExDeck = AI.GetAIExtraDeck()
			for j = 1,#AIGrave do
				if bit32.band(AIGrave[j].type,TYPE_MONSTER) > 0 and AIGrave[j].setcode == 132 then
					for k = 1,#AIExDeck do
						if AIExDeck[k].id == 23232295 then
							GlobalSummonedThisTurn = GlobalSummonedThisTurn + 1
							return COMMAND_SUMMON,i
						end
					end
				end
			end
		end
	end
    
  -------------------------------------------------------  
  -- AI should summon "Exiled Force" if players
  -- strongest attack position monster has more attack points than AI's.
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 74131780 then -- Exiled Force
      if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") and Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") >= 1900 then
		GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SUMMON,i
       end
     end
   end
  
  -------------------------------------------------------  
  -- AI should summon "Neo-Spacian Grand Mole" if player
  -- controls any level 4+ or XYZ type monsters.
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 80344569 then -- Neo-Spacian Grand Mole
     local OppMon = AI.GetOppMonsterZones() 
	  for x=1,#OppMon do
       if OppMon[x] ~= false then
		if OppMon[x].level > 4 or OppMon[x].rank > 0 then	
		 return COMMAND_SUMMON,i
         end
       end
     end
   end
 end
 
  -------------------------------------------------------  
  -- AI should summon "Constellar Pollux" if he
  -- has any "Constellar" monsters in hand
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 78364470 then -- Constellar Pollux
	   if Archetype_Card_Count(AIHand(),83,nil) -1 > 0 and Global1PTPollux == nil or 
	   AIArchetypeMonNotID(83, 78364470) == 0 then 
		Global1PTPollux = 1
		GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SUMMON,i
        end
      end
    end
  
  -------------------------------------------------------  
  -- AI should summon "Constellar Algiedi" if he
  -- has any "Constellar" monsters in hand
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 41269771 then -- Constellar Algiedi
       ----print("Archetype_Card_Count",Archetype_Card_Count(AIHand(),83,nil) )
	   if Archetype_Card_Count(AIHand(),83,nil) -1 > 0 then 
		GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		GlobalActivatedCardID = SummonableCards[i].id
		return COMMAND_SUMMON,i
        end
      end
    end
  
  -------------------------------------------------------  
  -- AI should summon "Constellar Kaus" if he
  -- has any "Constellar" monsters on field
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 70908596 then -- Constellar Kaus
       if Archetype_Card_Count(AIMon(),83,POS_FACEUP) > 0 then 
		GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SUMMON,i
        end
      end
    end
  
  -------------------------------------------------------  
  -- AI should summon "Constellar Siat" if he
  -- controls level 5 or 6 "Constellar" monster.
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 78364470 then -- Constellar Siat
       if Card_Count_Specified(UseLists({AIMon(),AIGrave()}), nil, nil, nil, "==", 6, nil, 83, nil, nil) > 0 and 
	      Card_Count_Specified(AIMon(), nil, nil, nil, "==", 6, nil, 83, nil, nil) > 0 or 
		  Card_Count_Specified(UseLists({AIMon(),AIGrave()}), nil, nil, nil, "==", 5, nil, 83, nil, nil) > 0 and 
		  Card_Count_Specified(AIMon(), nil, nil, nil, "==", 5, nil, 83, nil, nil) > 0 then 
		GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SUMMON,i
        end
      end
    end
  
  -------------------------------------------------------  
  -- AI should summon "Constellar Sheratan" if he
  -- has specified monster in deck.
  -------------------------------------------------------
  for i=1,#SummonableCards do   
	if SummonableCards[i].id == 78486968 then -- Constellar Sheratan
       if Get_Card_Count_ID(AIDeck(),78364470,nil) > 0 or Get_Card_Count_ID(AIDeck(),70908596,nil) > 0 or Get_Card_Count_ID(AIDeck(),41269771,nil) > 0 then 
		GlobalActivatedCardID = SummonableCards[i].id
		GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SUMMON,i
        end
      end
    end
  
  -------------------------------------------------------  
  -- AI should normal summon Plaguespreader Zombie 
  -- if a synchro summon can be performed
  -- Otherwise, let normal summoning logic handle it
  -------------------------------------------------------
  for i=1,#SummonableCards do   
    if SummonableCards[i].id == 33420078 then -- Plaguespreader Zombie
      if Get_Card_Count_ID(AIGrave(),09411399,nil) >0 and Get_Card_Count_ID(AIDeck(),09411399,nil) > 0 -- can activate Destiny Hero - Malicious to perform a lvl 8 synchro
      and Cards_Available(AIExtra(), TYPE_SYNCHRO, 8) > 0
      then 
        GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SUMMON,i
	  end
      local AIMons=AI.GetAIMonsterZones()
      for j=1,#AIMons do
        if AIMons[j] and bit32.band(AIMons[j].position,POS_FACEUP)> 0 then
          local lvl = AIMons[j].level
          if Cards_Available(AIExtra(),TYPE_SYNCHRO,AIMons[j].level+2) > 0 then
            GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
			return COMMAND_SUMMON,i
          end
        end
      end
    end
  end
  
  -------------------------------------------------------
  -- Venus should be summoned if AI can bring out stronger monster to the field 
  -------------------------------------------------------
  for i=1,#SummonableCards do
    if SummonableCards[i].id == 64734921 then -- The Agent of Creation - Venus
      local AIHand = AIHand()
      local HandHighestATK = 0
      for x=1,#AIHand do
        if AIHand[x].attack > HandHighestATK then
         HandHighestATK = AIHand[x].attack       
        if AIHand[x].level >= 5 and
         HandHighestATK > Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") then 
          if Get_Card_Count_ID(AIHand(),39552864,nil) > 0 or   -- Mystical Shine Ball
             Get_Card_Count_ID(AIDeck(),39552864,nil) > 0 then -- Mystical Shine Ball                 
             GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
			return COMMAND_SUMMON,i
           end
         end
       end
     end
   end
 end
	
  -------------------------------------------------------
  -- *****************************************************
  --        General tribute summoning logic
  -- *****************************************************
  -------------------------------------------------------   
  ---------------------
  -- Summoning
  ---------------------
   for i=1,#SummonableCards do	  
	   CalculatePossibleSummonAttack(SummonableCards)
	   if SummonableCards[i].level >= 5 and NormalSummonBlacklist(SummonableCards[i].id) == 0 and 
	     (AIMonCountLowerLevelAndAttack(SummonableCards[i].level,SummonableCards[i].attack) + GlobalAdditionalTributeCount) >= AIMonGetTributeCountByLevel(SummonableCards[i].level) then
        if SummonableCards[i].type ~= TYPE_MONSTER + TYPE_EFFECT + TYPE_FLIP and 
          (SummonableCards[i].attack >= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") and
		   SummonableCards[i].attack > Get_Card_Att_Def(OppMon(), attack, ">", POS_FACEUP_ATTACK, defense)) or 
		   CanChangeOutcome(cards, SummonableCards, cards.activatable_cards) == 1 then   
		   GlobalActivatedCardLevel = SummonableCards[i].level
           GlobalActivatedCardAttack = SummonableCards[i].attack
		   GlobalSummonedCardID = SummonableCards[i].id
		   GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		   GlobalAdditionalTributeCount = GlobalAdditionalTributeCount-1
		  return COMMAND_SUMMON,i
        end
      end
    end
  ---------------------
  -- Setting
  ---------------------
   for i=1,#SummonableCards do
       CalculatePossibleSummonAttack(SummonableCards)
	   if SummonableCards[i].level >= 5 and NormalSummonBlacklist(SummonableCards[i].id) == 0 and
	      AIMonCountLowerLevelAndAttack(SummonableCards[i].level,SummonableCards[i].attack) >= AIMonGetTributeCountByLevel(SummonableCards[i].level) then
         if SummonableCards[i].type == TYPE_MONSTER + TYPE_EFFECT + TYPE_FLIP or 
           (SummonableCards[i].attack < Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") and 
		    SummonableCards[i].defense >= GetAIMonstersHighestATK()) and 
		    CanChangeOutcome(cards, SummonableCards, cards.activatable_cards) == 0 then   
		    GlobalActivatedCardLevel = SummonableCards[i].level
            GlobalActivatedCardAttack = SummonableCards[i].attack
		    GlobalSummonedCardID = SummonableCards[i].id
		    GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		    GlobalAdditionalTributeCount = GlobalAdditionalTributeCount-1
		   return COMMAND_SET_MONSTER,i
         end
       end   
	 end 

  -------------------------------------------------------
  -- *****************************************************
  --       General normal summoning and setting logic 
  -- *****************************************************
  -------------------------------------------------------   
  -- Normal Summon a monster if it has a higher ATK
  -- than any of the opponent's attack position
  -- monsters, or if the AI controls other monsters. 
  --  
  -- Certain monsters should not usually be normal
  -- summoned, such as Ancient Gear Gadjiltron
  -- Dragon, Tragoedia and Gorz.
  --------------------------------------------------  
  for i=1,#SummonableCards do
    if SummonableCards[i].id ~= 31305911 and          -- Marshmallon
       SummonableCards[i].id ~= 23205979 and          -- Spirit Reaper
       SummonableCards[i].id ~= 62892347 and          -- A.F. The Fool
       SummonableCards[i].id ~= 12538374 and          -- Treeborn Frog
       SummonableCards[i].id ~= 15341821 and          -- Dandylion
       SummonableCards[i].id ~= 41872150 then         -- Locusts
	  if NormalSummonBlacklist(SummonableCards[i].id) == 0 and SummonableCards[i].level < 5 then
        if NormalSummonWhitelist(SummonableCards[i].id) == 1 and SummonableCards[i].level < 5 then          
		   GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		  return COMMAND_SUMMON,i
         end
       end
     end
      
	  -----------------------------------------------------------------------
      -- Check if monster isn't of a flip effect type, and has more attack points
      -- than player's strongest monster, or if any actions can be takes to increase strength of summonable monster,
	  -- or if any XYZ monsters can be special summoned as result, and Summon or Set monster depending on result.
	  -----------------------------------------------------------------------
	 for i=1,#SummonableCards do
	  if NormalSummonBlacklist(SummonableCards[i].id) == 0 and 
	  SummonableCards[i].type ~= TYPE_MONSTER + TYPE_EFFECT + TYPE_FLIP and SummonableCards[i].level < 5 then
		if SummonableCards[i].attack >= SummonableCards[i].defense and SummonableCards[i].attack ~= 0 
		or Get_Card_Count_Pos(OppMon(), POS_FACEUP) == 0 and SummonableCards[i].attack ~= 0 then
          if SummonableCards[i].attack >= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") or 
		   CanChangeOutcome(cards, SummonableCards, cards.activatable_cards) == 1 then
		   GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
			return COMMAND_SUMMON,i
            end
          end
        end
      end
    end
  
  ---------------------------------------------------
  -- If an in-hand monster has a flip effect, set it.
  ---------------------------------------------------
  if #cards.monster_setable_cards > 0 then
    for i=1,#cards.monster_setable_cards do
      if cards.monster_setable_cards[i].level < 5 and cards.monster_setable_cards[i].type == TYPE_MONSTER + TYPE_EFFECT + TYPE_FLIP then
        GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SET_MONSTER,i
      end
    end
  end
  
  --------------------------------------
  -- If it gets this far, set a monster.
  --------------------------------------
  -- if Get_Card_Count(AIMon()) == 0 then -- AI was limited to set monster only when he had none, instead of building up defence, why ?
    for i=1,#cards.monster_setable_cards do
      if NormalSummonBlacklist(cards.monster_setable_cards[i].id) == 0 then
       if cards.monster_setable_cards[i].level < 5 then
		  GlobalSummonedThisTurn = GlobalSummonedThisTurn+1
		return COMMAND_SET_MONSTER,i
      end
    end
  end
 
-------------------------------------------------
-- **********************************************
--         Card position changing :)
-- **********************************************
-------------------------------------------------
 
  --------------------------------------------------
  -- Flip "Constellar Kaust" to attack position if AI
  -- controls any other "Constellar" monster
  --------------------------------------------------
  for i=1,#RepositionableCards do  
   if RepositionableCards[i] ~= false then
    if RepositionableCards[i].id ==  70908596 and -- Constellar Kaust
	   RepositionableCards[i].position == POS_FACEDOWN_DEFENCE then 
     if Archetype_Card_Count(AIMon(),83,POS_FACEUP) > 0 then 
	   return COMMAND_CHANGE_POS,i
       end 
     end
   end 
 end 
  
  --------------------------------------------------
  -- Flip any level 4+ face down "Constellar" monster
  -- if AI has "Constellar Kaust" on field.
  --------------------------------------------------
  for i=1,#RepositionableCards do  
   if RepositionableCards[i] ~= false then
    if RepositionableCards[i].setcode == 83 and RepositionableCards[i].level >= 4 and 
	   RepositionableCards[i].position == POS_FACEDOWN_DEFENCE then
     if Get_Card_Count_ID(AIMon(), 70908596, nil) > 0 then -- Constellar Kaust
	   return COMMAND_CHANGE_POS,i
       end 
     end
   end 
 end 
  
  --------------------------------------------------
  -- Flip any "Toon" monster to attack position if AI
  -- controls "Toon World" or "Toon Kingdom".
  --------------------------------------------------
  for i=1,#RepositionableCards do  
   if RepositionableCards[i] ~= false then
    if isToonUndestroyable(RepositionableCards) == 1 then 
	  if RepositionableCards[i].position == POS_FACEUP_DEFENCE or
         RepositionableCards[i].position == POS_FACEDOWN_DEFENCE then   
	   return COMMAND_CHANGE_POS,i
       end 
     end
   end 
 end  
  
  --------------------------------------------------
  -- Always change "Maiden with Eyes of Blue" to
  -- attack position if possible.
  --------------------------------------------------
  for i=1,#RepositionableCards do  
   if RepositionableCards[i] ~= false then
    if RepositionableCards[i].id == 88241506 and -- Maiden with Eyes of Blue	
       RepositionableCards[i].position == POS_FACEUP_DEFENCE then
	   return COMMAND_CHANGE_POS,i
       end 
     end
   end 
  
  --------------------------------------------------
  -- If AI's monster has less attack than the
  -- opponent's strongest monster, turn it to defence position.
  --------------------------------------------------
    for i=1,#RepositionableCards do	  
	  if RepositionableCards[i].position == POS_FACEUP_ATTACK then      
        if RepositionableCards[i].id ~= 88241506 and  -- Maiden with Eyes of Blue	
		   RepositionableCards[i].id ~= 23232295 then -- Battlin' Boxer Lead Yoke	
		 if RepositionableCards[i].attack < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack") and RepositionableCards[i].attack < 2400 and 
		    isToonUndestroyable(RepositionableCards) == 0 then
		  return COMMAND_CHANGE_POS,i
         end
       end
     end
   end
  
  --------------------------------------------------
  -- If the AI controls a monster with higher attack
  -- than strongest players monster, or if AI controls 
  -- monster with higher attack than players strongest defence position monster and attack position 
  -- monster, turn him to attack position.
  --------------------------------------------------  
  for i=1,#RepositionableCards do
   if RepositionableCards[i].attack > 0 then
    if RepositionableCards[i].attack >= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") and Get_Card_Count_Pos(OppMon(), POS_FACEUP_ATTACK) > 0 or
       RepositionableCards[i].attack > Get_Card_Att_Def(OppMon(),"defense",">",POS_FACEUP_DEFENCE,"defense") and  
       RepositionableCards[i].attack >= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack") or 
	   RepositionableCards[i].attack < Get_Card_Att_Def(OppMon(), "attack", ">", POS_FACEUP_DEFENCE, "attack") and 
	   RepositionableCards[i].attack > Get_Card_Att_Def(OppMon(),"attack", ">", POS_FACEUP_DEFENCE, "defense") and
	   Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP_ATTACK,"attack") > Get_Card_Att_Def(OppMon(), "attack", ">", POS_FACEUP_DEFENCE, "defense") then
	  if RepositionableCards[i].position == POS_FACEUP_DEFENCE or
         RepositionableCards[i].position == POS_FACEDOWN_DEFENCE then
		  return COMMAND_CHANGE_POS,i
         end
       end
     end 
   end
 
 --------------------------------------------------
 -- If the AI controls a monster with higher attack,
 -- than any of the opponent's monsters, 
 -- and opponent controls one or less monsters in attack position, 
 -- turn as many monsters as we can to attack position.
 --------------------------------------------------  
 local ChangePosOK = 0
 local AIMons = AI.GetAIMonsterZones()  
  for i=1,#AIMons do
	if AIMons[i] ~= false then
      if AIMons[i].attack > Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack") and
        Get_Card_Count_Pos(OppMon(), POS_FACEUP_ATTACK) <= 1 and AIMons[i].attack > Get_Card_Att_Def(OppMon(),defense,">",POS_FACEUP_DEFENCE,defense) then
        ChangePosOK = 1
      end
    end
  end
  if ChangePosOK == 1 then
    for i=1,#RepositionableCards do
      if RepositionableCards[i].id ~= 21502796 and -- Any except Ryko!
         RepositionableCards[i].attack > 0 then
        if RepositionableCards[i].position == POS_FACEUP_DEFENCE or
           RepositionableCards[i].position == POS_FACEDOWN_DEFENCE then
		  return COMMAND_CHANGE_POS,i
        end
      end
    end
  end
 
-------------------------------------------------
-- **********************************************
--         Spell and trap card setting :|
-- **********************************************
-------------------------------------------------
  
  ---------------------------------------------------------
  -- Set trap and quick-play cards in Main Phase 2, 
  -- or if it's the first turn of the duel.
  ---------------------------------------------------------
  if #cards.st_setable_cards > 0 and (AI.GetCurrentPhase() == PHASE_MAIN2 or Duel.GetTurnCount() == 1) then
    local setCards = cards.st_setable_cards
    for i=1,#setCards do
      if bit32.band(setCards[i].type,TYPE_TRAP) > 0 or bit32.band(setCards[i].type,TYPE_QUICKPLAY) > 0 then
		return COMMAND_SET_ST,i
      end
    end
  end

  -------------------------------------------------------
  -- Set spell cards as a bluff if the AI has no backrow.
  -- Should obviously only do this if the AI doesn't have
  -- Treeborn Frog in the Graveyard or on the field, or
  -- if the AI has Gorz in hand.
  -------------------------------------------------------
  if Get_Card_Count_ID(AIHand(), 12538374, nil) == 0 and -- Gorz
	 Get_Card_Count_ID(UseLists({AIMon(),AIGrave()}), 12538374, nil) == 0 and   -- Treeborn Frog
	 Get_Card_Count_ID(AIMon(), 98777036, POS_FACEUP) == 0 then  -- Tragoedia
	if #cards.st_setable_cards > 0 and AI.GetCurrentPhase() == PHASE_MAIN2 then
      local setCards = cards.st_setable_cards
      for i=1,#setCards do
        if bit32.band(setCards[i].type,TYPE_SPELL) > 0 then
          if Get_Card_Count(AIST()) < 2 then
            return COMMAND_SET_ST,i
          end
        end
      end
    end
  end


  ----print("DECISION: go to next phase")
  ------------------------------------------------------------
  -- Proceed to the next phase, and let AI write epic line in chat
  ------------------------------------------------------------
  -- there should be check here to see if the next phase is disallowed (like Karakuri having to attack)  I'm too lazy to make it right now, sorry. :*	
	return COMMAND_TO_NEXT_PHASE,1
  end
    