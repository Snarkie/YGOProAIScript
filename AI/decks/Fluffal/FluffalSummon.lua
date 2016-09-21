------------------------
------- SUMMON ---------
------------------------
-- FluffalM Normal Summon
function SummonDog()
  return OPTCheck(39246582)
end
function SummonBear()
  return not OPTCheck(03841833)
end
function SummonOwl()
  return OPTCheck(65331686)
end
function SummonOwl2()
  return OPTCheck(65331686)
  and not HasID(AIHand(),39246582,true) -- Dog
end
function SummonOwl3()
  return
    OPTCheck(65331686)
	and not HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	and not HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	and not HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
	and not OPTCheck(72413000) -- Wings
end
function SpecialSummonSheep(c)
  if OPTCheck(c.id)
  and CountEgdeImp(AIGrave()) > 0
  and not HasID(AIMon(),98280324,true)
  then
    return true
  else
    return false
  end
end
function SpecialSummonSheep2()
  if OPTCheck(98280324)
  and CountEgdeImp(UseLists({AIGrave(),AIHand()})) > 0
  and not HasID(AIMon(),98280324,true)
  then
    return true
  else
    return false
  end
end
function SpecialSummonSheep3()
  if OPTCheck(98280324) and HasID(AIHand(),97567736,true)-- Tomahawk
  and not HasID(AIMon(),98280324,true)  
  then
    return true
  else
    return false
  end
end
function SpecialSummonSheep4()
  if OPTCheck(98280324)
  and CountEgdeImp(UseLists({AIGrave(),AIHand()})) > 0
  and (
    CountFluffal(AIHand()) - Get_Card_Count_ID(AIHand(),98280324)
  ) > 0
  and not HasID(AIMon(),98280324,true) 
  then
    return true
  else
    return false
  end
end
function SummonMouse()
  return OPTCheck(06142488)
    and Get_Card_Count_ID(AIDeck(),06142488) == 2
	and #AIMon() < 3
	and (
	  HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	  or HasID(UseLists({AIHand(),AIST()}),43698897,true) -- FFactory
	  or HasID(UseLists({AIHand(),AIST()}),06077601,true) -- FFusion
	)
	and AI.GetPlayerLP(1) > OppGetStrongestAttack()
	and AI.GetPlayerLP(1) >= 2000
	and Duel.GetTurnCount() ~= 1
end
function SummonPatchwork()
  return
    CountEgdeImp(UseLists({AIMon(),AIHand()})) == 0
    and (
	  HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	  or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
	)
end
function SummonOcto()
  return 
    OPTCheck(39246582) 
	and (CountFluffal(AIGrave()) + CountEgdeImp(AIGrave())) > 0
	and CardsMatchingFilter(AIBanish(),FilterType,TYPE_MONSTER) > 0
end
-- EdgeImp Summon
function SummonTomahawk()
  return OPTCheck(97567736)
end
function SummonChain()
  return
    Duel.GetTurnCount() ~= 1
	and (
	  OppGetStrongestAttack() < AIGetStrongestAttack()
	  or OppGetStrongestAttack() < 1200
	)
end
function SummonSabres()
  return
    Duel.GetTurnCount() ~= 1
	and (
	  OppGetStrongestAttack() < AIGetStrongestAttack()
	  or OppGetStrongestAttack() < 1200
	)
end

-- Other Summon
function SummonTourGuideFluffal()
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
function SpSummonFSabre()
  if GlobalIFusion == 1 then
    return true
  end
  if (
    HasID(AIMon(),00007620,true) -- Frightfur Kraken
    or HasID(AIMon(),85545073,true) -- Frightfur Bear
	or HasID(AIMon(),00464362,true) -- Frightfur Tiger
	or HasID(AIMon(),57477163,true) -- Frightfur Sheep
  )
  and (
	(GlobalMaterialF + GlobalMaterialE) > 1 -- Fluffal
	or OppGetStrongestAttack() >= AIGetStrongestAttack() -- Strong Opp
  )
  then
    return
	  AI.GetCurrentPhase() == PHASE_MAIN1
	  and (
	    not HasID(AIMon(),80889750,true) -- Frightfur Sabre-Tooth
		or #AIMon() <= 2 and #AIST() <= 2
	  )
  end
  return false
end
function SpSummonFSabreBanish()
  if CountFrightfurMon(AIGrave()) > 2 -- Frightfur Grave
  and (
    CountFluffalBanishTarget(UseLists({AIMon(),AIGrave()})) > 1 -- Fluffal
	or OppGetStrongestAttack() >= AIGetStrongestAttack() -- Strong Opp
  )
  and Duel.GetTurnCount() ~= 1
  then
    print("SpSummonFSabreBanish - ENTRA")
    return
	  not HasID(AIMon(),80889750,true)
	  and AI.GetCurrentPhase() == PHASE_MAIN1
  end
  return false
end

function SpSummonFKraken()
  if (
    GlobalMaterialE > 0 -- EdgeImp
  )
  and (
    GlobalMaterialF > 0 -- Fluffal
  )
  then
    return
	  not HasID(AIMon(),00007620,true)
	  and (
	    CardsMatchingFilter(OppMon(),FilterAffected,EFFECT_INDESTRUCTABLE) > 0
		or (
	      CardsMatchingFilter(OppMon(),FKrakenSendFilter) > 0
		  and CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) < 2
		  and (
		    #OppMon() == 0 
			or #OppMon() == 1 
			and (
			  CountFluffal(UseLists({AIHand(),AIMon()})) 
			  + CountEgdeImp(UseLists({AIHand(),AIMon()}))
			) >= 2
			and (
			  HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
		      or HasID(UseLists({AIHand(),AIST()}),94820406,true) -- DFusion
			)
		  )
		)
	  )
	  and Duel.GetTurnCount() > 1
	  and AI.GetCurrentPhase() == PHASE_MAIN1
  end
  return false
end
function SpSummonFKrakenBanish()
  if CountEgdeImp(UseLists({AIMon(),AIGrave()})) > 0
  and CountFluffalBanishTarget(UseLists({AIMon(),AIGrave()})) > 0
  then
    return
	  not HasID(AIMon(),00007620,true)
	  and (
	    CardsMatchingFilter(OppMon(),FilterAffected,EFFECT_INDESTRUCTABLE) > 0
		or (
	      CardsMatchingFilter(OppMon(),FKrakenSendFilter) > 0
		  and CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) < 2
		  and (
		    #OppMon() < 2
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
    or HasID(AIMon(),00006131,true) -- Patchwork
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
    or HasID(AIMon(),00006131,true) -- Patchwork
  )
  and CountFluffalBanishTarget(UseLists({AIMon(),AIGrave()})) > 0
  then
    return
	  not HasID(AIMon(),10383554,true)
	  and OPTCheck(10383554)
	  and FLeoFinish()
  end
  return false
end

function SpSummonFBear()
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
	#OppMon() == 1
	and CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) == 0
	and HasID(AIMon(),00464362,true)
end
function SpSummonFWolf()
  if (
    HasID(UseLists({AIMon(),AIHand()}),30068120,true) -- Sabres
  )
  and (
    CountFluffal(UseLists({AIHand(),AIMon()})) > 0 -- End Game
  )	
  and FWolfFinish()
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
  and CountFluffalBanishTarget(UseLists({AIMon(),AIGrave()})) > 0
  and FWolfFinish()
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
	or HasID(AIMon(),00006131,true) -- Patchwork
  )
  and (
    GlobalMaterialF > 1 -- Fluffal
	or GlobalMaterialF > 0
	and OppGetStrongestAttack() >= AIGetStrongestAttack()
	or GlobalMaterialF > 0
	and CountFrightfurMon(AIMon()) > 0
  )
  then
    return
	  not HasID(AIMon(),00464362,true)
	  and CardsMatchingFilter(OppField(),FTigerDestroyFilter) > 1
	  and AI.GetCurrentPhase() == PHASE_MAIN1
  end
  return false
end
function SpSummonFTigerBanish()
  if (
    HasID(UseLists({AIMon(),AIGrave()}),30068120,true) -- Sabres
    or HasID(UseLists({AIMon(),AIGrave()}),79109599,true) -- Kos
	or HasID(AIMon(),00006131,true) -- Patchwork
  )
  and CountFluffalBanishTarget(UseLists({AIMon(),AIGrave()})) > 0
  and (
    CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) > 0
	or CardsMatchingFilter(OppField(),FTigerDestroyFilter) > 1
  )
  then
    return
	  not HasID(AIMon(),00464362,true)
	  and CardsMatchingFilter(OppField(),FTigerDestroyFilter) > 1
	  and AI.GetCurrentPhase() == PHASE_MAIN1
  end
  return false
end

function SpSummonFSheep()
  if (
    HasID(UseLists({AIMon(),AIHand()}),61173621,true) -- Chain
    or HasID(UseLists({AIMon(),AIHand()}),79109599,true) -- Kos
	or HasID(AIMon(),00006131,true) -- Patchwork
  )
  and GlobalMaterialF > 0 -- Fluffal
  then
    return not HasID(AIMon(),57477163,true)
  end
  return false
end
function SpSummonFSheepBanish()
  if (
    HasID(UseLists({AIMon(),AIGrave()}),61173621,true) -- Chain
    or HasID(UseLists({AIMon(),AIGrave()}),79109599,true) -- Kos
	or HasID(AIMon(),00006131,true) -- Patchwork
  )
  and CountFluffalBanishTarget(UseLists({AIMon(),AIGrave()})) > 0
  and (#OppMon() > 0 or HasID(AIGrave(),61173621,true)) -- Chain
  then
    return not HasID(AIMon(),57477163,true)
  end
  return false
end

-- Other Fusion
function SpSummonSVFD()
  local countMaterial = 0
  countMaterial = countMaterial + CountEgdeImp(AIMon())
  if HasID(AIMon(),10802915,true) then -- TourGuide
    countMaterial = countMaterial + 1
  end
  if HasID(AIMon(),00464362,true) -- FTiger
  or HasID(AIMon(),57477163,true) -- FSheep
  then 
    countMaterial = countMaterial + 1
  end
  if CardsMatchingFilter(OppMon(),FilterSummon,SUMMON_TYPE_SPECIAL) > 0
    and CardsMatchingFilter(OppMon(),FilterLevelMin,5) > 0
	and HasID(UseLists({AIHand(),AIST()}),24094653,true) -- Polymerization
	and countMaterial >= 2
  then
    return 
	  not HasID(AIMon(),41209827,true) 
	  and GlobalDFusion == 0
	  and AI.GetCurrentPhase() == PHASE_MAIN1
  end
  return false
end

-- Other Synchro
function SpSummonNaturiaBeast()
  return
    OppGetStrongestAttack() <= 2200
end
function SpSummonDante()
  return
    OppGetStrongestAttack() < AIGetStrongestAttack()
    or CardsMatchingFilter(OppMon(),FilterAttackMax,2400) > 0
	or #OppMon() == 0
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
  return not HasID(AIST(),51452091,true)
end