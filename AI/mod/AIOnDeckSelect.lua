---------------------------------------
-- AIOnDeckSelect.lua
--
-- A set of functions to determine what 
-- deck AI is currently using 
---------------------------------------

-----------------------------
-- Checks if AI has set of cards of a specific deck 
-- in he's deck at the moment.
-----------------------------

function AIDeckID()
  local AIDeck = AI.GetAIMainDeck()
  local Result = 0
  for i=1,#AIDeck do
    if AIDeck[i] ~= false then
      if DarkWorld_CardList(AIDeck[i].id) == 1 then
        Result = 1 -- Dark World
      end
    end
  end
  for i=1,#AIDeck do
  if AIDeck[i] ~= false then
      if ElementalDragon_CardList(AIDeck[i].id) == 1 then
        Result = 2 -- E Dragons
      end
    end
  end
  return Result
end

function DarkWorld_CardList(CardId)
  if CardId ~= 64631466 or CardId ~= 63519819 or -- Relinquished, Thousand-Eyes Restrict 
     CardId ~= 10000000 or CardId ~= 10000020 or -- Obelisk the Tormentor, Slifer the Sky Dragon
     CardId ~= 10000010 then                    -- The Winged Dragon of Ra   
    return 0
  end
  return 1
end

function ElementalDragon_CardList(CardId)
  if CardId == 64631466 and CardId == 63519819 and -- Relinquished, Thousand-Eyes Restrict 
     CardId == 10000000 and CardId == 10000020 and -- Obelisk the Tormentor, Slifer the Sky Dragon
     CardId == 10000010 then                    -- The Winged Dragon of Ra   
     return 1
  end
  return 0
end



