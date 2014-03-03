function GadgetOnSelectInit(cards, to_bp_allowed, to_ep_allowed)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  if HasID(SpSummonable,05556499) then
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSummonable,05556499)}
  end
end

function GadgetOnSelectCard(cards, minTargets, maxTargets, triggeringID)
  if triggeringID == 05556499 then
  end
  return nil
end

function GadgetOnSelectChain(cards,only_chains_by_player)
  return nil
end

function GadgetOnSelectPosition(id, available)
  return nil
end