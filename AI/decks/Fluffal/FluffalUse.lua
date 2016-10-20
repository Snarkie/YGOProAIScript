------------------------
--------- USE ----------
------------------------

-- FluffalM Use
function UseFluffalBear(c,mode)
  if (
    CardsMatchingFilter(AIST(),ToyVendorCheckFilter,true) == 0
	or CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) == 0
  )
  then
    if HasID(AIHand(),72413000,true) -- Wings
    or HasID(AIHand(),67441435,true) -- Bulb
    then
	  OPTSet(c.id)
      return true
    elseif CountToyVendorDiscardTarget(mode) > 0
    and (
      #AIHand() > 2
	  or OppGetStrongestAttack() >= AIGetStrongestAttack()
	  or GlobalFluffalPercent >= 0.45
    )
	then
	  OPTSet(c.id)
	  return true
	elseif
	(
	  not NormalSummonCheck()
	  and (
	    HasID(AIHand(),39246582,true) and OPTCheck(39246582) -- Dog
		or
		HasID(AIHand(),00007614,true) and SummonOcto() -- Octo
	  )
	)
	or
	(
      CardsMatchingFilter(AIST(),ToyVendorCheckFilter,false) > 0 -- ToyVendor
	  and HasID(AIGrave(),72413000,true) -- Wings
	  and OPTCheck(72413000)
    )
	then
	  OPTSet(c.id)
	  return true
	end
  else
    return false
  end
end
function UseBearPoly(c)
  if FilterLocation(c,LOCATION_MZONE)
  and not HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
  then
    OPTSet(c.id)
    return true
  else
    return false
  end
end
function UseBearPoly2(c)
  if FilterLocation(c,LOCATION_MZONE) then
    OPTSet(c.id)
    return true
  else
    return false
  end
end
function UseOwl(c)
  GlobalMaterialF = CountMaterialFTarget(UseLists({AIHand(),AIMon()}),MATERIAL_TOGRAVE)
  GlobalMaterialE = CountMaterialETarget(UseLists({AIHand(),AIMon()}),MATERIAL_TOGRAVE)
  local countF = CountFusionTarget()
  if countF > 0 then
    OPTSet(c.id)
    return true
  else
    return false
  end
end
function UseSheep(c)
  if CountEgdeImp(AIGrave()) > 0 then
    OPTSet(c.id)
    return true
  else
    return false
  end
end
function UseSheep2(c)
  if CountEgdeImp(UseLists({AIGrave(),AIHand()})) > 0
  then
    OPTSet(c.id)
    return true
  else
    return false
  end
end
function UseSheepTomahawk(c)
  if HasID(AIHand(),97567736,true) -- Tomahawk
  then
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
    OPTCheck(10802915) -- TGuide
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
function UseWings2(c)
  if ExpectedDamage(1) >= AI.GetPlayerLP(1)
  and #AIMon() == 0
  then
    OPTSet(c.id)
	return true
  else
    return false
  end
end

-- EdgeImp Use
function UseTomahawkCopy(c)
  return true
end
function UseTomahawkDamage(c)
  if #AIHand() > 4
  or HasID(AIHand(),98280324,true) -- Sheep
  or AI.GetPlayerLP(2) <= 800
  then
    return true
  else
    return false
  end
end
function UseSabres(c)
  if HasID(AIHand(),06142488,true) -- Mouse Hand
  and HasID(AIMon(),06142488,true) -- Mouse Field
  and #AIMon() < 4
  then
    OPTSet(30068120)
    return true
  else
    return false
  end
end
function UseSabres2(c)
  local countDiscart = CountPrioTarget(AIHand(),PRIO_DISCARD,3)
  local hand = #AIHand()

  if HasID(AIExtra(),83531441,true) -- Dante
  and OPTCheck(06142488) -- Mouse
  and countDiscart > 0
  and FieldCheck(3) > 0
  and OppGetStrongestAttDef() < 2500
  then
    OPTSet(30068120)
    return true
  elseif HasID(AIExtra(),41209827,true) -- Starve
  and OPTCheck(06142488) -- Mouse
  and countDiscart > 0
  and hand > 5
  and SpSummonStarve()
  and (
    HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
  )
  then
    OPTSet(30068120)
    return true
  elseif CountEgdeImp(UseLists({AIHand(),AIMon()})) == 0
  and not HasID(UseLists({AIHand(),AIMon()}),79109599,true)
  and countDiscart > 1
  and hand > 5
  and (
    HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
  )
  then
    OPTSet(30068120)
	return true
  else
    return false
  end
end

-- Other Use
function UseKoS(c)
  if not HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
  and not HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
  and not HasID(AIST(),43698897,true) -- FFactory
  and (
    Get_Card_Count_ID(UseLists({AIHand(),AIMon()}),c.id) > 1
	or HasID(UseLists({AIHand(),AIST()}),01845204,true) -- IFusion
	or HasID(UseLists({AIHand(),AIMon()}),30068120,true) -- Sabres
	or HasID(UseLists({AIHand(),AIMon()}),61173621,true) -- Chain
	or
	CountFrightfurMon(AIMon()) > 0
	and CountFluffalGraveTarget(UseLists({AIHand(),AIMon()})) > 1
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

function UseKoSDiscard(c)
  if CountToyVendorDiscardTarget(1) == 0
  and (
    CardsMatchingFilter(AIST(),ToyVendorCheckFilter,true) > 0
	or HasID(AIHand(),70245411,true) -- ToyVendor
  )
  and (
    #AIHand() > 3
    or OPTCheck(72413000) -- Wings
  )
  and (
    CountEgdeImp(UseLists({AIHand(),AIMon()})) > 0
	or HasID(AIHand(),24094653,true) -- Polymerization
  )
  and Duel.GetTurnCount() > 1
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
GlobalFluffalPercent = 0.0
function ActiveToyVendor(c,mode)
  if HasID(AIHand(),72413000,true) -- Wings
  then
	return true
  elseif not NormalSummonCheck()
  and (
    HasID(AIHand(),39246582,true) and OPTCheck(39246582) -- Dog
	or
	HasID(AIHand(),00007614,true) and SummonOcto() -- Octo
  )
  and OPTCheck(72413000) and not HasID(AIGrave(),72413000,true) -- Wings
  then
    return false
  elseif HasID(AIHand(),67441435,true) -- Bulb
  then
    return true
  elseif CountToyVendorDiscardTarget(mode) > 0
  and (
    CardsMatchingFilter(AIST(),ToyVendorCheckFilter,true) == 0
	or FilterLocation(c,LOCATION_SZONE)
  )
  and (
    #AIHand() > 3 and FilterLocation(c,LOCATION_HAND)
	or #AIHand() > 2 and FilterLocation(c,LOCATION_SZONE)
	or GlobalFluffalPercent >= 0.45
	or OppGetStrongestAttack() >= AIGetStrongestAttack()
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
  return false
end

function UseToyVendor(c,mode)
  if HasID(AIHand(),72413000,true) -- Wings
  then
    OPTSet(c.cardid)
	return true
  elseif not NormalSummonCheck()
  and (
    HasID(AIHand(),39246582,true) and OPTCheck(39246582) -- Dog
	or
	HasID(AIHand(),00007614,true) and SummonOcto() -- Octo
  )
  and OPTCheck(72413000) and not HasID(AIGrave(),72413000,true) -- Wings
  then
    return false
  elseif HasID(AIHand(),67441435,true) -- Bulb
  then
	OPTSet(c.cardid)
    return true
  elseif CountToyVendorDiscardTarget(mode) > 0
  and (
    #AIHand() > 2
	or GlobalFluffalPercent >= 0.45
	or OppGetStrongestAttack() >= AIGetStrongestAttack()
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
    OPTSet(c.cardid)
	return true
  else
    return false
  end
  return false
end

function ActiveFFactory(c)
  return FilterLocation(c,LOCATION_HAND) and UseFFactory(c)
end
function UseFFactory(c)
  if HasID(AIGrave(),06077601,true) -- FFusion
  or HasID(AIGrave(),01845204,true) -- IFusion
  or HasID(AIGrave(),94820406,true) -- DFusion
  or Get_Card_Count_ID(AIGrave(),24094653) > 1 -- Polymerization
  or
  #AIMon() == 5
  and HasID(AIGrave(),24094653,true) -- Polymerization
  and (
    not HasID(UseLists({AIHand(),AIST()}),06077601,true) -- FFusion
    or not OPTCheck(06077601)
  )
  or #OppField() <= 2
  and HasID(AIGrave(),24094653,true) -- Polymerization
  and (
    not HasID(UseLists({AIHand(),AIST()}),06077601,true) -- FFusion
    or not OPTCheck(06077601)
  )
  then
    GlobalMaterialF = CountMaterialFTarget(UseLists({AIHand(),AIMon()}),MATERIAL_TOGRAVE)
    GlobalMaterialE = CountMaterialETarget(UseLists({AIHand(),AIMon()}),MATERIAL_TOGRAVE)
	local countF = CountFusionTarget()
    if countF > 0 then
      OPTSet(c.id)
      return true
    else
      return false
    end
  else
	return false
  end
  return false
end

-- Spell Use
function UseIFusion(c)
  if AI.GetPlayerLP(1) <= 1000 then
    return false
  end
  if HasID(AIExtra(),80889750,true) -- FSabreTooth
  --and not HasID(AIMon(),57477163,true) -- FSheep
  and (
    HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	or HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
  )
  and (
    CountMaterialFTarget(UseLists({AIHand(),AIMon()}),MATERIAL_TOGRAVE)
	+ CountEgdeImp(UseLists({AIHand(),AIMon()}))
  )	> 1
  --and Duel.GetTurnCount() ~= 1
  then
    GlobalActivatedCardID = c.id
    OPTSet(c.id)
    return true
  elseif not HasID(AIMon(),80889750,true) -- FSabreTooth
  and HasID(UseLists({AIHand(),AIST()}),06077601,true) -- FFusion
  and CountFrightfurMon(UseLists({AIMon(),AIGrave()})) > 2 -- Frightfurs
  and CountMaterialFTarget(UseLists({AIMon(),AIGrave()}),PRIO_BANISH) > 1
  then
    OPTSet(c.id)
    return true
  else
    return false
  end
end

-- FUSION USE
GlobalMaterialF = 0
GlobalMaterialE = 0
function UsePolymerization(c)
  GlobalPolymerization = 1

  GlobalMaterialF = CountMaterialFTarget(UseLists({AIHand(),AIMon()}),MATERIAL_TOGRAVE)
  GlobalMaterialE = CountMaterialETarget(UseLists({AIHand(),AIMon()}),MATERIAL_TOGRAVE)
  local countF = CountFusionTarget()

  GlobalPolymerization = 0

  if countF > 0
  then
    return true
  else
    return false
  end
end
function UseDFusion(c)
  GlobalDFusion = 1

  GlobalMaterialF = CountMaterialFTarget(UseLists({AIHand(),AIMon()}),MATERIAL_TOGRAVE)
  GlobalMaterialE = CountMaterialETarget(UseLists({AIHand(),AIMon()}),MATERIAL_TOGRAVE)
  local countF = CountFusionTarget()

  GlobalDFusion = 0

  if countF > 0
  and (Duel.GetTurnCount() > 1 or GlogalFSabreTooth > 0)
  then
    return true
  else
    return false
  end
end

function UseFFusion(c)
  GlobalFFusion = 1

  GlobalMaterialF = CountMaterialFTarget(UseLists({AIMon(),AIGrave()}),PRIO_BANISH)
  GlobalMaterialE = CountMaterialETarget(UseLists({AIMon(),AIGrave()}),PRIO_BANISH)
  local countF = CountFusionTarget()

  GlobalFFusion = 0

  if countF > 0 and Duel.GetTurnCount() > 1 then
    OPTSet(c.id)
    return true
  else
    return false
  end
end

-- Trap Use
function UseFReserve(c)
  return HasID(AIGrave(),24094653,true)
end
function UseFReserve2(c)
  return
    AI.GetPlayerLP(1) <= 2000
	or
	AI.GetPlayerLP(1) <= 5000 and #AIMon() == 0
end

function UseJAvarice(c)
  local countFluffal = CountFluffal(AIGrave())
  local countGrave = #AIGrave()
  local countST = CardsMatchingFilter(AIGrave(),FilterType,TYPE_SPELL+TYPE_TRAP)
  if countST > 2
  and (countGrave - countFluffal) >= 5
  then
    return true
  elseif ExpectedDamage(1) >= AI.GetPlayerLP(1) and #AIMon() == 0
  then
    return true
  end
  return false
end

-- Frightfur Use
function UseFSabre(c)
  return true
end
function UseFKrakenSend(c)
  if not BattlePhaseCheck() then
    OPTSet(c.id)
    return true
  end
  local fkrakenCanSend = CardsMatchingFilter(OppMon(),FKrakenSendFilter)
  local fkrakenCanAttak = CanAttackAttackMax(OppMon(),false,c.attack-1)
  if CardsMatchingFilter(OppMon(),FilterAffected,EFFECT_INDESTRUCTABLE) > 0
  then
    OPTSet(c.id)
    return true
  elseif OppGetStrongestAttDef() > AIGetStrongestAttack()
  and fkrakenCanSend > 0
  then
    OPTSet(c.id)
    return true
  elseif #OppMon() > 2
  and fkrakenCanSend > 0
  then
    OPTSet(c.id)
    return true
  elseif fkrakenCanAttak <= 2
  and not (
    HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
    or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	or HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
  )
  then
    return false
  else
    OPTSet(c.id)
	return true
  end
end
function UseFKrakenRepo(c)
  if c.attack <= 3500
  then
    return true
  else
    return false
  end
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

-- Other Fusion Use
function UseStarve(c)
  GlobalActivatedCardID = c.id
  OPDSet(c.id)
  return true
end
-- Other XYZ Use
function UseDanteFluffal(c)
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
  if id == 00007614  then -- Octo
    if card.description == 121824 then
	  id = id
	else -- Material
	  id = id + 1
	end
	result = 1
  end

  if id == 61173621 then -- Chain
	result = 1
  end

  if id == 10802915 then -- TourGuide
	result = 1
  end

  if id == 43698897 then -- FFactory
	result = 1
  end
  if id == 70245411 then -- ToyVendor
	result = 1
  end

  if id == 80889750 then -- FSabreTooth
	result = 1
  end
  if id == 00007620 and UseFKrakenRepo(card) then -- FKraken
	result = 1
  end
  if id == 85545073 then -- FBear
    result = 1
  end
  if id == 00464362 then -- FTiger
    return UseFTiger(card)
  end
  if id == 57477163 then -- FSheep
    result = 1
  end

  if id == 41209827 then -- Starve
    result = 1
  end

  if result then
    if result == 1 then
      OPTSet(id)
	end
  end

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