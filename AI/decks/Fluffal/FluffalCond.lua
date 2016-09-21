------------------------
--------- COND ---------
------------------------
-- FluffalM cond
function DogCond(loc,c)
  if GlobalSheep == 1 then
    if not HasID(AIHand(),c.id,true) then
	  return 9
	else
	  return 1
	end
  end
  if GlobalFusionSummon > 0 then
	if FilterLocation(c,LOCATION_MZONE)
	then
	  return 5
	elseif Get_Card_Count_ID(AIHand(),c.id) > 1 then
	  return 5
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
	  and not NormalSummonCheck()
  end
  if loc == PRIO_TOFIELD then
    if GlobalSabres > 0 then
	  return 10
	end
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
    return 
	  not OPTCheck(c.id) or Get_Card_Count_ID(AIHand(),c.id) > 1
  end
  if loc == PRIO_BANISH then
    if FilterLocation(c,LOCATION_GRAVE) then
	  return true
	else
	  return false
	end
  end
  return true
end

function BearCond(loc,c)
  if GlobalSheep == 1 then
    if not HasID(AIHand(),c.id,true) and OPTCheck(c.id) then
	  return 8
	else
	  return 6
	end
  end
  if GlobalFusionSummon > 0 then
	if FilterLocation(c,LOCATION_MZONE) then
	  return 6
	elseif Get_Card_Count_ID(AIDeck(),70245411) == 0 then -- Toy Vendor
	  return 7
	elseif Get_Card_Count_ID(AIHand(),c.id) > 1 then
	  return 5
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    if OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
	and Get_Card_Count_ID(AIDeck(),70245411) > 0 -- Toy Vendor
	and OPTCheck(72413000) -- Wings
	and (
	  not HasID(UseLists({AIHand(),AIST()}),70245411,true) -- ToyVendor
	  or HasID(AIGrave(),72413000,true) -- Wings
    )
	and (
	  CountToyVendorDiscardTarget() > 0
	  or HasID(AIGrave(),72413000,true) -- Wings
	) then
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
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return
	  Get_Card_Count_ID(AIDeck(),70245411) == 0 -- Toy Vendor
  end
  if loc == PRIO_BANISH then
    if FilterLocation(c,LOCATION_GRAVE) then
	  return true
	else
	  return false
	end
  end
  return true
end

function OwlCond(loc,c)
  if GlobalSheep == 1 then
    if not HasID(AIHand(),c.id,true) then
	  return 10
	else
	  return 7
	end
  end
  if GlobalFusionSummon > 0 then
	if FilterLocation(c,LOCATION_MZONE) then
	  return 3
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    if not HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	and not HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	and not NormalSummonCheck()
	then
	  return 7
	end
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
	  and not NormalSummonCheck()
  end
  if loc == PRIO_TOFIELD then
    if OPTCheck(c.id)
	and not HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	and not HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	then
	  return 10
	else
	  return OPTCheck(c.id)
	end
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 6
	  else
	    return 3
	  end
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    if FilterLocation(c,LOCATION_GRAVE) then
	  return true
	else
	  return false
	end
  end
  return true
end

function SheepCond(loc,c)
  if GlobalFusionSummon > 0 then
	if FilterLocation(c,LOCATION_MZONE) then
	  return 3
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    if OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
	and CountEgdeImp(AIGrave()) > 0 and CountFluffal(AIMon()) > 0
	and not HasID(UseLists({AIHand(),AIMon()}),79109599,true) -- KoS
	and (
	  HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	)
	then
	  return 8
	end
    return
	  OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
	  and CountEgdeImp(AIGrave()) > 0 -- Edge Imp
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
    if FilterLocation(c,LOCATION_GRAVE) then
	  return true
	else
	  return false
	end
  end
  return true
end

function CatCond(loc,c)
  if GlobalSheep == 1 then
    if not HasID(AIHand(),c.id,true) then
	  return 5
	else
	  return 1
	end
  end
  if GlobalRabit > 0 then
    return 10
  end
  if GlobalFusionSummon > 0 then
    if OPTCheck(c.id)
	and (
		GlobalPolymerization == 1
		or HasID(AIGrave(),24094653,true) --Polymerization
	)
	then
	  return 11
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    return
	  OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
	  and (
	    Get_Card_Count_ID(UseLists({AIST(),AIHand()}),24094653) > 0 -- Polymerization
		or Get_Card_Count_ID(AIHand(),79109599) > 0 -- King of the Swamp
	  )
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 8
	  else
	    return 3
	  end
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    if FilterLocation(c,LOCATION_GRAVE) then
	  return HasID(UseLists({AIGrave(),AIBanish()}),38124994,true) -- Rabit
	else
	  return false
	end
  end
  return true
end

function RabitCond(loc,c)
  if GlobalSheep == 1 then
    if not HasID(AIHand(),c.id,true) then
	  return 5
	else
	  return 1
	end
  end
  if GlobalFusionSummon > 0 then
    if OPTCheck(c.id)
	and (
	  HasID(UseLists({AIHand(),AIGrave()}),02729285,true) -- Cat
	  or HasID(UseLists({AIHand(),AIGrave()}),00007614,true) -- Octo
	)
	then
	  return 9
	else
	  return 2
	end
  end
  if loc == PRIO_TOHAND then
    return
	  OPTCheck(c.id) and not HasID(AIHand(),c.id,true) -- Rabit
	  and (
	    Get_Card_Count_ID(UseLists({AIST(),AIHand()}),24094653) > 0 -- Polymerization
		or Get_Card_Count_ID(AIHand(),79109599) > 0 -- King of the Swamp
	  )
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
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end

function MouseCond(loc,c)
  if GlobalSheep == 1 then
    if FilterPosition(c,POS_FACEUP_ATTACK)then
	  return 7
	else
	  return 6
	end
  end
  if GlobalFusionSummon > 0 then
    local result = 1
    if Get_Card_Count_ID(AIDeck(),c.id) == 0 then
	  result = 8
	  if #AIMon() >= 4 and GlobalFusionId == 80889750 then
	    result = result + 3
	  end
	  if FilterPosition(c,POS_FACEUP_ATTACK) then
	    result = result + 1
	  end
	end
	return result
  end
  if loc == PRIO_TOHAND then
    return
	  OPTCheck(c.id) and not HasID(AIHand(),c.id,true) -- Mouse
	  and Get_Card_Count_ID(AIDeck(),c.id) == 2 -- Mouse Deck
  end
  if loc == PRIO_TOFIELD then
    return
	  OPTCheck(c.id)
	  and Get_Card_Count_ID(AIDeck(),c.id) == 2 -- Mouse Deck
	  and OPTCheck(10802915) -- TourGuide
	  and OPTCheck(67441435) -- Bulb
	  and not (HasID(AIGrave(),67441435,true) and OPDCheck(67441435)) -- Bulb
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 6
	  else
	    return 3
	  end
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    if GlobalSabres == 1 then
	  return 10
	end
	if Get_Card_Count_ID(AIDeck(),c.id) == 1 then
	  return 2
	end
    return
	  Get_Card_Count_ID(AIDeck(),c.id) == 0
  end
  if loc == PRIO_BANISH then
    if FilterPosition(c,POS_FACEUP_ATTACK) then
	  return 10
	else
	  return 9
	end
    return true
  end
  return true
end

function WingsCond(loc,c)
  if GlobalSheep == 1 then
    if OPTCheck(c.id)
	and not HasID(UseLists({AIHand(),AIGrave()}),c.id,true)
	and CardsMatchingFilter(AIST(),ToyVendorCheckFilter,true) > 0 -- Toy Vendor
	then
	  return 6
	else
	  return 1
	end
  end
  if GlobalFusionSummon > 0 then
    if OPTCheck(c.id)
	and HasID(AIST(),70245411,true) -- Toy Vendor
	then
	  return 8
	else
      return 7
	end
  end
  if loc == PRIO_TOHAND then
    return
	  OPTCheck(c.id) and not HasID(UseLists({AIHand(),AIGrave()}),c.id,true) -- Wings
	  and (
	    Get_Card_Count_ID(AIHand(),70245411) > 0 -- Toy Vendor
	    or CardsMatchingFilter(AIST(),ToyVendorCheckFilter,true) > 0 -- Toy Vendor
		or HasID(AIST(),70245411,true) -- Toy Vendor
		and (
		  HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
		  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
		)
		and (
		  CountEgdeImp(UseLists({AIHand(),AIMon()})) > 0 -- EdgeImp
		  or HasID(UseLists({AIHand(),AIMon()}),79109599,true) -- KoS
		)
	  )
  end
  if loc == PRIO_TOFIELD then
    return true
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 10
	  else
	    return 3
	  end
	end
    return true
  end
  if loc == PRIO_DISCARD then
    return true
  end
  if loc == PRIO_BANISH then
    return Get_Card_Count_ID(UseLists({AIGrave(),AIBanish()}),70245411) == 3 --ToyVendor
  end
  return true
end

function PatchworkCond(loc,c)
  if GlobalSheep == 1 then
    return 1
  end
  if GlobalFusionSummon == 2 then -- FirstMaterial
    return 9
  end
  if GlobalFusionSummon > 2 then -- SecondMaterial
    return 3
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return true
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 6
	  else
	    return 3
	  end
	end
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

function OctoCond(loc,c)
  if GlobalSheep == 1 then
    return 4
  end
  if GlobalFusionSummon > 0 then
    if CardsMatchingFilter(AIBanish(),FilterType,TYPE_MONSTER) > 1 then
	  return 8
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    if Get_Card_Count_ID(AIBanish(),72413000) == 2 then
	  return 10
	end
    if OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
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
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id) and (
	  CountFluffal(AIGrave()) > 2
	  or not OPTCheck(72413000)
	)
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 6
	  else
	    return 3
	  end
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return Get_Card_Count_ID(AIGrave(),38124994) > 0
  end
  return true
end

-- EdgeImp Cond
function TomahawkCond(loc,c)
  if GlobalFusionSummon == 2 then -- FirstMaterial
    return 9
  end
  if GlobalFusionSummon > 2 then -- SecondMaterial
    return 6
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
    if GlobalFusionSummon > 1 then
	  return 9
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return true
  end
  if loc == PRIO_BANISH then
    return not OPTCheck(c.id)
  end
  return true
end

function ChainCond(loc,c)
  if GlobalFusionSummon > 2 then -- SecondMaterial
    if OPTCheck(c.id) then
      return 6
	else
	  return 1
	end
  end
  if loc == PRIO_TOHAND then
    return
	  OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
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
    return OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return not OPTCheck(c.id)
  end
  return true
end

function SabresCond(loc,c)
  if GlobalFusionSummon == 2 then
    if c.original_id == c.id then -- Sabres
	  return 8
	else
	  return 7 -- Tomahawk
	end
  end
  if GlobalFusionSummon > 2 then -- SecondMaterial
    return 1
  end
  if loc == PRIO_TOHAND then
	if not HasID(AIHand(),c.id,true) -- Sabres
	and not HasID(AIMon(),79109599,true) -- KoS
	and CountEgdeImp(UseLists({AIHand(),AIMon()})) == 0 -- EdgeImp
	and (
	  HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	  or HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
	  or HasID(AIHand(),79109599,true) -- Kos
	)
	and not (
	  HasID(AIGrave(),c.id,true)
	  and HasID(UseLists({AIHand(),AIMon()}),98280324,true) -- Sheep
	  and OPTCheck(98280324)
	  and CountFluffal(AIMon()) > 0
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
	    return 7
	  else
	    return 1
	  end
	end
    return true
  end
  if loc == PRIO_DISCARD then
    return
	  CountEgdeImp(UseLists({AIHand(),AIMon()})) > 1
	  or Get_Card_Count_ID(AIGrave(),72413000) > 0 and OPTCheck(72413000) -- Wings
	  or HasID(UseLists({AIHand(),AIMon()}),98280324,true) and OPTCheck(98280324) -- Sheep
  end
  if loc == PRIO_BANISH then
    return not OPTCheck(c.id)
  end
  return true
end

-- Other Cond
function TourGuideCond(loc,c)
  if GlobalFusionSummon > 0 then
    return 10
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  return 1
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return
	  not OPTCheck(c.id)
	  or not HasID(AIDeck(),30068120,true) -- Sabres
	  or not HasID(AIExtra(),83531441,true) -- Dante
  end
  if loc == PRIO_BANISH then
    return true
  end
  return true
end
function KoSCond(loc,c)
  if GlobalFusionSummon > 0
  or GlobalFFusion > 0
  then
    return 10
  end
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return 
	  HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
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
    return not OPTCheck(c.id)
  end
  return true
end

function BulbCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 2
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
    return not OPDCheck(c.id)
  end
  return true
end

--FLuffalS Cond
function ToyVendorCond(loc,c)
  if loc == PRIO_TOHAND then
    return HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return not OPTCheck(c.cardid)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return not OPTCheck(c.id)
  end
  return true
end
function FFusionCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
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
    return
	  Duel.GetTurnCount() > 2
	  and (
	    not OPTCheck(c.id)
	    or CountFluffalBanishTarget(AIGrave()) < 2
	    or Get_Card_Count_ID(UseLists({AIST(),AIHand()}),c.id) > 1
	  )
  end
  if loc == PRIO_BANISH then
    return true
  end
  return true
end
function FFactoryCond(loc,c)
  if loc == PRIO_TOHAND then
    return
	  OPTCheck(c.id)
	  and not HasID(AIHand(),c.id,true)
	  and (
	    HasID(UseLists({AIGrave(),AIHand()}),06077601,true) -- FFusion
        or HasID(UseLists({AIGrave(),AIHand()}),01845204,true) -- IFusion
		or HasID(UseLists({AIGrave(),AIHand()}),94820406,true) -- DFusion
	    or Get_Card_Count_ID(AIGrave(),24094653) > 1 -- Polymerization
	  )
	  and CountFluffal(AIHand()) > 0
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return not OPTCheck(c.id)
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
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    if not (
	  OPTCheck(c.id)
	  and (
	    HasID(UseLists({AIHand(),AIST()}),24094653,true) --Polymerization
	    or HasID(UseLists({AIGrave(),AIHand()}),94820406,true) -- DFusion
	    or HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
	  )
	)
	then
	  return true
	else
	  return false
	end
  end
  if loc == PRIO_BANISH then
    return not OPTCheck(c.id)
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
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return
	  Get_Card_Count_ID(UseLists({AIST(),AIHand()}),c.id) > 1
	  or HasID(AIST(),66127916,true) -- Fusion Reserve
  end
  if loc == PRIO_BANISH then
    return true
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
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return
	  Get_Card_Count_ID(UseLists({AIST(),AIHand()}),c.id) > 1
  end
  if loc == PRIO_BANISH then
    return true
  end
  return true
end

function GClycloneCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return true
  end
  if loc == PRIO_BANISH then
    return not OPTCheck(c.id)
  end
  return true
end

-- Trap Cond
function FReserveCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(c.id)
  end
  if loc == PRIO_TOGRAVE then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return not OPTCheck(c.id)
  end
  return true
end

-- Frightfur Cond
function FSabreToothCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  return true
	end
    if GlobalFusionSummon > 0 then -- Polymerization or Frightfur Factory
	  return SpSummonFSabre()
	end
	if GlobalFFusion > 0 then -- Frightfur Fusion
	  return SpSummonFSabreBanish()
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
    if GlobalFusionSummon > 1 then
	  return 1
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return true
  end
  return true
end
function FKrakenCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  return 
	    CardsMatchingFilter(OppMon(),FKrakenSendFilter) > 0
		or #OppMon() == 0 and #OppST() < 2
	end
    if GlobalFusionSummon > 0 then -- Polymerization or Frightfur Factory
	  return SpSummonFKraken()
	end
	if GlobalFFusion > 0 then -- Frightfur Fusion
	  return SpSummonFKrakenBanish()
	end
	return true
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 4
	  else
	    return 1
	  end
	end
    if GlobalFusionSummon > 1 then
	  return 6
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return true
  end
  return true
end
function FLeoCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  return true
	end
    if GlobalFusionSummon > 0 then -- Polymerization or Frightfur Factory
	  return SpSummonFLeo()
	end
	if GlobalFFusion > 0 then -- Frightfur Fusion
	  return SpSummonFLeoBanish()
	end
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 2
	  else
	    return 1
	  end
	end
    if GlobalFusionSummon > 1 then
	  return 1
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return true
  end
  return true
end

function FBearCond(loc,c)
  if loc == PRIO_TOHAND then
    return
	  OPTCheck(03841833) and not HasID(AIHand(),03841833,true) -- Bear
	  and not HasID(UseLists({AIHand(),AIST()}),70245411,true) -- Toy Vendor
	  and #AIHand() > 2
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  return true
	end
    if GlobalFusionSummon > 0 then -- Polymerization or Frightfur Factory
	  return SpSummonFBear()
	end
	if GlobalFFusion > 0 then -- Frightfur Fusion
	  return SpSummonFBearBanish()
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
    if GlobalFusionSummon > 1 then
	  return 5
	end
    return not OPTCheck(c.id) and not HasID(AIMon(),c.id,true)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return true
  end
  return true
end

function FWolfCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  return true
	end
    if GlobalFusionSummon > 0 then -- Polymerization or Frightfur Factory
	  return SpSummonFWolf()
	end
	if GlobalFFusion > 0 then -- Frightfur Fusion
	  return SpSummonFWolfBanish()
	end
  end
  if loc == PRIO_TOGRAVE then
    if GlobalOcto == 1 then
	  return 2
	end
    if GlobalFusionSummon > 1 then
	  return 1
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return true
  end
  return true
end

function FTigerCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),30068120,true) -- Sabres
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  return true
	end
    if GlobalFusionSummon > 0 then -- Polymerization or Frightfur Factory
	  return SpSummonFTiger()
	end
	if GlobalFFusion > 0 then -- Frightfur Fusion
	  return SpSummonFTigerBanish()
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
    if GlobalFusionSummon > 1 then
	  return 4
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return true
  end
  return true
end

function FSheepCond(loc,c)
  if loc == PRIO_TOHAND then
    return OPTCheck(c.id) and not HasID(AIHand(),c.id,true)
  end
  if loc == PRIO_TOFIELD then
    if GlogalFSabreTooth > 0 then
	  return true
	end
    if GlobalFusionSummon > 0 then -- Polymerization or Frightfur Factory
	  return SpSummonFSheep()
	end
	if GlobalFFusion > 0 then -- Frightfur Fusion
	  return SpSummonFSheepBanish()
	end
	return true
  end
  if loc == PRIO_TOGRAVE then
	if FilterAffected(c,EFFECT_CANNOT_ATTACK) then -- Instant Fusion
	  OPTReset(c.cardid)
	  return 9999
	else
	  return true
	end
	if GlobalOcto == 1 then
	  if not HasID(AIGrave(),c.id,true) then
	    return 4
	  else
	    return 1
	  end
	end
  end
  if loc == PRIO_TOGRAVE then
    if GlobalFusionSummon > 1 then
	  return 3
	end
    return not OPTCheck(c.id)
  end
  if loc == PRIO_DISCARD then
    return not OPTCheck(c.id)
  end
  if loc == PRIO_BANISH then
    return true
  end
  return true
end

function SVFDCond(loc,c)
  if loc == PRIO_TOFIELD then
    if GlobalFusionSummon > 0 then -- Polymerization or Frightfur Factory
	  return SpSummonSVFD()
	end
	if GlobalFFusion > 0 then -- Frightfur Fusion
	  return false
	end
  end
  return true
end

FluffalPriorityList={
--PRIO_TOHAND = 1
--PRIO_TOFIELD = 3
--PRIO_TOGRAVE = 5
--PRIO_DISCARD = 7
--PRIO_BANISH = 9

 [39246582] = {8,1,7,1,4,1,4,1,9,4,DogCond},		-- Fluffal Dog
 [03841833] = {10,2,2,1,4,1,4,1,8,3,BearCond},		-- Fluffal Bear
 [65331686] = {5,4,9,1,2,1,1,1,5,2,OwlCond},		-- Fluffal Owl
 [98280324] = {6,2,1,1,3,1,3,1,6,2,SheepCond},		-- Fluffal Sheep
 [02729285] = {7,5,2,1,1,1,1,1,3,1,CatCond},		-- Fluffal Cat
 [38124994] = {5,3,2,1,1,1,1,1,7,1,RabitCond},		-- Fluffal Rabit
 [06142488] = {1,1,10,2,5,1,4,1,10,5,MouseCond},	-- Fluffal Mouse
 [72413000] = {9,1,3,2,8,1,10,1,9,1,WingsCond},		-- Fluffal Wings
 [00006131] = {1,1,5,4,5,1,1,1,3,2,PatchworkCond},	-- Fluffal Patchwork (BETA)
 [00007614] = {5,1,5,1,1,1,1,1,4,2,OctoCond},		-- Fluffal Octo (BETA)
 [97567736] = {1,1,6,3,8,1,7,1,6,1,TomahawkCond},	-- Edge Imp Tomahawk
 [61173621] = {8,2,4,4,6,1,6,1,4,1,ChainCond},		-- Edge Imp Chain
 [30068120] = {8,3,4,5,7,1,5,4,5,1,SabresCond},		-- Edge Imp Sabres
 [10802915] = {1,1,1,1,1,1,8,1,10,1,TourGuideCond},	-- Tour Guide
 [79109599] = {1,1,3,2,9,1,1,1,10,1,KoSCond},		-- King of the Swamp
 [67441435] = {1,1,8,2,9,1,9,1,1,1,BulbCond},		-- Glow-Up Bulb

 [70245411] = {5,4,1,1,2,1,1,1,1,1,ToyVendorCond},	-- Toy Vendor
 [06077601] = {3,1,1,1,1,1,2,1,10,1,FFusionCond},	-- Frightfur Fusion
 [43698897] = {4,2,1,1,1,1,1,1,1,1,FFactoryCond},	-- Frightfur Factory
 [01845204] = {1,1,1,1,3,2,3,1,4,1,IFusionCond},	-- Instant Fusion
 [24094653] = {1,1,1,1,1,1,3,1,3,1,PolyCond},		-- Polymerization
 [94820406] = {1,1,1,1,1,1,2,1,5,1,DFusionCond},	-- DFusionCond
 [05133471] = {1,1,1,1,7,6,8,6,1,1,GClycloneCond},	-- Galaxy Cyclone
 [43898403] = {1,1,1,1,2,1,2,1,1,1,nil},			-- Twin Twister

 [66127916] = {1,1,1,1,1,1,1,1,1,1,FReserveCond}, 	-- Fusion Reserve

 [80889750] = {1,1,7,1,1,4,1,1,4,1,FSabreToothCond},-- Frightfur Sabre-Tooth
 [00007620] = {1,1,6,1,5,3,1,1,2,1,FKrakenCond},	-- Frightfur Kraken (BETA)
 [10383554] = {1,1,9,1,2,1,1,1,10,1,FLeoCond},		-- Frightfur Leo
 [85545073] = {5,1,1,1,3,1,1,1,2,1,FBearCond},		-- Frightfur Bear
 [11039171] = {2,1,8,1,2,1,1,1,9,1,FWolfCond},		-- Frightfur Wolf
 [00464362] = {3,1,5,1,5,4,1,1,3,1,FTigerCond},		-- Frightfur Tiger
 [57477163] = {4,1,4,1,4,2,1,1,2,1,FSheepCond},		-- Frightfur Sheep
 [41209827] = {2,1,10,1,1,1,1,1,1,1,SVFDCond}, 		-- Starve Venom Fusion Dragon<
 [33198837] = {1,1,1,1,1,1,1,1,1,1,nil}, 			-- Naturia Beast
 [42110604] = {1,1,1,1,1,1,1,1,1,1,nil}, 			-- Hi-Speedroid Chanbara
 [82633039] = {1,1,1,1,1,1,1,1,1,1,nil}, 			-- Castel
 [83531441] = {1,1,1,1,1,1,1,1,1,1,nil}, 			-- Dante
}