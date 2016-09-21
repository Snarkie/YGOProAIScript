------------------------
--------- USE ----------
------------------------
-- FluffalM Use
function UseFluffalBear(c)
  if CountToyVendorDiscardTarget() > 0 and #AIHand() > 2
  or HasID(AIHand(),72413000,true) -- Wings
  or HasID(AIHand(),67441435,true) -- Bulb
  or (not NormalSummonCheck() and HasID(AIHand(),39246582,true)) -- Dog
  or (
    CardsMatchingFilter(AIST(),ToyVendorCheckFilter,false) > 0 -- Toy Vendor
	and HasID(AIGrave(),72413000,true) -- Wings
  )
  then
    OPTSet(c.id)
    return true
  else
    return false
  end
end
function UseFluffalBear2(c)
  if FilterLocation(c,LOCATION_MZONE) then
    OPTSet(c.id)
    return true
  else
    return false
  end
end
function UseOwl(c)
  OPTSet(c.id)
  return true
end
function UseOwl2(c)
  GlobalFusionSummon = 1
  GlobalMaterialF = CountMaterialFTarget(UseLists({AIHand(),AIMon()}))
  GlobalMaterialE = CountMaterialETarget(UseLists({AIHand(),AIMon()}))
  local countF = CountFusionTarget()
  GlobalFusionSummon = 0
  if countF > 0 then
    OPTSet(c.id)
    return true
  else
    return false
  end
end
function UseSheep(c)
  if OPTCheck(c.id) and CountEgdeImp(AIGrave()) > 0 then
    OPTSet(c.id)
    return true
  else
    return false
  end
end
function UseSheep2(c)
  if OPTCheck(c.id)
  and CountEgdeImp(UseLists({AIGrave(),AIHand()})) > 0
  then
    OPTSet(c.id)
    return true
  else
    return false
  end
end
function UseSheep3(c)
  if OPTCheck(c.id) and HasID(AIHand(),97567736,true) then -- Tomahawk
    OPTSet(c.id)
    return true
  else
    return false
  end
end

function UseMouse(c)
  OPTSet(c.id)
  OPDSet(c.cardid)
  return
    OPTCheck(10802915) -- TourGuide
	and OPTCheck(67441435) -- Bulb
end
function UseWings(c)
  if CountWingsTarget() > 0
  and CardsMatchingFilter(AIST(),ToyVendorCheckFilter,false) > 0
  then
    OPTSet(c.id)
	return true
  else
    return false
  end
end
-- EdgeImp Use
function UseTomahawk1(c)
  return true
end
function UseTomahawk2(c)
  return true
end
function UseSabres(c)
  if HasID(AIHand(),06142488,true) -- Mouse Hand
  and HasID(AIMon(),06142488,true) -- Mouse Field
  and #AIMon() < 4
  then
    return true
  else
    return false
  end
end
function UseSabres2(c)
  if HasID(AIHand(),06142488,true) -- Mouse Hand
  and HasID(AIMon(),06142488,true) -- Mouse Field
  and #AIMon() < 4
  then
    return true
  elseif HasID(AIExtra(),83531441,true) -- Dante
  and OPTCheck(06142488) -- Mouse
  and CountPrioTarget(AIHand(),PRIO_DISCARD,1) > 0
  and FieldCheck(3) > 0
  and OppGetStrongestAttDef() < 2500
  then
    return true
  elseif HasID(AIExtra(),41209827,true) -- Starve
  and OPTCheck(06142488) -- Mouse
  and CountPrioTarget(AIHand(),PRIO_DISCARD,1) > 0
  and #AIHand() > 4
  and SpSummonSVFD()
  and (
    HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
  )
  then
    return true
  else
    return false
  end
end
-- Other Use
function UseTourGuide()
  OPTSet(10802915)
  return true
end
function UseKoS(c)
  if not HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
  and not HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
  and (
    CardsMatchingFilter(UseLists({AIHand(),AIMon()}),FilterID,c.id) > 1
	or HasID(UseLists({AIHand(),AIST()}),01845204,true) -- Instant Fusion
	or HasID(UseLists({AIHand(),AIMon()}),30068120,true) -- Sabres
	or HasID(UseLists({AIHand(),AIMon()}),61173621,true) -- Chain
	and not HasID(AIMon(),57477163,true) -- FSheep
  )
  and not (
    HasID(AIHand(),65331686,true) -- Owl
	and not NormalSummonCheck()
  )
  then
    return true
  else
    return false
  end
end
function UseKoS2(c) -- When I dont have cards to discard
  if CountToyVendorDiscardTarget() == 0
  and (
    CardsMatchingFilter(AIST(),ToyVendorCheckFilter,true) > 0
	or HasID(AIHand(),70245411,true) -- Toy Vendor
  )
  and #AIHand() > 3
  and OPTCheck(72413000) -- Wings
  then
    return true
  else
    return false
  end
end
function UseBulb(c)
  if FieldCheck(4) > 0
  and OPTCheck(06142488) -- Mouse
  and AI.GetCurrentPhase() == PHASE_MAIN1
  and (
	OppGetStrongestAttDef() <= 2100
    or OppGetStrongestAttack() < AIGetStrongestAttack()
  )
  then
    OPDSet(c.id)
	OPTSet(c.id)
    return true
  else
    return false
  end
end
-- FluffalS Use
function ActiveToyVendor(c)
  if CountToyVendorDiscardTarget() > 0
  and (
	#AIHand() > 2
	or HasID(AIHand(),72413000,true) and OPTCheck(72413000) -- Wings
  )
  and not (
    #AIMon() == 5 and (
      HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	  or HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
	  or HasID(UseLists({AIHand(),AIST()}),06077601,true) -- FFusion
	)
  )
  then
    return true
  else
    return false
  end
end
function ActiveToyVendor2(c)
  if CardsMatchingFilter(AIST(),ToyVendorCheckFilter,true) == 0 -- Toy Vendor
  and (
    CountToyVendorDiscardTarget() > 0
    and #AIHand() > 2
	or (
	  HasID(AIHand(),72413000,true) -- Wings
	  and OPTCheck(72413000)
	)
  )
  and not (
    #AIMon() == 5 and (
      HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	  or HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
	  or HasID(UseLists({AIHand(),AIST()}),06077601,true) -- FFusion
	)
  )
  then
    return true
  else
    return false
  end
end
function UseToyVendor(c)
  if HasID(AIHand(),72413000,true) then -- Wings
    OPTSet(c.cardid)
	return true
  elseif
  not NormalSummonCheck() and HasID(AIHand(),39246582,true) and OPTCheck(39246582) -- Dog
  and OPTCheck(72413000) and not HasID(AIGrave(),72413000,true) then -- Wings
	return false
  elseif (
    #AIHand() > 2
	or OppGetStrongestAttack() >= AIGetStrongestAttack()
  )
  and CountToyVendorDiscardTarget() > 0
  then
    OPTSet(c.cardid)
	return true
  else
    return false
  end
end

function ActiveFFactory(c)
  if FilterLocation(c,LOCATION_HAND) or FilterPosition(c,POS_FACEDOWN) then
    if HasID(AIGrave(),06077601,true) -- Frightfur Fusion
    or HasID(AIGrave(),01845204,true) -- Instant Fusion
	or HasID(AIGrave(),94820406,true) -- Dark Fusion
	or Get_Card_Count_ID(AIGrave(),24094653) > 1 -- Polymerization
	or AI.GetPlayerLP(1) <= 2000
	then
	  GlobalFusionSummon = 1
	  GlobalMaterialF = CountMaterialFTarget(UseLists({AIHand(),AIMon()}))
      GlobalMaterialE = CountMaterialETarget(UseLists({AIHand(),AIMon()}))
      local countF = CountFusionTarget()
	  GlobalFusionSummon = 0
      if countF > 0 then
        return true
      else
        return false
      end
	else
	  return false
	end
  else
    return false
  end
end
function UseFFactory(c)
  if FilterLocation(c,LOCATION_SZONE) then
    if HasID(AIGrave(),06077601,true) -- Frightfur Fusion
    or HasID(AIGrave(),01845204,true) -- Instant Fusion
	or HasID(AIGrave(),94820406,true) -- Dark Fusion
	or Get_Card_Count_ID(AIGrave(),24094653) > 1 -- Polymerization
	or AI.GetPlayerLP(1) <= 2000
	then
	  GlobalFusionSummon = 1
	  GlobalMaterialF = CountMaterialFTarget(UseLists({AIHand(),AIMon()}))
      GlobalMaterialE = CountMaterialETarget(UseLists({AIHand(),AIMon()}))
      local countF = CountFusionTarget()
	  GlobalFusionSummon = 1
      if countF > 0 then
	    OPTSet(c.id)
        return true
      else
        return false
      end
	else
	  return false
	end
  end
end

function UseFFusion(c)
  GlobalFFusion = 1
  local countF = CountFusionTarget()
  GlobalFFusion = 0
  if countF > 0 then
    OPTSet(c.id)
    return true
  else
    return false
  end
end
-- Spell Use
function UseIFusion(c)
  if not HasID(AIMon(),80889750,true) -- Frightfur Sabre-Tooth
  and (
    HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	or HasID(UseLists({AIHand(),AIST()}),43698897,true) -- Frightfur Factory
  )
  and CountMaterialFTarget(UseLists({AIHand(),AIMon()})) > 1
  and Duel.GetTurnCount() ~= 1
  then
    OPTSet(c.id)
    return true
  else
    return false
  end
end
GlobalMaterialF = 0
GlobalMaterialE = 0
function UsePolymerization(c)
  GlobalFusionSummon = 1
  GlobalPolymerization = 1

  GlobalMaterialF = CountMaterialFTarget(UseLists({AIHand(),AIMon()}))
  GlobalMaterialE = CountMaterialETarget(UseLists({AIHand(),AIMon()}))
  local countF = CountFusionTarget()

  GlobalFusionSummon = 0
  GlobalPolymerization = 0
  if countF > 0
  then
    return true
  else
    return false
  end
end
function UseDFusion(c)
  GlobalFusionSummon = 1
  GlobalDFusion = 1

  GlobalMaterialF = CountMaterialFTarget(UseLists({AIHand(),AIMon()}))
  GlobalMaterialE = CountMaterialETarget(UseLists({AIHand(),AIMon()}))
  local countF = CountFusionTarget()

  GlobalDFusion = 0
  GlobalFusionSummon = 0
  if countF > 0
  then
    return true
  else
    return false
  end
end

function UseGCyclone(c)
  if FilterLocation(c,LOCATION_HAND)
  or FilterLocation(c,LOCATION_SZONE)
  then
    if CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) > 0 then
	  return true
	else
	  return false
	end
  end
  local oppSTFaceUp = CardsMatchingFilter(OppST(),FilterPosition,POS_FACEUP)
  local oppSTNoDestroy = CardsMatchingFilter(OppST(),NoDestroyCheck)
  if FilterLocation(c,LOCATION_GRAVE) then
    if oppSTFaceUp > 0
	and oppSTFaceUp > oppSTNoDestroy
	then
	  return true
	else
	  return false
	end
  end
  return false
end
-- Trap Use
function UseFReserve(c)
  return HasID(AIGrave(),24094653,true)
end
function UseFReserve2(c)
  return AI.GetPlayerLP(1) <= 2000 or  AI.GetPlayerLP(1) <= 5000 and AIMon() == 0
end
-- Frightfur Use
function UseFKraken(c)
  return true
end
function UseFSabre(c)
  return true
end
function UseFLeo(c)
  OPTSet(c.id)
  return true
end
function UseFTiger(c)
  if CardsMatchingFilter(OppField(),FTigerDestroyFilter) > 0 then
	return true
  end
end

-- Other Use
function UseDanteFluffal(c)
  GlobalActivatedCardID = c.id
  OPDSet(c.id)
  return true
end
function UseStarve(c)
  GlobalActivatedCardID = c.id
  OPDSet(c.id)
  return true
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
--00007614, -- Fluffal Octo (BETA)
--97567736, -- Edge Imp Tomahawk
--61173621, -- Edge Imp Chain
--30068120, -- Edge Imp Sabres
--79109599, -- King of the Swamp
--67441435, -- Glow-Up Bulb

--06077601, -- Frightfur Fusion
--43698897, -- Frightfur Factory
--70245411, -- Toy Vendor
--01845204, -- Instant Fusion
--24094653, -- Polymerization
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

function FluffalEffectYesNo(id,card) -- FLUFFAL EFFECT YES/NO
  print("EffectYesNo - Cardid: "..card.id.." - desc: "..card.description)
  local result = nil
  if id == 39246582 then -- Dog
	result = 1
  end
  if id == 65331686 then -- Owl
	result = 1
  end
  if id == 02729285 then -- Cat
	result = 1
  end
  if id == 38124994 then -- Rabit
	result = 1
  end
  if id == 00007614 then -- Octo
	result = 1
  end

  if id == 61173621 then -- Chain
	result = 1
  end

  if id == 10802915 then -- TourGuide
	result = UseTourGuide()
  end

  if id == 43698897 then -- Frightfur Factory
	result = 1
  end
  if id == 70245411 then -- ToyVendor
	result = 1
  end

  if id == 80889750 then -- Frightfur Sabre-Tooth
	result = 1
  end
  if id == 00007620 then -- Frightfur Kraken
	result = 1
  end
  if id == 10383554 then -- Frightfur Leo
	result = 1
  end
  if id == 00464362 then -- Frightfur Tiger
    return UseFTiger(card)
  end
  if id == 57477163 then -- Frightfur Sheep
    return 1
  end

  if id == 41209827 then -- Starve
    return 1
  end

  OPTSet(id)
  return result
end

function FluffalYesNo(desc) -- FLUFFAL YES/NO
  print("YesNo: "..desc)
  if desc == 1561083776 then -- Tomahawk Desc 1
    return 1
  end
  if desc == 1561083777 then -- Tomahawk Desc 2
    return 1
  end
  if desc == 93 then -- Choose material?
    return 0
  end
  return nil
end
