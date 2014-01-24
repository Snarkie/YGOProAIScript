--- OnSelectNumber ---
--
-- Called when AI has to declare a number. 
-- Example card(s): Reasoning
-- 
-- Parameters:
-- choices = table containing the valid choices
--
-- Return: index of the selected choice
function OnSelectNumber(choices)

  --print("OnSelectNumber")
  for i=1,#choices do
          ----print(i, choices[i])
  end


  -------------------------------------------
  -- The AI should always try to mill as many
  -- cards as possible with Card Trooper.
  -------------------------------------------
  if GlobalActivatedCardID == 85087012 then
    GlobalActivatedCardID = nil
    return #choices
  end


  -------------------------------------------
  -- Reset this variable if it gets this far.
  -------------------------------------------
  GlobalActivatedCardID = nil


  -- Example implementation: pick one of the available choices randomly
  return math.random(#choices)

end
