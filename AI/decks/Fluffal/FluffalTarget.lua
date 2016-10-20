-----------------------
------- TARGET --------
-----------------------

-- FluffalM Target
function DogTarget(cards)
  local result
  --CountPrioTarget(cards,PRIO_TOHAND,1,nil,nil,nil,"DogTarget")
  result = Add(cards,PRIO_TOHAND)
  return result
end
function OwlTarget(cards,c,min,max)
  local result
  if FilterLocation(c,LOCATION_MZONE) then
    result = FusionSummonTarget(cards,c,min,max,MATERIAL_TOGRAVE)
  else
    result = Add(cards)
  end
  return result
end
GlobalSheep = 0
function SheepTarget(cards)
  if LocCheck(cards,LOCATION_MZONE) then
    local result = {}
    for i=1, #cards do
	  local c = cards[i]
	  result[i] = c
	  result[i].prio = GetPriority(c,PRIO_TOHAND)
	  --print("SheepTarget - id: "..result[i].id.." prio: "..result[i].prio)
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
  local result
  GlobalRabit = 1
  result = Add(cards,PRIO_TOHAND)
  GlobalRabit = 0
  return result
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
  local result
  GlobalOcto = 1
  if LocCheck(cards,LOCATION_GRAVE) then
    print("OctoTarget - GRAVE to HAND")
	if HasID(AIGrave(),72413000,true) -- Wings
	and OPTCheck(72413000)
	and CountFluffal(AIGrave()) <= 2
	and CountEgdeImp(AIGrave()) > 0
	then
	  --CountPrioTarget(cards,PRIO_TOHAND,max,nil,EdgeImpFilter,nil,"OctoTarget")
	  result = Add(cards,PRIO_TOHAND,max,EdgeImpFilter)
	else
	  --CountPrioTarget(cards,PRIO_TOHAND,max,nil,nil,nil,"OctoTarget")
	  result = Add(cards,PRIO_TOHAND,max)
	end

	GlobalOcto = 0
    return result
  end
  if LocCheck(cards,LOCATION_REMOVED) then
    print("OctoTarget - REMOVED to GRAVE")
	result = Add(cards,PRIO_TOGRAVE,max)
	GlobalOcto = 0
    return result
  end
  return Add(cards)
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
  local result
  GlobalSabres = 1
  if CardsMatchingFilter(UseLists({AIHand(),AIST()}),ToyVendorCheckFilter,true) > 0
  then
    result = Add(cards,PRIO_TOFIELD,1,FluffalFilter)
  else
    result = Add(cards,PRIO_DISCARD)
  end
  GlobalSabres = 0
  return result
end

-- Other Target
function TGuideTarget(cards)
  return Add(cards,PRIO_TOFIELD)
end
function KoSTarget(cards)
  return Add(cards,PRIO_TOHAND)
end
-- FluffalS Target
GlobalToyVendor = 0
function ToyVendorTarget(cards)
  if LocCheck(cards,LOCATION_DECK) then
    print("ToyVendorTarget - DECK to HAND")
	GlobalToyVendor = 0
	--CountPrioTarget(cards,PRIO_TOHAND,1,nil,nil,nil,"ToyVendorTarget - HAND")
    return Add(cards,PRIO_TOHAND)
  end
  if GlobalToyVendor == 0 then
    print("ToyVendorTarget - HAND to GRAVE")
	GlobalToyVendor = 1
    return Add(cards,PRIO_DISCARD)
  end
  if GlobalToyVendor == 1 then
    print("ToyVendorTarget - HAND to FIELD")
	GlobalToyVendor = 2
    return Add(cards,PRIO_TOFIELD)
  end
  if GlobalToyVendor == 2 then
    GlobalToyVendor = 0
  end
end

-- FUSION TARGET
GlobalFusionPerform = 0 -- Perform Only
GlobalFusionId = 0 -- Fusion MonsterID

GlobalPolymerization = 0
function PolymerizationTarget(cards,c,min,max)
  --print("PolymerizationTarget: "..GlobalFusionPerform)
  local result
  GlobalPolymerization = 1
  result = FusionSummonTarget(cards,c,min,max,MATERIAL_TOGRAVE)
  GlobalPolymerization = 0
  return result
end

GlobalDFusion = 0
function DFusionTarget(cards,c,min,max)
  local result
  GlobalDFusion = 1
  result = FusionSummonTarget(cards,c,min,max,MATERIAL_TOGRAVE)
  GlobalDFusion = 0
  return result
end

GlobalFFactory = 0
function FFactoryTarget(cards,c,min,max)
  --print("FFactoryTarget: "..GlobalFusionPerform)
  if LocCheck(cards,LOCATION_GRAVE) then
    print("FFactoryTarget - GRAVE to BANISH")
    return Add(cards,PRIO_BANISH)
  end
  if LocCheck(cards,LOCATION_REMOVED) then
    print("FFactoryTarget - BANISH to HAND")
    return Add(cards,PRIO_TOHAND)
  end
  local result
  GlobalFFactory = 1
  result = FusionSummonTarget(cards,c,min,max,MATERIAL_TOGRAVE)
  GlobalFFactory = 0
  return result
end

GlobalFFusion = 0
function FFusionTarget(cards,c,min,max)
  local result
  GlobalFFusion = 1
  result = FusionSummonTarget(cards,c,min,max,PRIO_BANISH)
  GlobalFFusion = 0
  return result
end

-- FUSION FUNCTIONS
function MaxMaterials(fusionId,min,max)
  local result = 1

  if(fusionId == 80889750) then -- FSabreTooth
    result = 2
  else
    result = 1
  end

  if fusionId == 11039171 then -- FWolf
    result = 1
	if #AIMon() > 4 then
	  result = result + 1
	end
	if #OppMon() == 0
	and CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) == 0
	then
	  local oppRemainLP = AI.GetPlayerLP(2) - ExpectedDamage(2)
	  result = RoundCustom((oppRemainLP / (2000 + FrightfurBoost(fusionId))),0)
	end
  end

  if fusionId == 00464362 then -- FTiger
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
	  result = 1
	elseif CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) == 1 then
	  if result > 2 then
	    result = 2
	  end
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
function FusionSummonTarget(cards,c,min,max,materialDest)
  if LocCheck(cards,LOCATION_EXTRA) then
    local result = {}
    local indexT = 1

	for i=1, #cards do
	  local c = cards[i]
	  result[i] = c
	  print("FusionTarget0: "..c.id.." - PRIO: "..GetPriority(c,PRIO_TOFIELD))
	end
	GlobalFusionPerform = 1
	indexT = Add(cards,PRIO_TOFIELD)[1]
	GlobalFusionId = result[indexT].id
	print("FusionTarget: "..GlobalFusionId)
	return Add(cards,PRIO_TOFIELD)
  end

  if GlobalFusionPerform == 1 then
    GlobalFusionPerform = 2
    --print("FusionTarget1 - First Material")
	--CountPrioTarget(cards,materialDest,1,nil,nil,nil,"FusionTarget1")
	return Add(cards,materialDest)
  end

  if GlobalFusionPerform >= 2 then
    GlobalFusionPerform = GlobalFusionPerform + 1
    --print("FusionTarget"..GlobalFusionPerform.." - Second Material")
	--CountPrioTarget(cards,materialDest,MaxMaterials(GlobalFusionId,min,max),nil,nil,nil,"FusionTarget"..GlobalFusionPerform)
	return Add(cards,materialDest,MaxMaterials(GlobalFusionId,min,max))
  end
end

-------------------

-- Spell Target
GlobalIFusion = 0
function IFusionTarget(cards)
  local result = {}
  local indexT = 1
  for i=1, #cards do
	local c = cards[i]
	result[i] = c
  end
  indexT = Add(cards,PRIO_TOFIELD)[1]
  OPTSet(result[indexT].cardid)
  GlobalIFusion = 1
  return Add(cards,PRIO_TOFIELD)
end

-- Trap Target
function FReserveTarget(cards,c)
  if LocCheck(cards,LOCATION_EXTRA) then
    print("FReserveTarget - EXTRA")
    return Add(cards,PRIO_TOHAND)
  end
  if LocCheck(cards,LOCATION_DECK) then
    print("FReserveTarget - DECK to HAND")
    return Add(cards,PRIO_TOHAND)
  end
  return Add(cards)
end

GlobalJAvarice = 0
function JAvariceTarget(cards)
  GlobalJAvarice = 1
  return Add(cards,PRIO_TOHAND,5,FilterType,TYPE_SPELL+TYPE_TRAP)
end

function BTSDarkLawTarget(cards)
  local darkLawIndex = IndexByID(OppMon(),58481572)
  if darkLawIndex then
    print("DarkLawIndex: "..darkLawIndex)
    return {darkLawIndex}
  else
    return {1}
  end
end

-- Frightfur Target
GlogalFSabreTooth = 0
function FSabreTarget(cards)
  local result
  GlogalFSabreTooth = 1
  --CountPrioTarget(cards,PRIO_TOFIELD,1,nil,nil,nil,"FSabreTarget")
  result = Add(cards,PRIO_TOFIELD)
  GlogalFSabreTooth = 0
  return result
end
function FKrakenTarget(cards)
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
	and OPTCheck(06077601)
	then
      result[#result+1] = FFactoryIndex
	end
  end

  return result
end

function StarveTarget(cards,c,min,max)
  return BestTargets(cards,max,TARGET_DESTROY)
end
-- Other Fusion Target
-- Other XYZ Target

--39246582, -- Fluffal Dog
--03841833, -- Fluffal Bear
--65331686, -- Fluffal Owl
--98280324, -- Fluffal Sheep
--02729285, -- Fluffal Cat
--38124994, -- Fluffal Rabit
--06142488, -- Fluffal Mouse
--72413000, -- Fluffal Wings
--81481818, -- Fluffal Patchwork (BETA)
--00007614, -- Fluffal Octo (BETA)
--97567736, -- Edge Imp Tomahawk
--61173621, -- Edge Imp Chain
--30068120, -- Edge Imp Sabres
--10802915, -- Tour Guide from the Underworld
--79109599, -- King of the Swamp
--67441435, -- Glow-Up Bulb

--70245411, -- Toy Vendor
--06077601, -- Frightfur Fusion
--43698897, -- Frightfur Factory
--01845204, -- Instant Fusion
--24094653, -- Polymerization
--94820406, -- Dark Fusion
--05133471, -- Galaxy Cyclone
--43898403, -- Twin Twister

--66127916, -- Fusion Reserve

--80889750, -- Frightfur Sabre-Tooth
--00007620, -- Frightfur Kraken (BETA)
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
  if id == 02729285 then -- Cat
    return CatTarget(cards)
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
  if id == 10802915 then -- TGuide
    return TGuideTarget(cards)
  end

  if id == 70245411 then -- ToyVendor
	return ToyVendorTarget(cards,c)
  end

  if id == 24094653 then -- Polymerization
	return PolymerizationTarget(cards,c,min,max)
  end
  if id == 94820406 then -- DFusion
	return DFusionTarget(cards,c,min,max)
  end
  if id == 43698897 then -- FFactory
	return FFactoryTarget(cards,c,min,max)
  end
  if id == 06077601 then -- FFusion
	return FFusionTarget(cards,c,min,max)
  end

  if id == 01845204 then -- IFusion
	return IFusionTarget(cards)
  end

  if id == 66127916 then -- FReserve
	return FReserveTarget(cards)
  end
  if id == 98954106 then -- JAvarice
	return JAvariceTarget(cards)
  end

  if id == 78474168
  and GlobalDarkLaw > 0
  then
    return BTSDarkLawTarget(cards,c)
  end

  if id == 80889750 then -- FSabreTooth
	return FSabreTarget(cards)
  end
  if id == 00007620 then -- FKraken
	return FKrakenTarget(cards)
  end
  if id == 10383554 then -- FLeo
	return FLeoTarget(cards)
  end
  if id == 00464362 then -- FTiger
    return FTigerTarget(cards,c,min,max)
  end

  if id == 41209827 then
    return StarveTarget(cards,c,min,max)
  end

  return nil
end

function FluffalNumber(choices) -- FLUFFAL NUMBER
  --print("FluffalNumber")
  return nil
end

function RoundCustom(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end