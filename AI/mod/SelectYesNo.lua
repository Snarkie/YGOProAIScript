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
function GetAttacker()
  local attacker = Duel.GetAttacker()
  local attackerid = nil
  local cards = nil
  if attacker then 
    attackerid = attacker:GetCode() 
    if attacker:IsControler(player_ai) then
      cards = AIMon()
    else
      cards = OppMon()
    end
    return cards[IndexByID(cards,attackerid)]
  end
  return nil
end

function OnSelectYesNo(description_id)
	if description_id == 30 then
    GlobalAIIsAttacking = true
    local cards = nil
    local attacker = GetAttacker()
    local attack = 0
    if attacker then
      cards = {attacker}
      ApplyATKBoosts(cards)
      attacker = cards[1]
      attack = attacker.attack
    end
    cards=OppMon()
    ApplyATKBoosts(cards)
    local lowest = Get_Card_Att_Def(cards,"attack","<",POS_FACEUP_ATTACK,"attack")
    lowest = math.max(lowest,Get_Card_Att_Def(OppMon(),"defense","<",POS_FACEUP_DEFENCE,"defense"))
    if attack>lowest then 
      return 1
    else
      return 0
    end
	end
  if description_id == 1457766049 then  -- Star Seraph Sovereign
    if FieldCheck(4) == 1 then
      return 1
    else
      return 0
    end
  end
	return -1
end

