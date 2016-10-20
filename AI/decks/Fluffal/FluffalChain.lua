------------------------
-------- CHAIN ---------
------------------------
-- FluffalM Chain
function ChainDog(c)
  return true
end
function ChainOwl(c)
  return true
end
function ChainCat(c)
  return true
end
function ChainRabit(c)
  return true
end
function ChainOcto(c)
  return true
end
-- EdgeImp Chain
function ChainChain(c)
  return true
end
function ChainFTiger(c)
  return true
end
-- Other Chain
--[[
function ChainNaturiaBeast(c)
  local link = Duel.GetCurrentChain()
  local p = Duel.GetChainInfo(link, CHAININFO_TRIGGERING_PLAYER)
  if p then
    if p == 1-player_ai then
	  return true
	else
	  return false
	end
  end
  return false
end
--]]
-- FluffalS Chain
-- Spell Chain
-- Trap Chain
function ChainFReserve(c)
  if CheckGenericRemoval(c) then
    return true
  else
    return false
  end
end

function ChainJAvarice(c)
  return
    CheckGenericRemoval(c)
	--or UseJAvarice(c)
end

function CheckGenericRemoval(c)
  return
    RemovalCheckCard(c,CATEGORY_DESTROY)
	or RemovalCheckCard(c,CATEGORY_REMOVE)
	or RemovalCheckCard(c,CATEGORY_TOGRAVE)
	or RemovalCheckCard(c,CATEGORY_TOHAND)
	or RemovalCheckCard(c,CATEGORY_REMOVE)

	or RemovalCheck(c.id,CATEGORY_DESTROY)
	or RemovalCheck(c.id,CATEGORY_REMOVE)
	or RemovalCheck(c.id,CATEGORY_TOGRAVE)
	or RemovalCheck(c.id,CATEGORY_TOHAND)
	or RemovalCheck(c.id,CATEGORY_TODECK)
end
-- Frightfur Chain

function FluffalChain(cards) -- FLUFFAL CHAINS
  --print("FluffalChain")
  if HasIDNotNegated(cards,39246582,ChainDog) then -- Dog
    return 1,CurrentIndex
  end
  if HasIDNotNegated(cards,65331686,ChainOwl) then -- Owl
    return 1,CurrentIndex
  end
  if HasIDNotNegated(cards,02729285,ChainCat) then -- Cat
    return 1,CurrentIndex
  end
  if HasIDNotNegated(cards,38124994,ChainRabit) then -- Rabit
    return 1,CurrentIndex
  end
  if HasIDNotNegated(cards,00007614,ChainOcto) then -- Octo
    return 1,CurrentIndex
  end

  if HasIDNotNegated(cards,61173621,ChainChain) then -- Chain
    return 1,CurrentIndex
  end

  if HasIDNotNegated(cards,00464362,ChainFTiger) then -- FTiger
    return 1,CurrentIndex
  end

  if HasID(cards,43898403,ChainTwinTwister) then -- TwinTwisters
    return 1,CurrentIndex
  end

  if HasIDNotNegated(cards,66127916,ChainFReserve) then -- FReserve
    return 1,CurrentIndex
  end
  if HasIDNotNegated(cards,98954106,ChainJAvarice) then -- JAvarice
    return 1,CurrentIndex
  end
  if HasIDNotNegated(cards,51452091,false) then -- RDecree
    return 1,CurrentIndex
  end

  return nil
end

function FluffalChainOrder(cards) -- FLUFFAL CHAIN ORDER
  --print("FluffalChainOrder")
  local result = {}

  for i=1,#cards do
    local c=cards[i]
    if c.level>5 then
      result[#result+1]=i
    end
  end
  for i=1,#cards do
    local c=cards[i]
    if c.id == 39246582 then -- To protect Dog
      result[#result+1]=i
    end
  end
  for i=1,#cards do
    local c=cards[i]
    if not (c.level>5) and not (c.id == 39246582) then
      result[#result+1]=i
    end
  end

  return result
end
