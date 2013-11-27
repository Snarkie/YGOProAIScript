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
-- Prefer monsters that benefit from being tributed
---------------------------------------------------
function TributeWhitelist(id)
  if id == 03300267 or id == 77901552 -- Hieratic Dragons of Su, Tefnuit,
  or id == 31516413 or id == 78033100 -- Eset, Gebeb
  then
    return 1
  end
  return 0
end

--------------------------------------------------- 
-- always prefer mind-controlled, whitelisted or 
-- token monsters, otherwise check for rank, 
-- attack and tribute exceptions.
---------------------------------------------------
function OnSelectTribute(cards,minTributes, maxTributes)
  --print("OnSelectTribute")
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








