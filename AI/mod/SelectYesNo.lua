--- OnSelectYesNo() ---
--
-- Called when AI has to decide something
-- 
-- Parameters:
-- description_id = id of the text dialog that is normally shown to the player
--
-- The descriptions can be found in strings.conf
-- For example, description id 30 = 'Replay, do you want to continue the Battle?'
--
-- Return: 
-- 1 = yes
-- 0 = no
-- -1 = let the ai decide
function OnSelectYesNo(description_id)
  --print("OnYesNo")
	-- Example implementation: continue attacking, let the ai decide otherwise
	if description_id == 30 then
		return 1
	else
		return -1
	end
end

