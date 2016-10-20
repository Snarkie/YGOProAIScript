------------------------
--------- COND ---------
------------------------

-- FluffalM cond
function DogCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if not OPTCheck(c.id) and Duel.GetTurnCount() ~= 1
	or
	Get_Card_Count_ID(AIHand(),c.id) > 1
	and GlobalFusionId ~= 80889750
	then
      return 5 + PrioFluffalMaterial(c,1)
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    if GlobalSheep == 1
	and not HasID(AIHand(),c.id,true)
	then
      return 8
    end
	if #AIDeck() <= 17 then
	  return 3
	end
	if HasID(AIHand(),c.id,true)
	or not OPTCheck(c.id)
	then
	  return 1
	end
	return
	  not NormalSummonCheck()
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 6
	  else
	    return 3
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    if Get_Card_Count_ID(AIHand(),c.id) > 1 then
	  return 5
	else
	  return not OPTCheck(c.id)
    end
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function BearCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if not HasID(AIDeck(),70245411,true) then
	  return 7 + PrioFluffalMaterial(c,1)
    elseif not OPTCheck(c.id) and Duel.GetTurnCount() ~= 1
	or
	Get_Card_Count_ID(AIHand(),c.id) > 1
	and GlobalFusionId ~= 80889750
	then
      return 6 + PrioFluffalMaterial(c,1)
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    if GlobalSheep == 1
	and not HasID(AIHand(),c.id,true)
	then
      return 6
    end
    if HasID(AIHand(),c.id,true)
	or not OPTCheck(c.id)
	then
	  return 1
	end
    local fluffalsGrave = CountFluffal(AIGrave())
	if HasID(AIDeck(),70245411,true) -- ToyVendor
	and not HasID(AIHand(),70245411,true)
	and OPTCheck(72413000) -- Wings
	and (
	  not HasID(AIST(),70245411,true) -- ToyVendor
	  or
	  HasID(AIGrave(),72413000,true) -- Wings
	  and fluffalsGrave < 2
    )
	and (
	  CountToyVendorDiscardTarget(1) > 0
	  or
	  HasID(AIGrave(),72413000,true) -- Wings
	  and fluffalsGrave < 2
	)
    then
      return true
    else
      return false
    end
  end
  if loc == PRIO_TOFIELD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 7
	  else
	    return 3
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    if Get_Card_Count_ID(AIDeck(),70245411) == 0 then
	  return 6
	end
    return
	  Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function OwlCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
	then
      return 3 + PrioFluffalMaterial(c,1)
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    if GlobalSheep == 1
	and not HasID(AIHand(),c.id,true)
	then
      return 9
    end
	if HasID(AIHand(),c.id,true)
	or not OPTCheck(c.id)
	then
	  return 1
	end
	if not NormalSummonCheck()
	then
	  if not HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  and not HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	  then
	    return 7
	  end
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_TOFIELD then
    if OPTCheck(c.id)
	then
	  if not HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  and not HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	  then
	    return true
	  else
	    return false
	  end
	else
	  return 1
	end
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 7
	  else
	    return 4
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end

function SheepCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if not OPTCheck(c.id) or Get_Card_Count_ID(UseLists({AIHand(),AIMon()}),c.id) > 1
	then
      return 3 + PrioFluffalMaterial(c,1)
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    if HasID(AIHand(),c.id,true)
	or not OPTCheck(c.id)
	then
	  return 1
	end
    local edgeImpHand = CountEgdeImp(AIHand())
	local edgeImpMon = CountEgdeImp(AIMon())
	local edgeImpGrave = CountEgdeImp(AIGrave())
    if Duel.GetTurnCount() == 1
	and (edgeImpHand + edgeImpGrave) > 0
	then
	  return 8
	end
	if edgeImpGrave > 0
	then
	  if CountEgdeImp(UseLists({AIHand(),AIMon()})) == 0
	  and not HasID(UseLists({AIHand(),AIMon()}),79109599,true) -- KoS
	  and CountFluffal(AIMon()) > 0
	  and (
	    HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	    or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	  )
	  then
	    return 8
	  end
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 6
	  else
	    return 3
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end

function CatCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if OPTCheck(c.id)
	and (
      GlobalPolymerization == 1
	  or HasID(AIGrave(),24094653,true) --Polymerization
	)
	then
      return 11 + PrioFluffalMaterial(c,1)
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    if GlobalRabit > 0 and
	not HasID(AIHand(),c.id,true)
	then
      return 9
    end
    if GlobalSheep == 1
	and not HasID(AIHand(),c.id,true)
	then
      return 4
    end
    if GlobalOcto > 0 then
	  return 8
	end
	if HasID(AIHand(),c.id,true)
	or not OPTCheck(c.id)
	then
	  return 1
	end
    if HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(AIHand(),79109599,true) -- KoS
	then
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_TOFIELD then
    if OPTCheck(c.id)
	and (
	  HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	  or HasID(AIHand(),79109599,true) -- King of the Swamp
	)
	then
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 9
	  else
	    return 1
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end

function RabitCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if OPTCheck(c.id)
	and (
	  HasID(UseLists({AIHand(),AIGrave()}),02729285,true) -- Cat
	  or HasID(AIGrave(),00007614,true) -- Octo
	)
	then
      return 9 + PrioFluffalMaterial(c,1)
	else
	  return 1 + PrioFluffalMaterial(c,1)
	end
  end
  if loc == PRIO_TOHAND then
    if GlobalSheep == 1
	and not HasID(AIHand(),c.id,true)
	then
      return 5
    end
    if GlobalOcto > 0 then
	  return 10
	end
	if HasID(AIHand(),c.id,true)
	or not OPTCheck(c.id)
	then
	  return 1
	end
    if HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(AIHand(),79109599,true) -- KoS
	then
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_TOFIELD then
    if OPTCheck(c.id)
	and (
	  HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	  or HasID(AIHand(),79109599,true) -- King of the Swamp
	)
	then
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 11
	  else
	    return 1
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end

function MouseCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if not HasID(AIDeck(),c.id,true)
	and FilterPosition(c,POS_FACEUP_ATTACK)
	then
      return 8 + PrioFluffalMaterial(c,1)
	elseif not HasID(AIDeck(),c.id,true)
	then
      return 7 + PrioFluffalMaterial(c,1)
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    if GlobalSheep == 1 then
      if not HasID(AIHand(),c.id,true) then
	    if FilterPosition(c,POS_FACEUP_ATTACK) then
	      return 6
		end
		return 4
	  else
	    return 1
	  end
    end
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if OPTCheck(c.id)
	and Get_Card_Count_ID(AIDeck(),c.id) > 0
	and OPTCheck(10802915) -- TourGuide
	and OPTCheck(67441435) -- Bulb
	and not (HasID(AIGrave(),67441435,true) and OPDCheck(67441435)) -- Bulb
	then
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 5
	  else
	    return 2
	  end
	end
    return
	  not OPTCheck(c.id)
	  or Get_Card_Count_ID(AIHand(),c.id) > 1
	  or Get_Card_Count_ID(AIDeck(),c.id) == 0
  end
  if loc == PRIO_DISCARD then
    if GlobalSabres == 1 then
	  return 11
	end
	if Get_Card_Count_ID(AIDeck(),c.id) == 1 then
	  return 3
	end
    return
	  Get_Card_Count_ID(AIDeck(),c.id) == 0
      or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    if FilterPosition(c,POS_FACEUP_ATTACK) then
	  return 10
	end
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function WingsCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if OPTCheck(c.id)
	and HasID(AIST(),70245411,true) -- Toy Vendor
	then
	  return 8
	else
      return 7
	end
  end
  if loc == PRIO_TOHAND then
    if GlobalSheep == 1
    and not HasID(AIHand(),c.id,true)
	then
      return 5
    end
	if GlobalOcto > 0 then
	  return 0
	end
	if HasID(UseLists({AIHand(),AIGrave()}),c.id,true)
	or not OPTCheck(c.id)
	then
	  return 1
	end
    if HasID(AIHand(),70245411,true) -- ToyVendor HAND
	or
	CardsMatchingFilter(AIST(),ToyVendorCheckFilter,true) > 0 -- ToyVendor
	or
	HasID(AIST(),70245411,true) -- Toy Vendor
	and (
	  HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	)
	and (
	  CountEgdeImp(UseLists({AIHand(),AIMon()})) > 0 -- EdgeImp
	  or HasID(UseLists({AIHand(),AIMon()}),79109599,true) -- KoS
	)
	then
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_TOFIELD then
    return true
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 10
	  else
	    return 1
	  end
	end
    return true
  end
  if loc == PRIO_DISCARD then
    return true
  end
  if loc == PRIO_BANISH then
    return Get_Card_Count_ID(UseLists({AIGrave(),AIBanish()}),70245411) == 3
  end
  return true
end
function PatchworkCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if GlobalFusionPerform == 2
	and GlobalFusionId ~= 00007620
	then
	  return 11
	end
    return 3 + PrioFluffalMaterial(c,1)
  end
  if loc == PRIO_TOHAND then
    if GlobalSheep == 1 then
      if not HasID(AIHand(),c.id,true) then
		return 2
	  else
	    return 1
	  end
    end
    return not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return CountEgdeImp(UseLists({AIHand(),AIMon()})) == 0
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 4
	  else
	    return 1
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return true
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
GlobalAuxOcto = 0
function OctoCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if OPTCheck(c.id + 1)
	and CardsMatchingFilter(AIBanish(),FilterType,TYPE_MONSTER) >= 1
	then
	  if Get_Card_Count_ID(UseLists({AIHand(),AIMon()}),c.id) == 2 then
	    if GlobalAuxOcto == 0 then
		  GlobalAuxOcto = c.cardid
		end
	    if GlobalAuxOcto == c.cardid then
		  return 1
		else
		  return 8 + PrioFluffalMaterial(c,1)
		end
	  else
	    GlobalAuxOcto = 0
	  end
	  return 8 + PrioFluffalMaterial(c,1)
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    if GlobalRabit > 0
	and not HasID(AIHand(),c.id,true)
	then
      return 10
    end
    if GlobalSheep == 1
	and not HasID(AIHand(),c.id,true)
	then
      return 7
    end
    if GlobalOcto > 0 then
	  return 2
	end
	if HasID(AIHand(),c.id,true)
	or not OPTCheck(c.id)
	then
	  return 1
	end
    if HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	or HasID(AIHand(),79109599,true) -- KoS
	then
	  if Get_Card_Count_ID(AIBanish(),72413000) == 2 then
	    return 10
	  end
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_TOFIELD then
    if OPTCheck(c.id)
	then
	  if (
	    HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	    or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	    or HasID(AIHand(),79109599,true) -- KoS
	  )
	  and	not (
	    HasID(AIGrave(),72413000,true) -- Wings
	    and OPTCheck(72413000)
	    and CountFluffal(AIGrave()) <= 2
	  )
	  then
	    return true
	  else
	    return false
	  end
	else
	  return 1
	end
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 3
	  else
	    return 2
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return
	  FilterLocation(c,LOCATION_GRAVE)
	  and not HasID(AIBanish(),c.id,true)
  end
  return true
end

-- EdgeImp Cond
function TomahawkCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if GlobalFusionPerform == 2
	then
	  return 10 + PrioFluffalMaterial(c,1)
	elseif GlobalFusionPerform > 2 then
	  return 5 + PrioFluffalMaterial(c,1)
	end
	return 5 + PrioFluffalMaterial(c,1)
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id) and HasID(AIDeck(),30068120,true) -- Sabres
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 4
	  else
	    return 1
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return true
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function ChainCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if GlobalFusionId == 57477163 and OPTCheck(c.id) then -- FSheep
	  return 10
	end
    if GlobalFusionPerform == 2
	then
	  if OPTCheck(c.id) then
	    return 6 + PrioFluffalMaterial(c,1)
	  else
	    return 1
	  end
	elseif GlobalFusionPerform > 2 then
	  return 5 + PrioFluffalMaterial(c,1)
	end
	if OPTCheck(c.id) then
	  return 6 + PrioFluffalMaterial(c,1)
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    if GlobalSheep == 1 then
      if not HasID(AIHand(),c.id,true)
	  and OPTCheck(c.id)
	  then
		return 5
	  else
	    return 2
	  end
    end
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if OPTCheck(c.id)
	and (
	  HasID(AIDeck(),06077601,true) -- FFusion
	  or HasID(AIDeck(),43698897,true) -- FFactory
	)
	and (
	  not HasID(AIHand(),06077601,true) -- FFusion
	  or HasID(AIDeck(),43698897,true) -- FFactory
	)
	then
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 5
	  else
	    return 1
	  end
	end
    return OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function SabresCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if GlobalFusionPerform == 2
	then
	  return 5 + PrioFluffalMaterial(c,1)
	elseif GlobalFusionPerform > 2
	then
	  return 1 + PrioFluffalMaterial(c,1)
	end
	return 5 + PrioFluffalMaterial(c,1)
  end
  if loc == PRIO_TOHAND then
    if GlobalOcto > 0
	and not HasID(AIHand(),c.id,true)
	then
	  return 10
	end
	if Duel.GetTurnCount() == 1
	and not HasID(AIHand(),c.id,true)
	then
	  return 7
	end
	if HasID(AIHand(),c.id,true) then
	  return 1
	end
	local countKoS = Get_Card_Count_ID(AIHand(),79109599)
	local hasFusionSpell = false
	if HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	or HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
	then
	  hasFusionSpell = true
	end
	if CountEgdeImp(UseLists({AIHand(),AIMon()})) == 0 -- EdgeImp
	and (
	  not HasID(UseLists({AIHand(),AIMon()}),79109599,true) -- KoS
	  or
	  not hasFusionSpell
	  and countKoS == 1
	)
	and (
	  hasFusionSpell
	  or HasID(AIHand(),79109599,true) -- KoS
	)
	and not (
	  HasID(AIGrave(),c.id,true)
	  and HasID(UseLists({AIHand(),AIMon()}),98280324,true)
	  and OPTCheck(98280324)
	  and CountFluffal(AIMon()) > 0
	) -- Sheep
	then
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_TOFIELD then
    if GlobalSheep == 1 then
      if not HasID(AIHand(),c.id,true) then
		return 4
	  else
	    return 3
	  end
    end
    return true
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 8
	  else
	    return 2
	  end
	end
    return true
  end
  if loc == PRIO_DISCARD then
    if CountEgdeImp(UseLists({AIHand(),AIMon()})) > 1
	or HasID(AIGrave(),72413000,true) and OPTCheck(72413000) -- Wings
	or HasID(UseLists({AIHand(),AIMon()}),98280324,true) and OPTCheck(98280324) -- Sheep
	then
	  return true
	elseif HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	then
	  return 2
	else
	  return false
	end
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end

-- Other Cond
function TourGuideCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    return 10 + PrioFluffalMaterial(c,1)
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    if not OPTCheck(c.id)
	or not HasID(AIDeck(),30068120,true) -- Sabres
    or not HasID(AIExtra(),83531441,true) -- Dante
	then
      return true
	else
	  return false
	end
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function KoSCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if GlobalFusionId == 57477163 then -- FSheep
	  return 2 + PrioFluffalMaterial(c,1)
	end
    return 10 + PrioFluffalMaterial(c,1)
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	then
      return true
	else
	  return false
	end
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 9
	  else
	    return 1
	  end
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    if GlobalFusionId == 57477163 then -- FSheep
	  return 2 + PrioFluffalMaterial(c,2)
	end
    return 10 + PrioFluffalMaterial(c,2)
  end
  return true
end
function BulbCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    return 5 + PrioFluffalMaterial(c,1)
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return true
  end
  if loc == PRIO_TOGRAVE then
    return true
  end
  if loc == PRIO_DISCARD then
    return true
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end

--FLuffalS Cond
function ToyVendorCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return not OPTCheck(c.cardid)
  end
  if loc == PRIO_DISCARD then
    return Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function FFusionCond(loc,c)
  if loc == PRIO_TOHAND then
    return
	  OPTCheck(c.id)
	  and not HasID(AIHand(),c.id,true)
	  and Duel.GetTurnCount() >= 2
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return
	  not OPTCheck(c.id)
	  or Get_Card_Count_ID(UseLists({AIST(),AIHand()}),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    if Duel.GetTurnCount() >= 2
	and (
	  not OPTCheck(c.id)
	  or CountFluffalBanishTarget(AIGrave()) < 2
	)
	then
	  return true
	elseif Get_Card_Count_ID(UseLists({AIST(),AIHand()}),c.id) > 1
	then
	  return 3
	else
	  return false
	end
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function FFactoryCond(loc,c)
  if loc == PRIO_TOHAND then
    if OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
	and (
	  HasID(UseLists({AIGrave(),AIHand()}),06077601,true) -- FFusion
      or HasID(UseLists({AIGrave(),AIHand()}),01845204,true) -- IFusion
	  or HasID(UseLists({AIGrave(),AIHand()}),94820406,true) -- DFusion
	  or Get_Card_Count_ID(AIGrave(),24094653) > 1 -- Polymerization
	)
	and CountFluffal(UseLists({AIHand(),AIMon()})) > 0
	and (
	  CountEgdeImp(UseLists({AIHand(),AIMon()})) > 0
	  or CountFrightfurMon(AIMon()) > 0
	  or HasID(AIHand(),79109599,true) -- KoS
	)
	then
      return true
	else
	  return false
	end
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end

-- Spell Cond
function IFusionCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    if not (
	  OPTCheck(c.id)
	  and (
	    HasID(UseLists({AIHand(),AIST()}),24094653,true) --Polymerization
	    or HasID(UseLists({AIGrave(),AIHand()}),94820406,true) -- DFusion
	    or HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
		or HasID(AIHand(),79109599,true) -- KoS
	  )
	)
	then
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function PolyCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    if HasID(AIST(),66127916,true) then
	  return 10
	end
    if Get_Card_Count_ID(AIHand(),c.id) > 2
	then
	  return 8
	end
	return Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function DFusionCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function GCycloneCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function TTwisterCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end

-- Trap Cond
function FReserveCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end

-- Frightfur Cond
function FSabreToothCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    return 1 + PrioFrightfurMaterial(c,1)
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  return 5
	end
	if FilterLocation(c,LOCATION_GRAVE)
	or FilterLocation(c,LOCATION_REMOVED)
	then
	  return true
	elseif not HasID(AIExtra(),c.id,true)
	then
	  return 0
	end
	if GlobalFFusion > 0 then
	  return SpSummonFSabreToothBanish()
	end
    if SpSummonFSabreTooth() then
	  if HasID(AIMon(),c.id,true) then
	    return 4
	  end
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 3
	  else
	    return 1
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function FKrakenCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    return 6 + PrioFrightfurMaterial(c,1)
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  if not HasID(AIMon(),c.id,true)
	  then
	    return 10
	  else
	    return 4
	  end
	end
	if FilterLocation(c,LOCATION_GRAVE)
	or FilterLocation(c,LOCATION_REMOVED)
	then
	  return true
	elseif not HasID(AIExtra(),c.id,true)
	then
	  return 0
	end
    return SpSummonFKraken()
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 7
	  else
	    return 1
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function FLeoCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    return 1 + PrioFrightfurMaterial(c,1)
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if FilterLocation(c,LOCATION_GRAVE)
	or FilterLocation(c,LOCATION_REMOVED)
	then
	  return true
	elseif not HasID(AIExtra(),c.id,true)
	then
	  return 0
	end
	if GlobalFFusion > 0 then
	  return SpSummonFLeoBanish()
	end
    return SpSummonFLeo()
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 2
	  else
	    return 1
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function FBearCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    return 3 + PrioFrightfurMaterial(c,1)
  end
  if loc == PRIO_TOHAND then
    return
	  OPTCheck(03841833) and not HasID(AIHand(),03841833,true) -- Bear
	  and not HasID(UseLists({AIHand(),AIST()}),70245411,true) -- Toy Vendor
	  and #AIHand() > 2
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  if not HasID(AIMon(),c.id,true)
	  then
	    return 7
	  else
	    return 2
	  end
	end
	if FilterLocation(c,LOCATION_GRAVE)
	or FilterLocation(c,LOCATION_REMOVED)
	then
	  return true
	elseif not HasID(AIExtra(),c.id,true)
	then
	  return 0
	end
	if GlobalFFusion > 0 then
	  return SpSummonFBearBanish()
	end
    return SpSummonFBear()
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 3
	  else
	    return 1
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function FWolfCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    return 1 + PrioFrightfurMaterial(c,1)
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  return 1
	end
	if FilterLocation(c,LOCATION_GRAVE)
	or FilterLocation(c,LOCATION_REMOVED)
	then
	  return true
	elseif not HasID(AIExtra(),c.id,true)
	then
	  return 0
	end
	if GlobalFFusion > 0 then
	  return SpSummonFWolfBanish()
	end
    return SpSummonFWolf()
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 2
	  else
	    return 1
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function FTigerCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    return 5 + PrioFrightfurMaterial(c,1)
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  return 9
	end
	if FilterLocation(c,LOCATION_GRAVE)
	or FilterLocation(c,LOCATION_REMOVED)
	then
	  return true
	elseif not HasID(AIExtra(),c.id,true)
	then
	  return 0
	end
	if GlobalFFusion > 0 then
	  return SpSummonFTigerBanish()
	end
    return SpSummonFTiger()
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 5
	  else
	    return 1
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function FSheepCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    if FilterAffected(c,EFFECT_CANNOT_ATTACK) then -- IFusion
	  GlobalIFusion = 0
	  OPTReset(c.cardid)
	  return 9999
	else
	  return 4 + PrioFrightfurMaterial(c,1)
	end
  end
  if loc == PRIO_TOHAND then
    return
	  OPTCheck(61173621)
	  and not HasID(UseLists({AIHand(),AIGrave()}),61173621,true) -- Chain
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  if CardsMatchingFilter(OppMon(),BAFilter) > 0
	  and not HasID(AIMon(),57477163,true)
	  then
	    return 11
	  end
	  if not HasID(AIMon(),c.id,true)
	  then
	    return 8
	  else
	    return 3
	  end
	end
	if FilterLocation(c,LOCATION_GRAVE)
	or FilterLocation(c,LOCATION_REMOVED)
	then
	  return true
	elseif not HasID(AIExtra(),c.id,true)
	then
	  return 0
	end
	if GlobalFFusion > 0 then
	  return SpSummonFSheepBanish()
	end
    return SpSummonFSheep()
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 4
	  else
	    return 1
	  end
	end
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end

-- Other Fusion
function StarveCond(loc,c)
  if loc == MATERIAL_TOGRAVE then
    return 0
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return SpSummonStarve()
  end
  if loc == PRIO_TOGRAVE then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end

MATERIAL_TOGRAVE = 21

FluffalPriorityList={
--PRIO_TOHAND = 1
--PRIO_TOFIELD = 3
--PRIO_TOGRAVE = 5
--PRIO_DISCARD = 7
--PRIO_BANISH = 9
--MATERIAL_TOGRAVE = 21

 [39246582] = {8,1,7,1,4,1,3,1,9,4,DogCond},		-- Fluffal Dog
 [03841833] = {10,2,2,1,4,5,1,1,7,3,BearCond},		-- Fluffal Bear
 [65331686] = {5,3,10,7,2,1,1,1,5,2,OwlCond},		-- Fluffal Owl
 [98280324] = {6,2,0,0,3,1,3,1,6,2,SheepCond},		-- Fluffal Sheep
 [02729285] = {7,5,1,1,1,1,1,1,3,1,CatCond},		-- Fluffal Cat
 [38124994] = {5,3,1,1,1,1,1,1,4,1,RabitCond},		-- Fluffal Rabit
 [06142488] = {1,1,9,2,5,0,6,1,10,8,MouseCond},		-- Fluffal Mouse
 [72413000] = {9,1,3,2,9,4,10,8,6,1,WingsCond},		-- Fluffal Wings
 [81481818] = {2,1,5,4,5,1,2,1,4,3,PatchworkCond},	-- Fluffal Patchwork (BETA)
 [00007614] = {6,1,8,3,1,1,3,1,4,2,OctoCond},		-- Fluffal Octo (BETA)
 [97567736] = {1,1,5,2,8,6,8,4,6,2,TomahawkCond},	-- Edge Imp Tomahawk
 [61173621] = {7,2,4,4,6,1,6,1,4,1,ChainCond},		-- Edge Imp Chain
 [30068120] = {8,3,4,3,7,2,5,3,5,1,SabresCond},		-- Edge Imp Sabres
 [10802915] = {1,1,1,1,9,1,8,1,10,9,TourGuideCond},	-- Tour Guide
 [79109599] = {5,1,3,2,8,2,1,1,10,3,KoSCond},		-- King of the Swamp
 [67441435] = {1,1,8,2,9,3,9,3,1,1,BulbCond},		-- Glow-Up Bulb
 [23434538] = {9,1,-1,0,-1,0,-1,0,-1,0,nil},		-- Maxx "C"

 [70245411] = {5,4,1,1,4,1,1,1,1,1,ToyVendorCond},	-- Toy Vendor
 [06077601] = {3,1,1,1,2,1,2,0,9,1,FFusionCond},	-- Frightfur Fusion
 [43698897] = {4,2,1,1,2,1,1,0,1,1,FFactoryCond},	-- Frightfur Factory
 [01845204] = {1,1,1,1,3,2,3,1,7,1,IFusionCond},	-- Instant Fusion
 [24094653] = {1,1,1,1,2,1,3,1,3,1,PolyCond},		-- Polymerization
 [94820406] = {1,1,1,1,2,1,2,1,7,1,DFusionCond},	-- Dark Fusion
 [05133471] = {1,1,1,1,7,6,7,5,1,1,GCycloneCond},	-- Galaxy Cyclone
 [43898403] = {1,1,1,1,2,1,6,4,2,1,TTwisterCond},	-- Twin Twister

 [66127916] = {1,1,1,1,1,1,1,1,1,1,FReserveCond}, 	-- Fusion Reserve
 [98954106] = {9,1,1,1,1,1,1,1,1,1,nil},			-- Jar of Avarice

 [80889750] = {1,1,7,1,1,1,1,1,4,1,FSabreToothCond},-- Frightfur Sabre-Tooth
 [00007620] = {1,1,6,1,5,3,1,1,2,1,FKrakenCond},	-- Frightfur Kraken (BETA)
 [10383554] = {1,1,9,1,2,1,1,1,10,1,FLeoCond},		-- Frightfur Leo
 [85545073] = {5,1,3,1,3,1,1,1,2,1,FBearCond},		-- Frightfur Bear
 [11039171] = {2,1,8,1,1,1,1,1,9,1,FWolfCond},		-- Frightfur Wolf
 [00464362] = {3,1,5,1,5,4,1,1,3,1,FTigerCond},		-- Frightfur Tiger
 [57477163] = {4,1,4,1,4,2,1,1,2,1,FSheepCond},		-- Frightfur Sheep
 [41209827] = {2,1,10,1,1,1,1,1,1,1,StarveCond}, 	-- Starve Venom Fusion Dragon<
 [33198837] = {1,1,1,1,1,1,1,1,1,1,nil}, 			-- Naturia Beast
 [42110604] = {1,1,1,1,1,1,1,1,1,1,nil}, 			-- Hi-Speedroid Chanbara
 [83531441] = {1,1,1,1,1,1,1,1,1,1,nil}, 			-- Dante
}