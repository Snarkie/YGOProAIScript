------------------------
------- SUMMON ---------
------------------------

-- FluffalM Summon
function SummonDog()
  return
    OPTCheck(39246582)
	and CountFluffal(AIDeck()) > 0
	and #AIDeck() > 17
end
function SummonDog2()
  return
    OPTCheck(39246582)
	and CountFluffal(AIDeck()) > 0
end
function SummonBear()
  return
    OPTCheck(03841833)
    and not HasID(AIDeck(),70245411,true) -- ToyVendor
end
function SummonOwl()
  return OPTCheck(65331686)
end
function SummonOwlNoFusion()
  return
    OPTCheck(65331686)
	and not HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	and not HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	and not HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
	and not OPTCheck(72413000) -- Wings
end
function SpSummonSheep()
  if OPTCheck(98280324)
  and not HasID(AIMon(),98280324,true)
  and CountEgdeImp(AIGrave()) > 0
  then
    print("SpSummonSheep")
    return true
  else
    return false
  end
end
function SpSummonSheep2()
  if OPTCheck(98280324)
  and not HasID(AIMon(),98280324,true)
  and CountEgdeImp(UseLists({AIGrave(),AIHand()})) > 0
  then
    print("SpSummonSheep2")
    return true
  else
    return false
  end
end
function SpSummonSheepTomahawk()
  if OPTCheck(98280324)
  and not HasID(AIMon(),98280324,true)
  and HasID(AIHand(),97567736,true) -- Tomahawk
  then
    print("SpSummonSheepTomahawk")
    return true
  else
    return false
  end
end
function SpSummonSheepEnd()
  if OPTCheck(98280324)
  and not HasID(AIMon(),98280324,true)
  and CountEgdeImp(UseLists({AIGrave(),AIHand()})) > 0
  and (
    CountFluffal(AIHand()) - Get_Card_Count_ID(AIHand(),98280324)
  ) > 0
  then
    return true
  else
    return false
  end
end
function SummonMouse(mode)
  if mode == nil then
    mode = 2
  end
  if OPTCheck(06142488)
  and Get_Card_Count_ID(AIDeck(),06142488) == mode
  and #AIMon() < 3
  and (
    HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	or HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
	or HasID(UseLists({AIHand(),AIST()}),06077601,true) -- FFusion
  )
  and (
    CountEgdeImp(UseLists({AIHand(),AIMon()}))
	or HasID(UseLists({AIHand(),AIMon()}),79109599,true) -- KoS
  )
  and Duel.GetTurnCount() ~= 1
  then
    return true
  else
    return false
  end
end
function SummonPatchwork()
  if CountEgdeImp(UseLists({AIMon(),AIHand()})) == 0
  and (
	HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
  )
  and not HasID(UseLists({AIHand(),AIST()}),01845204,true) -- IFusion
  then
    return true
  else
    return false
  end
end
function SummonOcto()
  local edgeImpGrave = CountEgdeImp(AIGrave())
  local fluffalGrave = CountFluffal(AIGrave())
  if OPTCheck(00007614)
  and (
    fluffalGrave > 2
	or
	not OPTCheck(72413000) -- Wings
	and fluffalGrave > 0
	or
	edgeImpGrave > 0
  )
  then
    if CardsMatchingFilter(AIBanish(),FilterType,TYPE_MONSTER) > 0
    and (
      HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	  or HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
    )
	then
	  return true
	elseif OPTCheck(98280324) -- Sheep
    and HasID(AIHand(),98280324,true)
	then
	  return true
	elseif OPTCheck(03841833) -- Bear
	and HasID(AIGrave(),03841833,true)
	and not HasID(AIST(),70245411,true) -- ToyVendor
	and HasID(AIDeck(),70245411,true)
	and #AIHand() > 3
	then
	  return true
	else
	  return false
	end
  else
    return false
  end
end

function SummonOcto2()
  local edgeImpGrave = CountEgdeImp(AIGrave())
  local fluffalGrave = CountFluffal(AIGrave())
  if OPTCheck(00007614)
  and (edgeImpGrave + fluffalGrave) > 0
  and (
    HasID(AIHand(),70245411,true) -- ToyVendor
	or
	CardsMatchingFilter(AIST(),ToyVendorCheckFilter,true) > 0
	or
	HasID(AIGrave(),03841833,true) -- Bear
	and OPTCheck(03841833)
	and HasID(AIDeck(),70245411,true)
  )
  then
    return true
  else
    return false
  end
end

-- EdgeImp Summon
function SummonTomahawk(c)
  return OPTCheck(97567736)
end
function SummonChain(c)
  return
    Duel.GetTurnCount() > 1
	and (
	  OppGetStrongestAttack() < 1200
	  or
	  OppGetStrongestAttack() < AIGetStrongestAttack()
	  and CanAttackAttackMax(OppMon(),false,c.attack-1)
	)
end
function SummonSabres(c)
  return
    Duel.GetTurnCount() > 1
	and (
	  OppGetStrongestAttack() < 1200
	  or
	  OppGetStrongestAttack() < AIGetStrongestAttack()
	  and CanAttackAttackMax(OppMon(),false,c.attack-1)
	)
end
-- Other Summon
function SummonTGuide()
  if HasID(AIDeck(),30068120,true) -- Sabres
  and OPTCheck(06142488) -- Mouse
  and #AIMon() <= 3
  then
    if HasID(AIExtra(),83531441,true) -- Dante
	and (
	  CardsMatchingFilter(OppMon(),FilterAttackMax,2400) > 0
	  or #OppMon() == 0
	)
    then
      return true
	elseif HasID(AIExtra(),41209827,true) -- Starve
	and CardsMatchingFilter(OppMon(),FilterSummon,SUMMON_TYPE_SPECIAL) > 0
	and CardsMatchingFilter(OppMon(),FilterLevelMin,5) > 0
	and (
	  HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	)
    then
	  return true
	else
	  return false
	end
  else
    return false
  end
end
function SummonBulb()
  if FieldCheck(4) > 0
  and OPTCheck(06142488) -- Mouse
  and OppGetStrongestAttDef() <= 2100
  and AI.GetCurrentPhase() == PHASE_MAIN1
  then
    return true
  end
  return false
end

-- Frightfur Fusion Summon
function SpSummonFSabreTooth()
  if GlobalIFusion == 1 then
    return 10
  end
  if (
    HasID(AIMon(),00007620,true) -- FKraken
    or HasID(AIMon(),85545073,true) -- FBear
	or HasID(AIMon(),00464362,true) -- FTiger
	or HasID(AIMon(),57477163,true) -- FSheep
	or CardsMatchingFilter(AIMon(),FrightfurMonNegatedFilter) > 0
  )
  and (
	(GlobalMaterialF + GlobalMaterialE) > 1 -- Fluffal
	or
	OppGetStrongestAttack() >= AIGetStrongestAttack() -- Strong Opp
	and AI.GetCurrentPhase() == PHASE_MAIN1
  )
  then
    return
	  not HasID(AIMon(),80889750,true)
	  or
	  Get_Card_Count_ID(AIMon(),80889750) < 2
	  and #OppMon() <= 2
	  and CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) <= 2
	  and Duel.GetTurnCount() > 1
	  --and HasID(AIMon(),00464362,true) -- FTiger
	  and AI.GetCurrentPhase() == PHASE_MAIN1
  end
  return false
end
function SpSummonFSabreToothBanish()
 if CountFrightfurMon(UseLists({AIMon(),AIGrave()})) > 2
  and (
	GlobalMaterialF > 1 -- Fluffal
  )
  then
    return
	  not HasID(AIMon(),80889750,true)
  end
  return false
end
function SpSummonFKraken()
  if HasID(AIExtra(),00007620,true) -- Own
  and (
    GlobalMaterialE > 0 -- EdgeImp
  )
  and (
    GlobalMaterialF > 0 -- Fluffal
  )
  then
    if CardsMatchingFilter(OppMon(),BAFilter) > 0
	and not HasID(AIMon(),57477163,true)
	then
	  return 5
	end
    local frightfurAtk = 2200 + FrightfurBoost(00007620)
    return
	  not HasID(AIMon(),00007620,true)
	  and (
	    CardsMatchingFilter(OppMon(),FilterAffected,EFFECT_INDESTRUCTABLE) > 0
		or (
		  CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) < 2
		  and (
		    #OppMon() == 0
			or
			#OppMon() == 1
			and (GlobalMaterialF + GlobalMaterialE) > 2
			and (
			  HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
		      or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
			)
			or
			#OppMon() == 2
			and CanAttackAttackMax(OppMon(),false,frightfurAtk,nil,nil) > 0
			or
			#OppMon() > 2
			and CanAttackAttackMax(OppMon(),false,frightfurAtk,nil,nil) >= 2
		  )
		)
	  )
	  and Duel.GetTurnCount() > 1
	  and AI.GetCurrentPhase() == PHASE_MAIN1
  end
  return false
end

function FLeoFinish()
  return CardsMatchingFilter(OppMon(),FLeoFinishFilter,c) > 0
end
function SpSummonFLeo()
  if (
    HasID(UseLists({AIMon(),AIHand()}),79109599,true) -- KoS
    or HasID(AIMon(),81481818,true) -- Patchwork
  )
  and GlobalMaterialF > 0 -- Fluffal
  then
    return
	  not HasID(AIMon(),10383554,true)
	  and OPTCheck(10383554)
	  and FLeoFinish()
  end
  return false
end
function SpSummonFLeoBanish()
  if (
    HasID(UseLists({AIMon(),AIGrave()}),79109599,true) -- KoS
    or HasID(AIMon(),81481818,true) -- Patchwork
  )
  and GlobalMaterialF > 0 -- Fluffal
  then
    return
	  not HasID(AIMon(),10383554,true)
	  and OPTCheck(10383554)
	  and FLeoFinish()
  end
  return false
end
function SpSummonFBear()
  if (
    HasID(UseLists({AIMon(),AIHand()}),30068120,true) -- Sabres
	and HasID(UseLists({AIMon(),AIHand()}),79109599,true) -- KoS
  )
  or (
	HasID(UseLists({AIMon(),AIHand()}),03841833,true) -- Bear
	and HasID(UseLists({AIMon(),AIHand()}),79109599,true) -- KoS
  )
  or (
    HasID(UseLists({AIMon(),AIHand()}),30068120,true) -- Sabres
	and HasID(UseLists({AIMon(),AIHand()}),03841833,true) -- Bear
  )
  then
    local frightfurAtk = 2200 + FrightfurBoost(85545073)
    return
	  not HasID(AIMon(),85545073,true)
	  and OPTCheck(85545073)
	  and #OppMon() > 0
	  and CanAttackAttackMax(AIMon(),false,frightfurAtk-1) > 0
	  and Duel.GetTurnCount() > 1
	  and AI.GetCurrentPhase() == PHASE_MAIN1
  end
  return false
end
function SpSummonFBearBanish()
  return false
end

function FWolfFinish()
  return
    HasID(AIMon(),00464362,true)
    and #OppMon() == 0
	or
	HasID(AIMon(),80889750,true)
	and HasID(AIMon(),00464362,true)
	and CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) < 3
	or
	#OppMon() <= 1
	and HasID(AIMon(),00464362,true)
	and CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) == 0
	or
	#OppField() == 0
	and GlobalMaterialF > 1
end
function SpSummonFWolf()
  if (
    HasID(UseLists({AIMon(),AIHand()}),30068120,true) -- Sabres
  )
  and (
    CountFluffal(UseLists({AIHand(),AIMon()})) > 0 -- End Game
  )
  and FWolfFinish()
  and CardsMatchingFilter(OppMon(),FilterAffected,EFFECT_INDESTRUCTABLE_BATTLE) == 0
  then
    return
	  not HasID(AIMon(),11039171,true)
	  and AI.GetCurrentPhase() == PHASE_MAIN1
	  and GlobalBPAllowed
  end
  return false
end
function SpSummonFWolfBanish()
  if (
    HasID(UseLists({AIMon(),AIGrave()}),30068120,true) -- Sabres
  )
  and (
    CountFluffal(UseLists({AIHand(),AIGrave()})) > 0 -- End Game
  )
  and FWolfFinish()
  and CardsMatchingFilter(OppMon(),FilterAffected,EFFECT_INDESTRUCTABLE_BATTLE) == 0
  then
    return
	  not HasID(AIMon(),11039171,true)
	  and AI.GetCurrentPhase() == PHASE_MAIN1
	  and GlobalBPAllowed
  end
  return false
end
function SpSummonFTiger()
  if (
    HasID(UseLists({AIMon(),AIHand()}),30068120,true) -- Sabres
    or HasID(UseLists({AIMon(),AIHand()}),79109599,true) -- Kos
	or HasID(AIMon(),81481818,true) -- Patchwork
  )
  and (
    GlobalMaterialF > 1 -- Fluffal
	or
	GlobalMaterialF > 0
	and
	OppGetStrongestAttack() >= AIGetStrongestAttack()
	or
	GlobalMaterialF > 0
	and CountFrightfurMon(AIMon()) > 0
  )
  and (
    CardsMatchingFilter(OppField(),FTigerDestroyFilter) > 1
	or
	CardsMatchingFilter(OppField(),FTigerDestroyFilter) == 1
	and HasID(AIMon(),80889750,true) -- FSabreTooth
	or
	CardsMatchingFilter(OppField(),FTigerDestroyFilter) == 1
	and (GlobalMaterialF + GlobalMaterialE) >= 4
  )
  then
    if GlobalDarkLaw > 0 then
	  return 11
	end
    return
	  not HasID(AIMon(),00464362,true)
	  and AI.GetCurrentPhase() == PHASE_MAIN1
  end
  return false
end
function SpSummonFTigerBanish()
  if (
    HasID(UseLists({AIMon(),AIGrave()}),30068120,true) -- Sabres
    or HasID(UseLists({AIMon(),AIGrave()}),79109599,true) -- Kos
	or HasID(AIMon(),81481818,true) -- Patchwork
  )
  and (
    GlobalMaterialF > 1 -- Fluffal
	or
	GlobalMaterialF > 0
	and
	OppGetStrongestAttack() >= AIGetStrongestAttack()
	or
	GlobalMaterialF > 0
	and CountFrightfurMon(AIMon()) > 0
  )
  and (
    CardsMatchingFilter(OppField(),FTigerDestroyFilter) > 1
	or
	CardsMatchingFilter(OppField(),FTigerDestroyFilter) == 1
	and HasID(AIMon(),80889750,true) -- FSabreTooth
  )
  then
    if GlobalDarkLaw > 0 then
	  return 11
	end
    return
	  not HasID(AIMon(),00464362,true)
	  and AI.GetCurrentPhase() == PHASE_MAIN1
  end
  return false
end
function SpSummonFSheep()
  if HasID(AIExtra(),57477163,true) -- Own
  and (
    HasID(UseLists({AIMon(),AIHand()}),61173621,true) -- Chain
    or
	HasID(UseLists({AIMon(),AIHand()}),79109599,true) -- KoS
	and Duel.GetTurnCount() > 1
	or
	HasID(AIMon(),81481818,true) -- Patchwork
  )
  and GlobalMaterialF > 0 -- Fluffal
  then
    if Duel.GetTurnCount() == 1
	and not OPTCheck(61173621) -- Chain
	then
	  return false
	end
	if CardsMatchingFilter(OppMon(),BAFilter) > 0
	and not HasID(AIMon(),57477163,true)
	then
	  if CardsMatchingFilter(OppMon(),FilterPosition,POS_ATTACK) > 0
	  or CardsMatchingFilter(OppMon(),FilterDefenseMax,2400) > 0
	  or HasIDNotNegated(AIMon(),00464362,true) -- FTiger
	  then
	    return 7
	  else
	    return 4
	  end
	end
    return not HasID(AIMon(),57477163,true)
  end
  return false
end
function SpSummonFSheepBanish()
  if HasID(AIExtra(),57477163,true) -- Own
  and (
    HasID(UseLists({AIMon(),AIGrave()}),61173621,true) -- Chain
    or HasID(UseLists({AIMon(),AIGrave()}),79109599,true) -- Kos
	or HasID(AIMon(),81481818,true) -- Patchwork
  )
  and GlobalMaterialF > 0 -- Fluffal
  then
    if CardsMatchingFilter(OppMon(),BAFilter) > 0
	and not HasID(AIMon(),57477163,true)
	then
	  if CardsMatchingFilter(OppMon(),FilterPosition,POS_ATTACK) > 0
	  or CardsMatchingFilter(OppMon(),FilterDefenseMax,2400) > 0
	  or HasIDNotNegated(AIMon(),00464362,true) -- FTiger
	  then
	    return 7
	  else
	    return 4
	  end
	end
    return not HasID(AIMon(),57477163,true)
  end
  return false
end
-- Other Fusion Summon
function SpSummonStarve()
  local countMaterial = 0
  countMaterial = countMaterial + CountEgdeImp(AIMon())
  if HasID(AIMon(),10802915,true) then -- TourGuide
    countMaterial = countMaterial + 1
  end
  if HasID(AIMon(),00464362,true) -- FTiger
  or HasID(AIMon(),00007620,true) -- FKraken
  or HasID(AIMon(),57477163,true) -- FSheep
  then
    countMaterial = countMaterial + 1
  end
  if CardsMatchingFilter(OppMon(),FilterSummon,SUMMON_TYPE_SPECIAL) > 0
  and CardsMatchingFilter(OppMon(),FilterLevelMin,5) > 0
  and countMaterial >= 2
  and (
    HasID(UseLists({AIHand(),AIST()}),24094653,true)
	or GlobalPolymerization > 0
  ) -- Polymerization
  then
    if GlobalIFusion == 1 then
	  return 11
	end
    return
	  not HasID(AIMon(),41209827,true)
	  and GlobalDFusion == 0
	  and AI.GetCurrentPhase() == PHASE_MAIN1
  end
  return false
end
-- Other Synchro Summon
function SpSummonNaturiaBeast()
  return
    OppGetStrongestAttack() <= 2200
end
function SpSummonChanbara()
  return
    AI.GetCurrentPhase() == PHASE_MAIN1
	and GlobalBPAllowed
	and (
	  OppGetStrongestAttack() < AIGetStrongestAttack()
	  or CardsMatchingFilter(OppMon(),FilterAttackMax,2200) > 0
	  or #OppMon() == 0
	)
end
-- Other XYZ Summon
function SpSummonDante()
  return
    OppGetStrongestAttack() < AIGetStrongestAttack()
    or CardsMatchingFilter(OppMon(),FilterAttackMax,2499) > 0
	or #OppMon() == 0
end
------------------------
--------- SET ----------
------------------------

-- FluffalM Set
function SetWings(c)
  if #AIMon() == 0 then
    return true
  else
    return false
  end
  return false
end
-- EdgeImp Set
function SetChain(c)
  return true
end
function SetSabres(c)
  if #AIMon() == 0 then
    return true
  else
    return false
  end
  return false
end
-- Other Set
-- FluffalS Set
-- Spell Set
-- Trap Set
function SetFReserve(c)
  return true
end
function SetRDecree(c)
  return not HasID(AIST(),c.id,true)
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

------------------------
------ REPOSITION ------
------------------------

function RepFKraken(c)
  if FilterPosition(c,POS_DEFENSE)
  and AI.GetCurrentPhase() == PHASE_MAIN1
  then
    if c.attack >= c.defense then
	  return true
	end
	if OPTCheck(c.id)
	and OppGetStrongestAttack() < AIGetStrongestAttack()
	then
	  return true
	elseif not OPTCheck(c.id)
	and OppGetStrongestAttack() < c.attack
	then
	  return true
	elseif not OPTCheck(c.id)
	and OppGetStrongestAttack() < AIGetStrongestAttack()
	and OppGetStrongestAttack() >= c.attack
	and #OppMon() > 1
	then
	  return true
	end
  end
  if AI.GetCurrentPhase() == PHASE_MAIN2 then
    return GenericReposition(c)
  end
  return false
end
function RepFSheep(c)
  if FilterPosition(c,POS_DEFENSE)
  then
    return true
  else
    return false
  end
end

function RepDante(c)
  if FilterPosition(c,POS_DEFENSE)
  and BattlePhaseCheck()
  and (
    #OppMon() == 0
	or OppGetStrongestAttDef() <= c.attack
  )
  and NotNegated(c)
  or
  FilterPosition(c,POS_FACEUP_ATTACK)
  and (
    Negated(c)
    or TurnEndCheck()
    or OppGetStrongestAttDef()>=1000
    and OppHasStrongestMonster()
  )
  then
    return true
  elseif FilterPosition(c,POS_FACEDOWN_DEFENSE)
  and c.xyz_material_count > 0
  then
    return true
  else
    return false
  end
end

function GenericReposition(c)
  if FilterPosition(c,POS_ATTACK) then
    if c.defense > c.attack
	then
      return true
    else
	  return false
	end
  end
  if FilterPosition(c,POS_DEFENSE) then
    if c.attack >= c.defense then
      return true
    else
	  return false
	end
  end
  return false
end