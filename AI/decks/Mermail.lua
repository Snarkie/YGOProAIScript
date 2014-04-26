Mermail = nil
function MermailCheck()
  if Mermail == nil then
    Mermail = HasID(UseLists({AIDeck(),AIHand()}),21954587) -- check if the deck has Megalo
  end 
  return Mermail
end
function MegaloPrio(loc)
  return 1
end
function TeusPrio(loc)
end
MermailPrio = {}
MermailPrio[21954587] = MegaloPrio
MermailPrio[22446869] = TeusPrio
MermailPrio[37781520] = {2,2,2,2} -- Leed
function MermailGetPriority(id,loc)
  local index = 0
  local checklist = nil
  local result = 0
  if loc == LOCATION_HAND then
    index = 1
  elseif loc == LOCATION_FIELD then
    index = 2
  elseif loc == LOCATION_GRAVE then
    index = 3
  elseif loc == LOCATION_REMOVED then
    index = 4
  else
  end
  checklist = MermailPrio[id]
  if checklist then
    --print("check")
    if type(checklist)=="function" then
      --print("function: "..checklist(loc))
      result = checklist(loc)
    else
      --print("value")
      if checklist[index] then
        result = checklist[index]
      end
    end
  end
  return result
end
function MermailAssignPriority(cards,loc)
  local index = 0
  for i=1,#cards do
    cards[i].index=i
    cards[i].prio=MermailGetPriority(cards[i].id,loc)
  end
end
function MermailOnSelectInit(cards, to_bp_allowed, to_ep_allowed)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  
  cards=AIHand()
  for i=1,#cards do
    --print("ID: "..cards[i].id..", Prio: "..MermailGetPriority(cards[i].id))
  end
  --
  return nil
end
  
function MermailOnSelectCard(cards, minTargets, maxTargets,ID,triggeringCard)
  return nil
end

function MermailOnSelectChain(cards,only_chains_by_player)
  return nil
end

function MermailOnSelectEffectYesNo(id)
  local result = nil
  return result
end

MermailAtt={
  21954587 -- Megalo
}
MermailDef={
}
function MermailOnSelectPosition(id, available)
  result = nil
  for i=1,#MermailAtt do
    if MermailAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#MermailDef do
    if MermailDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  return result
end