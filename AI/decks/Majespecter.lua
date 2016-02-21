function SpecterStartup(deck)
  -- function called at the start of the duel, if the AI was detected playing your deck.
  --AI.Chat("Startup functions loaded.")
  AI.Chat("This is the AI_Majespecter version 1.2 by Xaddgx.")
  AI.Chat("Good luck! Maybe I will treat you to some glorious puns this game.")
  -- Your links to the important AI functions. If you don't specify a function,
  -- or your function returns nil, the default logic will be used as a fallback.
  deck.Init                 = SpecterInit
  deck.Card                 = SpecterCard
  deck.Chain                = SpecterChain
  deck.EffectYesNo          = SpecterEffectYesNo
  deck.Position             = SpecterPosition
  --deck.BattleCommand        = SpecterBattleCommand
  --deck.AttackTarget         = SpecterAttackTarget

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

  -- Blacklists to disallow default logic or other decks to handle specific cards
  -- Only used, if your deck was detected

  deck.ActivateBlacklist    = SpecterActivateBlacklist
  deck.SummonBlacklist      = SpecterSummonBlacklist
  deck.SetBlacklist         = SpecterSetBlacklist
  deck.RepositionBlacklist  = SpecterRepoBlacklist
  deck.Unchainable          = SpecterUnchainable

  -- Priority list for your deck. May override priorities used by the default logic,
  -- but this will only apply, if your deck was detected.

  deck.PriorityList         = SpecterPriorityList
end

-- Your deck. The startup function must be on top of this line.
-- 3 required parameters.
-- First one: Your deck's name, as a string. Will be displayed in debug mode.
-- 2nd: The deck identifier. Can be a card ID (as a number) or a list of IDs.
--   Use a card or a combination of cards, that identifies your deck from others.
-- 3rd: The Startup function. Must be defined here, so it can be called at the start of the duel.
--  Technically not required, but doesn't make a lot of sense to leave it out, it would prevent
--  you from setting up all your functions and blacklists.

DECK_SPECTER = NewDeck("Majespecter",{76473843,53208660},SpecterStartup) -- Majesty's Pegasus, Pendulum Call Xaddgx
-- BlueEyes White Dragon and BlueEyes Maiden. BEWD is used in the Exodia deck as well,
-- so we use a 2nd card to identify the deck 100%. Could just use Maiden as well.

SpecterActivateBlacklist={
-- Blacklist of cards to never activate or chain their effects by the default AI logic
-- Anything you add here should be handled by your script, otherwise the cards will never activate
51531505, -- Dragonpit Scale 8
15146890, -- Dragonpulse Scale 1
14920218, -- Peasant Scale 2
13972452, -- Specter Storm
53208660, -- Pendulum Call
96598015, -- Pot of Riches
43898403, -- Twin Twister
49366157, -- Specter Cyclone
76473843, -- Majesty's Pegasus
36183881, -- Specter Tornado
78949372, -- Specter Supercell
02572890, -- Specter Tempest
05650082, -- Storming Mirror Force
18326736, -- Ptolemaeus
62709239, -- Phantom Knights XYZ
85252081, -- Granpulse XYZ
94784213, -- Specter Fox
00645794, -- Specter Toad
68395509, -- Specter Crow
31991800, -- Specter Raccoon
05506791, -- Specter Cat
82633039, -- Castel
52558805, -- Temtempo Djinn
72714461, -- Insight Magician
31437713, -- Heartlandraco
21044178, -- Abyss Dweller
15914410, -- Angineer
93568288, -- Rhapsody
}
SpecterSummonBlacklist={
-- Blacklist of cards to never be normal summoned or set by the default AI logic (apparently this includes special summoning?)
94784213, -- Specter Fox
00645794, -- Specter Toad
68395509, -- Specter Crow
31991800, -- Specter Raccoon
05506791, -- Specter Cat
51531505, -- Dragonpit Scale 8
15146890, -- Dragonpulse Scale 1
14920218, -- Peasant Scale 2
18326736, -- Ptolemaeus
62709239, -- Phantom Knights XYZ
85252081, -- Granpulse
52558805, -- Temtempo Djinn
34945480, -- Azathoth
09272381, -- Constellar Diamond
88722973, -- Majester Paladin
71068247, -- Totem Bird
15914410, -- Mechquipped Angineer
72714461, -- Insight Magician
21044178, -- Abyss Dweller
22653490, -- Lightning Chidori
82633039, -- Castel
84013237, -- Utopia
56832966, -- Utopia Lightning
31437713, -- Heartlandraco
93568288, -- Rhapsody
}
SpecterSetBlacklist={
-- Blacklist for cards to never set to the S/T Zone to chain or as a bluff
12580477, -- Raigeki
13972452, -- Storm
96598015, -- Pot of Riches
76473843, -- Majesty's Pegasus
}
SpecterRepoBlacklist={
-- Blacklist for cards to never be repositioned
51531505, -- Dragonpit Scale 8
05506791, -- Specter Cat
19665973, -- Battle Fader
}
SpecterUnchainable={
-- Blacklist for cards to not chain multiple copies in the same chain
--59616123, -- trapstun
-- don't chain Maiden to herself. Sounds pointless because she is once per turn,
-- but this will also prevent chaining from other unchainable cards, like chaining
-- DPrison on something attacking Maiden, even though she would negate the attack anyways
43898403, -- Twin Twister
49366157, -- Specter Cyclone
05650082, -- Storming Mirror Force
36183881, -- Specter Tornado
78949372, -- Specter Supercell
02572890, -- Specter Tempest
18326736, -- Ptolemaeus2
52558805, -- Temtempo Djinn
}
 
 function RaccoonCond(loc)
  if loc == PRIO_TOHAND then
    return Duel.GetCurrentPhase() == PHASE_END
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(31991800) and not (HasScales() and HasID(AIExtra(),31991800,true))
	and (not HasID(AIHand(),31991800,true) or (HasID(AIHand(),31991800,true) and not NormalSummonCheck(player_ai)))
  end
  if loc == PRIO_BANISH then
    return CardsMatchingFilter(AIMon(),LevelFourFieldCheck)>0 or not HasID(AIExtra(),31991800,true)
  end
 return true
end

function FoxCond(loc)
  if loc == PRIO_TOHAND then
    return (CardsMatchingFilter(UseLists({AIST(),AIHand()}),SpecterBackrowFilter)<2 and not Duel.GetCurrentPhase()==PHASE_END
	and CardsMatchingFilter(AIDeck(),SpecterTrapFilter)>0
	and not HasID(UseLists({AIExtra(),AIHand()}),94784213,true))
	or (HasScales() and CardsMatchingFilter(UseLists({AIExtra(),AIMon(),AIHand()}),function(c) return c.id==94784213 end)==0)
  end
  if loc == PRIO_TOFIELD then
    return CardsMatchingFilter(UseLists({AIST(),AIHand()}),SpecterBackrowFilter)<2 and OPTCheck(94784213)
	and (not HasID(AIHand(),94784213,true) or (HasID(AIHand(),94784213,true) and not NormalSummonCheck(player_ai)))
	and not (HasScales() and HasID(AIExtra(),94784213,true))
  end
  if loc == PRIO_BANISH then
    return CardsMatchingFilter(AIMon(),LevelFourFieldCheck)==2 or not HasID(AIExtra(),94784213,true)
  end
 return true
end

function CatCond(loc)
  if loc == PRIO_TOHAND then
    return CardsMatchingFilter(UseLists({AIST(),AIHand()}),SpecterBackrowFilter)>=2 and not Duel.GetCurrentPhase()==PHASE_END
	and not HasID(UseLists({AIExtra(),AIHand(),AIMon()}),05506791,true)
  end
  if loc == PRIO_TOFIELD then
    return CardsMatchingFilter(UseLists({AIST(),AIHand()}),SpecterBackrowFilter)>=2 and OPTCheck(05506791)
	and not (HasScales() and Duel.GetTurnCount() ~= SpecterGlobalPendulum and HasID(AIExtra(),05506791,true))
  end
  if loc == PRIO_BANISH then
    return CardsMatchingFilter(AIMon(),LevelFourFieldCheck)==1 or not HasID(AIExtra(),05506791,true)
  end
 return true
end

function CrowCond(loc) --Code a to field/hand if Majespecter Cyclone would be useful for removing an opponent's monster.
  if loc == PRIO_TOHAND then
    return OPTCheck(68395509)
	and CardsMatchingFilter(AIDeck(),SpecterSpellFilter)>0
	and CardsMatchingFilter(UseLists({AIST(),AIHand()}),SpecterBackrowFilter)<2
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(68395509)
	and (not HasID(AIHand(),68395509,true)
	and NormalSummonCheck(player_ai))
  end
  if loc == PRIO_BANISH then
    return NeedsSStormOverSCyclone()
	and Duel.GetTurnPlayer()==player_ai
	and HasScales()
	and Duel.GetTurnCount() ~= SpecterGlobalPendulum
	and DualityCheck()
	and (not HasID(AIMon(),31991800,true) or HasID(AIExtra(),31991800,true))
	and not HasID(AIExtra(),68395509,true)
	and not UsableSTornado()
  end
 return true
end

function ToadCond(loc)
  if loc == PRIO_TOHAND then
    return OPTCheck(00645794)
  end
  if loc == PRIO_TOFIELD then
    return OPTCheck(00645794)
	and (not HasID(AIHand(),00645794,true)
	or (HasID(AIHand(),00645794,true) and not NormalSummonCheck(player_ai)))
  end
 return true
end

function STempestCond(loc)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists({AIST(),AIHand()}),02572890,true)
	and not NeedsRaccoonEnd()
  end
  if loc == PRIO_TOFIELD then
    return not HasID(UseLists({AIST(),AIHand()}),02572890,true)
	and not NeedsRaccoonEnd()
  end
 return true
end
  

function STornadoCond(loc)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists({AIST(),AIHand()}),36183881,true)
	and not NeedsRaccoonEnd()
  end
  if loc == PRIO_TOFIELD then
    return not HasID(UseLists({AIST(),AIHand()}),36183881,true)
	and not NeedsRaccoonEnd()
  end
 return true
end

function SCycloneCond(loc)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists({AIST(),AIHand()}),49366157,true)
	and not NeedsRaccoonEnd()
  end
  if loc == PRIO_TOFIELD then
    return not HasID(UseLists({AIST(),AIHand()}),49366157,true)
	and not NeedsRaccoonEnd()
  end
 return true
end

function SStormCond(loc)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists({AIST(),AIHand()}),13972452,true)
	and not NeedsRaccoonEnd()
  end
  if loc == PRIO_TOFIELD then
    return not HasID(UseLists({AIST(),AIHand()}),13972452,true)
	and not NeedsRaccoonEnd()
  end
 return true
end

function SCellCond(loc)
  if loc == PRIO_TOHAND then
    return (CardsMatchingFilter(AIGrave(),SpecterCardFilter)>=4 or CardsMatchingFilter(UseLists({AIST(),AIHand()}),SpecterBackrowFilter)>=2)
	and not NeedsRaccoonEnd()
  end
  if loc == PRIO_TOFIELD then
    return (CardsMatchingFilter(AIGrave(),SpecterCardFilter)>=4 or CardsMatchingFilter(UseLists({AIST(),AIHand()}),SpecterBackrowFilter)>=2)
	and not NeedsRaccoonEnd()
  end
 return true
end

function DragonpitCond(loc)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists({AIST(),AIHand()}),51531505,true)
	and not HasScales()
	and not NeedsRaccoonEnd()
  end
 return true
end

function DragonpulseCond(loc)
  if loc == PRIO_TOHAND then
    return (not HasID(UseLists({AIST(),AIHand()}),15146890,true)
	or HasScales())
	and not NeedsRaccoonEnd()
  end
 return true
end

function InsightCond(loc)
  if loc == PRIO_TOHAND then
    return ((NeedsScale5() and not HasID(AIDeck(),51531505,true))
	or HasScales())
	and not NeedsRaccoonEnd()
  end
 return true
end

function SpecterPeasantCond(loc)
  if loc == PRIO_TOHAND then
    return (not HasID(UseLists({AIST(),AIHand()}),14920218,true)
	or HasScales()
	or (MajestyCheck()
	and HasID(AIST(),51531505,true)
	and HasScales()))
	and not NeedsRaccoonEnd()
  end
 return true
end
  
function SpecterMonsterFilter(c)
  return (IsSetCode(c.setcode,0xd0) or c.id==14920218) and bit32.band(c.type,TYPE_MONSTER)>0
end

function TrueSpecterMonsterFilter(c)
  return IsSetCode(c.setcode,0xd0) and FilterType(c,TYPE_MONSTER)
end

function SpecterCardFilter(c)
  return IsSetCode(c.setcode,0xd0)
end

function SpecterBackrowFilter(c)
  return c.id==49366157
  or c.id==36183881
  or c.id==02572890
end

function SpecterPendulumFilter(c)
  return IsSetCode(c.setcode,0xd0) and bit32.band(c.type,TYPE_PENDULUM)>0
end

function SpecterSpellFilter(c)
  return IsSetCode(c.setcode,0xd0) and bit32.band(c.type,TYPE_SPELL)>0
end

function SpecterTrapFilter(c)
  return IsSetCode(c.setcode,0xd0) and bit32.band(c.type,TYPE_SPELL)>0
end

function AllPendulumFilter(c)
  return bit32.band(c.type,TYPE_PENDULUM)>0
end

function LevelThreeFieldCheck(c)
  return c.id==05506791 --Cat
  or c.id==31991800 --Raccoon
end

function LevelFourFieldCheck(c) --Script error on below line for some reason
  return c.id==00645794 --Toad
  or c.id==68395509 --Crow
  or c.id==94784213 --Fox
  or c.id==15146890 --Dragonpulse Scale 1
end

function AllMonsterFilter(c)
  return FilterType(c,TYPE_MONSTER)
end

function ScaleHighExcludeRaccoonFilter(c)
  return c.id==51531505
  or c.id==00645794
  or c.id==68395509
  or c.id==72714461
end

function ScaleHighFilter(c)
  return c.id==51531505 --Dragonpit Scale 8
  or c.id==00645794 --Toad
  or c.id==68395509 --Crow
  or c.id==31991800 --Raccoon
  or c.id==72714461 --Insight
end

function ScaleLowFilter(c)
  return c.id==15146890 --Dragonpulse Scale 1
  or c.id==14920218 --Peasant Scale 2
  or c.id==94784213 --Fox
  or c.id==05506791 --Cat
end
  
function SummonRaccoon1()
  return OPTCheck(31991800)
end

function SummonRaccoon2()
  return CardsMatchingFilter(AIMon(),LevelThreeFieldCheck)==1 or CardsMatchingFilter(AIMon(),LevelThreeFieldCheck)==3
end

function SummonRaccoon3() --Summon normally before Pendulum Summoning, in case Solemn Warning is around.
  return HasScales()
  and SummonRaccoon1()
  and OppDownBackrow()
end

function SummonRaccoon4() --Summon normally if you can get another scale 5.
  return SummonRaccoon1()
  and NeedsScale5Raccoon()
end

function RaccoonHandCheck()
  return HasID(AIHand(),31991800,true)
  and HasScales()
  and OppDownBackrow()
  and not NormalSummonCheck(player_ai)
  and #AIMon()<5
end

function SummonFox1()
  return OPTCheck(94784213)
end

function SummonFox2()
  return CardsMatchingFilter(AIMon(),LevelFourFieldCheck)==1 or CardsMatchingFilter(AIMon(),LevelFourFieldCheck)==3
end

function SummonFox3() --Summon normally before Pendulum Summoning, in case Solemn Warning is around.
  return HasScales()
  and SummonFox1()
  and OppDownBackrow()
end

function SummonCat1()
  return OPTCheck(05506791)
end

function SummonCat2()
  return CardsMatchingFilter(AIMon(),LevelThreeFieldCheck)==1 or CardsMatchingFilter(AIMon(),LevelThreeFieldCheck)==3
end

function SummonCat3() --Summon normally before Pendulum Summoning, in case Solemn Warning is around.
  return HasScales()
  and SummonCat1()
  and OppDownBackrow()
  and NeedsRaccoon()
end

function SummonCrow1()
  return OPTCheck(68395509)
end

function SummonCrow2()
  return CardsMatchingFilter(AIMon(),LevelFourFieldCheck)==1 or CardsMatchingFilter(AIMon(),LevelFourFieldCheck)==3
end

function SummonCrow3() --Summon normally before Pendulum Summoning, in case Solemn Warning is around.
  return HasScales()
  and SummonCrow1()
  and OppDownBackrow()
end

function SummonToad1()
  return OPTCheck(00645794)
end

function SummonToad2()
  return CardsMatchingFilter(AIMon(),LevelFourFieldCheck)==1 or CardsMatchingFilter(AIMon(),LevelFourFieldCheck)==3
end

function SummonToad3() --Summon normally before Pendulum Summoning, in case Solemn Warning is around.
  return HasScales()
  and SummonToad1()
  and OppDownBackrow()
end

function SpecterPendulumSummon(count)
  if count == nil then count = 1 end
  return CardsMatchingFilter(UseLists({AIExtra(),AIHand()}),AllMonsterFilter)>=count
  and DualityCheck() and SpecterPendulumSummonCheck()
end

function SpecterPendulumSummonCheck()
  return SpecterGlobalPendulum~=Duel.GetTurnCount()
end

function PlayMajesty()
  return CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>0
  and not HasID(AIST(),76473843,true)
end

function UseMajesty()
  return true
end

function DiscardTargetFilter(c)
  return c.id==51531505 --Dragonpit 8
  or c.id==15146890 --Dragonpulse 1
  or c.id==14920218 --Peasant 2
  or c.id==13972452 --SStorm
  or c.id==19665973 --Fader
  or c.id==02572890 --STempest
  or c.id==36183881 --STornado
  or c.id==49366157 --SCyclone
end

function MajestyDiscardAvailable() --Getting lazy with the last line...
  return (HasID(AIHand(),76473843,true) and HasID(AIST(),76473843,true))
  or CardsMatchingFilter(AIHand(),function(c) return c.id==76473843 end)>1
  or (CardsMatchingFilter(AIExtra(),AllMonsterFilter)>0 and #AIMon()==0 and #AIHand()<3 and HasID(AIHand(),76473843,true))
end

function PendulumCallDiscardAvailable()
  return CardsMatchingFilter(AIHand(),function(c) return c.id==53208660 end)>1
end

function DiscardTargetAvailable()
  return CardsMatchingFilter(AIHand(),DiscardTargetFilter)>0
  or MajestyDiscardAvailable()
  or PendulumCallDiscardAvailable()
end

function UsePendulumCallSpecter()
  return DiscardTargetAvailable()
  and OPTCheck(53208660)
  and (NoScalesInsight() and CardsMatchingFilter(UseLists({AIHand(),AIST()}),function(c) return c.id==72714461 end)<2)
end

function NoScalesInsight()
  return CardsMatchingFilter(AIST(),FilterType,TYPE_PENDULUM)<2
end

function NoScales()
  return NeedsScale5()
  or NeedsScale2()
end

function UsePendulumCallScaleReplaceSpecter()
  return OPTCheck(53208660)
  and NoScales()
  and SpecterExtraCount()
end

function SpecterExtraCount()
  return CardsMatchingFilter(AIExtra(),SpecterMonsterFilter)>1
end

function PlayDragonpit() --Scale 8
  return (CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleLowFilter)>0
  and CardsMatchingFilter(AIST(),ScaleHighFilter)==0)
  or HasID(AIST(),72714461,true) --Insight
end

function PlayToad() --Scale5
  return CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleLowFilter)>0
  and CardsMatchingFilter(AIST(),ScaleHighFilter)==0
  and not HasID(AIHand(),51531505,true) --Dragonpit 8
end

function PlayCrow() --Scale5
  return CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleLowFilter)>0
  and CardsMatchingFilter(AIST(),ScaleHighFilter)==0
  and not HasID(AIHand(),51531505,true) --Dragonpit 8
  and not HasID(AIHand(),00645794,true) --Specter Toad
end

function PlayRaccoon() --Scale5
  return CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleLowFilter)>0
  and CardsMatchingFilter(AIST(),ScaleHighFilter)==0
  and not HasID(AIHand(),51531505,true) --Dragonpit 8
  and not HasID(AIHand(),00645794,true) --Specter Toad
  and not HasID(AIHand(),68395509,true) --Specter Crow
end

function PlayDragonpulse() --Scale 1
  return (CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleHighFilter)>0
  and CardsMatchingFilter(AIST(),ScaleLowFilter)==0)
  or HasID(AIST(),72714461,true)
end

function PlayPeasant()
  return (CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleHighFilter)>0
  and CardsMatchingFilter(AIST(),ScaleLowFilter)==0)
  or HasID(AIST(),72714461,true)
end

function PlayCat() --Scale 2
  return CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleHighFilter)>0
  and CardsMatchingFilter(AIST(),ScaleLowFilter)==0
  and not HasID(AIHand(),15146890,true) --Dragonpulse 1
  and not HasID(AIHand(),14920218,true) --Peasant 2
end

function PlayFox() --Scale2
  return CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleHighFilter)>0
  and CardsMatchingFilter(AIST(),ScaleLowFilter)==0
  and not HasID(AIHand(),15146890,true) --Dragonpulse 1
  and not HasID(AIHand(),14920218,true) --Peasant 2
  and not HasID(AIHand(),05506791,true) --Specter Cat
end

function NeedsScale5Raccoon()
  return CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleLowFilter)>0
  and CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleHighExcludeRaccoonFilter)==0
end

function NeedsScale5()
  return CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleLowFilter)>0
  and CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleHighFilter)==0
end

function NeedsScale2()
  return CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleHighFilter)>0
  and CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleLowFilter)==0
end

function HasScales()
  return CardsMatchingFilter(AIST(),ScaleHighFilter)==1
  and CardsMatchingFilter(AIST(),ScaleLowFilter)==1
end

function NeedsRaccoon()
  return CardsMatchingFilter(UseLists({AIMon(),AIHand(),AIExtra()}),function(c) return c.id==31991800 end)==0
end

function NeedsFox()
  return CardsMatchingFilter(UseLists({AIMon(),AIHand(),AIExtra()}),function(c) return c.id==94784213 end)==0
end

function SpecterPtolemaeusSummon()
  return XYZSummonOkay() and SpecterMP2Check()
  and HasID(AIExtra(),18326736,true)
end

function SpecterPtolemaeusFilter1(c)
  return c.id==18326736 and c.xyz_material_count==2
end

function SpecterPtolemaeusFilter2(c)
  return c.id==18326736 and c.xyz_material_count>2
end

function EndPhasePtolemaeus()
  return CardsMatchingFilter(AIMon(),SpecterPtolemaeusFilter1)>0
  and Duel.GetCurrentPhase()==PHASE_END
end

function PtolemaeusAzathoth()
  return CardsMatchingFilter(AIMon(),SpecterPtolemaeusFilter2)>0
  and Duel.GetCurrentPhase()==PHASE_DRAW
  and Duel.GetTurnPlayer()==1-player_ai
end

function WorthPendulumActivation()
  return CardsMatchingFilter(AIExtra(),SpecterMonsterFilter)>0
  or CardsMatchingFilter(UseLists({AIHand(),AIST()}),FilterType,TYPE_PENDULUM)>2
end

function WorthPendulumSummoning()
  return CardsMatchingFilter(AIExtra(),AllPendulumFilter)>0
  or CardsMatchingFilter(AIHand(),AllMonsterFilter)>1
  or (CardsMatchingFilter(AIHand(),AllMonsterFilter)==1 and NormalSummonCheck(player_ai))
  or (HasScales() and HasID(AIHand(),51531505,true))
  or (CardsMatchingFilter(AIHand(),AllMonsterFilter)==1 and (HasID(AIHand(),05506791,true) or HasID(AIHand(),14920218,true)))
end

function DragonpitScaleAndHand()
  return HasID(AIHand(),51531505,true)
  and HasID(AIST(),51531505,true)
end

function SpecterMP2Check()
  return AI.GetCurrentPhase() == PHASE_MAIN2 or not GlobalBPAllowed
end

function SetSTempest()
  return Duel.GetTurnCount() == 1 or (Duel.GetCurrentPhase()==PHASE_MAIN2 or (Duel.GetCurrentPhase()==PHASE_MAIN1 and not GlobalBPAllowed))
end

function SetSTornado()
  return Duel.GetTurnCount() == 1 or (Duel.GetCurrentPhase()==PHASE_MAIN2 or (Duel.GetCurrentPhase()==PHASE_MAIN1 and not GlobalBPAllowed))
end

function SetSCell()
  return Duel.GetTurnCount() == 1 or (Duel.GetCurrentPhase()==PHASE_MAIN2 or (Duel.GetCurrentPhase()==PHASE_MAIN1 and not GlobalBPAllowed))
end

function SetSCyclone()
  return Duel.GetTurnCount() == 1 or (Duel.GetCurrentPhase()==PHASE_MAIN2 or (Duel.GetCurrentPhase()==PHASE_MAIN1 and not GlobalBPAllowed))
end

function SetSStorm()
  return Duel.GetTurnCount() == 1 or (Duel.GetCurrentPhase()==PHASE_MAIN2 or (Duel.GetCurrentPhase()==PHASE_MAIN1 and not GlobalBPAllowed))
end

function SetTwinTwister()
  return Duel.GetTurnCount() == 1 or (Duel.GetCurrentPhase()==PHASE_MAIN2 or (Duel.GetCurrentPhase()==PHASE_MAIN1 and not GlobalBPAllowed))
end

function SetVanity()
  return Duel.GetTurnCount() == 1 or (Duel.GetCurrentPhase()==PHASE_MAIN2 or (Duel.GetCurrentPhase()==PHASE_MAIN1 and not GlobalBPAllowed))
end

function SetStormingMirror()
  return Duel.GetTurnCount() == 1 or (Duel.GetCurrentPhase()==PHASE_MAIN2 or (Duel.GetCurrentPhase()==PHASE_MAIN1 and not GlobalBPAllowed))
end

function SetPendulumCall()
  return (Duel.GetCurrentPhase()==PHASE_MAIN2 or (Duel.GetCurrentPhase()==PHASE_MAIN1 and not GlobalBPAllowed))
  and not (HasID(AIDeck(),51531505,true) or (HasID(AIDeck(),15146890,true) or HasID(AIDeck(),14920218,true))) --Magicians
  and not HasID(UseLists({AIST(),AIHand()}),43898403,true) --Twin Twister
end

function UseSCell()
  return CardsMatchingFilter(AIGrave(),SpecterCardFilter)>=5
  or CardsMatchingFilter(AIST(),SpecterPendulumFilter)>0
end

function MagicianPendulumFilter(c)
  return c.id==51531505 --Dragonpit Scale 8
  or c.id==15146890 --Dragonpulse Scale 1
  or c.id==72714461 --Insight
  or c.id==14920218 --Peasant
end

function ScaleHighSpecterFilter(c)
  return c.id==68395509
  or c.id==00645794
  or c.id==31991800
end

function PlayInsight1()
  return OPTCheck(53208660)
  and CardsMatchingFilter(UseLists({AIST(),AIHand()}),MagicianPendulumFilter)>1
  and CardsMatchingFilter(AIST(),ScaleHighSpecterFilter)==0
end

function PlayInsight2()
  return CardsMatchingFilter(UseLists({AIST(),AIHand()}),ScaleLowFilter)>0
  and CardsMatchingFilter(AIST(),ScaleHighFilter)==0
end

function PlayInsight3()
  return CardsMatchingFilter(UseLists({AIST(),AIHand()}),function(c) return c.id==72714461 end)>1
  and OPTCheck(53208660)
  and CardsMatchingFilter(AIST(),ScaleHighSpecterFilter)==0
end

function UseInsight()
  return OPTCheck(53208660)
end

function DragonpitFilter(c)
  return c.id==51531505
end

function DragonpulseFilter(c)
  return c.id==15146890
end

function MakeRoom()
  return (#AIMon()==5 
  and (CardsMatchingFilter(AIHand(),SpecterMonsterFilter)>0
  or CardsMatchingFilter(AIHand(),LevelFourMagicianFilter)>0)
  and not NormalSummonCheck(player_ai))
  or (#AIMon()==5 and HasScales() and Duel.GetTurnCount() ~= SpecterGlobalPendulum and CardsMatchingFilter(UseLists({AIHand(),AIExtra()}),TrueSpecterMonsterFilter)>0)
  or (#AIMon()==4 and HasScales() and Duel.GetTurnCount() ~= SpecterGlobalPendulum and CardsMatchingFilter(UseLists({AIHand(),AIExtra()}),TrueSpecterMonsterFilter)>1)
  or (#AIMon()==3 and HasScales() and Duel.GetTurnCount() ~= SpecterGlobalPendulum and CardsMatchingFilter(UseLists({AIHand(),AIExtra()}),TrueSpecterMonsterFilter)>2)
  or (#AIMon()==2 and HasScales() and Duel.GetTurnCount() ~= SpecterGlobalPendulum and CardsMatchingFilter(UseLists({AIHand(),AIExtra()}),TrueSpecterMonsterFilter)>3)
  or (#AIMon()==1 and HasScales() and Duel.GetTurnCount() ~= SpecterGlobalPendulum and CardsMatchingFilter(UseLists({AIHand(),AIExtra()}),TrueSpecterMonsterFilter)>4)
end

function TotemBirdFilter(c)
  return FilterPosition(c,POS_FACEDOWN)
end

function SummonTotemBird()
  return (CardsMatchingFilter(OppST(),TotemBirdFilter)>0
  and (AIGetStrongestAttack() > OppGetStrongestAttack() or OppGetStrongestAttack()<1900)
  and ((AI.GetCurrentPhase() == PHASE_MAIN1 and GlobalBPAllowed) or Duel.GetTurnCount() == 1))
  and XYZSummonOkayWind()
  and HasID(AIExtra(),71068247,true)
end

function SummonTotemBirdRoom()
  return MakeRoom()
  and HasID(AIExtra(),71068247,true)
  and (CardsMatchingFilter(OppST(),TotemBirdFilter)>0
  and (AIGetStrongestAttack() > OppGetStrongestAttack() or OppGetStrongestAttack()<1900)
  and ((AI.GetCurrentPhase() == PHASE_MAIN1 and GlobalBPAllowed) or Duel.GetTurnCount() == 1))
end

function GranpulseFilter(c)
  return bit32.band(c.type,TYPE_PENDULUM)>0
  and SpecterDestroyFilter(c)
end

function OppHasScales()
  return CardsMatchingFilter(OppST(),FilterType,TYPE_PENDULUM)>1
end

function SummonGranpulse()
  return (CardsMatchingFilter(OppST(),GranpulseFilter)>0 and AI.GetCurrentPhase() == PHASE_MAIN2 and OppHasScales())
  and (XYZSummonOkay() or MakeRoom())
  and HasID(AIExtra(),85252081,true)
  and not SpecterSummonMechquipped()
end

function SummonGranpulse2()
  return ((CardsMatchingFilter(OppST(),GranpulseFilter)>0 and OppHasScales()
  and (AI.GetCurrentPhase() == PHASE_MAIN2 or not GlobalBPAllowed)
  and #OppHand()<2)
  or (CardsMatchingFilter(OppST(),OppDownBackrowFilter)>0 and Duel.GetTurnCount() ~= SpecterGlobalPendulum and HasScales()
  and CardsMatchingFilter(UseLists({AIHand(),AIExtra()}),SpecterMonsterFilter)>0))
  and HasID(AIExtra(),85252081,true)
end

function SummonGranpulse3()
  return (XYZSummonOkay() or MakeRoom())
  and SpecterMP2Check()
  and OppGetStrongestAttack() > AIGetStrongestAttack()
  and CardsMatchingFilter(OppMon(),GranpulseEnemyFilter)>0
  and CardsMatchingFilter(AIMon(),LevelFourFieldCheck)<2
end
  
function GranpulseEnemyFilter(c)
  return c.attack>=2000
  and c.attack<=2800
  and FilterPosition(c,POS_FACEUP_ATTACK)
end

function UseGranpulse()
  return CardsMatchingFilter(OppST(),OppBackrowFilter)>0
end

function OppBackrowFilter(c)
  return FilterLocation(c,LOCATION_SZONE)
  and SpecterDestroyFilter(c)
end

function OppHasBackrow()
  return #OppST()>0
end

function OppDownBackrowFilter(c)
  return FilterPosition(c,POS_FACEDOWN)
  and SpecterDestroyFilter(c)
  and not (DestroyBlacklist(c)
  and (bit32.band(c.position, POS_FACEUP)>0 
  or bit32.band(c.status,STATUS_IS_PUBLIC)>0))
end

function OppDownBackrow()
  return CardsMatchingFilter(OppST(),OppDownBackrowFilter)>0
end

function NeedsRaccoonEnd()
  return NeedsRaccoon()
  and AI.GetCurrentPhase() == PHASE_END
end

function SummonDragonpulse()
  return true
end

function SummonInsight()
  return ((AIGetStrongestAttack() > OppGetStrongestAttack() 
  or OppGetStrongestAttack()<1500)
  and Duel.GetTurnCount() ~= 1)
  or CardsMatchingFilter(AIMon(),LevelFourFieldCheck)>0
end

function SetInsight()
  return SpecterMP2Check()
  or Duel.GetTurnCount() == 1
end

function StormingMirrorFilter1(c)
  return not FilterStatus(c,STATUS_LEAVE_CONFIRMED)
  and not FilterAffected(c,EFFECT_IMMUNE_EFFECT)
  and Affected(c,TYPE_TRAP)
  and c.attack>=1000 and c.attack<2000 and bit32.band(c.position,POS_FACEUP_ATTACK)
  and c:is_affected_by(EFFECT_CANNOT_ATTACK_ANNOUNCE)==0 and c:is_affected_by(EFFECT_CANNOT_ATTACK)==0
end

function StormingMirrorFilter2(c)
  return not FilterStatus(c,STATUS_LEAVE_CONFIRMED)
  and not FilterAffected(c,EFFECT_IMMUNE_EFFECT)
  and Affected(c,TYPE_TRAP)
  and c.attack>=2000 and c.attack<3000 and bit32.band(c.position,POS_FACEUP_ATTACK)
  and c:is_affected_by(EFFECT_CANNOT_ATTACK_ANNOUNCE)==0 and c:is_affected_by(EFFECT_CANNOT_ATTACK)==0
end

function StormingMirrorFilter3(c)
  return not FilterStatus(c,STATUS_LEAVE_CONFIRMED)
  and not FilterAffected(c,EFFECT_IMMUNE_EFFECT)
  and Affected(c,TYPE_TRAP)
  and c.attack>=3000 and bit32.band(c.position,POS_FACEUP_ATTACK)
  and c:is_affected_by(EFFECT_CANNOT_ATTACK_ANNOUNCE)==0 and c:is_affected_by(EFFECT_CANNOT_ATTACK)==0
end

function ChainStormingMirror() --Return to this to chain it when it would lose the duel.
  return CardsMatchingFilter(OppMon(),StormingMirrorFilter1)>2 
  or CardsMatchingFilter(OppMon(),StormingMirrorFilter2)>1 
  or CardsMatchingFilter(OppMon(),StormingMirrorFilter3)>0
  --or ChainSwiftScarecrow(05650082)
end

function SpecterKozmoSummonMechquipped()
  return (XYZSummonOkay() or MakeRoom())
  and EnableKozmoFunctions()
  and (AI.GetCurrentPhase() == PHASE_MAIN2 or not GlobalBPAllowed)
  and HasID(AIExtra(),15914410,true)
end

function SpecterKozmoSummonMechquippedRoom()
  return SpecterKozmoSummonMechquipped()
  and MakeRoom()
end

function EnableKozmoFunctionsFilter(c)
  return IsSetCode(c.setcode,0xd2)
end

function EnableKozmoFunctions()
  return CardsMatchingFilter(OppDeck(),EnableKozmoFunctionsFilter)>=5
end

function KLightningTargets(c)
  return c.id==55885348
  or c.id==20849090
  or c.id==29491334
  or c.id==94454495
  or c.id==37679169
  or c.id==54063868
end

function SpecterKozmoSummonUtopiaLightning()
  return EnableKozmoFunctions()
  and CardsMatchingFilter(OppMon(),KLightningTargets)>0
  and ((XYZSummonOkay() or MakeRoom()) or (#AIMon()>=3 and AI.GetPlayerLP(2)<=4000))
  and Duel.GetCurrentPhase() == PHASE_MAIN1
  and GlobalBPAllowed
end

function SpecterKozmoSummonUtopiaLightningRoom()
  return SpecterKozmoSummonUtopiaLightning()
  and MakeRoom()
end

function ChainTempestKozmo()
  if not EnableKozmoFunctions() then return false end
  local e
  for i=1,Duel.GetCurrentChain() do
    e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
    if e and e:GetHandler():GetCode()==31061682 
	and e:GetHandlerPlayer()==1-player_ai then
	 return true
	elseif Duel.GetOperationInfo(Duel.GetCurrentChain(), CATEGORY_SPECIAL_SUMMON) 
	and e:GetHandler():GetCode()==93302695 then
	 return true
	end
  end
 return false
end

function SpecterSummonMechquipped()
  return ((CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>2
  and MultiDanger()
  and (AI.GetCurrentPhase() == PHASE_MAIN2 or not GlobalBPAllowed))
  or (HasID(UseLists({AIST(),AIHand()}),function(c) return c.id==05851097 end)
  and (AIGetStrongestAttack() > OppGetStrongestAttDef() or OppGetStrongestAttDef() < 1800))
  or NoSpecterBackrow())
  and HasID(AIExtra(),15914410,true)
end

function SpecterSummonMechquipped2()
  return MakeRoom()
  and HasID(AIExtra(),15914410,true)
end

function SpecterSummonMechquippedRoom()
  return MakeRoom()
  and HasID(AIExtra(),15914410,true)
end

function MultiDangerFilter(c)
  return c.attack >= AIGetStrongestAttack()
end

function MultiDanger()
  return CardsMatchingFilter(OppMon(),MultiDangerFilter)>1
end

function NoSpecterBackrow()
  return CardsMatchingFilter(UseLists({AIST(),AIHand()}),SpecterBackrowFilter)==0
end

function SpecterHasMonsters()
  return CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>2
  or (CardsMatchingFilter(AIMon(),LevelFourMagicianFilter)==1 and CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>1)
  or CardsMatchingFilter(AIMon(),LevelFourMagicianFilter)>1
end

function SpecterHasMonstersWind()
  return CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>2
end

function XYZSummonOkay()
  return SpecterHasMonsters()
  or (NoSpecterBackrow()
  and SpecterMiscBackrow())
end

function SpecterMiscBackrowFilter(c)
  return (c.id==05851097 or c.id==05650082)
  and ((FilterLocation(c,LOCATION_SZONE)
  and FilterPosition(c,POS_FACEUP))
  or FilterLocation(c,LOCATION_HAND))
end

function SpecterMiscBackrow()
  return CardsMatchingFilter(UseLists({AIHand(),AIST()}),SpecterMiscBackrow)>0
end

function XYZSummonReallyOkay()
  return CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>3
  or (CardsMatchingFilter(AIMon(),LevelFourMagicianFilter)==2 and CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>1)
  or CardsMatchingFilter(AIMon(),LevelFourMagicianFilter)>2
end

function XYZSummonOkayWind()
  return SpecterHasMonstersWind()
  or NoSpecterBackrow()
end

function LevelFourMagicianFilter(c)
  return c.id==15146890
  or c.id==72714461
end

function SpecterPhantomFilter(c)
  return (Targetable(c,TYPE_MONSTER)
  and SpecterDestroyFilter(c)
  and Affected(c,TYPE_MONSTER,3)
  and not SpecterCodedTargets(c))
  or FilterPosition(c,POS_FACEDOWN)
end

function SpecterPhantomFilter2(c)
  return Targetable(c,TYPE_MONSTER)
  and SpecterDestroyFilter(c)
  and Affected(c,TYPE_MONSTER,3)
  and not SpecterCodedTargets(c)
end

function SpecterSummonPhantom()
  return CardsMatchingFilter(OppMon(),SpecterPhantomFilter)>0
  and (XYZSummonOkay() or MakeRoom())
  and (CardsMatchingFilter(AIST(),MagicianPendulumFilter)>0 and not OPTCheck(53208660))
  and (CardsMatchingFilter(OppST(),OppDownBackrowFilter)<2 or not HasID(AIExtra(),71068247,true))
  and HasID(AIExtra(),62709239,true)
end

function SpecterSummonPhantom2()
  return (XYZSummonOkay() or MakeRoom())
  and HasID(AIExtra(),62709239,true)
  and CardsMatchingFilter(OppMon(),SpecterPhantomFilter2)>0
  and CardsMatchingFilter(AIMon(),AllyPhantomFilter2)>0
  and HasScales()
  and OppGetStrongestAttDef() > AIGetStrongestAttack()
  and (Duel.GetTurnCount() ~= SpecterGlobalPendulum 
  or (CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>2 or CardsMatchingFilter(AIMon(),MagicianPendulumFilter)>0))
end

function SpecterSummonPhantom3()
  return (XYZSummonOkay() or MakeRoom())
  and HasID(AIExtra(),62709239,true)
  and CardsMatchingFilter(OppMon(),SpecterPhantomFilter2)>0
  and CardsMatchingFilter(AIST(),AllyPhantomFilter3)>0
  and OppGetStrongestAttDef() > AIGetStrongestAttack()
  and Duel.GetTurnCount() ~= SpecterGlobalPendulum
end

function SpecterUsePhantom()
  return CardsMatchingFilter(OppMon(),SpecterPhantomFilter)>0
  and CardsMatchingFilter(AIST(),MagicianPendulumFilter)>0 and not OPTCheck(53208660)
end

function SpecterUsePhantom2()
  return CardsMatchingFilter(OppMon(),SpecterPhantomFilter2)>0
  and CardsMatchingFilter(AIMon(),AllyPhantomFilter2)>0
end

function SpecterUsePhantom3()
  return CardsMatchingFilter(OppMon(),SpecterPhantomFilter2)>0
  and CardsMatchingFilter(AIST(),AllyPhantomFilter3)>0
end

function AllyPhantomFilter(c)
  return FilterType(c,TYPE_PENDULUM)
  and FilterLocation(c,LOCATION_SZONE)
end

function AllyPhantomFilter2(c)
  if CardsMatchingFilter(AIMon(),MagicianPendulumFilter)>0 then
    return IsSetCode(c.setcode,0x98) and FilterLocation(c,LOCATION_MZONE)
  elseif (CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>1 and HasID(AIMon(),62709239,true)) then
    return IsSetCode(c.setcode,0xd0) and FilterType(c,TYPE_MONSTER) and FilterLocation(c,LOCATION_MZONE)
  elseif CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>3 then
    return IsSetCode(c.setcode,0xd0) and FilterType(c,TYPE_MONSTER) and FilterLocation(c,LOCATION_MZONE)
  end
end

function AllyPhantomFilter3(c)
  if CardsMatchingFilter(AIST(),ScaleHighFilter)>0 and HasScales() and CardsMatchingFilter(AIHand(),ScaleHighFilter)>0 then
    return (c.id==51531505 or c.id==72714461 or c.id==00645794 or c.id==68395509 or c.id==31991800) and FilterLocation(c,LOCATION_SZONE)
  elseif CardsMatchingFilter(AIST(),ScaleLowFilter)>0 and HasScales() and CardsMatchingFilter(AIHand(),ScaleLowFilter)>0 then
    return (c.id==15146890 or c.id==05506791 or c.id==94784213 or c.id==14920218) and FilterLocation(c,LOCATION_SZONE)
  end
end

function SpecterTornadoFilter(c)
  return Targetable(c,TYPE_TRAP)
  and Affected(c,TYPE_TRAP)
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and not SpecterCodedTargets(c)
end

function SpecterTornadoFilter2(c)
  return Targetable(c,TYPE_TRAP)
  and Affected(c,TYPE_TRAP)
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and (bit32.band(c.type,TYPE_XYZ+TYPE_SYNCHRO+TYPE_RITUAL+TYPE_FUSION)>0 or c.level>4)
  and not SpecterCodedTargets(c)
end

function ChainSpecterTornado()
  return CardsMatchingFilter(OppMon(),SpecterTornadoFilter)>0
  and (NeedsRaccoonExtra() or NeedsCatExtra()
  or NeedsFoxExtra() or NeedsCrowExtra()
  or NeedsToadExtra())
  and HasScales()
  and ((Duel.GetTurnPlayer()==player_ai and Duel.GetTurnCount() ~= SpecterGlobalPendulum)
  or (Duel.GetTurnPlayer()==1-player_ai and AI.GetCurrentPhase() == PHASE_END))
  and UnchainableCheck(36183881)
  and not MajestyCheck()
end

function ChainSpecterTornado2()
  return CardsMatchingFilter(OppMon(),SpecterTornadoFilter2)>0
  and Duel.GetTurnPlayer()==1-player_ai
  and UnchainableCheck(36183881)
  and not MajestyCheck()
end

function ChainSpecterTornado3()
  return CardsMatchingFilter(OppMon(),SpecterTornadoFilter)>0
  and HasScales()
  and (Duel.GetTurnPlayer()==player_ai and Duel.GetTurnCount() ~= SpecterGlobalPendulum)
  and VanityRemovalNeeded()
  and UnchainableCheck(36183881)
end

function ChainSpecterTornado4()
  if AngineerProtecting() then return false end
  if Duel.GetCurrentPhase() == PHASE_BATTLE and Duel.GetTurnPlayer()==1-player_ai then
		local source = Duel.GetAttacker()
		local target = Duel.GetAttackTarget()
    if source and target then
      if source:IsControler(player_ai) then
        target = Duel.GetAttacker()
        source = Duel.GetAttackTarget()
      end
      if target:IsControler(player_ai)
	  and Targetable(source,TYPE_TRAP) and Affected(source,TYPE_TRAP)
	  and SpecterDestroyFilter(source)
	  and WinsBattle(source,target)
	  and UnchainableCheck(36183881)
	  and not target:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)
	  then
--	  GlobalTargetSet(source,OppMon())
      return true
     end
   end
  end
 return false
end

function NeedsRaccoonExtra()
  return HasID(AIMon(),31991800,true)
  and not HasID(AIExtra(),31991800,true)
end

function NeedsCatExtra()
  return HasID(AIMon(),05506791,true)
  and not HasID(AIExtra(),05506791,true)
end

function NeedsFoxExtra()
  return HasID(AIMon(),94784213,true)
  and not HasID(AIExtra(),94784213,true)
end

function NeedsCrowExtra()
  return HasID(AIMon(),68395509,true)
  and not HasID(AIExtra(),68395509,true)
end

function NeedsToadExtra()
  return HasID(AIMon(),00645794,true)
  and not HasID(AIExtra(),00645794,true)
end

function VanityFilter(c)
  return c.id==05851097 and FilterPosition(c,POS_FACEUP)
end

function VanityLockdown()
  return AIGetStrongestAttack() > OppGetStrongestAttDef()
  and CardsMatchingFilter(AIST(),VanityFilter)>0
end

function VanityRemovalNeeded()
  return AIGetStrongestAttack() <= OppGetStrongestAttDef()
  and CardsMatchingFilter(AIST(),VanityFilter)>0
  and CardsMatchingFilter(OppST(),VanityFilter)==0
end

function SpecterChainTotemBird() --Might as well negate whatever the opponent plays if they have one card or less in the hand.
  if #OppHand()<2
  and EffectCheck(1-player_ai)~=nil then
  local e
  for i=1,Duel.GetCurrentChain() do
    e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
    if e and e:GetHandler():GetCode()~=NegateBlackList
	and e:GetHandlerPlayer()==1-player_ai then
    return true
    end
   end
  end
 return false
end

function SpecterCycloneFilter(c)
  return Targetable(c,TYPE_SPELL)
  and Affected(c,TYPE_SPELL)
  and SpecterDestroyFilter(c)
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and not SpecterCodedTargets(c)
end

function SpecterCycloneFilter2(c)
  return Targetable(c,TYPE_SPELL)
  and Affected(c,TYPE_SPELL)
  and SpecterDestroyFilter(c)
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and (bit32.band(c.type,TYPE_XYZ+TYPE_SYNCHRO+TYPE_RITUAL+TYPE_FUSION)>0 or c.level>4)
  and not SpecterCodedTargets(c)
end

function ChainSpecterCyclone()
  return CardsMatchingFilter(OppMon(),SpecterCycloneFilter)>0
  and (NeedsRaccoonExtra() or NeedsCatExtra()
  or NeedsFoxExtra() or NeedsCrowExtra()
  or NeedsToadExtra())
  and HasScales()
  and ((Duel.GetTurnPlayer()==player_ai and Duel.GetTurnCount() ~= SpecterGlobalPendulum)
  or (Duel.GetTurnPlayer()==1-player_ai and AI.GetCurrentPhase() == PHASE_END))
  and UnchainableCheck(49366157)
  and not MajestyCheck()
end

function ChainSpecterCyclone2()
  return CardsMatchingFilter(OppMon(),SpecterCycloneFilter2)>0
  and Duel.GetTurnPlayer()==1-player_ai
  and UnchainableCheck(49366157)
  and not MajestyCheck()
end

function ChainSpecterCyclone3()
  return CardsMatchingFilter(OppMon(),SpecterCycloneFilter)>0
  and HasScales()
  and (Duel.GetTurnPlayer()==player_ai and Duel.GetTurnCount() ~= SpecterGlobalPendulum)
  and VanityRemovalNeeded()
  and UnchainableCheck(49366157)
end

function ChainSpecterCyclone4()
  if AngineerProtecting() then return false end
  if Duel.GetCurrentPhase() == PHASE_BATTLE and Duel.GetTurnPlayer()==1-player_ai then
		local source = Duel.GetAttacker()
		local target = Duel.GetAttackTarget()
    if source and target then
      if source:IsControler(player_ai) then
        target = Duel.GetAttacker()
        source = Duel.GetAttackTarget()
      end
      if target:IsControler(player_ai)
	  and Targetable(source,TYPE_SPELL) and Affected(source,TYPE_SPELL)
	  and SpecterDestroyFilter(source)
	  and WinsBattle(source,target)
	  and UnchainableCheck(49366157)
	  and not target:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)
	  then
--	  GlobalTargetSet(source,OppMon())
      return true
     end
   end
  end
 return false
end

function SpecterHeroTrashTalkFilter(c)
  return c.id==08949584 --A Hero Lives
  and FilterPosition(c,POS_FACEUP)
end

function SpecterHeroTrashTalk()
  return AI.GetPlayerLP(2)==4000
  and CardsMatchingFilter(OppST(),SpecterHeroTrashTalkFilter)>0
  and Duel.GetTurnCount() == 2
  and CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>0
  and CardsMatchingFilter(AIST(),SpecterBackrowFilter)>0
  and not VanityLockdown()
end

function DetectShadowMist()
  return CardsMatchingFilter(OppMon(),function(c) return c.id==50720316 end)>0
  and Duel.GetTurnCount() == 2
  and #OppMon()==1
end

function TornadoShadowMistFilter(c)
  return SpecterTornadoFilter(c)
  and c.id==50720316
end

function TornadoShadowMist()
  return AI.GetCurrentPhase() == PHASE_END
  and CardsMatchingFilter(OppMon(),TornadoShadowMistFilter)==1
  and Duel.GetTurnCount() == 2
end

function CycloneShadowMistFilter(c)
  return SpecterCycloneFilter(c)
  and c.id==50720316
end

function CycloneShadowMist()
  return AI.GetCurrentPhase() == PHASE_END
  and CardsMatchingFilter(OppMon(),CycloneShadowMistFilter)==1
  and Duel.GetTurnCount() == 2
end

function SpecterChainNegation(card) --Taken from Generic.lua, added some card IDs that weren't negated.
  local e,c,id 
  if EffectCheck(1-player_ai)~=nil then
    e,c,id = EffectCheck()
    if EffectNegateFilter(c,card) then
      SetNegated()
      return true
    end
	elseif HasID(AIMon(),71068247,true) then 
	local e
	  for i=1,Duel.GetCurrentChain() do
	  e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
	    if e and (e:GetHandler():GetCode()==21143940 or e:GetHandler():GetCode()==93600443 or e:GetHandler():GetCode()==84536654) then
	     return true
		end
	  end
  else
    local cards = SubGroup(OppMon(),FilterStatus,STATUS_SUMMONING)
    if #cards > 1 and Duel.GetCurrentChain()<1 then
      return true
    end
    if #cards == 1 and Duel.GetCurrentChain()<1 then
      c=cards[1]
      return SummonNegateFilter(c)
    end
  end
  return false
end

function SpecterTemtempoFilter1(c) --Honor Ark, Honor Dark, Full-Armored Lancer, Cowboy, Ignis, Zenmaines, Sky Cavalry, Gachi Gachi.
  return Affected(c,TYPE_MONSTER,3)
  and FilterType(c,TYPE_XYZ) 
  and c.xyz_material_count==1 
  and Targetable(c,TYPE_MONSTER)
  and (c.id==48739166
  or c.id==12744567
  or c.id==25853045
  or (c.id==12014404 and FilterPosition(c,POS_FACEUP_DEFENCE) and AI.GetPlayerLP(1)<=800)
  or c.id==03989465
  or c.id==78156759
  or c.id==36776089
  or c.id==10002346)
end

function SpecterTemtempoFilter2(c) --Totem Bird, Starliege Paladynamo, Brotherhood Cardinal
  return Affected(c,TYPE_MONSTER,3)
  and FilterType(c,TYPE_XYZ)
  and c.xyz_material_count==2
  and Targetable(c,TYPE_MONSTER)
  and (c.id==71068247
  or c.id==61344030
  or c.id==58504745)
end

function SpecterTemtempoFilter3(c) --Only chain during opponent's turn. Dark Rebellion, GTomahawk, Shogi XYZ, Excalibur, Castel, ARK Knight
  return Affected(c,TYPE_MONSTER,3)
  and FilterType(c,TYPE_XYZ)
  and c.xyz_material_count==2
  and Targetable(c,TYPE_MONSTER)
  and (c.id==16195942
  or c.id==10389142
  or c.id==75253697
  or c.id==60645181
  or c.id==82633039
  or c.id==48739166)
end

function SpecterTemtempoFilter4(c) --Utopia Lightning
  return Affected(c,TYPE_MONSTER,3)
  and FilterType(c,TYPE_XYZ)
  and c.xyz_material_count==3
  and Targetable(c,TYPE_MONSTER)
  and c.id==56832966
end

function SpecterSummonTemtempo() --Pure gimmick mode initiated, you don't have to check if you have Majespecters, who even needs those?
  return (CardsMatchingFilter(OppMon(),SpecterTemtempoFilter1)>0
  or CardsMatchingFilter(OppMon(),SpecterTemtempoFilter2)>0)
  and HasID(AIExtra(),52558805,true)
end

function SpecterChainTemtempo1()
  return CardsMatchingFilter(OppMon(),SpecterTemtempoFilter1)>0
end

function SpecterChainTemtempo2()
  return CardsMatchingFilter(OppMon(),SpecterTemtempoFilter2)>0
end

function SpecterChainTemtempo3()
  return CardsMatchingFilter(OppMon(),SpecterTemtempoFilter3)>0
  and Duel.GetTurnPlayer() == 1-player_ai
end

function SpecterChainTemtempo4()
  return CardsMatchingFilter(OppMon(),SpecterTemtempoFilter4)>0
  and Duel.GetTurnPlayer() == 1-player_ai
  and AI.GetCurrentPhase() == PHASE_BATTLE
end

function SpecterChainTemtempo5()
  return not (SpecterChainTemtempo1()
  and SpecterChainTemtempo2()
  and SpecterChainTemtempo3()
  and SpecterChainTemtempo4())
end

function SpecterXYZSummon(index,id)
  if index == nil then
    index = CurrentIndex
  end
  SpecterGlobalMaterial = true
  if id then
    SpecterGlobalSSCardID = id
  end
  return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
end

--[[function SpecterXYZSetup(cards,minTargets,maxTargets,triggeringID,triggeringCard) --Cheating AI. Pretty much the best mistake of my life.
--  if SpecterGlobalMaterial then
    if not triggeringCard then
	local function compare(a,b)
	local result = {}
      return a.attack < b.attack
    end
	local list = {}
    for i=1,#cards do
      if cards[i] and bit32.band(cards[i].type,TYPE_MONSTER) > 0
      then   
        cards[i].index=i
        list[#list+1]=cards[i]
        if cards[i].id == 72714461 or cards[i].id == 15146890 or cards[i].id == 40318957 then
            cards[i].attack = -3
        else
            cards[i].attack = -1
        end
      end
    end
    table.sort(list,compare)
    result={}
    check={}
    for i=1,#minTargets do
      result[i]=list[i].index
      check[i]=list[i]
    end
  end
 return result
end]]

function SpecterOnSelectMaterial(cards,min,max,id)
  if id == SpecterGlobalSSCardID then
   return Add(cards,PRIO_TOGRAVE,min)
  end
end

function SStormFilter1(c)
  return Targetable(c,TYPE_SPELL)
  and Affected(c,TYPE_SPELL)
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and not SpecterCodedTargets(c)
end

function SStormFilter2(c)
  return Targetable(c,TYPE_SPELL)
  and Affected(c,TYPE_SPELL)
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and (bit32.band(c.type,TYPE_XYZ+TYPE_SYNCHRO+TYPE_RITUAL+TYPE_FUSION)>0 or c.level>4)
  and not SpecterCodedTargets(c)
end

function SStormFilter4(c)
  return Targetable(c,TYPE_SPELL)
  and Affected(c,TYPE_SPELL)
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and BypassDestroyFilter(c)
  and not SpecterCodedTargets(c)
end

function UseSStorm1()
  return HasScales()
  and CardsMatchingFilter(OppMon(),SStormFilter1)>0
  and Duel.GetTurnCount() ~= SpecterGlobalPendulum
  and (NeedsRaccoonExtra() or NeedsCatExtra()
  or NeedsFoxExtra() or NeedsCrowExtra()
  or NeedsToadExtra())
  and not MajestyCheck()
end

function UseSStorm2()
  return CardsMatchingFilter(OppMon(),SStormFilter2)>0
  and not MajestyCheck()
end

function UseSStorm3()
  return CardsMatchingFilter(OppMon(),SStormFilter1)>0
  and HasScales()
  and Duel.GetTurnCount() ~= SpecterGlobalPendulum
  and VanityRemovalNeeded()
end

function UseSStorm4()
  return CardsMatchingFilter(OppMon(),SStormFilter4)>0
  and (not MajestyCheck() or not WindaCheck())
end

function MajestyCheck()
  if Duel.GetTurnPlayer() == player_ai
  and OPTCheck(76473843) 
  and ((Duel.GetTurnCount() ~= SpecterGlobalPendulum and HasScales()) or CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>1)
  and (HasIDNotNegated(AIST(),76473843,true)
  or HasID(AIHand(),76473843,true) and not FieldSpellNotActivatable() and not HasID(AIST(),76473843,true)) then
   return true
  end
 return false
end

function FieldSpellNotActivatableFilter(c) --Field Barrier, Closed Forest, Anti-Spell Fragrance, Spell Canceller, Spell Sealing
  return (c.id==07153114
  or c.id==78082039
  or c.id==58921041
  or c.id==84636823
  or c.id==71983925)
  and FilterPosition(c,POS_FACEUP)
  and NotNegated(c)
end

function FieldSpellNotActivatable() --Checks for cards that prevent another Field from being played. Necrovalley etc., Mechanical Hound, Bamboo Shoot.
  return CardsMatchingFilter(UseLists({OppMon(),OppST()}),FieldSpellNotActivatableFilter)>0
  or (HasIDNotNegated(OppMon(),58139128,true)
  and (HasIDNotNegated(OppST(),47355498,true) and HasIDNotNegated(OppMon(),03381441,true)))
  or (HasIDNotNegated(OppMon(),22512237,true) and #OppHand()==0)
  or HasIDNotNegated(OppMon(),20174189,true)
end

function SpecterSummonChidori(c,mode)
  if (XYZSummonOkayWind() or MakeRoom()) then
    if mode == 1 
    and CardsMatchingFilter(OppField(),ChidoriFilter,POS_FACEUP)>0
    and CardsMatchingFilter(OppField(),ChidoriFilter,POS_FACEDOWN)>0
    then
      return true
    elseif mode == 2 
    and HasPriorityTarget(OppField(),false,nil,ChidoriFilter,POS_FACEUP)
    then
      return true
    end
  end
 return false
end

function SpecterSummonChidori2()
  return Duel.GetTurnCount() ~= SpecterGlobalPendulum
  and OppDownBackrow()
  and HasScales()
  and CardsMatchingFilter(UseLists({AIHand(),AIExtra()}),TrueSpecterMonsterFilter)>0
  and HasID(AIExtra(),22653490,true)
end

function SpecterSummonCastel()
  return XYZSummonOkay()
  and OppGetStrongestAttack() > AIGetStrongestAttack()
  and (OppGetStrongestAttack() > 2000 and not SpecterSummonMajester1())
  and CardsMatchingFilter(OppMon(),SpecterCastelFilter)>0 
  and HasID(AIExtra(),82633039,true) 
  and MP2Check()
end

function SpecterSummonCastelRoom()
  return MakeRoom()
  and OppGetStrongestAttack() > AIGetStrongestAttack()
  and (OppGetStrongestAttack() > 2000 and (not HasID(AIExtra(),88722973,true) and NeedsRaccoon()))
  and CardsMatchingFilter(OppMon(),SpecterCastelFilter)>0
  and HasID(AIExtra(),82633039,true)
end

function SpecterCastelFilter(c)
  return FilterPosition(c,POS_FACEUP)
  and Targetable(c,TYPE_MONSTER)
  and Affected(c,TYPE_MONSTER,4)
--  and c.attack > AIGetStrongestAttack()
end

function SpecterUseCastel()
  return CardsMatchingFilter(OppField(),SpecterCastelFilter)>0
end

function SpecterSummonUtopiaLightning()
  return CardsMatchingFilter(OppMon(),SpecterLightningFilter)>0
  and XYZSummonOkay()
  and OppGetStrongestAttDef() >= AIGetStrongestAttack()
  and AI.GetCurrentPhase() == PHASE_MAIN1
  and GlobalBPAllowed
  and HasID(AIExtra(),56832966,true)
  and not HasID(AIMon(),56832966,true)
end

function SpecterSummonUtopiaLightningRoom()
  return MakeRoom()
  and CardsMatchingFilter(OppMon(),SpecterLightningFilter)>0
  and OppGetStrongestAttDef() >= AIGetStrongestAttack()
  and AI.GetCurrentPhase() == PHASE_MAIN1
  and GlobalBPAllowed
end

function SpecterLightningFilter(c)
  return not FilterAffected(c,EFFECT_CANNOT_BE_BATTLE_TARGET)
  and not FilterAffected(c,EFFECT_INDESTRUCTABLE_BATTLE)
end

function SpecterSummonHeartland()
  return XYZSummonReallyOkay()
  and HasScales()
  and HasID(AIExtra(),31437713,true)
  and SpecterMP2Check()
  and not HasPtolemaeusExtra()
end

function SpecterActivateHeartland()
  return OppGetStrongestAttDef() >= AIGetStrongestAttack()
--  and #AIMon() < #OppMon()
end

function SpecterSummonHeartlandFinish()
  return AI.GetCurrentPhase() == PHASE_MAIN1 and GlobalBPAllowed
  and AI.GetPlayerLP(2)<=2000
  and HasID(AIExtra(),31437713,true)
end

function SpecterActivateHeartlandFinish()
  return AI.GetCurrentPhase() == PHASE_MAIN1 and GlobalBPAllowed
  and AI.GetPlayerLP(2)<=2000
end

function HasPtolemaeusExtra()
  return HasID(AIExtra(),18326736,true)
  and HasID(AIExtra(),09272381,true)
  and HasID(AIExtra(),34945480,true)
end

function SpecterSummonMajester1()
  return XYZSummonOkay()
  and NeedsRaccoon()
  and SpecterMP2Check()
  and OPTCheck(05506791)
  and HasID(AIExtra(),88722973,true)
end

function SpecterSummonMajester2() --???
  return MakeRoom()
  and HasID(AIExtra(),88722973,true)
end

function SpecterSummonMajesterRoom()
  return MakeRoom()
  and HasID(AIExtra(),88722973,true)
end

function UseDragonpit()
  return CardsMatchingFilter(OppST(),OppDownBackrowFilter)>0
  and (CardsMatchingFilter(AIExtra(),AllPendulumFilter)>0
  or CardsMatchingFilter(AIHand(),AllPendulumFilter)>1)
  and Duel.GetTurnCount() ~= SpecterGlobalPendulum
  and OPTCheck(51531505)
  and not RaccoonHandCheck()
end

function UseDragonpitVanitys()
  return CardsMatchingFilter(OppST(),VanityFilter)>0
  and CardsMatchingFilter(AIST(),VanityFilter)==0
  and (CardsMatchingFilter(AIExtra(),AllPendulumFilter)>0
  or CardsMatchingFilter(AIHand(),AllPendulumFilter)>1
  or (CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>0
  and HasID(AIST(),76473843,true)
  and OPTCheck(76473843)))
  and Duel.GetTurnCount() ~= SpecterGlobalPendulum
  and OPTCheck(51531505)
  and not RaccoonHandCheck()
end

function DragonpitVanitysTargetFilter(c)
  return FilterType(c,TYPE_SPELL+TYPE_TRAP)
  and not FilterType(c,TYPE_PENDULUM)
  and SpecterDestroyFilter(c)
end

function RaccoonFilter(c) --Test
  return c.id==31991800
end

--Lol, Shadolls are with me in spirit and copied coding.

function SpecterGetPriority(c,loc)
  local checklist = nil
  local result = 0
  local id = c.id
  if loc == nil then
    loc = PRIO_TOHAND
  end
  checklist = Prio[id]
  if checklist then
    if checklist[11] and not(checklist[11](loc,c)) then
      loc = loc + 1
    end
    result = checklist[loc]
  end
  return result
end

function SpecterAssignPriority(cards,loc,filter)
  local index = 0
  for i=1,#cards do
    cards[i].index=i
    cards[i].prio=SpecterGetPriority(cards[i],loc)
  end
end

function SpecterPriorityCheck(cards,loc,count,filter)
  if count == nil then count = 1 end
  if loc==nil then loc=PRIO_TOHAND end
  if cards==nil or #cards<count then return -1 end
  SpecterAssignPriority(cards,loc,filter)
  table.sort(cards,function(a,b) return a.prio>b.prio end)
  return cards[count].prio
end

function SpecterTrapPriorityFilter(c)
  return (c.id==78949372
  or c.id==36183881
  or c.id==02572890)
  and FilterLocation(c,LOCATION_DECK)
end

function SpecterSpellPriorityFilter(c)
  return (c.id==49366157
  or c.id==13972452)
  and FilterLocation(c,LOCATION_DECK)
end

function EnableBlueEyesFunctionsFilter(c)
  return c.id==71039903
  or c.id==45467446
  or c.id==38517737
end

function EnableBlueEyesFunctions()
  return CardsMatchingFilter(UseLists({OppDeck(),OppGrave()}),EnableBlueEyesFunctionsFilter)>5
end

function EnableShadollFunctionsFilter(c)
  return IsSetCode(c.setcode,0x9d)
end

function EnableShadollFunctions()
  return CardsMatchingFilter(UseLists({OppDeck(),OppGrave()}),EnableShadollFunctionsFilter)>5
end

function SpecterBlueSummonAbyss()
  return EnableBlueEyesFunctions()
  and (XYZSummonReallyOkay()
  and SpecterMP2Check()
  and AIGetStrongestAttack() > OppGetStrongestAttDef()
  or MakeRoom())
end

function SpecterShadollSummonAbyss()
  return EnableShadollFunctions()
  and (XYZSummonOkay()
  and SpecterMP2Check()
  and AIGetStrongestAttack() > OppGetStrongestAttDef()
  or MakeRoom())
end

function SpecterShadollSummonAbyssRoom()
  return EnableShadollFunctions()
  and MakeRoom()
--  and AIGetStrongestAttack() > OppGetStrongestAttDef()
end

function SpecterShadollFusionGrave()
  return (HasID(OppGrave(),44394295,true)
  or HasID(OppGrave(),06417578,true)
  or HasID(OppGrave(),60226558,true))
  and EnableShadollFunctions()
end

function ChainSpecterAbyss()
  if (EnableBlueEyesFunctions() and Duel.GetTurnPlayer()==1-player_ai) then return true end
  if (EnableShadollFunctions() and Duel.GetTurnPlayer()==1-player_ai) then return true end
  if (EnableRaidraptorFunctions() and Duel.GetTurnPlayer()==1-player_ai) then return true end
  if (EnableBAFunctions() and Duel.GetTurnPlayer()==1-player_ai) then return true end
  if EnableShadollFunctions() then
  local e
    for i=1,Duel.GetCurrentChain() do
    e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
      if e and (e:GetHandler():GetCode()==84968490 or e:GetHandler():GetCode()==77505534 or e:GetHandler():GetCode()==06417578 or e:GetHandler():GetCode()==74519184) 
	  and e:GetHandlerPlayer()==1-player_ai then
	   return true
	  end
	end
  end
  if EnableShadollFunctions() then
    if SpecterDestroyCheckOpp(03717252) or SpecterDestroyCheckOpp(77723643) or SpecterDestroyCheckOpp(30328508) or SpecterDestroyCheckOpp(52551211)
	or SpecterDestroyCheckOpp(04939890) or SpecterDestroyCheckOpp(37445295) or SpecterDestroyCheckOpp(74822425) or SpecterDestroyCheckOpp(19261966)
    or SpecterDestroyCheckOpp(20366274) or SpecterDestroyCheckOpp(48424886) or SpecterDestroyCheckOpp(74009824) or SpecterDestroyCheckOpp(94977269)
	or SpecterDestroyCheckOpp(03717252) or (SpecterDestroyCheckOpp(04904633) and SpecterShadollFusionGrave()) then
	  return true
	end
  end
  if EnableBAFunctions() then
  local e
    for i=1,Duel.GetCurrentChain() do
    e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
      if e and (e:GetHandler():GetCode()==60743819 or e:GetHandler():GetCode()==20513882 or e:GetHandler():GetCode()==36006208 or e:GetHandler():GetCode()==57728570 or e:GetHandler():GetCode()==53582587) 
	  and e:GetHandlerPlayer()==1-player_ai then
	   return true
	  end
	end
  end
  if EnableBAFunctions() then
    if Duel.GetCurrentPhase() == PHASE_BATTLE then
    local source = Duel.GetAttacker()
	local target = Duel.GetAttackTarget()
      if source and target then
        if source:IsControler(player_ai) then
        target = Duel.GetAttacker()
        source = Duel.GetAttackTarget()
        end
        if target:IsControler(player_ai)
		and source:IsPosition(POS_FACEUP)
		and target:IsPosition(POS_FACEUP_ATTACK)
		and Winsbattle(target,source)
		and not source:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)
		and (source:IsCode(20758643) or source:IsCode(57143342) or source:IsCode(09342162) or source:IsCode(36553319) or source:IsCode(84764038) 
		or source:IsCode(27552504) or (source:IsCode(62957424) and #OppHand()>0) or source:IsCode(00601193) or source:IsCode(18386170) 
		or source:IsCode(83531441))
		then
		  return true
		end
	  end
	end
  end
--[[  if EnableBAFunctions() and GlobalMurderDante then
    GlobalMurderDante = false
	return true
  end]]
  if EnableBAFunctions() and SpecterDestroyCheckOpp(83531441) then
    return true
  end
  if EnableBAFunctions() and SpecterRemovalCheckOpp(83531441) and EnemyHasDante() then
    return true
  end
  if RemovalCheck(21044178) then
    return true
  end
 return false
end

function SpecterBASummonAbyss()
  return EnableBAFunctions()
  and (XYZSummonOkay()
  and (SpecterMP2Check() 
  or CardsMatchingFilter(OppMon(),SpecterBABattleTargets)>0 and GlobalBPAllowed and Duel.GetCurrentPhase() == PHASE_MAIN1)
  and AIGetStrongestAttack() > OppGetStrongestAttDef()
  or MakeRoom())
end

function SpecterBABattleTargets(c)
  return c.id==20758643
  or c.id==57143342
  or c.id==09342162
  or c.id==36553319
  or c.id==84764038
  or c.id==27552504
  or c.id==62957424
  or c.id==00601193
  or c.id==18386170
end

function EnableExodiaLibraryFunctionsFilter(c)
  return c.id==89997728
  or c.id==70791313
  or c.id==33396948
  or c.id==07902349
  or c.id==08124921
  or c.id==44519536
  or c.id==70903634
  or c.id==70368879
  or c.id==79814787
  or c.id==39701395
  or c.id==38120068
end

function EnableExodiaLibraryFunctions()
  return CardsMatchingFilter(UseLists({OppDeck(),OppGrave(),OppHand()}),EnableExodiaLibraryFunctionsFilter)>=15
end

function ChainTempestLibrary()
  if not EnableExodiaLibraryFunctions() then return false end
  local e
  for i=1,Duel.GetCurrentChain() do
    e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
    if e and e:GetHandler():GetCode()==70791313 
	and e:GetHandlerPlayer()==1-player_ai then
	 return true
	end
  end
 return false
end

function ChainSCycloneLibrary()
  if not EnableExodiaLibraryFunctions() then return false end
  if HasID(OppMon(),70791313,true) 
  and UnchainableCheck(49366157) then
    return true
  end
 return false
end

function ChainSTornadoLibrary()
  if not EnableExodiaLibraryFunctions() then return false end
  if HasID(OppMon(),70791313,true) 
  and UnchainableCheck(36183881) then
    return true
  end
 return false
end

function LibraryRemoved()
  return EnableExodiaLibraryFunctions()
  and HasID(UseLists({OppGrave(),OppBanish()}),70791313,true)
  and #OppMon()==0
end

function LossToExodia()
  return EnableExodiaLibraryFunctions()
  and HasID(AIHand(),33396948,true)
  and HasID(AIHand(),07902349,true)
  and HasID(AIHand(),08124921,true)
  and HasID(AIHand(),44519536,true)
  and HasID(AIHand(),70903634,true)
end

function NeedsSStormOverSCycloneFilter(c)
  return Targetable(c,TYPE_SPELL)
  and Affected(c,TYPE_SPELL)
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and (c.attack > AIGetStrongestAttack() 
  or FilterAffected(c,EFFECT_CANNOT_BE_BATTLE_TARGET))
  and FilterAffected(c,EFFECT_INDESTRUCTABLE_EFFECT)
  and not SpecterDestroyFilter(c)
end

function NeedsSStormOverSCyclone()
  return (CardsMatchingFilter(OppMon(),NeedsSStormOverSCycloneFilter)>0
  or CardsMatchingFilter(OppMon(),BypassDestroyFilter)>0
  or EnableBAFunctions()
  and EnemyHasDante())
  and HasID(AIDeck(),13972452,true)
end

function BypassDestroyFilter(c) --Indexes cards that the AI fails to check with DestroyFilter normally. Sins, C-Lancer, ArchSeraph, eartH, Kagutsuchi, Sentry, Beetle, Yoke, SHARK, Full Lancer, Maestroke, Zenmaines, Gantetsu, U-Future, Angineer, Winda, Wickedwitch
  return (((c.id==62541668
  or c.id==99469936
  or c.id==67173574
  or c.id==23998625
  or c.id==01855932
  or c.id==49678559
  or c.id==76067258
  or c.id==23232295
  or c.id==48739166
  or c.id==25853045
  or c.id==25341652
  or c.id==78156759
  or c.id==10002346
  or c.id==65305468
  or c.id==15914410)
  and c.xyz_material_count>0)
  or c.id==94977269
  or c.id==93302695)
  and NotNegated(c)
end

function SpecterDestroyFilter(c,nontarget) --Wait, why have I been writing as if someone else is here? And why am I still doing it? Man, I'm stupid. That's why I'm copying more code.
  return not FilterAffected(c,EFFECT_INDESTRUCTABLE_EFFECT)
  and not FilterStatus(c,STATUS_LEAVE_CONFIRMED)
  and (nontarget==true or not FilterAffected(c,EFFECT_CANNOT_BE_EFFECT_TARGET))
  and not (DestroyBlacklist(c)
  and FilterPublic(c))
  and not BypassDestroyFilter(c)
end

function UsePeasantPendulum()
  return HasID(AIST(),51531505,true)
  and Duel.GetTurnCount() ~= SpecterGlobalPendulum
  and CardsMatchingFilter(OppST(),OppDownBackrowFilter)>0
  and OPTCheck(14920218)
  and OPTCheck(51531505)
end

function InsightfulPhantomSetup()
  return HasID(AIExtra(),62709239,true)
  and (HasID(AIST(),72714461,true) or HasID(AIHand(),72714461,true))
  and CardsMatchingFilter(OppField(),InsightfulPhantomEnemyFilter)>0
  and CardsMatchingFilter(AIST(),InsightfulPhantomAllyFilter)==1
  and CardsMatchingFilter(AIST(),MagicianPendulumFilter)==1
  and CardsMatchingFilter(AIHand(),MagicianPendulumFilter)>0
  and OPTCheck(53208660)
  and DualityCheck()
  and CardsMatchingFilter(UseLists({AIST(),OppST()}),VanityFilter)==0
  and Duel.GetTurnCount() ~= SpecterGlobalPendulum
  and ((HasID(AIDeck(),14920218,true) and HasID(AIST(),51531505,true))
  or HasID(AIDeck(),51531505,true) and HasID(AIST(),14920218,true))
end

function InsightfulPhantomEnemyFilter(c)
  return SpecterDestroyFilter(c)
end

function InsightfulPhantomAllyFilter(c)
  return IsSetCode(c.setcode,0xd0)
  and FilterLocation(c,LOCATION_SZONE)
end

function InsightfulLevel3Filter(c)
  return c.id==31991800
  or c.id==05506791
end

function InsightfulMajestyFilter(c) --Index non-level 3 monsters to be tributed
  return c.id==14920218
  or c.id==94784213
  or c.id==68395509
  or c.id==00645794
end

function InsightfulPhantomSummon()
  return InsightfulPhantomSetup()
end

function InsightfulRaccoonSummon()
  return CardsMatchingFilter(AIMon(),InsightfulLevel3Filter)==1
  and InsightfulPhantomSetup()
end

function InsightfulCatSummon()
  return CardsMatchingFilter(AIMon(),InsightfulLevel3Filter)==1
  and InsightfulPhantomSetup()
end

function InsightfulFodderSummon()
  return InsightfulPhantomSetup()
  and CardsMatchingFilter(AIMon(),InsightfulLevel3Filter)==1
  and HasID(AIST(),76473843,true)
  and OPTCheck(76473843)
  and (HasID(AIDeck(),31991800,true) or HasID(AIDeck(),05506791,true))
end

function InsightfulMajesty()
  return InsightfulPhantomSetup()
  and ((CardsMatchingFilter(AIMon(),InsightfulLevel3Filter)==1
  and CardsMatchingFilter(AIMon(),InsightfulMajestyFilter)>0)
  or CardsMatchingFilter(AIMon(),InsightfulMajestyFilter)>0
  and CardsMatchingFilter(AIHand(),InsightfulLevel3Filter)>0
  and NormalSummonCheck(player_ai))
end

function InsightfulPhantomUse()
  return (HasID(AIST(),72714461,true) or HasID(AIHand(),72714461,true))
  and CardsMatchingFilter(OppField(),InsightfulPhantomEnemyFilter)>0
  and CardsMatchingFilter(AIST(),InsightfulPhantomAllyFilter)==1
  and CardsMatchingFilter(AIST(),MagicianPendulumFilter)==1
  and CardsMatchingFilter(AIHand(),MagicianPendulumFilter)>0
  and OPTCheck(53208660)
  and Duel.GetTurnCount() ~= SpecterGlobalPendulum
  and ((HasID(AIDeck(),14920218,true) and HasID(AIST(),51531505,true))
  or HasID(AIDeck(),51531505,true) and HasID(AIST(),14920218,true))
end

function SpecterChainMechquipped(c)
  local targets = RemovalCheckList(AIMon(),CATEGORY_DESTROY,nil,nil,SpecterMechquippedFilter)
  if targets then
    for i=1,#targets do
    end
    BestTargets(targets,1,TARGET_PROTECT)
    GlobalTargetSet(targets[1],AIMon())
    return true
  end
  if AI.GetCurrentPhase() == PHASE_BATTLE and Duel.GetTurnPlayer()==1-player_ai then
    local aimon,oppmon = GetBattlingMons()
    if WinsBattle(oppmon,aimon) 
    and aimon.id ~= 23899727 
    then
      GlobalTargetSet(aimon)
      return true
    end
  end
  targets = SubGroup(AIMon(),SpecterMechquippedFilter,15914410)
  if RemovalCheckCard(c) then
    BestTargets(targets,1,TARGET_PROTECT)
    GlobalTargetSet(targets[1],AIMon())
    return true
  end
--[[  targets = SubGroup(AIMon(),SpecterMechquippedFilter)
  if NegateCheckCard(c) then
    BestTargets(targets,1,TARGET_PROTECT)
    GlobalTargetSet(targets[1],AIMon())
    return true
  end]]
  targets = SubGroup(AIMon(),SpecterMechquippedFilter)
  if AI.GetCurrentPhase() == PHASE_BATTLE and Duel.GetTurnPlayer()==1-player_ai and CardsMatchingFilter(OppMon(),SpecterMechquippedFilter2)>0 then
    BestTargets(targets,1,TARGET_PROTECT)
	GlobalTargetSet(targets[1],AIMon())
	return true
  end
  return false
end

function SpecterMechquippedFilter(c)
  return CurrentOwner(c)==1
  and FilterType(c,TYPE_MONSTER)
  and FilterPosition(c,POS_FACEUP_ATTACK) 
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE)==0
  and c:is_affected_by(EFFECT_IMMUNE_EFFECT)==0
  and (id == nil or c.id~=id)
  and (c.id~=56832966 or (c.id==56832966 and c.xyz_material_count<2))
end

function SpecterMechquippedFilter2(c) --Index cards that prevent effects from being activated when they attack.
  return c.id==56421754
  or c.id==45349196
  or c.id==83866861
  or c.id==29357956
  or c.id==57477163
  or c.id==88033975
  or c.id==56832966
end

function SpecterChainUtopiaLightning()
  if EnableKozmoFunctions() then return false end
  if Duel.GetCurrentPhase() == PHASE_DAMAGE then
		local source = Duel.GetAttacker()
		local target = Duel.GetAttackTarget()
    if source and target then
      if source:IsControler(player_ai) then
        target = Duel.GetAttacker()
        source = Duel.GetAttackTarget()
      end
      if target:IsControler(player_ai)
      and source:IsPosition(POS_FACEUP_ATTACK)
	  and target:GetCode()==56832966 then
	   return true
	  end
	end
  end
 return false
end

function FaceupEnemiesFilter(c)
  return FilterPosition(c,POS_FACEUP)
end

function FaceupEnemies()
  return CardsMatchingFilter(OppMon(),FaceupEnemiesFilter)>0
end

function CrowAttack()
  return AI.GetCurrentPhase() == PHASE_MAIN1
  and GlobalBPAllowed
  and (AIGetStrongestAttack() > OppGetStrongestAttDef()
  or OppGetStrongestAttDef() < 1000)
  and (FaceupEnemies() or #OppMon()==0)
end

function MajesterAttack()
  return AI.GetCurrentPhase() == PHASE_MAIN1
  and GlobalBPAllowed
  and (AIGetStrongestAttack() > OppGetStrongestAttDef()
  or OppGetStrongestAttDef() < 1850
  or (FaceupEnemies() or #OppMon()==0))
end

function CrowChangeToAttack()
  return AI.GetCurrentPhase() == PHASE_MAIN1
  and GlobalBPAllowed
  and ((AIGetStrongestAttack() > OppGetStrongestAttDef() and #OppMon()==1) 
  or OppGetStrongestAttDef() < 1000)
  and (FaceupEnemies() or #OppMon()==0)
end

function CrowChangeToDefence()
  return AI.GetCurrentPhase() == PHASE_MAIN2 
  or not GlobalBPAllowed
end

function MajesterChangeToAttack()
  return AI.GetCurrentPhase() == PHASE_MAIN1
  and GlobalBPAllowed
  and ((AIGetStrongestAttack() > OppGetStrongestAttDef() and #OppMon()==1) 
  or OppGetStrongestAttDef() < 1850)
  and (FaceupEnemies() or #OppMon()==0)
end

function MajesterChangeToDefence()
  return AI.GetCurrentPhase() == PHASE_MAIN2
  or not GlobalBPAllowed
end

function CatChangeToDefence()
  return true
end

function HasSTempest()
  return HasID(UseLists({AIHand(),AIST()}),02572890,true)
end

function HasSTornado()
  return HasID(UseLists({AIHand(),AIST()}),36183881,true)
end

function HasSCyclone()
  return HasID(UseLists({AIHand(),AIST()}),49366157,true)
end

function HasSStorm()
  return HasID(UseLists({AIHand(),AIST()}),13972452,true)
end

function HasSCell()
  return HasID(UseLists({AIHand(),AIST()}),78949372,true)
end

function EnableRaidraptorFunctionsFilter(c)
  return IsSetCode(c.setcode,0xb7)
end

function EnableRaidraptorFunctions()
  return CardsMatchingFilter(UseLists({OppDeck(),OppGrave()}),EnableRaidRaptorFunctionsFilter)>=10
  or CardsMatchingFilter(UseLists({OppMon(),OppGrave()}),EnemyUltimateFalconFilter)>0
end

function EnemyUltimateFalconFilter(c)
  return c.id==86221741
  and NotNegated(c)
end

function EnemyUltimateFalconFirstTurn()
  return CardsMatchingFilter(OppMon(),EnemyUltimateFalconFilter)>0
  and Duel.GetTurnCount() == 1
end

function EnemyUltimateFalcon()
  return CardsMatchingFilter(OppMon(),EnemyUltimateFalconFilter)>0
end

function SummonUtopiaLightningFalcon()
  return EnemyUltimateFalcon()
  and AI.GetCurrentPhase() == PHASE_MAIN1
  and GlobalBPAllowed
end

function SummonUtopiaLightningFalconRoom()
  return SummonUtopiaLightningFalcon()
  and MakeRoom()
end

function UsedUtopiaLightningFilter(c)
  return c.id==56832966
  and c.xyz_material_count<2
end

function UsedUtopiaLightning()
  return CardsMatchingFilter(AIMon(),UsedUtopiaLightningFilter)>0
  and Duel.GetCurrentPhase() == PHASE_BATTLE
end

function UsedUtopiaLightning2()
  return CardsMatchingFilter(AIMon(),UsedUtopiaLightningFilter)>0
  and Duel.GetCurrentPhase() == PHASE_MAIN2
end

function EnemyGraveFalconRevival()
  return EnableRaidraptorFunctions()
  and HasID(OppGrave(),58988903,true)
  and HasID(OppGrave(),86221741,true)
  and not EnemyUltimateFalcon()
end

function SpecterRaidraptorSummonAbyss()
  return EnemyGraveFalconRevival()
  and FalconDestroyTalk
end

function SpecterRaidraptorSummonHeartland()
  return FalconReviveTalk
  and EnemyUltimateFalcon()
  and Duel.GetCurrentPhase() == PHASE_MAIN1
  and GlobalBPAllowed
  and HasID(AIExtra(),31437713,true)
end

function HeartlandRaidraptor(c)
  return c.attack>0
  and FilterPosition(c,POS_FACEUP_ATTACK)
end

function SpecterRaidraptorActivateHeartland()
  return OppGetStrongestAttDef() >= AIGetStrongestAttack()
  and FalconReviveTalk
  and EnemyUltimateFalcon()
  and CardsMatchingFilter(AIMon(),HeartlandRaidraptor)>0
  and Duel.GetCurrentPhase() == PHASE_MAIN1
  and GlobalBPAllowed
end

function ChainTempestLastStrix()
  local e
  for i=1,Duel.GetCurrentChain() do
    e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
    if e and e:GetHandler():GetCode()==97219708
	and e:GetHandlerPlayer()==1-player_ai then
	 return true
	end
  end
 return false
end

function ChainSCycloneLastStrix()
  return HasID(OppMon(),97219708,true)
  and CardsMatchingFilter(OppMon(),EnemyLastStrixSC)>0
  and Duel.GetTurnPlayer()==1-player_ai
  and UnchainableCheck(49366157)
end

function ChainSTornadoLastStrix()
  return HasID(OppMon(),97219708,true)
  and CardsMatchingFilter(OppMon(),EnemyLastStrixST)>0
  and Duel.GetTurnPlayer()==1-player_ai
  and UnchainableCheck(36183881)
end
  
function EnemyLastStrixSC(c)
  return SpecterCycloneFilter(c)
  and c.id==97219708
end
  
function EnemyLastStrixST(c)
  return SpecterTornadoFilter(c)
  and c.id==97219708
end

function EnableBAFunctionsFilter(c)
  return IsSetCode(c.setcode,0xb1)
end

function EnableBAFunctions()
  return CardsMatchingFilter(UseLists({OppMon(),OppDeck(),OppGrave(),OppBanish()}),EnableBAFunctionsFilter)>=10
end

function EnemyBATempest(c)
  return (c.id==83531441 or c.id==10802915)
  and FilterStatus(c,STATUS_SUMMONING)
end

function EnemyDante(c)
  return c.id==83531441
  and c.xyz_material_count>0
end

function EnemyASF(c)
  return c.id==58921041
  and FilterPosition(c,POS_FACEUP)
end

function EnemyHasASF()
  return CardsMatchingFilter(OppMon(),EnemyASF)>0
end

function EnemyHasDante()
  return CardsMatchingFilter(OppMon(),EnemyDante)>0
end

function ChainSTempestBA()
  if not EnableBAFunctions() then return false end
  if HasIDNotNegated(AIST(),36183881,true) then return false end
  if HasIDNotNegated(AIST(),49366157,true) then return false end
  if CardsMatchingFilter(OppMon(),EnemyBATempest)>0 then
    return true
  end
 return false
end

function ChainSTornadoDante()
  if not EnableBAFunctions() then return false end
  if HasSStorm() and not EnemyHasASF() and Duel.GetTurnPlayer()==player_ai then return false end
  if not HasIDNotNegated(AIST(),36183881,true) then return false end
  if EnemyHasDante() and Duel.GetTurnPlayer()==1-player_ai then
    return true
  end
  if EnemyHasDante() and not SpecterBACanGetAbyss() and Duel.GetTurnPlayer()==player_ai and MajestyCheck() then
    return true
  end
 return false
end

function ChainSCycloneDante()
  if not EnableBAFunctions() then return false end
  if ChainSTornadoDante() then return false end
  if HasSStorm() and not EnemyHasASF() and Duel.GetTurnPlayer()==player_ai then return false end
  if EnemyHasDante() and Duel.GetTurnPlayer()==1-player_ai then
    return true
  end
  if EnemyHasDante() and not SpecterBACanGetAbyss() and Duel.GetTurnPlayer()==player_ai and MajestyCheck() then
    return true
  end
 return false
end

function UseSStormDante()
  if not EnableBAFunctions() then return false end
  if EnemyHasDante() and not SpecterBACanGetAbyss() then
    return true
  end
 return false
end

function SpecterCanXYZLevel4()
  return (CardsMatchingFilter(AIMon(),LevelFourFieldCheck)>1
  or (CardsMatchingFilter(AIMon(),LevelFourFieldCheck)==1
  and (HasIDNotNegated(AIST(),76473843,true) or (HasID(AIHand(),76473843,true) and not FieldSpellNotActivatable()))
  or (CardsMatchingFilter(AIHand(),LevelFourFieldCheck)>0 and NormalSummonCheck(player_ai)))
  or (HasScales() and CardsMatchingFilter(UseLists({AIMon(),AIExtra(),AIHand()}),LevelFourFieldCheck)>1)
  or (HasID(AIHand(),31991800,true) and HasScales() and NormalSummonCheck(player_ai) and OPTCheck(31991800)))
end

function SpecterBACanGetAbyss()
  return SpecterCanXYZLevel4()
  and HasID(AIExtra(),21044178,true)
  and (XYZSummonOkay() or MakeRoom())
  and EnableBAFunctions()
  and DualityCheck()
end

function SpecterBASummonAbyss2()
  return SpecterBACanGetAbyss()
end

function SpecterBAAbyssKill()
  return SpecterBACanGetAbyss()
  and (UsableSCyclone() or UsableSStorm())
  and HasScales()
  and Duel.GetTurnCount() ~= SpecterGlobalPendulum
end

function SpecterBASummonAbyssRoom()
  return MakeRoom()
  and SpecterBACanGetAbyss()
end

function SpecterCodedTargets(c)
  if EnableBAFunctions() then
   return c.id==83531441
  end
  if EnableShadollFunctions() then
    if WindaLives() then
     return c.id==94977269
	end
  end
end

function WindaLives()
  return Duel.GetCurrentPhase() ~= PHASE_BATTLE
  and Duel.GetTurnPlayer()==1-player_ai
end

function SpecterBACanGetChidori()
  return SpecterCanXYZLevel4()
  and HasID(AIExtra(),22653490,true)
  and EnableBAFunctions()
  and (XYZSummonOkayWind() or MakeRoom())
  and DualityCheck()
  and OppDownBackrow()
  and EnemyHasDante()
  and not SpecterBAAbyssKill()
end

function SpecterBASummonChidori()
  return SpecterBACanGetChidori()
end

function SpecterBACanGetCastel()
  return SpecterCanXYZLevel4()
  and HasID(AIExtra(),82633039,true)
  and EnableBAFunctions()
  and (XYZSummonOkay() or MakeRoom())
  and DualityCheck()
  and EnemyHasDante()
  and not SpecterBAAbyssKill()
end

function SpecterBASummonCastel()
  return SpecterBACanGetCastel()
end

function SpecterBASummonCastelRoom()
  return MakeRoom()
  and SpecterBACanGetCastel()
end
  
function UsableSCycloneFilter(c)
  return (FilterLocation(c,LOCATION_HAND)
  or FilterLocation(c,LOCATION_SZONE)
  and not FilterStatus(c,STATUS_SET_TURN))
  and c.id==49366157
end

function UsableSCyclone()
  return CardsMatchingFilter(UseLists({AIHand(),AIST()}),UsableSCycloneFilter)>0
  and CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>0
end

function UsableSStorm()
  return HasID(AIHand(),13972452,true)
  and CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>0
end

function UsableSTornadoFilter(c)
  return c.id==36183881
  and FilterLocation(c,LOCATION_SZONE)
  and not FilterStatus(c,STATUS_SET_TURN)
end

function UsableSTornado()
  return CardsMatchingFilter(AIST(),UsableSTornadoFilter)>0
  and CardsMatchingFilter(AIMon(),SpecterMonsterFilter)>0
end

--[[function UsableSTornadoCrow()
  return CardsMatchingFilter(AIST(),UsableSTornadoFilter)>0
  and ]]

function SpecterDestroyCheckOpp(id,category) --Currently don't know how to make this check for public cards.
  if Duel.GetCurrentChain() == 0 then return false end
  local cat={CATEGORY_DESTROY,CATEGORY_TOGRAVE}
  if category then cat={category} end
  for i=1,#cat do
    for j=1,Duel.GetCurrentChain() do
      local ex,cg = Duel.GetOperationInfo(j,cat[i])
      if ex and CheckNegated(j) then
        if id==nil then 
          return cg
        end
        if cg and id~=nil and cg:IsExists(function(c) return c:IsControler(1-player_ai) and c:IsCode(id) end, 1, nil) then
          return true
        end
      end
    end
  end
  return false
end

function SpecterRemovalCheckOpp(id,category)
  if Duel.GetCurrentChain() == 0 then return false end
  local cat={CATEGORY_DESTROY,CATEGORY_REMOVE,CATEGORY_TOGRAVE,CATEGORY_TOHAND,CATEGORY_TODECK}
  if category then cat={category} end
  for i=1,#cat do
    for j=1,Duel.GetCurrentChain() do
      local ex,cg = Duel.GetOperationInfo(j,cat[i])
      if ex and CheckNegated(j) then
        if id==nil then 
          return cg
        end
        if cg and id~=nil and cg:IsExists(function(c) return c:IsControler(1-player_ai) and c:IsCode(id) end, 1, nil) then
          return true
        end
      end
    end
  end
  return false
end

function SpecterRhapsodyATKCheck()
  local cards=AIMon()
  if not HasID(UseLists({AIMon(),AIExtra()}),56832966,true) 
  and not HasID(AIExtra(),56832966,true) then
    for i=1,#cards do
      if bit32.band(cards[i].type,TYPE_XYZ)>0 and cards[i].attack+1200 > OppGetStrongestAttack() then
	    return true
	  end
	end
  end
 return false
end

function SpecterRhapsodyMP1Filter(c)
  if RhapsodyGospelMP1() then
    return c.id==06853254
  end
  if RhapsodyRRReturnMP1() then
    return c.id==30500113
  end
  if RhapsodyTasukeMP1() then
    return c.id==86039057
  end
  if RhapsodyIAvenger() then
    return c.id==85475641
  end
  if RhapsodyDirectProtectors() then
    return c.id==80208158
    or c.id==34620088
    or c.id==02830693
    or c.id==24212820
    or c.id==77462146
  end
  return c.id==34710660
  or c.id==04906301
  or c.id==93830681
  or c.id==27978707
  or c.id==27660735
  or c.id==62017867
  or c.id==82593786
  or c.id==50185950
end

function SpecterRhapsodyMP2Filter(c) --Come back to this later for Bujingi Hare conditions
  if HasID(OppGrave(),09411399,true) and HasID(OppDeck(),09411399,true) then
    return c.id==09411399
  end
  if RhapsodyCyclone() then
    return c.id==05133471
  end
  if RhapsodyRedice() then
    return c.id==85704698
  end
  if RhapsodySSScout() then
    return c.id==90727556
  end
  if RhapsodyTasukeMP2() then
    return c.id==86039057
  end
  return c.id==92826944
  or c.id==29904964
  or c.id==17502671
  or c.id==04081665
  or c.id==00128454
  or c.id==94919024
  or c.id==05818294
  or c.id==88940154
  or c.id==13521194
  or c.id==69723159
  or c.id==88728507
  or c.id==56574543
  or c.id==68819554
  or c.id==99315585
  or c.id==49919798
  or c.id==19310321
  or c.id==42551040
  or c.id==45705025
  or c.id==36704180
  or c.id==54320860
  or c.id==52158283
  or c.id==96427353
  or c.id==70124586
  or c.id==23857661
  or c.id==21767650
  or c.id==34710660
  or c.id==33145233
  or c.id==67489919
  or c.id==03580032
  or c.id==08903700
  or c.id==37984162
  or c.id==48427163
  or c.id==59640711
  or c.id==63821877
  or c.id==90432163
  or c.id==15981690
  or c.id==36426778
  or c.id==59463312
  or c.id==72291078
  or c.id==23893227
  or c.id==36736723
  or c.id==45206713
  or c.id==71039903
  or c.id==33245030
  or c.id==18988391
  or c.id==72413000
  or c.id==23740893
  or c.id==79234734
  or c.id==06853254
  or c.id==14816688
  or c.id==22842126
  or c.id==41201386
  or c.id==44771289
  or c.id==74335036
  or c.id==81994591
  or c.id==88204302
  or c.id==99330325
  or c.id==18803791
  or c.id==30392583
  or c.id==34834619
  or c.id==47435107
  or c.id==62835876
  or c.id==08437145
  or c.id==46008667
  or c.id==15155568
  or c.id==19254117
  or c.id==21648584
  or c.id==30500113
  or c.id==51606429
  or c.id==63227401
  or c.id==73694478
  or c.id==67381587
  or c.id==78474168
  or c.id==70043345
  or c.id==61257789
  or c.id==92418590
  or c.id==11366199
  or c.id==77121851
  or c.id==56174248
  or c.id==24861088
  or c.id==92572371
  or c.id==32623004
  or c.id==23571046
  or c.id==33420078
  or c.id==01357146
  or c.id==09742784
  or c.id==11747708
  or c.id==66853752
  or c.id==92901944
  or c.id==85475641
  or c.id==00286392
  or c.id==80208158
  or c.id==34620088
  or c.id==02830693
  or c.id==24212820
  or c.id==77462146
end

function RhapsodyCyclone()
  return (OPTCheck(53208660)
  or CardsMatchingFilter(AIST(),MagicianPendulumFilter)<2
  or HasIDNotNegated(AIST(),76473843,true)
  or HasIDNotNegated(AIST(),78949372,true))
  and HasID(OppGrave(),05133471,true)
end

function RhapsodyGospelMP1()
  return CardsMatchingFilter(OppMon(),FilterRace,RACE_DRAGON)>0
  and HasID(OppGrave(),06853254,true)
end

function RhapsodyRRReturnMP1()
  return CardsMatchingFilter(OppMon(),EnableRaidRaptorFunctionsFilter)>0
  and HasID(OppGrave(),30500113,true)
end

function RhapsodyRedice()
  return CardsMatchingFilter(OppMon(),SpecterSpeedroidTuners)==0
  and HasID(OppGrave(),85704698,true)
end

function SpecterSpeedroidTuners(c)
  return FilterType(c,TYPE_TUNER)
  and IsSetCode(c.setcode,0x2016)
end

function RhapsodyTasukeMP1()
  return #OppHand()==0
  and HasID(OppGrave(),86039057,true)
  and not TasukeOpponentActivated
end

function RhapsodyTasukeMP2()
  return HasID(OppGrave(),86039057,true)
  and not TasukeOpponentActivated
end

function TasukeOpponentCheck()
  local e
  for i=1,Duel.GetCurrentChain() do
    e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
    if e and e:GetHandler():GetCode()==86039057
	and e:GetHandlerPlayer()==1-player_ai 
	and CardsMatchingFilter(AIST(),VanityFilter)==0 then
	 return true
	end
  end
 return false
end

function RhapsodySSScout()
  return #OppST()==0
  and HasID(OppGrave(),90727556,true)
end

function RhapsodyIAvenger()
  return #OppHand()==0
  and HasID(OppGrave(),85475641,true)
  and #OppMon()>0
end

function RhapsodyDirectProtectors() --Imperfection, still needs to check if it would destroy monsters and then get direct attacks
  return #OppMon()==0
  and (HasID(OppGrave(),80208158,true)
  or HasID(OppGrave(),34620088,true)
  or HasID(OppGrave(),02830693,true)
  or HasID(OppGrave(),24212820,true)
  or HasID(OppGrave(),77462146,true))
end
  
--Is Kaeynn the Master Blacksmith really worth it? No, no it isn't.
--An exception for Soulbang Cannon will need to be added later.
--Interceptomato is not worth it.
--Is Overlay Eater really worth it?
--Is Spell Recycler really worth it?
--May add Void Seer to MP1 list later, under specific conditions.
--May add Destruction Sword Flash to MP1 list later, under specific conditions.
--Dice-Roll Battle would be a good target if this deck actually used synchros.
--Damage Diet would be a target if this deck actually inflicted effect damage.
--I think The Phantom Wing, The Phantom Fog Blade, and The Phantom Sword would just chain?
--Blaze Accelerator Reload would undoubtedly chain.
--Is D/D Rebuild really worth it?
--PSY-Frame Overload would just chain.
--Is Vampire Grace really worth it?
--Is InterplanetaryPurlyThornywhothehellcares Beast really worth it?
--Revival Rose is not worth it.
--Worm Yagan is not worth it.
--They can't conduct their battle phase against a Majespecter deck if they use Gogogo Gigas.
--Might need an exception for NoPenguin in MP1? Not like anyone actually knows how Penguin decks work.
--I guess Majosheldon could be an unknown Monarch card? Still not worth it.
--Naturia Pineapple is not worth it.
--Maybe Scrap Searcher should be hit during MP1, but I'll leave it at a MP2 monster for now.
--Naturia Ladybug is not worth it.
--Stardust Xiaolong is not worth it.
--Samsara Lotus MIGHT be worth it, but I'm not including it for now.
--Will add Stardust Dragon later.

--Look buddy, Rhapsody is at least 170 lines of code. If you think I'm about to sit here and label every single ID that I actually did use,
--then you're crazy. If you wish to seek them out easily, I searched "banish this card from your graveyard" first.
--After that, I searched "Special Summon this card from your graveyard."

function SpecterSummonRhapsodyMP1()
  return XYZSummonOkay()
  and Duel.GetCurrentPhase() == PHASE_MAIN1 and GlobalBPAllowed
  and CardsMatchingFilter(OppGrave(),SpecterRhapsodyMP1Filter)>0
  and SpecterRhapsodyATKCheck()
  and not SpecterSummonUtopiaLightning()
end

function SpecterSummonRhapsodyRoom()
  return MakeRoom()
  and Duel.GetCurrentPhase() == PHASE_MAIN1 and GlobalBPAllowed
  and CardsMatchingFilter(OppGrave(),SpecterRhapsodyMP1Filter)>0
  and SpecterRhapsodyATKCheck()
  and not SpecterSummonUtopiaLightning()
end

function SpecterSummonRhapsodyMP2()
  local cards=AIMon()
  if XYZSummonOkay()
  and SpecterMP2Check()
  and CardsMatchingFilter(OppGrave(),SpecterRhapsodyMP2Filter)>0 then
    for i=1,#cards do
	  if bit32.band(cards[i].type,TYPE_XYZ)>0 then
	    return true
	  end
	end
  end
 return false
end

function SpecterUseRhapsody()
  return true
end

function AngineerProtecting()
  local e
    for i=1,Duel.GetCurrentChain() do
    e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
    if e and e:GetHandler():GetCode()==15914410
	and e:GetHandlerPlayer()==player_ai then
	 return true
	end
  end
 return false
end

function EnemyHasStallFilter(c)
  if EnemyHasTraffic() then
    return c.id==46083380 and FilterPosition(c,POS_FACEUP)
  end
  if EnemyHasDoor() then
    return c.id==30606547 and FilterPosition(c,POS_FACEUP)
  end
  if EnemyHasMessenger() then
    return c.id==44656491 and FilterPosition(c,POS_FACEUP)
  end
  if EnemyHasInsectBarrier() then
    return c.id==23615409 and FilterPosition(c,POS_FACEUP)
  end
  return (c.id==72302403
  or c.id==58775978
  or c.id==18634367
  or c.id==93087299)
  and FilterPosition(c,POS_FACEUP)
end

function EnemyHasStall()
  return CardsMatchingFilter(OppST(),EnemyHasStallFilter)>0
  and AIGetStrongestAttack() > OppGetStrongestAttDef()
  and #AIMon()>2
  and CardsMatchingFilter(AIMon(),MajespecterAttack)>2
end

function MajespecterAttack(c)
  return FilterPosition(c,POS_FACEUP_ATTACK)
end

function EnemyHasTraffic()
  return HasID(OppST(),46083380,true)
  and #AIMon()>2
end

function EnemyHasDoor()
  return HasID(OppST(),30606547,true)
  and #AIMon()>3
end

function EnemyHasMessenger()
  return HasID(OppST(),44656491,true)
  and AIGetStrongestAttack() > 1500
end

function EnemyHasInsectBarrier()
  return HasID(OppST(),23615409,true)
  and CardsMatchingFilter(AIMon(),ConvertedInsects)>1
end

function ConvertedInsects(c)
  return FilterRace(c,RACE_INSECT)
end

--function EnemyHasMonsterStall()

function EnemyHasHeliosphere() --Implement monster stall
  return #AIHand()<=4
  and #OppMon()==1
  and HasID(OppMon(),51043053,true)
end

function UseDragonpitStall()
  return EnemyHasStall()
  and OPTCheck(51531505)
  and (not RaccoonHandCheck() or #AIMon()==5)
end

function UseDragonpitDestiny()
  return EnemyHasDestinyBoard()
  and OPTCheck(51531505)
  and not RaccoonHandCheck()
end

function EnemyHasDestinyBoardFilter(c) -- F I N A L
  return (c.id==94212438
  or c.id==31893528
  or c.id==67287533
  or c.id==94772232
  or c.id==30170981)
  and FilterPosition(c,POS_FACEUP)
end

function EnemyHasDestinyBoard()
  return CardsMatchingFilter(OppST(),EnemyHasDestinyBoardFilter)>1
end

function MajestyCrow()
  if OPTCheck(31991800) and HasID(AIDeck(),31991800,true) and NormalSummonCheck(player_ai) then return false end
  if EnableShadollFunctions()
  and HasID(AIDeck(),68395509,true)
  and HasID(AIDeck(),13972452,true) 
  and not WindaCheck() then
   return true
  end
 return false
end

function RaccoonAddCrow()
  return NeedsSStormOverSCyclone()
  and NormalSummonCheck(player_ai)
  and HasID(AIDeck(),68395509,true)
  and OPTCheck(68395509)
  and not HasID(AIHand(),68395509,true)
  and (not HasScales() or (HasID(AIExtra(),68395509,true) and HasScales()) or not WindaCheck())
end

function MajesterAddInsight()
  return CardsMatchingFilter(AIST(),MagicianPendulumFilter)==1
  and NoScales()
  and HasID(AIDeck(),72714461,true)
end

function MajesterAddPeasant()
  return HasID(AIST(),51531505,true)
  and (HasID(AIGrave(),51531505,true) or HasID(AIGrave(),72714461,true))
end
  
function SpecterInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  
  if HasIDNotNegated(Act,85252081,UseGranpulse) then
    return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(SpSum,62709239,InsightfulPhantomSummon) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(Act,62709239,InsightfulPhantomUse) then
	GlobalCardMode = 7
   return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasID(Sum,94784213,InsightfulFodderSummon) then  --Fox
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,68395509,InsightfulFodderSummon) then  --Crow
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,00645794,InsightfulFodderSummon) then  --Toad
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasIDNotNegated(Act,76473843,InsightfulMajesty,nil,LOCATION_SZONE,POS_FACEUP) then
    OPTSet(76473843)
	GlobalCardMode = 1
	return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasID(Sum,31991800,InsightfulRaccoonSummon) then
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,05506791,InsightfulCatSummon) then
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasIDNotNegated(Act,14920218,UsePeasantPendulum,nil,LOCATION_SZONE,POS_FACEUP) then
    OPTSet(14920218)
	return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,51531505,UseDragonpit,nil,LOCATION_SZONE,POS_FACEUP) then
    OPTSet(51531505)
	GlobalCardMode = 1
	return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,51531505,UseDragonpitVanitys,nil,LOCATION_SZONE,POS_FACEUP) then
    OPTSet(51531505)
	GlobalCardMode = 3
	return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,51531505,UseDragonpitStall,nil,LOCATION_SZONE,POS_FACEUP) then
    OPTSet(51531505)
	GlobalCardMode = 5
	return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,51531505,UseDragonpitDestiny,nil,LOCATION_SZONE,POS_FACEUP) then
    OPTSet(51531505)
	GlobalCardMode = 7
    return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,82633039,SpecterUseCastel,1322128625) then
    OPTSet(82633039)
	return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,62709239,SpecterUsePhantom) then
    GlobalCardMode = 1
    return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,62709239,SpecterUsePhantom3) then
    GlobalCardMode = 5
    return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,62709239,SpecterUsePhantom2) then
     GlobalCardMode = 3
	return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,93568288,SpecterUseRhapsody,1497092609) then
    return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,93568288,SpecterUseRhapsody,1497092608) then
    GlobalCardMode = 1
    return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(SpSum,56832966) and SummonUtopiaLightningFinish(SpSum[CurrentIndex],2) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,84013237) and SummonUtopiaLightningFinish(SpSum[CurrentIndex],1) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,31437713,SpecterSummonHeartlandFinish) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(Act,31437713,SpecterActivateHeartlandFinish) then
    return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,76473843,PlayMajesty,nil,LOCATION_HAND) then
    return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,13972452,UseSStorm4) then
    GlobalCardMode = 5
	return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,13972452,UseSStorm2) then
    GlobalCardMode = 1
    return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,13972452,UseSStorm3) then
    GlobalCardMode = 1
    return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,13972452,UseSStorm1) then
    GlobalCardMode = 1
    return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,13972452,UseSStormDante) then
    GlobalCardMode = 3
    return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,76473843,UseMajesty,nil,LOCATION_SZONE,POS_FACEUP) then
    OPTSet(76473843)
	return COMMAND_ACTIVATE,CurrentIndex
  end
  
  if HasIDNotNegated(SpSum,56832966,SummonUtopiaLightningFalcon) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,84013237,SummonUtopiaLightningFalcon) then
    return SpecterXYZSummon()
  end
  
  if HasIDNotNegated(SpSum,22653490,SpecterSummonChidori2) then
    return SpecterXYZSummon()
  end
  
  if HasIDNotNegated(SpSum,85252081,SummonGranpulse) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,85252081,SummonGranpulse2) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,62709239,SpecterSummonPhantom) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,62709239,SpecterSummonPhantom2) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,62709239,SpecterSummonPhantom3) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,85252081,SummonGranpulse3) then
    return SpecterXYZSummon()
  end
  
  if HasIDNotNegated(Act,72714461,UseInsight,nil,LOCATION_SZONE,nil) then
    return COMMAND_ACTIVATE,CurrentIndex
  end
  
  if HasID(Sum,31991800,SummonRaccoon4) then
    return COMMAND_SUMMON,CurrentIndex
  end
  
  if HasID(Sum,31991800,SummonRaccoon3) then
    return COMMAND_SUMMON,CurrentIndex
  end
  
  if HasID(Sum,94784213,SummonFox3) then
    return COMMAND_SUMMON,CurrentIndex
  end
  
  if HasID(Sum,05506791,SummonCat3) then
    return COMMAND_SUMMON,CurrentIndex
  end
  
  if HasID(Sum,68395509,SummonCrow3) then
    return COMMAND_SUMMON,CurrentIndex
  end

  if HasID(Sum,00645794,SummonToad3) then
    return COMMAND_SUMMON,CurrentIndex
  end
  
  if HasIDNotNegated(SpSum,84013237,SpecterKozmoSummonUtopiaLightningRoom) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,15914410,SpecterKozmoSummonMechquippedRoom) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,21044178,SpecterShadollSummonAbyssRoom) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,84013237,SummonUtopiaLightningFalconRoom) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,21044178,SpecterBASummonAbyssRoom) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,82633039,SpecterBASummonCastelRoom) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,71068247,SummonTotemBirdRoom) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,82633039,SpecterSummonCastelRoom) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,84013237,SpecterSummonUtopiaLightningRoom) then --I'm sure this won't be a problem in the slightest.
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,93568228,SpecterSummonRhapsodyRoom) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,88722973,SpecterSummonMajesterRoom) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,15914410,SpecterSummonMechquippedRoom) then
    return SpecterXYZSummon()
  end
  
  for i=1,#SpSum do
    if PendulumCheck(SpSum[i]) and SpecterPendulumSummon() and WorthPendulumSummoning() then
      GlobalPendulumSummoningSpecter = true
      SpecterGlobalPendulum=Duel.GetTurnCount()
      return COMMAND_SPECIAL_SUMMON,i
    end
  end
  
  if HasID(Act,53208660,UsePendulumCallSpecter) then
    OPTSet(53208660)
	GlobalCardMode = 1
	return COMMAND_ACTIVATE,CurrentIndex
  end
  
  if HasID(Act,53208660,UsePendulumCallScaleReplaceSpecter) then
    OPTSet(53208660)
	GlobalCardMode = 1
    return COMMAND_ACTIVATE,CurrentIndex
  end
  
  --Pendulum activations
  if WorthPendulumActivation() then
    if HasID(Act,72714461,PlayInsight3,nil,LOCATION_HAND) then
	  return COMMAND_ACTIVATE,CurrentIndex
    elseif HasID(Act,72714461,PlayInsight1,nil,LOCATION_HAND) then
	  return COMMAND_ACTIVATE,CurrentIndex
    elseif HasID(Act,51531505,PlayDragonpit,nil,LOCATION_HAND) then
      return COMMAND_ACTIVATE,CurrentIndex
	elseif HasID(Act,72714461,PlayInsight2,nil,LOCATION_HAND) then
	  return COMMAND_ACTIVATE,CurrentIndex
    elseif HasID(Act,00645794,PlayToad,nil,LOCATION_HAND) then
      return COMMAND_ACTIVATE,CurrentIndex
    elseif HasID(Act,68395509,PlayCrow,nil,LOCATION_HAND) then
      return COMMAND_ACTIVATE,CurrentIndex
    elseif HasID(Act,31991800,PlayRaccoon,nil,LOCATION_HAND) then
      return COMMAND_ACTIVATE,CurrentIndex
    elseif HasID(Act,15146890,PlayDragonpulse,nil,LOCATION_HAND) then
      return COMMAND_ACTIVATE,CurrentIndex
	elseif HasID(Act,14920218,PlayPeasant,nil,LOCATION_HAND) then
	  return COMMAND_ACTIVATE,CurrentIndex
    elseif HasID(Act,05506791,PlayCat,nil,LOCATION_HAND) then
      return COMMAND_ACTIVATE,CurrentIndex
    elseif HasID(Act,94784213,PlayFox,nil,LOCATION_HAND) then
      return COMMAND_ACTIVATE,CurrentIndex
    end
  end
  
  if HasID(Sum,31991800,SummonRaccoon1) then
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,94784213,SummonFox1) then
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,05506791,SummonCat1) then
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,68395509,SummonCrow1) then
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,00645794,SummonToad1) then
    return COMMAND_SUMMON,CurrentIndex
  end
  
  
  if HasID(Sum,31991800,SummonRaccoon2) then
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,94784213,SummonFox2) then
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,05506791,SummonCat2) then
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,68395509,SummonCrow2) then
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,00645794,SummonToad2) then
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,15146890,SummonDragonpulse) then
    return COMMAND_SUMMON,CurrentIndex
  end
  if HasID(Sum,72714461,SummonInsight) then
    return COMMAND_SUMMON,CurrentIndex
  end
  
  if HasID(SetMon,72714461,SetInsight) then
    return COMMAND_SET_MONSTER,CurrentIndex
  end
  
  if HasIDNotNegated(SpSum,21044178,SpecterRaidraptorSummonAbyss) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,31437713,SpecterRaidraptorSummonHeartland) then
    AITrashTalk("Don't misunderstand my feelings due to all of this wisecrack; you are killing me right now.")
	return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,18326736,SpecterPtolemaeusSummon) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,22653490,SpecterBASummonChidori) then
    AITrashTalk("This is the chi to victory!")
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,82633039,SpecterBASummonCastel) then
    AITrashTalk("I will Castel you into the abyss!")
	return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,21044178,SpecterBASummonAbyss) then
    AITrashTalk("I have my own Abyss as well. It's a little watered down, mind you.")
	return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,21044178,SpecterBASummonAbyss2) then
    AITrashTalk("I have my own Abyss as well. It's a little watered down, mind you.")
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,71068247,SummonTotemBird) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,56832966,SpecterKozmoSummonUtopiaLightning) then
    AITrashTalk("I see that your monsters are made up of Kozmolecules.")
	return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,84013237,SpecterKozmoSummonUtopiaLightning) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,15914410,SpecterKozmoSummonMechquipped) then
    AITrashTalk("You've forced me to switch to my Kozmode.")
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,15914410,SpecterSummonMechquipped) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,15914410,SpecterSummonMechquipped2) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,52558805,SpecterSummonTemtempo) then
    AITrashTalk("Now try to keep up with this Temtemporary summon!")
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,22653490,SpecterSummonChidori,1) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,22653490,SpecterSummonChidori,2) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,82633039,SpecterSummonCastel) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,56832966) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,56832966,SpecterSummonUtopiaLightning) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,84013237,SpecterSummonUtopiaLightning) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,21044178,SpecterBlueSummonAbyss) then
    AITrashTalk("You're looking a little Blue-Eyes there. Want to talk about it?")
	AITrashTalk("Well, too bad. I'm the equivalent of talking to a Wall-E.")
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,21044178,SpecterShadollSummonAbyss) then
    AITrashTalk("I will send you to The Shadoll Realm. Do you think that joke is too easy?")
	return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,31437713,SpecterSummonHeartland) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,88722973,SpecterSummonMajester1) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,88722973,SpecterSummonMajester2) then
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,93568288,SpecterSummonRhapsodyMP1) then
    AITrashTalk("I always enjoy a good Rhapsoda in the morning.")
    return SpecterXYZSummon()
  end
  if HasIDNotNegated(SpSum,93568288,SpecterSummonRhapsodyMP2) then
    AITrashTalk("I always enjoy a good Rhapsoda in the morning.")
    return SpecterXYZSummon()
  end
  
  if HasIDNotNegated(Rep,68395509,CrowChangeToDefence,nil,LOCATION_MZONE,POS_FACEUP_ATTACK) then
    return COMMAND_CHANGE_POS,CurrentIndex
  end
  if HasIDNotNegated(Rep,68395509,CrowChangeToAttack,nil,LOCATION_MZONE,POS_FACEUP_DEFENCE) then
    return COMMAND_CHANGE_POS,CurrentIndex
  end
  if HasIDNotNegated(Rep,88722973,MajesterChangeToDefence,nil,LOCATION_MZONE,POS_FACEUP_ATTACK) then
    return COMMAND_CHANGE_POS,CurrentIndex
  end
  if HasIDNotNegated(Rep,88722973,MajesterChangeToAttack,nil,LOCATION_MZONE,POS_FACEUP_DEFENCE) then
    return COMMAND_CHANGE_POS,CurrentIndex
  end
  if HasIDNotNegated(Rep,05506791,CatChangeToDefence,nil,LOCATION_MZONE,POS_FACEUP_ATTACK) then
    return COMMAND_CHANGE_POS,CurrentIndex
  end
  
  if HasID(SetST,53208660,SetPendulumCall) then
    return COMMAND_SET_ST,CurrentIndex
  end
  if HasID(SetST,43898403,SetTwinTwister) then
    return COMMAND_SET_ST,CurrentIndex
  end
  if HasID(SetST,13972452,SetSStorm) then
    return COMMAND_SET_ST,CurrentIndex
  end
  if HasID(SetST,49366157,SetSCyclone) then
    return COMMAND_SET_ST,CurrentIndex
  end
  if HasID(SetST,36183881,SetSTornado) then
    return COMMAND_SET_ST,CurrentIndex
  end
  if HasID(SetST,05650082,SetStormingMirror) then
    return COMMAND_SET_ST,CurrentIndex
  end
  if HasID(SetST,05851097,SetVanity) then
    return COMMAND_SET_ST,CurrentIndex
  end
  if HasID(SetST,02572890,SetSTempest) then
    return COMMAND_SET_ST,CurrentIndex
  end
  if HasID(SetST,78949372,SetSCell) then
    return COMMAND_SET_ST,CurrentIndex
  end
  
  if HasIDNotNegated(Act,31437713,SpecterRaidraptorActivateHeartland) and HeartlandTalk and not HeartlandTalk2 then
    HeartlandTalk2 = true
	AITrashTalk("Hey buddy, did you let this live just so you could hear another pun?")
	AITrashTalk("Alright, here's my last one: that card is Falcondescending.")
	return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,31437713,SpecterRaidraptorActivateHeartland) and not HeartlandTalk then
    HeartlandTalk = true
    AITrashTalk("If you keep this up, I will eventually run out of puns.")
	AITrashTalk("That wouldn't be good for the Falconomy, would it?")
	return COMMAND_ACTIVATE,CurrentIndex
  end
  if HasIDNotNegated(Act,31437713,SpecterActivateHeartland) then
    return COMMAND_ACTIVATE,CurrentIndex
  end
end

--You've gotta BE the targeting, Squidward!

function SpecterRhapsodyTarget(cards)
  if LocCheck(cards,LOCATION_OVERLAY) then
    return Add(cards,PRIO_TOGRAVE)
  elseif GlobalCardMode == 1 then
    GlobalCardMode = nil
	return BestTargets(cards) 
  elseif Duel.GetCurrentPhase() == PHASE_MAIN1 then
    return BestTargets(cards,1,PRIO_BANISH,SpecterRhapsodyMP1Filter)
  elseif Duel.GetCurrentPhase() == PHASE_MAIN2 then
    return BestTargets(cards,1,PRIO_BANISH,SpecterRhapsodyMP2Filter)
  end
 return BestTargets(cards)
end

function InsightfulMajestyTarget(cards)
  if LocCheck(cards,LOCATION_DECK) then
    return BestTargets(cards,1,PRIO_TOFIELD,InsightfulLevel3Filter)
  end
 return BestTargets(cards,1,PRIO_BANISH,InsightfulMajestyFilter)
end

function MajestyTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
   return InsightfulMajestyTarget(cards)
  end
  if LocCheck(cards,LOCATION_DECK) then
    if MajestyCrow() then
	  return FindID(68395509,cards,true)
	end
	return Add(cards,PRIO_TOFIELD)
  end
 return Add(cards,PRIO_BANISH)
end

function SpecterPtolemaeusTarget(cards)
  if EndPhasePtolemaeus() then
   return FindID(09272381,cards,true)
  else
   return FindID(34945480,cards,true)
 end
end

function RaccoonTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return RaccoonAdd(cards,1)
  elseif RaccoonAddCrow() then
    return FindID(68395509,cards,true)
  else
   return Add(cards,PRIO_TOHAND)
  end
end

function CatTarget(cards)
  if (NeedsScale2() or NeedsScale5()) and HasID(AIDeck(),31991800,true) then
    return FindID(31991800,cards,true)
  elseif HasScales() and NeedsRaccoon() and HasID(AIDeck(),31991800,true) then
    return FindID(31991800,cards,true)
  elseif HasScales() then
    return BestTargets(cards,1,PRIO_TOHAND,SpecterMonsterFilter)
  else
    return BestTargets(cards,1,PRIO_TOHAND,SpecterMonsterFilter)
  end
end

function InsightTarget(cards)
  if HasID(AIST(),15146890,true) and not HasID(AIST(),51531505,true) and HasID(AIDeck(),51531505,true) then
    return FindID(51531505,cards,true)
  elseif HasID(AIST(),51531505,true) and not HasID(AIST(),15146890,true) and HasID(AIDeck(),15146890,true) then
    return FindID(15146890,cards,true)
  elseif HasID(AIST(),51531505,true) and not HasID(AIST(),14920218,true) and HasID(AIDeck(),14920218,true) then
    return FindID(14920218,cards,true)
  elseif HasID(AIST(),14920218,true) and not HasID(AIST(),51531505,true) and HasID(AIDeck(),14920218,true) then
    return FindID(51531505,cards,true)
  end
 return {math.random(#cards)}
end

function SCellTarget(cards,min,max)
  return Add(cards,PRIO_TOHAND,math.max(min,math.min(3,max)))
end

function SCycloneTarget(cards)
  if GlobalCardMode == 13 then
    GlobalCardMode = 12
	return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 12 then
    GlobalCardMode = nil
	return FindID(83531441,cards,true)
  elseif GlobalCardMode == 11 then
    GlobalCardMode = 10
    return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 10 then
    GlobalCardMode = nil
	return FindID(97219708,cards,true)
  elseif GlobalCardMode == 9 then
    GlobalCardMode = 8
	return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 8 then
    GlobalCardMode = nil
	return FindID(70791313,cards,true)
  elseif GlobalCardMode == 7 then
    GlobalCardMode = 6
    return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 6 then
    GlobalCardMode = nil
    return BestTargets(cards,1,TARGET_DESTROY)
  elseif GlobalCardMode == 5 then
     GlobalCardMode = 4
	return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 4 then
     GlobalCardMode = nil
	return FindID(50720316,cards,true)
  elseif GlobalCardMode == 3 then
     GlobalCardMode = 2
    return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 2 then
     GlobalCardMode = nil
	return BestTargets(cards,1,TARGET_DESTROY,SpecterCycloneFilter2)
  elseif GlobalCardMode == 1 then
     GlobalCardMode = nil
	return BestTargets(cards,1,PRIO_BANISH)
  else
    return BestTargets(cards,1,TARGET_DESTROY,SpecterCycloneFilter)
  end
end

function STornadoTarget(cards)
  if GlobalCardMode == 13 then
    GlobalCardMode = 12
	return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 12 then
    GlobalCardMode = nil
	return FindID(83531441,cards,true)
  elseif GlobalCardMode == 11 then
    GlobalCardMode = 10
    return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 10 then
    GlobalCardMode = nil
	return FindID(97219708,cards,true)
  elseif GlobalCardMode == 9 then
    GlobalCardMode = 8
	return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 8 then
    GlobalCardMode = nil
	return FindID(70791313,cards,true)
  elseif GlobalCardMode == 7 then
    GlobalCardMode = 6
    return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 6 then
    GlobalCardMode = nil
    return BestTargets(cards,1,TARGET_BANISH)
  elseif GlobalCardMode == 5 then
     GlobalCardMode = 4
	return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 4 then
     GlobalCardMode = nil
	return FindID(50720316,cards,true)
  elseif GlobalCardMode == 3 then
     GlobalCardMode = 2
    return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 2 then
     GlobalCardMode = nil
	return BestTargets(cards,1,TARGET_BANISH,SpecterTornadoFilter2)
  elseif GlobalCardMode == 1 then
     GlobalCardMode = nil
	return BestTargets(cards,1,PRIO_BANISH)
  else
    return BestTargets(cards,1,TARGET_BANISH,SpecterTornadoFilter)
  end
end

function SStormTarget(cards)
  if GlobalCardMode == 5 then
    GlobalCardMode = 4
	return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 4 then
    GlobalCardMode = nil
	return BestTargets(cards,1,TARGET_TODECK,SStormFilter4)
  elseif GlobalCardMode == 3 then
    GlobalCardMode = 2
	return BestTargets(cards,1,PRIO_BANISH)
  elseif GlobalCardMode == 2 then
    GlobalCardMode = nil
    return FindID(83531443,cards,true)
  elseif GlobalCardMode == 1 then
     GlobalCardMode = nil
	return BestTargets(cards,1,PRIO_BANISH)
  end
 return BestTargets(cards,1,TARGET_TODECK)
end

function SpecterTemtempoTarget(cards)
  if GlobalCardMode == 10 then
     GlobalCardMode = 9
	return Add(cards,PRIO_TOGRAVE)
  elseif GlobalCardMode == 9 then
     GlobalCardMode = nil
	return BestTargets(cards,1,TARGET_OTHER)
  elseif GlobalCardMode == 8 then
     GlobalCardMode = 7
	return Add(cards,PRIO_TOGRAVE)
  elseif GlobalCardMode == 7 then
     GlobalCardMode = nil
	return BestTargets(cards,1,TARGET_OTHER,SpecterTemtempoFilter4)
  elseif GlobalCardMode == 6 then
     GlobalCardMode = 5
	return Add(cards,PRIO_TOGRAVE)
  elseif GlobalCardMode == 5 then
     GlobalCardMode = nil
    return BestTargets(cards,1,TARGET_OTHER,SpecterTemtempoFilter3)
  elseif GlobalCardMode == 4 then
     GlobalCardMode = 3
	return Add(cards,PRIO_TOGRAVE)
  elseif GlobalCardMode == 3 then
    GlobalCardMode = nil
	return BestTargets(cards,1,TARGET_OTHER,SpecterTemtempoFilter2)
  elseif GlobalCardMode == 2 then
     GlobalCardMode = 1
	return Add(cards,PRIO_TOGRAVE)
  elseif GlobalCardMode == 1 then
     GlobalCardMode = nil
	return BestTargets(cards,1,TARGET_OTHER,SpecterTemtempoFilter1)
  end
 return BestTargets(cards,1,TARGET_TOGRAVE)
end

function SpecterPhantomTarget(cards)
  if LocCheck(cards,LOCATION_OVERLAY) then
    return Add(cards,PRIO_TOGRAVE)
  elseif GlobalCardMode == 7 then
    GlobalCardMode = 6
    return BestTargets(cards,1,PRIO_BANISH,InsightfulPhantomAllyFilter)
  elseif GlobalCardMode == 6 then
    GlobalCardMode = nil
	return BestTargets(cards,1,TARGET_DESTROY,InsightfulPhantomEnemyFilter)
  elseif GlobalCardMode == 5 then
    GlobalCardMode = 4
	return BestTargets(cards,1,PRIO_BANISH,AllyPhantomFilter3)
  elseif GlobalCardMode == 4 then
    GlobalCardMode = nil
	return BestTargets(cards,1,TARGET_DESTROY,SpecterPhantomFilter2)
  elseif GlobalCardMode == 3 then
    GlobalCardMode = 2
	return BestTargets(cards,1,PRIO_BANISH,AllyPhantomFilter2)
  elseif GlobalCardMode == 2 then
    GlobalCardMode = nil
	return BestTargets(cards,1,TARGET_DESTROY,SpecterPhantomFilter2)
  elseif GlobalCardMode == 1 then
     GlobalCardMode = nil
	return BestTargets(cards,1,PRIO_BANISH,AllyPhantomFilter)
  else
    return BestTargets(cards,1,TARGET_DESTROY,SpecterPhantomFilter)
  end
end

function SpecterMajesterTarget(cards)
  if MajesterAddInsight() then
    return FindID(72714461,cards,true)
  elseif NeedsRaccoon() or (NeedsScale5() and not NeedsScale2()) or (NeedsScale2() and not NeedsScale5()) then
    return FindID(31991800,cards,true)
  elseif NeedsSStormOverSCyclone() and HasID(AIDeck(),68395509,true) and not HasID(AIST(),36183881,true) then
    return FindID(68395509,cards,true)
  elseif NeedsFox() then
    return FindID(94784213,cards,true)
  elseif MajesterAddPeasant() then
    return FindID(14920218,cards,true)
  else
    return BestTargets(cards,1,PRIO_BANISH,SpecterMonsterFilter)
  end
end
  

function GranpulseTarget(cards)
  if LocCheck(cards,LOCATION_OVERLAY) then
    return Add(cards,PRIO_TOGRAVE)
  elseif CardsMatchingFilter(OppST(),OppDownBackrowFilter)>0 and Duel.GetTurnCount() ~= SpecterGlobalPendulum and HasScales() then
    return BestTargets(cards,1,true,OppDownBackrowFilter)
  elseif CardsMatchingFilter(OppST(),GranpulseFilter)>0 and Duel.GetTurnCount() == SpecterGlobalPendulum and OppHasScales() then
    return BestTargets(cards,1,true,GranpulseFilter)
  elseif EnemyHasDestinyBoard() then
    return BestTargets(cards,1,TARGET_DESTROY,EnemyHasDestinyBoardFilter)
  elseif EnemyHasStall() then
    return BestTargets(cards,1,TARGET_DESTROY,EnemyHasStallFilter)
  elseif CardsMatchingFilter(OppST(),OppBackrowFilter)>0 and Duel.GetTurnCount() == SpecterGlobalPendulum then
    return BestTargets(cards,1,true,OppBackrowFilter)
  end
 return BestTargets(cards,1,TARGET_DESTROY)
end

function DragonpitTarget(cards)
  if GlobalCardMode == 7 then
    GlobalCardMode = 6
	return DragonpitDiscardLogic(cards)
  elseif GlobalCardMode == 6 then
    GlobalCardMode = nil
	return BestTargets(cards,1,TARGET_DESTROY,EnemyHasDestinyBoardFilter)
  elseif GlobalCardMode == 5 then
    GlobalCardMode = 4
	return DragonpitDiscardLogic(cards)
  elseif GlobalCardMode == 4 then
    GlobalCardMode = nil
	return BestTargets(cards,1,TARGET_DESTROY,EnemyHasStallFilter)
  elseif GlobalCardMode == 3 then
    GlobalCardMode = 2
   return DragonpitDiscardLogic(cards)
  elseif GlobalCardMode == 2 then
    GlobalCardMode = nil
   return BestTargets(cards,1,TARGET_DESTROY,DragonpitVanitysTargetFilter)
  elseif GlobalCardMode == 1 then
    GlobalCardMode = nil
   return DragonpitDiscardLogic(cards)
  end
 return BestTargets(cards,1,TARGET_DESTROY,OppDownBackrowFilter)
end

function DragonpitDiscardLogic(cards)
  if CardsMatchingFilter(AIHand(),MagicianPendulumFilter)>0 then
    return Add(cards,PRIO_TOGRAVE)
  elseif HasID(AIHand(),00645794,true) then
    return BestTargets(cards,1,nil,function(c) return c.id==00645794 end)
  elseif HasID(AIHand(),05506791,true) then
    return BestTargets(cards,1,nil,function(c) return c.id==05506791 end)
  elseif HasID(AIHand(),68395509,true) then
    return BestTargets(cards,1,nil,function(c) return c.id==68395509 end)
  else
    return Add(cards,PRIO_TOGRAVE)
  end
end


function FoxTarget(cards) --Fox just really wants to give a targeting error. What better solution than to force targets?
  if EnableKozmoFunctions() and HasID(AIDeck(),02572890,true) then
    return FindID(02572890,cards,true)
--[[  elseif not HasSTempest() then
    return FindID(02572890,cards,true)
  elseif not HasSTornado() then
    return FindID(36183881,cards,true)
  elseif not HasSCell() then
    return FindID(78949372,cards,true)]]
  elseif SpecterPriorityCheck(AIDeck(),PRIO_TOHAND,1,SpecterTrapPriorityFilter)>1 then
    return Add(cards,PRIO_TOHAND)
  end
 return {math.random(#cards)}
end

function CrowTarget(cards)
  if NeedsSStormOverSCyclone() then
    return FindID(13972452,cards,true)
  elseif SpecterPriorityCheck(AIDeck(),PRIO_TOHAND,1,SpecterSpellPriorityFilter)>1 then
    return Add(cards,PRIO_TOHAND)
  end
 return {math.random(#cards)}
end

function ToadTarget(cards)
  if EnableKozmoFunctions() and HasID(AIDeck(),02572890,true) then
    return FindID(02572890,cards,true)
--[[  elseif not HasSTempest() then
    return FindID(02572890,cards,true)
  elseif not HasSTornado() then
    return FindID(36183881,cards,true)
  elseif not HasSCell() then
    return FindID(78949372,cards,true)]]
  elseif SpecterPriorityCheck(AIDeck(),PRIO_TOFIELD,1,SpecterTrapPriorityFilter)>1 then
    return Add(cards,PRIO_TOFIELD)
  elseif SpecterPriorityCheck(AIDeck(),PRIO_TOFIELD,1,SpecterSpellPriorityFilter)>1 then
    return Add(cards,PRIO_TOFIELD)
  end
 return {math.random(#cards)}
end

function SpecterCallToGravePriority(card) --Choose which card is best for Pendulum Call's discard effect.
  local id=card.id
  if id==53208660 then --Pendulum Call duplicate
    return 10
  end
  if id==76473843 and MajestyDiscardAvailable() then --Field Spell
    return 9
  end
  if id==51531505 then --Dragonpit 8
    return 8
  end
  if id==15146890 then --Dragonpulse 1
    return 4
  end
  if id==14920218 then --Peasant 2
    return 2
  end
  if id==13972452 then --Specter Storm
    return 6
  end
  if id==19665973 then --Fader
    return 3
  end
  if id==02572890 then --Tempest
    return 1
  end
  if id==36183881 then --Tornado
    return 5
  end
  if id==49366157 then --SCyclone
    return 7
  end
  if id==72714461 then --Insight
    return 4
  end
 return GetPriority(card,PRIO_TOGRAVE)
end
  
function SpecterCallDiscardAssignPriority(cards,toLocation)
  local func = nil
  if toLocation==LOCATION_GRAVE then
    func = SpecterCallToGravePriority
  end
  for i=1,#cards do
    cards[i].priority=func(cards[i])
  end
end

function SpecterCallDiscardToGrave(cards,amount) --Discard for Pendulum Call
  local result = {}
  for i=1,#cards do
    cards[i].index=i
  end
  SpecterCallDiscardAssignPriority(cards,LOCATION_GRAVE)
  table.sort(cards,function(a,b) return a.priority>b.priority end)
  for i=1,amount do
    result[i]=cards[i].index
  end
  if result == nil then result = Add(cards,PRIO_TOGRAVE) end
  return result
end

function SpecterPendulumCallTarget(cards) --Xaddgx
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return SpecterCallDiscardToGrave(cards,1)
  else
   return Add(cards,PRIO_TOHAND)
  end
end

function RaccoonAddPriority(card) --Choose which card is best for Raccoon's add effect.
  local id=card.id
  if NeedsScale5() then
    if id==00645794 then --Toad
      return 10
    elseif id==68395509 then --Crow
	  return 9
	elseif id==31991800 then --Raccoon
	  return 8
	end
  end
  if NeedsScale2() then
    if id==05506791 then --Cat
	  return 10
	elseif id==94784213 then --Fox
	  return 9
	end
  end
 return GetPriority(card,PRIO_TOHAND)
end
  
function RaccoonAddAssignPriority(cards,toLocation)
  local func = nil
  if toLocation==LOCATION_HAND then
    func = RaccoonAddPriority
  end
  for i=1,#cards do
    cards[i].priority=func(cards[i])
  end
end

function RaccoonAdd(cards,amount)
  local result = {}
  for i=1,#cards do
    cards[i].index=i
  end
  RaccoonAddAssignPriority(cards,LOCATION_HAND)
  table.sort(cards,function(a,b) return a.priority>b.priority end)
  for i=1,amount do
    result[i]=cards[i].index
  end
  return result
end

function CatAddPriority(card) --Choose which card is best for Cat's add effect.
  local id=card.id
  if id==31991800 then --Raccoon
    return 10
  end
 return GetPriority(card,PRIO_TOHAND)
end
  
function CatAddAssignPriority(cards,toLocation)
  local func = nil
  if toLocation==LOCATION_HAND then
    func = CatAddPriority
  end
  for i=1,#cards do
    cards[i].priority=func(cards[i])
  end
end

function CatAdd(cards,amount)
  local result = {}
  for i=1,#cards do
    cards[i].index=i
  end
  CatAddAssignPriority(cards,LOCATION_HAND)
  table.sort(cards,function(a,b) return a.priority>b.priority end)
  for i=1,amount do
    result[i]=cards[i].index
  end
  return result
end

function InsightMagicianPriority(card) --Choose which card is best for Insight's effect.
  local id=card.id
  if id==51531505 then 
    if (HasID(AIST(),15146890,true) or HasID(AIST(),14920218,true)) then
    return 10
   else
    return 2
	end
  end
  if id==15146890 then
    if HasID(AIST(),51531505,true) then
    return 8
   else
    return 3
	end
  end
  if id==14920218 then
    if HasID(AIST(),51531505,true) then
	return 9
   else
    return 4
   end
 end
 return GetPriority(card,PRIO_TOGRAVE)
end
  
function InsightMagicianAssignPriority(cards,toLocation)
  local func = nil
  if toLocation==LOCATION_GRAVE then
    func = InsightMagicianPriority
  end
  for i=1,#cards do
    cards[i].priority=func(cards[i])
  end
end

function InsightMagicianTargeting(cards,amount)
  local result = {}
  for i=1,#cards do
    cards[i].index=i
  end
  InsightMagicianPriority(cards,LOCATION_GRAVE)
  table.sort(cards,function(a,b) return a.priority>b.priority end)
  for i=1,amount do
    result[i]=cards[i].index
  end
  return result
end

function SpecterPeasantTargeting(cards) --Applies to both effects
  if id==72714461 and NormalSummonCheck(player_ai) and Duel.GetTurnCount() == SpecterGlobalPendulum then
    return FindID(72714461,cards,true)
  elseif id==51531505 and OPTCheck(51531505) and HasID(AIST(),51531505,true) then
    return FindID(51531505,cards,true)
  elseif id==15146890 then
    return FindID(15146890,cards,true)
  end
 return Add(cards,PRIO_TOHAND)
end

function SpecterCard(cards,min,max,id,c,minTargets,maxTargets,triggeringID,triggeringCard)
  if GlobalPendulumSummoningSpecter and Duel.GetCurrentChain()==0 then
	GlobalPendulumSummoningSpecter = nil
	local x = CardsMatchingFilter(cards,AllMonsterFilter)
	x = math.min(x,max)
	return Add(cards,PRIO_TOFIELD,x)
  end
  if id == 31991800 then --Raccoon
    return RaccoonTarget(cards)
  end
  if id == 94784213 then --Fox
    return FoxTarget(cards)
  end
  if id == 18326736 then --Ptolemaeus
    return SpecterPtolemaeusTarget(cards)
  end
  if GlobalCatOverride and AI.GetCurrentPhase() == PHASE_END and not OPTCheck(05506791) then --Cat
    GlobalCatOverride = nil
    return CatTarget(cards)
  end
  if id == 76473843 then --Field Spell
    return MajestyTarget(cards)
  end
  if id == 53208660 then --Pendulum Call
    return SpecterPendulumCallTarget(cards)
  end
  if id == 72714461 then --Insight
    return InsightTarget(cards)
  end
  if id == 02572890 then --Specter Tempest
    return Add(cards,PRIO_BANISH)
  end
  if id == 78949372 then --Specter Supercell
    return SCellTarget(cards,min,max)
  end
  if id == 85252081 then --Granpulse
    return GranpulseTarget(cards)
  end
  if id == 00645794 then --Toad
    return ToadTarget(cards)
  end
  if id == 68395509 then --Crow
    return CrowTarget(cards)
  end
  if id == 15914410 then --Angineer
    return MechquippedTarget(cards)
  end
  if id == 62709239 then --Phantom Knights XYZ
    return SpecterPhantomTarget(cards)
  end
  if id == 36183881 then --Specter Tornado
    return STornadoTarget(cards)
  end
  if id == 49366157 then --Specter Cyclone
    return SCycloneTarget(cards)
  end
  if id == 52558805 then --Temtempo
    return SpecterTemtempoTarget(cards)
  end
  if id == 13972452 then --Specter Storm
    return SStormTarget(cards)
  end
  if id == 51531505 then --Dragonpit
    return DragonpitTarget(cards)
  end
  if id == 14920218 then --Peasant
    return SpecterPeasantTargeting(cards)
  end
  if id == 93568288 then --Number 80: Rhapsody in Berserk
    return SpecterRhapsodyTarget(cards)
  end
  if GlobalPaladinOverride and AI.GetCurrentPhase() == PHASE_END then --Majester Paladin
     GlobalPaladinOverride = nil
    return SpecterMajesterTarget(cards)
  end
  if SpecterGlobalMaterial then
     SpecterGlobalMaterial = nil
    return SpecterOnSelectMaterial(cards,min,max)
  end
  return nil
end

SpecterAtt={
15146890,
94784213,
00645794,
31991800,
34945480,
16195942,
84013237,
56832966,
31437713,
62709239,
71068247,
52558805,
21044178,
14920218,
}
--Dragonpulse, Fox, Toad
--Raccoon, Azathoth, Rebellion XYZ
--Utopia, Utopia Lightning, Heartlanddraco
--Phantom XYZ, Totem Bird, Temtempo, Abyss Dweller,
--Peasant
SpecterDef={
51531505,
05506791,
19665973,
18326736,
85252081,
93568288,
}
--Dragonpit, Cat, Fader,
--Ptolemaeus, Granpulse, Rhapsody
function SpecterPosition(id,available)
  local result
  for i=1,#SpecterAtt do
    if SpecterAtt[i]==id
    then
      result=POS_FACEUP_ATTACK
    end
  end
  for i=1,#SpecterDef do
    if SpecterDef[i]==id
    then
      result=POS_FACEUP_DEFENCE
    end
  end
  if id == 68395509 then
    if CrowAttack() then
	  result=POS_FACEUP_ATTACK
	else
	  result=POS_FACEUP_DEFENCE
	end
  end
  if id == 88722973 then
    if MajesterAttack() then
	  result=POS_FACEUP_ATTACK
	else
	  result=POS_FACEUP_DEFENCE
	end
  end
 return result
end

function UseRaccoon()
  return true
end

function UseFox()
  return true
end

function UseCrow()
  return true
end

function UseCat()
  return true
end

function UseToad()
  return true
end

function UseMajester()
  return true
end

function UsePeasantMon()
  return true
end

function SpecterEffectYesNo(id,card)
  local result
  if id == 31991800 and (NeedsScale5() or NeedsScale2()) then --Add based on the last needed Pendulum Scale
    OPTSet(31991800)
	GlobalCardMode = 1
	result = 1
  end
  if id == 31991800 and UseRaccoon() then --Add based on priority
    OPTSet(31991800)
    result = 1
  end
  if id == 68395509 and UseCrow() then
    OPTSet(68395509)
    result = 1
  end
  if id == 94784213 and UseFox() then
    OPTSet(94784213)
    result = 1
  end
  if id == 00645794 and UseToad() then
    OPTSet(00645794)
    result = 1
  end
  if id == 05506791 and UseCat() then
    OPTSet(05506791)
	GlobalCatOverride = true
    result = 1
  end
  if id == 78949372 then --Specter Supercell
    result = 1
  end
  if id == 14920218 and UsePeasantMon() then --Peasant
    result = 1
  end
  if id == 88722973 then --Majester Paladin
    GlobalPaladinOverride = true
    result = 1
  end
 return result
end

function SpecterChain(cards)
  if HasIDNotNegated(cards,18326736,EndPhasePtolemaeus) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,18326736,PtolemaeusAzathoth) then --Summon Azathoth on opponent's turn
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,78949372,UseSCell) then --Specter Supercell
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,02572890,ChainNegation) and not TasukeOpponentCheck() then --Specter Tempest
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,02572890,ChainTempestLastStrix) then --Versus Raidraptors
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,02572890,ChainTempestKozmo) then --Versus Kozmos
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,71068247,SpecterChainNegation) or HasIDNotNegated(cards,71068247,SpecterChainTotemBird) then --Totem Bird
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,05650082,ChainStormingMirror) then --Storming Mirror Force
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,15914410,SpecterChainMechquipped) then --Angineer
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,56832966,SpecterChainUtopiaLightning) then --Utopia Lightning
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,02572890,ChainSTempestBA) then --Versus Burning Abyss
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,36183881,ChainSTornadoDante) then --Versus Burning Abyss
    GlobalCardMode = 13
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,49366157,ChainSCycloneDante) then --Versus Burning Abyss
    GlobalCardMode = 13
--	GlobalMurderDante = true
	return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,49366157,ChainSCycloneLastStrix) then --Versus Raidraptors
	GlobalCardMode = 11
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,36183881,ChainSTornadoLastStrix) then --Versus Raidraptors
	GlobalCardMode = 11
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,49366157,ChainSCycloneLibrary) and GlobalExodiaTrashTalked then --Reading rainbow
	AITrashTalk("In life, learning from your mistakes will go a long way. Have you learned yet?")
	GlobalCardMode = 9
   return {1,IndexByID(cards,49366157)}
  end
  if HasIDNotNegated(cards,36183881,ChainSTornadoLibrary) and GlobalExodiaTrashTalked then --Reading rainbow
	AITrashTalk("In life, learning from your mistakes will go a long way. Have you learned yet?")
	GlobalCardMode = 9
   return {1,IndexByID(cards,36183881)}
  end
  if HasIDNotNegated(cards,49366157,ChainSCycloneLibrary) and not GlobalExodiaTrashTalked then --Reading rainbow
    GlobalExodiaTrashTalk = true
	AITrashTalk("Exodiuhhh...")
	GlobalCardMode = 9
   return {1,IndexByID(cards,49366157)}
  end
  if HasIDNotNegated(cards,36183881,ChainSTornadoLibrary) and not GlobalExodiaTrashTalked then --Reading rainbow
    GlobalExodiaTrashTalk = true
	AITrashTalk("Exodiuhhh...")
	GlobalCardMode = 9
   return {1,IndexByID(cards,36183881)}
  end
  if HasIDNotNegated(cards,36183881,TornadoShadowMist) and GlobalHeroTrashTalk then --End Phase, HERO trash talk.
    GlobalHeroTrashTalk = nil
	GlobalCardMode = 5
	AITrashTalk("My favorite Harry Potter character was HERO-N WEASLEY.")
	return {1,IndexByID(cards,36183881)}
  end
  if HasIDNotNegated(cards,49366157,CycloneShadowMist) and GlobalHeroTrashTalk then --End Phase, HERO trash talk.
    GlobalHeroTrashTalk = nil
	GlobalCardMode = 5
	AITrashTalk("My favorite Harry Potter character was HERO-N WEASLEY.")
	return {1,IndexByID(cards,49366157)}
  end
  if HasIDNotNegated(cards,36183881,ChainSpecterTornado2) then --Specter Tornado
	GlobalCardMode = 3
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,36183881,ChainSpecterTornado) or HasIDNotNegated(cards,36183881,ChainSpecterTornado3) then --Specter Tornado
    GlobalCardMode = 1
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,49366157,ChainSpecterCyclone2) then --Specter Cyclone
	GlobalCardMode = 3
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,49366157,ChainSpecterCyclone) or HasIDNotNegated(cards,36183881,ChainSpecterCyclone3) then --Specter Cyclone
    GlobalCardMode = 1
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,49366157,ChainSpecterCyclone4) then --Specter Cyclone
    GlobalCardMode = 7
   return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,36183881,ChainSpecterTornado4) then --Specter Tornado
    GlobalCardMode = 7
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,21044178,ChainSpecterAbyss) then --Abyss Dweller
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,02572890,ChainTempestLibrary) and GlobalExodiaTrashTalked then
    AITrashTalk("In life, learning from your mistakes will go a long way. Have you learned yet?")
	return {1,IndexByID(cards,02572890)}
  end
  if HasIDNotNegated(cards,02572890,ChainTempestLibrary) and not GlobalExodiaTrashTalked then
    GlobalExodiaTrashTalk = true
    AITrashTalk("Exodiuhhh...")
	return {1,IndexByID(cards,02572890)}
  end
  if SpecterHeroTrashTalk() then
    GlobalHeroTrashTalk = true
--	AITrashTalk("Do you really see nothing wrong with what you just did?")
    AITrashTalk("...Sure.")
  end
  if HasIDNotNegated(cards,02572890) and DetectShadowMist() and GlobalHeroTrashTalk then
    GlobalHeroTrashTalk = nil
	AITrashTalk("My favorite Harry Potter character was HERO-N WEASLEY.")
	return {1,CurrentIndex}
  end
  if GlobalHeroTrashTalk and Duel.GetTurnCount() == 3 then
     GlobalHeroTrashTalk = nil
     AITrashTalk("My favorite Harry Potter character was HERO-N WEASLEY.")
  end
  if GlobalExodiaTrashTalk and LibraryRemoved() and not GlobalExodiaTrashTalked then
     GlobalExodiaTrashTalk = nil
	 GlobalExodiaTrashTalked = true
	 AITrashTalk("Don't worry, you can just surrender and try Exodia Library again.")
	 AITrashTalk("Not like I'll remember that you've done this before, anyways.")
  end
  if #OppDeck()<=10 and not GlobalExodiaLoss and HasID(OppMon(),70791313,true) then
    GlobalExodiaLoss = true
    AITrashTalk("I always knew you librarians were evil.")
  end
  if HasIDNotNegated(cards,52558805,SpecterChainTemtempo1) then --Temtempo 1, chain to single materials.
     GlobalCardMode = 2
	 AITrashTalk("Take a vote on whether or not you like this on a Temtempoll.")
	return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,52558805,SpecterChainTemtempo2) then --Temtempo 2, chain to double materials.
     GlobalCardMode = 4
	 AITrashTalk("Take a vote on whether or not you like this on a Temtempoll.")
	return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,52558805,SpecterChainTemtempo3) then --Temtempo 3, chain on opponent's turn to double materials.
     GlobalCardMode = 6
	 AITrashTalk("Look buddy, there's not a lot of puns I can make out of Temtempo.")
	return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,52558805,SpecterChainTemtempo4) then --Temtempo 4, chain on opponent's turn to triple materials (only Utopia Lightning currently)
     GlobalCardMode = 8
	 AITrashTalk("Utopia Lightning? Then check out this ELECTRIFYING maneuver!")
	return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,52558805,SpecterChainTemtempo5) then --Temtempo 5, chain instantly for all other cards that don't meet the other conditions
     GlobalCardMode = 10
--	 AITrashTalk("I have no witty comment here. Why don't you submit one on the forums for me?")
	return {1,CurrentIndex}
  end
  if EnemyUltimateFalconFirstTurn() and not FalconFirstTurnTalk then
    FalconFirstTurnTalk = true
	AITrashTalk("On the first turn? Buddy. Pal. Friend. Do you truly hate me this much, Raidraptor guy?")
  end
  if EnemyUltimateFalcon() and Duel.GetTurnCount() ~= 1 and not FalconGeneralTalk and not FalconFirstTurnTalk then
    FalconGeneralTalk = true
	AITrashTalk("You got that card against Majespecters? Bravo. I have no idea how I let you get that, Raidraptor guy.")
  end
  if UsedUtopiaLightning() and HasID(OppGrave(),86221741,true) and not EnemyUltimateFalcon() and not FalconDestroyTalk then
    FalconDestroyTalk = true
	AITrashTalk("Looks like your Ultimate Falcon... just paid the Ultimate Price.")
  end
  if UsedUtopiaLightning2() and HasID(OppGrave(),86221741,true) and not EnemyUltimateFalcon() and not FalconDestroyTalk2 then
    FalconDestroyTalk2 = true
	AITrashTalk("You know you smirked, don't try to cover it up.")
  end
  if EnemyUltimateFalcon() and FalconDestroyTalk and not FalconReviveTalk then
    FalconReviveTalk = true
	AITrashTalk("Let's start a petition, you and me. We'll rename that card to Ultimate Falcongress.")
	AITrashTalk("Why? Because it dictates everything.")
  end
  if TasukeOpponentCheck() then
    TasukeOpponentActivated = true
	AITrashTalk("The legendary Tasuke Samurai #420 has arrived.")
  end
  return nil
end

SpecterPriorityList={
-- Priority list for your cards. You want to add all cards in your deck here,
-- or at least all cards you want to enable the Add function for.

--PRIO_HAND = 1
--PRIO_FIELD = 3
--PRIO_GRAVE = 5
--PRIO_SOMETHING = 7
--PRIO_BANISH = 9
 [31991800] = {7,1,8,2,0,0,1,1,9,3,RaccoonCond},             --Specter Raccoon
 [94784213] = {6,2,6,2,1,1,1,1,6,1,FoxCond},                 --Specter Fox
 [05506791] = {5,2,5,2,1,1,1,1,8,2,CatCond},                 --Specter Cat
 [00645794] = {3,1,3,1,1,1,1,1,3,1,ToadCond},                --Specter Toad
 [68395509] = {4,1,4,1,1,1,1,1,4,1,CrowCond},                --Specter Crow
 [51531505] = {3,1,1,1,9,1,1,1,1,1,DragonpitCond},           --Dragonpit Scale 8
 [15146890] = {5,2,1,1,7,1,1,1,1,1,DragonpulseCond},         --Dragonpulse Scale 1
 [19665973] = {1,1,1,1,1,1,1,1,1,1,nil},                     --Fader
 [72714461] = {4,2,1,1,8,1,1,1,1,1,InsightCond},             --Insight Scale 5
 [14920218] = {5,2,1,1,7,1,1,1,1,1,SpecterPeasantCond},      --Peasant Scale 2
 
 [36183881] = {8,2,8,2,1,1,1,1,1,1,STornadoCond},            --Specter Tornado
 [02572890] = {9,3,9,3,1,1,1,1,1,1,STempestCond},            --Specter Tempest
 [49366157] = {6,2,6,2,1,1,1,1,1,1,SCycloneCond},            --Specter Cyclone
 [13972452] = {5,1,5,1,1,1,1,1,1,1,SStormCond},              --Specter Storm
 [78949372] = {7,4,7,4,1,1,1,1,1,1,SCellCond},               --Specter Supercell
 }