--- OnSelectTribute ---
--
-- Called when AI has to tribute monster(s). 
-- Example card(s): Caius the Shadow Monarch, Beast King Barbaros, Hieratic
-- 
-- Parameters (3):
-- cards = available tributes
-- minTributes = minimum number of tributes
-- maxTributes = maximum number of tributes
--
-- Return:
-- result = table containing tribute indices



--------------------------------------------------- 
-- always prefer mind-controlled, whitelisted or 
-- token monsters, otherwise check for rank, 
-- attack and tribute exceptions.
---------------------------------------------------
function OnSelectTribute(cards,minTributes, maxTributes)
  local result = {}
  local preferred = {}
  local valid = {}
  for i=1,#cards do
	if cards[i].owner == 2 or TributeWhitelist(cards[i].id) > 0 or 
	   bit32.band(cards[i].type,TYPE_TOKEN) > 0  then      
	  preferred[#preferred+1]=i
    elseif cards[i].rank == 0 and cards[i].level <= GlobalActivatedCardLevel and 
      cards[i].attack < GlobalActivatedCardAttack and IsTributeException(cards[i].id) == 0 then
	  valid[#valid+1]=i
    end
  end
  for i=1,minTributes do
    if preferred[i] then
      result[i]=preferred[i]
    else
      result[i]=valid[i-#preferred]
    end
  end
  return result
end








