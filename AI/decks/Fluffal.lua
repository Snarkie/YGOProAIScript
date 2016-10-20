require("ai.decks.Fluffal.FluffalFilter")
require("ai.decks.Fluffal.FluffalCond")
require("ai.decks.Fluffal.FluffalSummon")
require("ai.decks.Fluffal.FluffalUse")
require("ai.decks.Fluffal.FluffalTarget")
require("ai.decks.Fluffal.FluffalChain")
require("ai.decks.Fluffal.FluffalBattle")

function FluffalStartup(deck)
  print("AI_Fluffal v0.0.0.6.7 by neftalimich.")
  AI.Chat("Duel!")

  deck.Init                 = FluffalInit
  deck.Card                 = FluffalCard
  deck.Chain                = FluffalChain
  deck.ChainOrder			= FluffalChainOrder
  deck.EffectYesNo			= FluffalEffectYesNo
  deck.YesNo				= FluffalYesNo
  deck.Position             = FluffalPosition
  deck.BattleCommand        = FluffalBattleCommand
  deck.AttackTarget         = FluffalAttackTarget
  deck.AttackBoost			= FluffalAttackBoost

  deck.ActivateBlacklist    = FluffalActivateBlacklist
  deck.SummonBlacklist      = FluffalSummonBlacklist
  deck.SetBlacklist         = FluffalSetBlacklist
  deck.RepositionBlacklist  = FluffalRepoBlacklist
  deck.Unchainable          = FluffalUnchainable

  deck.PriorityList         = FluffalPriorityList

  --[[
  Other, more obscure functions, in case you need them. Same as before,
  not defining a function or returning nil causes default logic to take over

  deck.YesNo
  deck.Option
  deck.Sum
  deck.Tribute
  deck.BattleCommand
  deck.AttackTarget
  deck.DeclareCard
  deck.Number
  deck.Attribute
  deck.MonsterType
  ]]

  --[[
  local e0=Effect.GlobalEffect()
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVED)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetFieldGroup(player_ai,LOCATION_HAND,0)
		--Duel.ConfirmCards(1-player_ai,g)
	end)
	Duel.RegisterEffect(e0,0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_TO_HAND)
	Duel.RegisterEffect(e1,0)
	local e2=e0:Clone()
	e2:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
	Duel.RegisterEffect(e2,0)
  local e3=Effect.GlobalEffect()
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_PUBLIC)
  e3:SetTargetRange(LOCATION_HAND,0)
  Duel.RegisterEffect(e3,player_ai)
  --]]
end

DECK_FLUFFAL = NewDeck("Fluffal",{03841833,72413000},FluffalStartup)

function FluffalInit(cards,to_bp_allowed,to_ep_allowed) -- FLUFFAL INIT

  --GLOBAL
  GlobalSheep = 0
  GlobalRabit = 0
  GlobalOcto = 0
  GlobalSabres = 0
  GlogalFSabreTooth = 0
  GlobalToyVendor = 0
  GlobalFusionPerform = 0
  GlobalFusionId = 0
  GlobalPolymerization = 0
  GlobalDFusion = 0
  GlobalFFusion = 0
  GlobalMaterialF = 0
  GlobalMaterialE = 0

  -- GLOBAL INIT
  GlobalFluffalPercent = CountFluffal(AIDeck()) / #AIDeck()
  print("FluffalPercent: "..(GlobalFluffalPercent * 100).." %")

  -- FLUFFAL VS VANITY'S EMPTINESS
  if CardsMatchingFilter(OppST(),VanityFilter) > 0 then -- VANITY
    local vanity = FluffalVsVanity(cards,to_bp_allowed,to_ep_allowed)
	if vanity then
	  return {vanity[1],vanity[2]}
    end
	return nil
  end

  -- FLUFFAL VS DARKLAW
  GlobalDarkLaw = 0
  if HasID(OppMon(),50720316,true) -- ShadowMist
  and CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN) > 0
  then
    if HasIDNotNegated(Act,12580477) -- Raigeki
    then
      return {COMMAND_ACTIVATE,CurrentIndex}
    end
	if HasIDNotNegated(Sum,97567736,SummonTomahawk) then
      return {COMMAND_SUMMON,CurrentIndex}
    end
	return nil
  end
  if HasIDNotNegated(OppMon(),58481572,true) -- DarkLaw
  then
    GlobalDarkLaw = 1
	local darklaw = FluffalVsDarkLaw(cards,to_bp_allowed,to_ep_allowed)
	if darklaw then
	  return {darklaw[1],darklaw[2]}
    end
	return nil
  end

  -- FLUFFAL VS TRUE MONARCHS

  -- FLUFFAL PRINCIPAL
  local principal = FluffalPrincipal(cards,to_bp_allowed,to_ep_allowed)
  if principal then
    return {principal[1],principal[2]}
  end

  return nil
end

function FluffalPrincipal(cards,to_bp_allowed,to_ep_allowed)
  --print("PRINCIPAL")
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards

  -- ACTIVE EFFECT 1
  if HasIDNotNegated(Act,10383554,UseFLeo) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasID(Act,05133471,nil,nil,LOCATION_GRAVE)
  and UseGalaxyCyclone(2)
  and (
    not FlootGateCheatCheck()
	or CardsMatchingFilter(OppST(),FlootGateFilter) > 0
  )
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,05133471,nil,nil,LOCATION_HAND+LOCATION_ONFIELD)
  and UseGalaxyCyclone(1)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,41209827,UseStarve) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,00007620,UseFKrakenSend) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,30068120,UseSabres) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,06142488,UseMouse) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,97567736,false,1561083776,UseTomahawkDamage)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,97567736,false,1561083777,UseTomahawkCopy) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,12580477) and UseRaigeki()
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(SpSum,83531441,SpSummonDante)
  and not SpSummonStarve()
  then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Act,98280324,UseSheep) then
    GlobalSheep = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,30068120,UseSabres2) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,66127916,UseFReserve) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,79109599,UseKoS) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,03841833,UseFluffalBear,1) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  -- NORMAL SUMMON NO DOG
  if HasIDNotNegated(Sum,65331686,SummonOwlNoFusion) then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Sum,10802915,SummonTGuide)
  and not HasID(AIHand(),39246582,true)
  then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Sum,00007614,SummonOcto)
  and not HasID(AIHand(),39246582,true) then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Sum,65331686,SummonOwl)
  and not HasID(AIHand(),39246582,true) then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  -- ACTIVE EFFECT TOY VENDOR & WINGS
  if HasIDNotNegated(Act,70245411,UseToyVendor,1,LOCATION_SZONE,POS_FACEUP) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,70245411,ActiveToyVendor,1,LOCATION_SZONE,POS_FACEDOWN)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,72413000,UseWings) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,70245411,ActiveToyVendor,1,LOCATION_HAND)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  -- NORMAL SUMMON 2
  if HasID(Act,43898403,UseTwinTwister) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Sum,39246582,SummonDog) then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Sum,65331686,SummonOwl) then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  -- ACTIVE EFFECT 3
  if HasIDNotNegated(Act,83531441,UseDanteFluffal) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,72413000,UseWings2) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,79109599,UseKoSDiscard) then
	return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,03841833,UseBearPoly) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  -- NORMAL SUMMON 3
  if HasIDNotNegated(Sum,10802915,SummonTGuide) then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Sum,00007614,SummonOcto) then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Sum,97567736,SummonTomahawk) then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Sum,06142488)
  and SummonMouse(2)
  then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Sum,81481818,SummonPatchwork) then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Sum,06142488)
  and SummonMouse(1)
  then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Sum,00007614,SummonOcto2) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Sum,39246582,SummonDog2) then
    return {COMMAND_SUMMON,CurrentIndex}
  end


  -- ACTIVE EFFECT SHEEP
  if HasIDNotNegated(UseLists({AIHand(),AIMon()}),98280324,true)
  and #AIMon() <= 3
  and SpSummonSheepEnd()
  and CountFluffal(AIMon()) == 0
  then
    for i=1,#Sum do
	  if not(Sum[i].id == 98280324) and FluffalFilter(Sum[i]) then
	    return {COMMAND_SUMMON,i}
	  end
    end
  end

  -- SPECIAL SUMMON 1
  if HasIDNotNegated(SpSum,98280324,SpSummonSheep) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Act,67441435,UseBulb) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(SpSum,33198837,SpSummonNaturiaBeast) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(SpSum,42110604,SpSummonChanbara) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

  -- ACTIVE EFFECT TOY VENDOR 2
  if HasIDNotNegated(Act,70245411,UseToyVendor,2,LOCATION_SZONE,POS_FACEUP) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,70245411,ActiveToyVendor,2,LOCATION_SZONE,POS_FACEDOWN)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,70245411,ActiveToyVendor,2,LOCATION_HAND)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end


  -- ACTIVE EFFECT FUSION
  if HasIDNotNegated(Act,65331686,UseOwl) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,01845204,UseIFusion) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,43698897,UseFFactory)
  and HasID(AIGrave(),06077601,true) -- FFusion
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,43698897,ActiveFFactory)
  and HasID(AIGrave(),06077601,true) -- FFusion
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,94820406,UseDFusion) then
    if SpSummonFSabreTooth() then
	  return {COMMAND_ACTIVATE,CurrentIndex}
	end
  end

  if HasIDNotNegated(Act,24094653,UsePolymerization) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,94820406,UseDFusion) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,43698897,UseFFactory) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,43698897,ActiveFFactory) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  -- ACTIVE EFFECT POST FUSION
  if HasIDNotNegated(Act,66127916,UseFReserve2) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,98954106,UseJAvarice) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  -- ACTIVE EFFECT SHEEP TOMAHAWK
  if HasIDNotNegated(Act,98280324,UseSheepTomahawk) then
    GlobalSheep = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(SpSum,98280324,SpSummonSheepTomahawk) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

  -- ACTIVE EFFECT FUSION 2
  if HasIDNotNegated(Act,06077601,UseFFusion)
  and AI.GetCurrentPhase() == PHASE_MAIN1
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  -- NORMAL SUMMON 4
  if HasIDNotNegated(Sum,67441435,SummonBulb) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Sum,61173621,SummonChain) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Sum,30068120,SummonSabres) then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  -- REPOSITION 1
  if HasIDNotNegated(Rep,00007620,RepFKraken) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end

  if HasIDNotNegated(Rep,57477163,RepFSheep) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end

  if HasIDNotNegated(Rep,83531441,RepDante) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end

  -- TURN END CHECK
  if TurnEndCheck() then
    -- ACTIVE EFFECT
    if HasIDNotNegated(SpSum,98280324,SpSummonSheep2) then
      return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
    end
	if HasIDNotNegated(Act,98280324,UseSheep2) then -- Sheep
      GlobalSheep = 1
      return {COMMAND_ACTIVATE,CurrentIndex}
    end
	if HasIDNotNegated(Act,03841833,UseBearPoly2) then
      return {COMMAND_ACTIVATE,CurrentIndex}
    end
	if HasID(SetST,42110604,SetFReserve) then
      return {COMMAND_SET_ST,CurrentIndex}
    end
	if HasID(SetST,51452091,SetRDecree) then
      return {COMMAND_SET_ST,CurrentIndex}
    end
	if HasIDNotNegated(SetMon,61173621,SetChain) then
      return {COMMAND_SET_MONSTER,CurrentIndex}
    end
	if HasIDNotNegated(SetMon,30068120,SetSabres) then
      return {COMMAND_SET_MONSTER,CurrentIndex}
    end
	if HasIDNotNegated(SetMon,72413000,SetWings) then
      return {COMMAND_SET_MONSTER,CurrentIndex}
    end
  end
end

function FluffalVsVanity(cards,to_bp_allowed,to_ep_allowed)
  --print("VANITY")
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards


  -- VANITY ACTIVE EFFECT 1
  if HasIDNotNegated(Act,12580477) and UseRaigeki()
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,05133471,nil,nil,LOCATION_GRAVE)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,05133471,nil,nil,LOCATION_HAND+LOCATION_ONFIELD)
  and UseGalaxyCyclone(1)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,43898403,UseTwinTwister) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  -- VANITY ACTIVE EFFECT TOY VENDOR & WINGS
  if HasIDNotNegated(Act,03841833,UseFluffalBear,1) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,70245411,UseToyVendor,1,LOCATION_SZONE,POS_FACEUP) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,70245411,ActiveToyVendor,1,LOCATION_SZONE,POS_FACEDOWN)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,72413000,UseWings) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,70245411,ActiveToyVendor,1,LOCATION_HAND)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  -- VANITY NORMAL SUMMON 1
  if HasIDNotNegated(Sum,39246582,SummonDog) then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(Sum,97567736,SummonTomahawk) then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Sum,00007614,SummonOcto2) then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  -- REPOSITION 1
  if HasIDNotNegated(Rep,00007620,RepFKraken) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end

  if HasIDNotNegated(Rep,57477163,RepFSheep) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end

  if HasIDNotNegated(Rep,83531441,false,nil,LOCATION_MZONE,POS_FACEDOWN) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end

  -- END TURN
  if TurnEndCheck() then
    -- ACTIVE EFFECT
	if HasID(SetST,42110604,SetFReserve) then
      return {COMMAND_SET_ST,CurrentIndex}
    end
	if HasID(SetST,51452091,SetRDecree) then
      return {COMMAND_SET_ST,CurrentIndex}
    end
	if HasIDNotNegated(SetMon,61173621,SetChain) then
      return {COMMAND_SET_MONSTER,CurrentIndex}
    end
	if HasIDNotNegated(SetMon,30068120,SetSabres) then
      return {COMMAND_SET_MONSTER,CurrentIndex}
    end
	if HasIDNotNegated(SetMon,72413000,SetWings) then
      return {COMMAND_SET_MONSTER,CurrentIndex}
    end

	if OppGetStrongestAttack() > AIGetStrongestAttack() then
	  if HasID(Rep,80889750,false,nil,LOCATION_MZONE,POS_FACEUP_ATTACK)
	  then
	    print("RepFSabre")
	    return {COMMAND_CHANGE_POS,CurrentIndex}
	  end
	end
  end

  return nil
end

function FluffalVsDarkLaw(cards,to_bp_allowed,to_ep_allowed)
  --print("DARKLAW")
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards

  if OppGetStrongestAttack() < AIGetStrongestAttack() then
	if AI.GetCurrentPhase() == PHASE_MAIN1 and to_bp_allowed then
      return {COMMAND_TO_NEXT_PHASE,1}
	end
  end

  if HasID(Act,78474168,nil,nil,LOCATION_GRAVE) -- BreakthroughSkill
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,78474168,nil,nil,LOCATION_HAND+LOCATION_ONFIELD) -- BreakthroughSkill
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,12580477) -- Raigeki
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,24094653,UsePolymerization)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,94820406,UseDFusion)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,06077601,UseFFusion)
  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  if HasIDNotNegated(Act,79109599,UseKoS) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  -- REPOSITION 1
  if HasIDNotNegated(Rep,00007620,RepFKraken) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end

  if HasIDNotNegated(Rep,57477163,RepFSheep) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end

  if HasIDNotNegated(Rep,83531441,false,nil,LOCATION_MZONE,POS_FACEDOWN) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end

  return nil
end

FluffalActivateBlacklist={
-- Blacklist of cards to never activate or chain their effects by the default AI logic
-- Anything you add here should be handled by your script, otherwise the cards will never activate

39246582, -- Fluffal Dog
03841833, -- Fluffal Bear
65331686, -- Fluffal Owl
98280324, -- Fluffal Sheep
02729285, -- Fluffal Cat
38124994, -- Fluffal Rabit
06142488, -- Fluffal Mouse
72413000, -- Fluffal Wings
81481818, -- Fluffal Patchwork (BETA)
00007614, -- Fluffal Octo (BETA)
97567736, -- Edge Imp Tomahawk
61173621, -- Edge Imp Chain
30068120, -- Edge Imp Sabres
10802915, -- Tour Guide from the Underworld
79109599, -- King of the Swamp
67441435, -- Glow-Up Bulb

06077601, -- Frightfur Fusion
43698897, -- Frightfur Factory
70245411, -- Toy Vendor
01845204, -- Instant Fusion
24094653, -- Polymerization
94820406, -- Dark Fusion
05133471, -- Galaxy Cyclone
43898403, -- Twin Twister
12580477, -- Raigeki

66127916, -- Fusion Reserve
98954106, -- Jar of Avarice
51452091, -- Royal Decree

80889750, -- Frightfur Sabre-Tooth
00007620, -- Frightfur Kraken (BETA)
10383554, -- Frightfur Leo
85545073, -- Frightfur Bear
11039171, -- Frightfur Wolf
00464362, -- Frightfur Tiger
57477163, -- Frightfur Sheep
41209827, -- Starve Venom Fusion Dragon
--33198837, -- Naturia Beast
42110604, -- Hi-Speedroid Chanbara
82633039, -- Castel
83531441, -- Dante
}
FluffalSummonBlacklist={
-- Blacklist of cards to never be normal summoned or set by the default AI logic (apparently this includes special summoning?)
39246582, -- Fluffal Dog
03841833, -- Fluffal Bear
65331686, -- Fluffal Owl
98280324, -- Fluffal Sheep
02729285, -- Fluffal Cat
38124994, -- Fluffal Rabit
06142488, -- Fluffal Mouse
72413000, -- Fluffal Wings
81481818, -- Fluffal Patchwork (BETA)
00007614, -- Fluffal Octo (BETA)
97567736, -- Edge Imp Tomahawk
61173621, -- Edge Imp Chain
30068120, -- Edge Imp Sabres
79109599, -- King of the Swamp
10802915, -- Tour Guide from the Underworld
67441435, -- Glow-Up Bulb

80889750, -- Frightfur Sabre-Tooth
00007620, -- Frightfur Kraken (BETA)
10383554, -- Frightfur Leo
85545073, -- Frightfur Bear
11039171, -- Frightfur Wolf
00464362, -- Frightfur Tiger
57477163, -- Frightfur Sheep
41209827, -- Starve Venom Fusion Dragon
33198837, -- Naturia Beast
42110604, -- Hi-Speedroid Chanbara
82633039, -- Castel
83531441, -- Dante
}
FluffalSetBlacklist={
-- Blacklist for cards to never set to the S/T Zone to chain or as a bluff
06077601, -- Frightfur Fusion
43698897, -- Frightfur Factory
70245411, -- Toy Vendor
01845204, -- Instant Fusion
24094653, -- Polymerization
94820406, -- Dark Fusion
05133471, -- Galaxy Cyclone

51452091, -- Royal Decree
}
FluffalRepoBlacklist={
-- Blacklist for cards to never be repositioned
98280324, -- Fluffal Sheep
02729285, -- Fluffal Cat
38124994, -- Fluffal Rabit
06142488, -- Fluffal Mouse
72413000, -- Fluffal Wings
81481818, -- Fluffal Patchwork (BETA)
79109599, -- King of the Swamp
67441435, -- Glow-Up Bulb
}
FluffalUnchainable={
-- Blacklist for cards to not chain multiple copies in the same chain
66127916, -- Fusion Reserve
98954106, -- Jar of Avarice
}

-- FluffalM
-- EdgeImp
-- Other
-- FluffalS
-- Spell
-- Trap
-- Frightfur
-- Other Fusion
-- Other XYZ

------------------------
------- FUNCTIONS ------
------------------------

function PrioFluffalMaterial(c,mode)
  local result = 0
  if mode == nil then mode = 1 end
  if mode == 1
  then
    if FilterLocation(c,LOCATION_MZONE)
    and #AIMon() == 5
    then
	  result = 4
	elseif FilterLocation(c,LOCATION_MZONE)
    and #AIMon() == 2
    then
	  result = 2
    elseif FilterLocation(c,LOCATION_MZONE)
	then
      result = 1
    elseif Get_Card_Count_ID(AIHand(),c.id) > 1
	then
      result = 1
    else -- HAND
      result = 0
    end
	if Negated(c) then
	  result = result + 1
    end
  else
    if FilterLocation(c,LOCATION_MZONE)
    and #AIMon() == 5
    then
	  result = 4
	elseif FilterLocation(c,LOCATION_MZONE)
	and #AIMon() == 4
	then
	  result = 2
    elseif FilterLocation(c,LOCATION_MZONE) then
      result = 0
    else -- GRAVE
      result = 3
    end
  end
  return result
end

function PrioFrightfurMaterial(c,mode)
  local result = 0
  if mode == nil then mode = 1 end
  if mode == 1
  then
    if Negated(c) then
	  result = 10
	end
  else
    result = 0
  end
  return result
end

function FluffalPrioMode(mode)
  local minPrio = 3 -- PrioDiscard

  if mode == nil then mode = 1 end

  if AI.GetPlayerLP(1) <= 4500
  or OppGetStrongestAttack() >= AI.GetPlayerLP(1)
  then
    minPrio = 2
  end

  if AI.GetPlayerLP(1) <= 2000
  or OppGetStrongestAttack() >= AI.GetPlayerLP(1)
  or ExpectedDamage(1) >= AI.GetPlayerLP(1)
  then
    minPrio = 1
  end

  if #AIMon() <= 1 then
    minPrio = minPrio - 1
  end

  if mode == 1 and minPrio < 1 then
    minPrio = 1
  end

  return minPrio
end

------------------------
-------- FILTER --------
------------------------

------------------------
--------- COND ---------
------------------------

------------------------
--------- USE ----------
------------------------

------------------------
------- SUMMON ---------
------------------------

-----------------------
------- TARGET --------
-----------------------

------------------------
-------- CHAIN ---------
------------------------

------------------------
-------- BATTLE --------
------------------------