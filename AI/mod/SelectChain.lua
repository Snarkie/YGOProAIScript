--- OnSelectChain --
--
-- Called when AI can chain a card.
-- This function is not completely implemented yet. The parameters will very likely change in the next version.
-- 
-- Parameters:
-- cards = table of cards to chain
-- only_chains_by_player = returns true if all cards in the chain are used by the Player
-- Return: 
-- result
--		1 = yes, chain a card
--		0 = no, don't chain
-- index = index of the chain
GlobalChain = 0
function OnSelectChain(cards,only_chains_by_player,forced)
  if Duel.GetCurrentChain()<=GlobalChain then
    GlobalTargetList = {} -- reset for new chain
  else
    GlobalChain=Duel.GetCurrentChain()
  end
  local result = 0
  local index = 1
  local ChainAllowed = 0
  
local result=FireFistOnChain(cards,only_chains_by_player)
if result ~= nil then
  return result[1],result[2]
end
result=HeraldicOnSelectChain(cards,only_chains_by_player)
if result ~= nil then
  return result[1],result[2]
end
result=GadgetOnSelectChain(cards,only_chains_by_player)
if result ~= nil then
  return result[1],result[2]
end
result=BujinOnSelectChain(cards,only_chains_by_player)
if result ~= nil then
  return result[1],result[2]
end
result=MermailOnSelectChain(cards,only_chains_by_player)
if result ~= nil then
  return result[1],result[2]
end
result=ShadollOnSelectChain(cards,only_chains_by_player)
if result ~= nil then
  return result[1],result[2]
end
result=SatellarknightOnSelectChain(cards,only_chains_by_player)
if result ~= nil then
  return result[1],result[2]
end
result=ChaosDragonOnSelectChain(cards,only_chains_by_player)
if result ~= nil then
  return result[1],result[2]
end
result=HATChain(cards)
if result ~= nil then
  return result[1],result[2]
end
result=QliphortChain(cards)
if result ~= nil then
  return result[1],result[2]
end
result = 0
 
  ------------------------------------------
  -- The first time around, it sets the AI's
  -- turn (only if the AI is playing second).
  -------------------------------------------
  if GlobalAIPlaysFirst == nil then
    if Duel.GetTurnCount() == 2 then
      GlobalIsAIsTurn = 1
      GlobalAIPlaysFirst = 0
      ResetOncePerTurnGlobals()
	  Globals()
	end
  end

  ----------------------------------------------
  -- This switches the GlobalIsAIsTurn variable.
  ----------------------------------------------
  if GlobalAIPlaysFirst == 1 then
    if GlobalIsAIsTurn == 1 then
      if Duel.GetTurnCount() % 2 == 0 then
        GlobalIsAIsTurn = 0
        ResetOncePerTurnGlobals()
	  end
    end
    if GlobalIsAIsTurn == 0 then
      if Duel.GetTurnCount() % 2 == 1 then
        GlobalIsAIsTurn = 1
        ResetOncePerTurnGlobals()
	  end
    end
  end
  if GlobalAIPlaysFirst == 0 then
    if GlobalIsAIsTurn == 1 then
      if Duel.GetTurnCount() % 2 == 1 then
        GlobalIsAIsTurn = 0
        ResetOncePerTurnGlobals()
	  end
    end
	if GlobalIsAIsTurn == 0 then
      if Duel.GetTurnCount() % 2 == 0 then
        GlobalIsAIsTurn = 1
        ResetOncePerTurnGlobals()
	  end
    end
  end
  	 
  ---------------------------------------------------------
  -- Compare the current field's state with the previously
  -- saved field state, and get the card  that the opponent
  -- has played or modified. If the opponent did summon,
  -- modify or activate something, this variable will be
  -- non-zero.
  ---------------------------------------------------------
  local OppCard = GetPlayedCard()
  local OppCardType = 0
  local OppCardOwner = 0

  --------------------------------------------------
  -- Nil values give me debug nightmares so here's a
  -- "catch" routine to determine a type value of a
  -- non-existant card.
  --------------------------------------------------
  if OppCard ~= 0 then
    OppCardType = OppCard.type
    OppCardOwner = OppCard.owner
  end

  
  ---------------------------------------------------
  -- Check if Trap or Spell cards shouldn't be activated here.
  -- 
  -- For now it simply checks if Royal Decree or Imperial Order
  -- is face up on the field.
  ---------------------------------------------------
  local TrapsNegated = Get_Card_Count_ID(UseLists({AIMon(),AIST(),OppMon(),OppST()}), 51452091, POS_FACEUP)
  local SpellsNegated = Get_Card_Count_ID(UseLists({AIMon(),AIST(),OppMon(),OppST()}), 61740673, POS_FACEUP)
  
  ---------------------------------------------
  -- Don't activate anything if the AI controls
  -- a face-up Light and Darkness Dragon.
  ---------------------------------------------
  if Get_Card_Count_ID(AIMon(), 47297616, POS_FACEUP) > 0 then
	return 0,0
  end
  
  ---------------------------------------
  -- Don't do anything if if the AI controls
  -- a face-up C106: Giant Hand Red with
  -- a "Number" monster as XYZ material,
  -- that didn't use its effect this turn
  ---------------------------------------
  
  local aimon = AIMon()
  local card = nil
  for i=1,#aimon do
    if aimon[i].id==55888045 then
      card = aimon[i]
    end
  end
  if card and bit32.band(card.position,POS_FACEUP)>0 
  and Duel.GetTurnCount() ~= GlobalC106
  and card:is_affected_by(EFFECT_DISABLE_EFFECT)==0 
  and card:is_affected_by(EFFECT_DISABLE)==0
  then
    local materials = card.xyz_materials
    for i=1,#materials do
      if bit32.band(materials[i].setcode,0x48)>0 then
        return 0,0
      end
    end
  end

 ---------------------------------------------
 -- Cocoon of Evolution on field turn counter
 --------------------------------------------- 
 if Global1PTVariable ~= 1 and GlobalIsAIsTurn == 1 then
  if Get_Card_Count_ID(UseLists({AIMon(),AIST()}), 40240595, POS_FACEUP) > 0 and Get_Card_Count_ID(UseLists({AIMon(),AIST()}),68144350,POS_FACEUP) > 0 and AI.GetCurrentPhase() == PHASE_END then -- Cocoon of Evolution, Petit Moth
    GlobalCocoonTurnCount = GlobalCocoonTurnCount +1
    Global1PTVariable = 1
	 else if Get_Card_Count_ID(UseLists({AIMon(),AIST()}), 40240595, POS_FACEUP) ==  0 or Get_Card_Count_ID(UseLists({AIMon(),AIST()}),58192742,POS_FACEUP) == 0 then
       GlobalCocoonTurnCount = 0
      end
    end
  end  
  
  -----------------------------------------------------
  -- Check if global chaining conditions are met,
  -- and set ChainAllowed variable to 1 if they are.
  -----------------------------------------------------
  for i=1,#cards do
   if Get_Card_Count_ID(AIST(),cards[i].id, POS_FACEUP) == 0 or
	  MultiActivationOK(cards[i].id) == 1 then 
	  if bit32.band(cards[i].type,TYPE_MONSTER) > 0 or (bit32.band(cards[i].type,TYPE_TRAP) > 0 and TrapsNegated == 0) or (bit32.band(cards[i].type,TYPE_SPELL) > 0 and SpellsNegated == 0) then		
		if UnchainableCheck(cards[i].id) then  -- Checks if any cards from UnchainableTogether list are already in chain.
          if isUnactivableWithNecrovalley(cards[i].id) == 0 or
		    (isUnactivableWithNecrovalley(cards[i].id) == 1 and Get_Card_Count_ID(UseLists({AIMon(),AIST(),OppMon(),OppST()}),47355498,POS_FACEUP) == 0) then -- Check if card shouldn't be activated when Necrovalley is on field
		    ChainAllowed = 1
		   end
         end
       end
     end
   end
  
  -----------------------------------------------------
  -- Proceed to chain any cards and check other chaining
  -- conditions, only if global restrictions above are met.
  -----------------------------------------------------
  if ChainAllowed == 1 then
  
  
  ------------------------------------------
  -- If the opponent activated a Trap card,
  -- the AI should chain "Royal Decree" and 
  -- "Trap Stun" first.
  ------------------------------------------
    for i=1,#cards do
      if cards[i].id == 51452091 or cards[i].id == 59616123 then
        if Get_Card_Count_ID(AIST(),51452091, POS_FACEUP) == 0 and Get_Card_Count_ID(AIST(),59616123, POS_FACEUP) == 0 then
		if OppCard ~= nil and OppCardOwner == 2 then
          if bit32.band(OppCard.type,TYPE_TRAP) > 0 and OppCard.position == POS_FACEUP then
             GlobalActivatedCardID = cards[i].id
            return 1,i
           end
         end
       end
     end
   end
    

  -------------------------------------------------
  -- Activate Torrential Tribute if the opponent
  -- controls at least 2 more monsters than the AI.
  -------------------------------------------------
	for i=1,#cards do
      if cards[i].id == 53582587 and
         Get_Card_Count(OppMon()) >= Get_Card_Count(AIMon()) + 2 then
         GlobalActivatedCardID = cards[i].id
        return 1,i
      end
   end
  
  ---------------------------------
  -- Activate Raigeki Break or Phoenix Wing Wind Blast only if
  -- the opponent controls a card.
  ---------------------------------
    for i=1,#cards do
      if cards[i].id == 04178474 or -- Raigeki B
         cards[i].id == 63356631 then -- Phoenix Wing Wind Blast
        if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") or Get_Card_Count(OppST()) > 0 then
          GlobalActivatedCardID = cards[i].id
          GlobalCardMode = 1
		  return 1,i
        end
      end
    end

  ----------------------------------
  -- Activate Icarus Attack only if
  -- the opponent controls 2+ cards.
  ----------------------------------
    for i=1,#cards do
      if cards[i].id == 53567095 then
        if Get_Card_Count(AI.GetOppMonsterZones()) + Get_Card_Count(OppST()) >= 2 then
          GlobalActivatedCardID = cards[i].id
          return 1,i
        end
      end
    end

  ----------------------------------------------------------------
  -- Activate Beckoning Light only if the number of LIGHT monsters
  -- in the AI's graveyard is 5 or more, and also greater than or
  -- equal to the number of cards in the AI's hand (at least 4)
  ----------------------------------------------------------------
    for i=1,#cards do
      if cards[i].id == 16255442 then
        local AIHand = AI.GetAIHand()
        if Get_Card_Count_ATT(AIGrave(),"==",ATTRIBUTE_LIGHT,nil) >= 5 and
           #AIHand >= 4 then
          GlobalActivatedCardID = cards[i].id
          return 1,i
        end
      end
    end
       
  -------------------------------------------------------
  -- Activate Zero Gardna's effect in the Draw Phase.
  -- This will help the AI to use this effect only on the
  -- opponent's turn.
  -------------------------------------------------------
  if AI.GetCurrentPhase() == PHASE_DRAW then
    for i=1,#cards do
      if cards[i].id == 93816465 then
        return 1,i
      end
    end
  end

  -------------------------------------------
  -- Activate Number 39: Utopia's effect only
  -- if it's the opponent's turn for now.
  -------------------------------------------
  for i=1,#cards do
    if cards[i].id == 84013237 and
       GlobalIsAIsTurn == 0 then
      GlobalActivatedCardID = cards[i].id
      return 1,i
    end
  end

  ----------------------------------------------
  -- Activate Formula Synchron's "Accel Synchro"
  -- effect if the AI hasn't already attempted
  -- it yet this turn.
  ----------------------------------------------
  for i=1,#cards do
    if cards[i].id == 50091196 and
       Global1PTFormula ~= 1 then
       Global1PTFormula = 1
       GlobalActivatedCardID = cards[i].id
      return 1,i
    end
  end

  ---------------------------------------------
  -- Always try to activate Stardust Dragon's
  -- or SD/AM's "summon from graveyard" effect.
  ---------------------------------------------
  for i=1,#cards do
    if cards[i].id == 44508094 or cards[i].id == 61257789 then
      if cards[i].location == LOCATION_GRAVE then
        return 1,i
      end
    end
  end
  
      
  ---------------------------------------------
  -- Activate Gladiator Beast War Chariot,
  -- only if Opp controls effect type monsters
  ---------------------------------------------
  for i=1,#cards do 
   if cards[i].id == 96216229 then -- Gladiator Beast War Chariot
	 if Get_Card_Count_Type(OppMon(), TYPE_MONSTER + TYPE_EFFECT, "==", POS_FACEUP) > 0 then
	    GlobalActivatedCardID = cards[i].id
	   return 1,i
      end
    end    
  end
  
  ---------------------------------------------
  -- AI should activate: Waboku, Negate Attack 
  -- only if player has any face up attack position monsters 
  -- with more attack points than AI's stronger attack pos monster
  --------------------------------------------- 
  if GlobalIsAIsTurn == 0 and Global1PTWaboku ~= 1 then
   for i=1,#cards do 
   if cards[i].id == 12607053 or cards[i].id == 14315573 then -- Waboku, Negate Attack
   if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def_Pos(AIMon()) or 
      Get_Card_Count(AIMon()) == 0 and Get_Card_Count_Pos(AIMon(), POS_FACEUP_ATTACK) > 0 then
	  Global1PTWaboku = 1 
	  GlobalActivatedCardID = cards[i].id
     return 1,i
    end
   end
  end
 end
 
 
  ---------------------------------------------
  -- AI should activate: Shadow Spell,
  -- only if player has stronger attack position monster than any of AI's
  -- and player's monster has 2000 attack points or more.
  ---------------------------------------------
   for i=1,#cards do
   if cards[i].id == 29267084 then -- Shadow Spell
    if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") >= 2000 and 
	  (Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack", ">",POS_FACEUP_ATTACK,"attack")) then
       GlobalActivatedCardID = cards[i].id
      return 1,i
     end
   end
 end
  
  ---------------------------------------------
  -- AI should activate: Return from the Different Dimension,
  -- only if AI can bring out strong tribute monster as result, 
  -- or if player or AI has 0 monsters on the field (just in case)
  ---------------------------------------------
  for i=1,#cards do
   if cards[i].id == 27174286 then -- Return from the Different Dimension
   local AIHand = AIHand()
   local HandHighestATK = 0
   local Result = 0
  if AI.GetCurrentPhase() == PHASE_BATTLE and GlobalIsAIsTurn == 0 and Get_Card_Count_Type(AIBanish(),TYPE_MONSTER,">",nil) >= 3 and Get_Card_Count(AIMon()) == 0 then 
   return 1,i
  end
 if AI.GetCurrentPhase() == PHASE_MAIN1 and Get_Card_Count_Type(AIBanish(),TYPE_MONSTER,">",nil) >= 3 and GlobalIsAIsTurn == 1 and Get_Card_Count(AIMon()) == 0 then	
  for x=1,#AIHand do
    if AIHand[x].attack > HandHighestATK then
       HandHighestATK = AIHand[x].attack       
      if AIHand[x].level >= 5 and
         HandHighestATK >= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") then
	      return 1,i 
	      end
        end
      end
    end
  end 
end
   
  ---------------------------------------------
  -- AI should activate: Zero Gravity, 
  -- only if Player is about to attack or attacked.
  ---------------------------------------------
  for i=1,#cards do  
   if cards[i].id == 83133491 then  -- Zero Gravity
    if Get_Card_Count_ID(UseLists({AIMon(),AIST()}), 83133491, POS_FACEUP) ==  0 and AI.GetCurrentPhase() == PHASE_DAMAGE and GlobalIsAIsTurn == 0 then
	   GlobalActivatedCardID = cards[i].id
      return 1,i
     end
   end
 end
  
  ---------------------------------------------
  -- AI should activate: Enemy Controller, if
  -- player's monster is stronger than AI's
  ---------------------------------------------
   for i=1,#cards do    
   if cards[i].id == 98045062 then -- Enemy Controller
	if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") and 
	   Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(OppMon(), "attack", ">", POS_FACEUP_ATTACK, "defense") then
	   GlobalActivatedCardID = cards[i].id
      return 1,i
     end
   end
 end
  
  ---------------------------------------------------
  -- Use these cards only on opponents cards.
  -- TODO: Expand card list
  ---------------------------------------------------
  for i=1,#cards do
	  if cards[i].id == 41420027 or cards[i].id == 84749824 
    or cards[i].id == 03819470 or cards[i].id == 77538567 
    then     
      local p = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_PLAYER)
      if p and p ~= player_ai then
        GlobalActivatedCardID = cards[i].id 
        return 1,i
      end
      local oppmon=OppMon()
      for j=1,#oppmon do
        if bit32.band(oppmon[j].status,STATUS_SUMMONING)>0 then
          return 1,i
        end
      end
    end
  end
   
  ---------------------------------------------------------
  -- Activate Stardust Dragon/etc's effect, 
  -- or Starlight Road only if the
  -- opponent activated something.
  ---------------------------------------------------------
  for i=1,#cards do
    if cards[i].id == 44508094 or cards[i].id == 58120309 or   -- SD, SR
       cards[i].id == 61257789 or cards[i].id == 35952884 or   -- SDAM, SQD
       cards[i].id == 24696097 or cards[i].id == 99188141 then -- SSD,THRIO
       local p = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_PLAYER)
       if p ~= player_ai then
        return 1,i
       end
    end
  end
  
  ---------------------------------------------
  -- AI should activate: Shrink, 
  -- only if AI's strongest monster's attack points are 
  -- lower than players strongest attack pos monster's points
  ---------------------------------------------
  for i=1,#cards do  
   if cards[i].id == 55713623 then -- Shrink
     if Get_Card_Count_Pos(AIMon(), POS_FACEUP) > 0 then
	 if Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") and 
	    Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") / 2 and
	    Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") >= 1400 then
	    GlobalActivatedCardID = cards[i].id
       return 1,i
       end
     end
   end
 end
	          
  ---------------------------------------------
  -- AI should activate: Amazoness Archers, 
  -- only if AI's monster can become stronger than
  -- any player's monster as result.
  ---------------------------------------------
  for i=1,#cards do  
   if cards[i].id == 67987611 then -- Amazoness Archers
    if (Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") + 500) >= Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") then 
	 GlobalActivatedCardID = cards[i].id
	 return 1,i
     end
   end
 end
  
  ---------------------------------------------
  -- Set global variable to 1 if player activates
  -- "Amazoness Archers" trap card
  ---------------------------------------------
  if Get_Card_Count_ID(OppST(), 67987611, POS_FACEUP) > 0 then
   if AI.GetCurrentPhase() == PHASE_BATTLE then
     Global1PTAArchers = 1
    end
  end
     
  ---------------------------------------------
  -- AI should activate: Spellbinding Circle, Mirror Force,  
  -- only if AI's monsters are weaker than players.
  ---------------------------------------------
  for i=1,#cards do   
   if cards[i].id == 18807108 or cards[i].id == 44095762 or -- Spellbinding Circle, Mirror Force
      cards[i].id == 70342110 then                          -- Dimensional Prison
    if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") 
   and Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(OppMon(),"attack", ">", POS_FACEUP_ATTACK,"defense")
   and Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") >= 1600 or AI.GetPlayerLP(1) <= 2000 then
	   GlobalActivatedCardID = cards[i].id
	    return 1,i
       end
     end
   end
   
  ---------------------------------------------
  -- Mandatory effects the AI could potentially 
  -- skip, if not handled here
  ---------------------------------------------
  for i=1,#cards do 
    if MandatoryCheck(cards[i]) then
      return 1,i
    end
  end  
  
  ----------------------------------------------------------
  -- For now, chain anything else (not already listed above)
  -- that can be chained, except cards with the same ID as
  -- another existing face-up spell/trap card, cards that 
  -- shouldn't be activated in a same chain, and cards that 
  -- shouldn't be activated under certain conditions.
  ----------------------------------------------------------
  
  for i=1,#cards do
   if Get_Card_Count_ID(AIST(),cards[i].id, POS_FACEUP) == 0 or
	  MultiActivationOK(cards[i].id) == 1 then 
    if bit32.band(cards[i].type,TYPE_MONSTER) > 0 or (bit32.band(cards[i].type,TYPE_TRAP) > 0 and TrapsNegated == 0) or 
	  (bit32.band(cards[i].type,TYPE_SPELL) > 0 and SpellsNegated == 0) then
	if UnchainableCheck(cards[i].id) then  -- Checks if any cards from UnchainableTogether list are already in chain.
    if isUnactivableWithNecrovalley(cards[i].id) == 0 or
	  (isUnactivableWithNecrovalley(cards[i].id) == 1 and Get_Card_Count_ID(UseLists({AIMon(),AIST(),OppMon(),OppST()}),47355498,POS_FACEUP) == 0) then -- Check if card shouldn't be activated when Necrovalley is on field
	 if CardIsScripted(cards[i].id) == 0 and cards[i]:is_affected_by(EFFECT_DISABLE)==0 and cards[i]:is_affected_by(EFFECT_DISABLE_EFFECT) == 0 then -- Check if card's activation is already scripted above
     GlobalActivatedCardID = cards[i].id 
	      return 1,i
         end
        else
          return 0,i
         end       
       end
     end
   end
 end
  
  -------------------------------------
  -- Otherwise don't activate anything.
  -------------------------------------
  return 0,0
  end
end
