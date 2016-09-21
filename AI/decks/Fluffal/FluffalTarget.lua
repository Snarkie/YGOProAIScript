-----------------------
------- TARGET --------
-----------------------
-- FluffalM Target
function DogTarget(cards)
  --CountPrioTarget(cards,PRIO_TOHAND,1,nil,nil,nil,"DogTarget")
  return Add(cards,PRIO_TOHAND)
end
function OwlTarget(cards,c,min,max)
  return FusionSummonTarget(cards,c,min,max)
end
GlobalSheep = 0
function SheepTarget(cards)
  if LocCheck(cards,LOCATION_MZONE) then
    local result = {}
    for i=1, #cards do
	  local c = cards[i]
	  result[i] = c
	  result[i].prio = GetPriority(c,PRIO_TOHAND)
	  result[i].index = i
	end
	local compare = function(a,b) return a.prio>b.prio end
	table.sort(result,compare)
    print("SheepTarget - MZONE to HAND")
    --return Add(cards,PRIO_TOHAND,1) -- c.prio -1 must
	return {result[1].index}
  end
  if LocCheck(cards,LOCATION_GRAVE) or LocCheck(cards,LOCATION_HAND) then
    print("SheepTarget - GRAVE/HAND to FIELD")
    return Add(cards,PRIO_TOFIELD,1)
  end
  return Add(cards)
end
function CatTarget(cards)
  return Add(cards,PRIO_TOHAND)
end
GlobalRabit = 0
function RabitTarget(cards)
  GlobalRabit = 1
  return Add(cards,PRIO_TOHAND)
end
function MouseTarget(cards,max)
  return Add(cards,PRIO_TOFIELD,max)
end
function WingsTarget(cards)
  if LocCheck(cards,LOCATION_GRAVE) then
    print("WingsTarget - GRAVE to BANISH")
    return Add(cards,PRIO_BANISH)
  end
  if LocCheck(cards,LOCATION_SZONE) then
    print("WingsTarget - SZONE to GRAVE")
    return Add(cards,PRIO_TOGRAVE)
  end
end
GlobalOcto = 0
function OctoTarget(cards,min,max)
  GlobalOcto = 1
  local result
  if LocCheck(cards,LOCATION_GRAVE) then
    print("OctoTarget - GRAVE to HAND")
	--CountPrioTarget(cards,PRIO_TOHAND,max,nil,nil,nil,"OctoTarget")
	result = Add(cards,PRIO_TOHAND,max)
	GlobalOcto = 0
    return result
  end
  if LocCheck(cards,LOCATION_REMOVED) then
    print("OctoTarget - REMOVED to GRAVE")
	result = Add(cards,PRIO_TOGRAVE,max)
	GlobalOcto = 0
    return result
  end
  return Add(cards) -- 
end
-- EdgeImp Target
function TomahawkTarget(cards)
  if LocCheck(cards,LOCATION_DECK) then
    print("TomahawkTarget - DECK to GRAVE")
    return Add(cards,PRIO_TOGRAVE)
  end
  if LocCheck(cards,LOCATION_HAND) then
    print("TomahawkTarget - HAND to GRAVE")
    return Add(cards,PRIO_DISCARD)
  end
  return Add(cards)
end
function ChainTarget(cards)
  return Add(cards,PRIO_TOHAND)
end
GlobalSabres = 0
function SabresTarget(cards)
  if CardsMatchingFilter(UseLists({AIHand(),AIST()}),ToyVendorCheckFilter,true) > 0
  then
    return Add(cards,PRIO_TOFIELD,1,FluffalFilter)
  end
  return Add(cards,PRIO_DISCARD)
end
-- Other Target
function KoSTarget(cards)
  return Add(cards,PRIO_TOHAND)
end
-- FluffalS Target
GlobalFFusion = 0
function FFusionTarget(cards,c,min,max)
  return FusionSummonBanishTarget(cards,c,min,max)
end
GlobalFFactory = 0
function FFactoryTarget(cards,c,min,max)
  if LocCheck(cards,LOCATION_GRAVE) then
    print("FFactoryTarget - GRAVE to BANISH")
    return Add(cards,PRIO_BANISH)
  end
  return FusionSummonTarget(cards,c,min,max)
end
GlobalToyVendor = 0
function ToyVendorTarget(cards,c)
  if LocCheck(cards,LOCATION_DECK) then
    print("ToyVendorTarget - DECK to HAND")
	GlobalToyVendor = 0
    return Add(cards,PRIO_TOHAND)
  end
  if GlobalToyVendor == 1 then
    print("ToyVendorTarget - HAND to GRAVE")
	OPTSet(c.cardid)
	GlobalToyVendor = 2
    return Add(cards,PRIO_DISCARD)
  end
  if GlobalToyVendor == 2 then
    print("ToyVendorTarget - HAND to FIELD")
	GlobalToyVendor = 3
    return Add(cards,PRIO_TOFIELD)
  end
  if GlobalToyVendor == 3 then
    GlobalToyVendor = 0
  end

  return Add(cards)
end
-- Spell Target
GlobalIFusion = 0
function IFusionTarget(cards,c)
  local result = {}
  local indexT = 1
  for i=1, #cards do
	local c = cards[i]
	result[i] = c
  end
  indexT = Add(cards,PRIO_TOFIELD)[1]
  OPTSet(result[indexT].cardid)

  return Add(cards,PRIO_TOFIELD)
end
function MaxMaterials(fusionId,min,max)
  local result = 1
  if(fusionId == 80889750) then -- FSabreTooth
    result = 2
  elseif fusionId == 11039171 and #AIMon() > 4 then -- Wolf
    result = 2
  else
    result = 1
  end
  
  if fusionId == 00464362 then -- Tiger 
	if HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	then
	  result = max - 2
	else
	  result = max - 1
	end
	
	if #AIMon() > 4 then
	  result = result + 1
	end
	
	if (result + 1) > CardsMatchingFilter(OppField(),FTigerDestroyFilter) then
	  result = CardsMatchingFilter(OppField(),FTigerDestroyFilter) - 1
	end

	if CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) > 1 then
	  if result > 2 then
	    result = 2
	  end
	end	
	if CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) > 2 then
	  result = 1
	end
  end
  
  if result > max then
    result = max
  end
  if result < min then
    result = min
  end
  
  print("MaxMaterials - fusionId "..fusionId.." max: "..max.." - Result: "..result)
  return result
end
GlobalFusionSummon = 0
GlobalFusionId = 0
function PolymerizationTarget(cards,c,min,max)
  return FusionSummonTarget(cards,c,min,max)
end
GlobalDFusion = 0
function DFusionTarget(cards,c,min,max)
  return FusionSummonTarget(cards,c,min,max)
end

function FusionSummonTarget(cards,c,min,max)
  local result = {}
  local indexT = 1
  if LocCheck(cards,LOCATION_EXTRA) then
    for i=1, #cards do
	  local c = cards[i]
	  result[i] = c
	  --print("Poly0: "..c.id.." - PRIO: "..GetPriority(c,PRIO_TOFIELD))
	end
	indexT = Add(cards,PRIO_TOFIELD)[1]
    GlobalFusionId = result[indexT].id
    print("FusionTarget: "..GlobalFusionId)
    return Add(cards,PRIO_TOFIELD)
  end
  if GlobalFusionSummon == 1 then
    GlobalFusionSummon = 2
    --print("FusionTarget - FirstMaterial: ")
	for i=1, #cards do
	  local c = cards[i]
	  result[i] = c
	  --print("Poly1: "..c.id.." - PRIO: "..GetPriority(c,PRIO_TOGRAVE))
	end
	return Add(cards,PRIO_TOGRAVE)
  end
  if GlobalFusionSummon == 2 then
    GlobalFusionSummon = 3
    --print("FusionTarget - SecondMaterial: ")
	for i=1, #cards do
	  local c = cards[i]
	  --print("Poly2: "..c.id.." - PRIO: "..GetPriority(c,PRIO_TOGRAVE))
	end
	return Add(cards,PRIO_TOGRAVE,MaxMaterials(GlobalFusionId,min,max))
  end
  if GlobalFusionId == 80889750 then -- GlobalIFusion
	GlobalIFusion = 0
  end
  return Add(cards,PRIO_TOGRAVE,1)
end

function FusionSummonBanishTarget(cards,c,min,max)
  local result = {}
  local indexT = 1
  if LocCheck(cards,LOCATION_EXTRA) then
    for i=1, #cards do
	  local c = cards[i]
	  result[i] = c
	  --print("FFusion0: "..c.id.." - PRIO: "..GetPriority(c,PRIO_TOFIELD))
	end
	indexT = Add(cards,PRIO_TOFIELD)[1]
    GlobalFusionId = result[indexT].id
    print("FusionTarget: "..GlobalFusionId)
    return Add(cards,PRIO_TOFIELD)
  end
  if GlobalFFusion == 1 then
    GlobalFFusion = 2
    --print("BanishFusionTarget - FirstMaterial: ")
	for i=1, #cards do
	  local c = cards[i]
	  result[i] = c
	  --print("FFusion1: "..c.id.." - PRIO: "..GetPriority(c,PRIO_BANISH))
	end
	return Add(cards,PRIO_BANISH)
  end
  if GlobalFFusion == 2 then
    GlobalFFusion = 3
    --print("BanishFusionTarget - SecondMaterial: ")
	for i=1, #cards do
	  local c = cards[i]
	  --print("FFusion2: "..c.id.." - PRIO: "..GetPriority(c,PRIO_BANISH))
	end
	return Add(cards,PRIO_BANISH,MaxMaterials(GlobalFusionId,min,max))
  end
  return Add(cards,PRIO_BANISH,1)
end

function GCycloneTarget(cards,c)
  return BestTargets(cards,1,TARGET_DESTROY)
end

-- Trap Target
function FReserveTarget(cards,c)
  if LocCheck(cards,LOCATION_EXTRA) then
    print("FReserveTarget - EXTRA")
    return Add(cards,PRIO_TOHAND)
  end
  if LocCheck(cards,LOCATION_DECK) then
    print("TomahawkTarget - DECK to HAND")
    return Add(cards,PRIO_TOHAND)
  end
  return Add(cards)
end
-- Frightfur Target
GlogalFSabreTooth = 0
function FSabreTarget(cards,c)
  local result
  GlogalFSabreTooth = 1
  --CountPrioTarget(cards,PRIO_TOFIELD,1,nil,nil,nil,"FSabreTarget")
  result = Add(cards,PRIO_TOFIELD)
  GlogalFSabreTooth = 0
  return result
end
function FKrakenTarget(cards,c)
  return BestTargets(cards,1,TARGET_DESTROY,FKrakenSendFilter)
end
function FLeoTarget(cards,c)
  return BestTargets(cards,1,TARGET_DESTROY,FLeoDestroyFilter,c)
end
function FTigerTarget(cards,c,min,max)
  local maxTargets = CardsMatchingFilter(OppField(),FTigerDestroyFilter)

  if maxTargets > max then
    maxTargets = max
  end

  local FFactoryIndex = IndexByID(cards,43698897)
  
  local result = BestTargets(cards,maxTargets,TARGET_DESTROY,FTigerDestroyFilter)
  
  if #result < max and FFactoryIndex then
    if not OPTCheck(43698897) -- FFactory
	and HasID(AIBanish(),06077601,true) -- FFusion
	then
      result[#result+1] = FFactoryIndex
	end
  end

  return result
end

--39246582, -- Fluffal Dog
--03841833, -- Fluffal Bear
--65331686, -- Fluffal Owl
--98280324, -- Fluffal Sheep
--02729285, -- Fluffal Cat
--38124994, -- Fluffal Rabit
--06142488, -- Fluffal Mouse
--72413000, -- Fluffal Wings
--00006131, -- Fluffal Patchwork (BETA)
--97567736, -- Edge Imp Tomahawk
--61173621, -- Edge Imp Chain
--30068120, -- Edge Imp Sabres
--79109599, -- King of the Swamp
--67441435, -- Glow-Up Bulb

--70245411, -- Toy Vendor
--06077601, -- Frightfur Fusion
--43698897, -- Frightfur Factory
--01845204, -- Instant Fusion
--24094653, -- Polymerization
--94820406, -- Dark Fusion
--43898403, -- Twin Twister

--66127916, -- Fusion Reserve

--80889750, -- Frightfur Sabre-Tooth
--10383554, -- Frightfur Leo
--85545073, -- Frightfur Bear
--11039171, -- Frightfur Wolf
--00464362, -- Frightfur Tiger
--57477163, -- Frightfur Sheep
--41209827, -- Starve Venom Fusion Dragon
--33198837, -- Naturia Beast
--42110604, -- Hi-Speedroid Chanbara
--82633039, -- Castel
--83531441, -- Dante

function FluffalCard(cards,min,max,id,c) -- FLUFFAL CARDS
  --print("FluffalCard: "..c.id.." - min: "..min.." - max: "..max)
  if id == 39246582 then -- Dog
    return DogTarget(cards)
  end
  if id == 65331686 then -- Owl
    return OwlTarget(cards,c,min,max)
  end
  if id == 98280324 then -- Sheep
    return SheepTarget(cards)
  end
  if id == 38124994 then -- Rabit
    return RabitTarget(cards)
  end
  if id == 06142488 then -- Mouse
    return MouseTarget(cards,max)
  end
  if id == 72413000 then -- Wings
    return WingsTarget(cards)
  end
  
  if id == 00007614 then -- Octo
    return OctoTarget(cards,min,max)
  end

  if id == 97567736 then -- Tomahawk
    return TomahawkTarget(cards)
  end
  if id == 61173621 then -- Chain
    return ChainTarget(cards)
  end
  if id == 30068120 then -- Sabres
    return SabresTarget(cards)
  end

  if id == 79109599 then -- KoS
    return KoSTarget(cards)
  end

  if id == 06077601 then -- Frightfur Fusion
	return FFusionTarget(cards,c,min,max)
  end
  if id == 43698897 then -- Frightfur Factory
	return FFactoryTarget(cards,c,min,max)
  end
  if id == 70245411 then -- Toy Vendor
	return ToyVendorTarget(cards,c)
  end

  if id == 01845204 then -- Instant Fusion
	return IFusionTarget(cards,c)
  end
  if id == 24094653 then -- Polymerization
	return PolymerizationTarget(cards,c,min,max)
  end
  
  if id == 94820406 then -- DFusion
	return DFusionTarget(cards,c,min,max)
  end

  if id == 66127916 then -- DFusion
	return FReserveTarget(cards)
  end

  if id == 80889750 then -- Frightfur Sabre-Tooth
	return FSabreTarget(cards)
  end
  if id == 00007620 then -- Frightfur Kraken
	return FKrakenTarget(cards,c)
  end
  if id == 10383554 then -- Frightfur Leo
	return FLeoTarget(cards)
  end
  if id == 00464362 then -- Frightfur Tiger
    return FTigerTarget(cards,c,min,max)
  end

  if id == 05133471 then -- Galaxy Cyclone
    return GCycloneTarget(cards,c)
  end
  return nil
end

function FluffalNumber(choices) -- FLUFFAL NUMBER
  return nil
end

NoDestroy = {
  57103969, -- Tenki
  05851097, -- Vanity's Emptinesss
}

function NoDestroyCheck(c,filter,opt)
  if c then
    local id=c.id
    for i=1,#NoDestroy do
      if NoDestroy[i]==id then
        return true
      end
    end
  end
  return false
end