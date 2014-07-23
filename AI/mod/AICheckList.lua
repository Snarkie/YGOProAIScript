---------------------------------------
-- AICheckList.lua
--
-- A set of functions to determine if a
-- card is part of an archetype or list.
---------------------------------------

-----------------------------
-- Checks if the card's ID is
-- of a Tribute Exception monster.
-----------------------------
function IsTributeException(CardId)
  if CardId == 64631466 or CardId == 63519819 or -- Relinquished, Thousand-Eyes Restrict 
     CardId == 10000000 or CardId == 10000020 or -- Obelisk the Tormentor, Slifer the Sky Dragon
     CardId == 10000010 then	                 -- The Winged Dragon of Ra		 
    return 1
  end
  return 0
end

function Is3TributeMonster(CardId)
  if CardId == 10000000 or CardId == 10000020 or -- Obelisk the Tormentor, Slifer the Sky Dragon
     CardId == 10000010 then	                 -- The Winged Dragon of Ra		 
    return 1
  end
  return 0
end

function LegitDWMonster(CardId)
  if CardId == 34230233 or CardId == 32619583 or 
     CardId == 33731070 or CardId == 79126789 then	 
    return 1
  end
  return 0
end

function IsUndestroyableByBattle(CardId)
  if CardId == 31305911 or CardId == 34408491 or CardId == 69031175 -- Marshmallon, Beelze, BW Armor Master
  or CardId == 31764700 or CardId == 04779091 or CardId == 78371393 -- the 3 Yubel forms
  or CardId == 74530899 or CardId == 23205979 or CardId == 62892347 -- Metaion, Spirit Reaper, AF - The Fool
  then 
    return 1
  end
  return 0
end

---------------------------------------------------------
-- Some cards shouldn't be banished
---------------------------------------------------------
function BanishBlacklist(CardId)
  if CardId == 65192027 or CardId == 88264978 or -- Dark Armed Dragon, REDMD
     CardId == 34230233 or CardId == 72989439 or -- Grapha, Black Luster Soldier
     CardId == 38495396 or CardId == 01662004 then  -- Constellar Ptolemy M7, FireFist Spirit  
	return 1
  end
    return 0
end

---------------------------------------------------------
-- Cards that benefit from being banished
---------------------------------------------------------
function BanishWhitelist(CardId)
  if CardId == 42216237 or CardId == 51858306   -- Angel of Zera, Eclipse Wyvern
  then
    return 1
  end
    return 0
end

-----------------------------
-- Checks if the card's ID is
-- of a Nordic Tuner monster.
-----------------------------
function IsNordicTuner(CardId)
  if CardId == 41788781 or CardId == 73417207 or   -- Guldfaxe, Mara
     CardId == 77060848 or CardId == 40844552 or   -- Svartalf, Valkyrie
     CardId == 61777313 then                       -- Vanadis
    return 1
  end
  return 0
end

-----------------------------
-- Checks if the card's ID is
-- of a "Gladiator Beast" archetype monster.
-----------------------------
function IsGladiatorArchetype(CardId)
  local AIMons  = AI.GetAIMonsterZones()
  for i=1,#AIMons do
  if AIMons[i] ~= false then
  if AIMons[i].id == CardId then
  if CardId == 42592719 or CardId == 90582719 or   -- Gladiator Beast Alexander, Gladiator Beast Andal
     CardId == 41470137 or CardId == 25924653 or   -- Gladiator Beast Bestiari, Gladiator Beast Darius
     CardId == 31247589 or CardId == 57731460 or   -- Gladiator Beast Dimacari, Gladiator Beast Equeste
     CardId == 73285669 or CardId == 90957527 or   -- Gladiator Beast Essedarii, Gladiator Beast Gaiodiaz
     CardId == 48156348 or CardId == 27346636 or   -- Gladiator Beast Gyzarus, Gladiator Beast Heraklinos
     CardId == 04253484 or CardId == 02067935 or   -- Gladiator Beast Hoplomus, Gladiator Beast Lanista
     CardId == 78868776 or CardId == 05975022 or   -- Gladiator Beast Laquari, Gladiator Beast Murmillo
     CardId == 29590752 or CardId == 00612115 or   -- Gladiator Beast Octavius, Gladiator Beast Retiari
     CardId == 02619149 or CardId == 77642288 or   -- Gladiator Beast Samnite, Gladiator Beast Secutor
     CardId == 79580323 or CardId == 65984457 or   -- Gladiator Beast Spartacus, Gladiator Beast Torax
     CardId == 50893987 and                        -- Gladiator Beast Tygerius
     (AIMons[i].position == POS_FACEUP_ATTACK or AIMons[i].position == POS_FACEUP_DEFENCE) then
    return 1
     end
      end
    end
  end
  return 0
end

--------------------------------
-- Checks if the card's ID is of
-- a main deck Nordic monster.
--------------------------------
function IsNordicMonster(CardId)
  if IsNordicTuner(CardId) == 1 then
    return 1
  end
  if CardId == 13455953 or CardId == 88283496 or   -- Dverg, Garmr
     CardId == 40666140 or CardId == 76348260 or   -- Ljosalf, Mimir
     CardId == 15394083 or CardId == 14677495 or   -- Tanngrisnir,Tanngnjostr
     CardId == 02333365 then                       -- Tyr
    return 1
  end
  return 0
end


-------------------------------------------------------
-- Checks if the card's ID is a Dark World monster that
-- has an effect that activates when it is discarded
-- by an effect controlled by the AI.
-------------------------------------------------------
function IsDiscardEffDWMonster(CardId)
  if CardId == 33731070 or CardId == 79126789 or   -- Beiige, Broww
     CardId == 07623640 or CardId == 78004197 or   -- Ceruli, Goldd
     CardId == 34230233 or CardId == 51232472 or   -- Grapha, Gren
     CardId == 25847467 or CardId == 15667446 or   -- Kahkki, Latinum
     CardId == 32619583 or CardId == 60228941 then -- Sillva, Snoww
    return 1
  end
  return 0
end


--------------------------------
-- Checks if the card's ID is an
-- Elemental HERO monster.
--------------------------------
function IsEHeroMonster(CardId)
  if IsEHeroMainDeckMonster(CardId) == 1 or
     IsEHeroFusionMonster(CardId) == 1 then
    return 1
  end
  return 0
end


------------------------------------
-- Checks if the card's ID is a
-- main deck Elemental HERO monster.
------------------------------------
function IsEHeroMainDeckMonster(CardId)
  if CardId == 21844576 or CardId == 59793705 or   -- Avian, Bladedge
     CardId == 79979666 or CardId == 58932615 or   -- Bubbleman, Burstinatrix
     CardId == 80908502 or CardId == 84327329 or   -- Captain Gold, Clayman
     CardId == 69572169 or CardId == 98266377 or   -- Flash, Heat
     CardId == 41077745 or CardId == 62107981 or   -- Ice Edge, Knospe
     CardId == 95362816 or CardId == 89252153 or   -- Lady Heat, Necroshade
     CardId == 05285665 or CardId == 89943723 or   -- Neo Bubbleman, Neos
     CardId == 69884162 or CardId == 37195861 or   -- Neos Alius, Ocean
     CardId == 51085303 or CardId == 89312388 or   -- Poison Rose, Prisma
     CardId == 20721928 or CardId == 40044918 or   -- Sparkman, Stratos
     CardId == 09327502 or CardId == 86188410 or   -- Voltic, Wildheart
     CardId == 75434695 then                       -- Woodsman
    return 1
  end
  return 0
end

---------------------------------
-- Checks if the card's ID is an
-- Elemental HERO fusion monster.
---------------------------------
function IsEHeroFusionMonster(CardId)
  if CardId == 40854197 or CardId == 11502550 or   -- Absolute Zero, Air Neos
     CardId == 55171412 or CardId == 17032740 or   -- Aqua Neos, Chaos Neos
     CardId == 28677304 or CardId == 41517968 or   -- Dark Neos, Darkbright
     CardId == 31111109 or CardId == 29343734 or   -- Divine Neos, Electrum
     CardId == 33574806 or CardId == 35809262 or   -- Escuridao, Flame Wing
     CardId == 81566151 or CardId == 16304628 or   -- Flare Neos, Gaia
     CardId == 85507811 or CardId == 48996569 or   -- Glow Neos, Grand Neos
     CardId == 03642509 or CardId == 68745629 or   -- Great Tornado, Inferno
     CardId == 78512663 or CardId == 05128859 or   -- Magma Neos, Marine Neos
     CardId == 14225239 or CardId == 52031567 or   -- Mariner, Mudballman
     CardId == 81003500 or CardId == 72926163 or   -- Necroid Shaman, Neos K
     CardId == 01945387 or CardId == 41436536 or   -- Nova Master, Phoenix E
     CardId == 60493189 or CardId == 47737087 or   -- Plasma Vice, Rampart B
     CardId == 25366484 or CardId == 88820235 or   -- Sh.Flare, Sh.Phoenix
     CardId == 81197327 or CardId == 49352945 or   -- Steam Healer,Storm Neos
     CardId == 83121692 or CardId == 74711057 or   -- Tempest, Terra Firma
     CardId == 22061412 or CardId == 61204971 or   -- The Shining, Thunder G
     CardId == 13293158 or CardId == 55615891 or   -- Wild Cyclone, Wild Wing
     CardId == 10526791 then                       -- Wildedge
    return 1
  end
  return 0
end


-----------------------------
-- Checks if the card's ID is
-- a Synchron tuner monster.
-----------------------------
function IsSynchronTunerMonster(CardId)
  if CardId == 52840598 or CardId == 25652655 or   -- Bri, Changer
     CardId == 56286179 or CardId == 19642774 or   -- Drill, Fleur
     CardId == 50091196 or CardId == 40348946 or   -- Formula, Hyper
     CardId == 63977008 or CardId == 56897896 or   -- Junk, Mono
     CardId == 96182448 or CardId == 20932152 or   -- Nitro, Quickdraw
     CardId == 71971554 or CardId == 83295594 or   -- Road, Steam
     CardId == 67270095 or CardId == 15310033 then -- Turbo, Unknown
    return 1
  end
  return 0
end


--------------------------
-- Checks if the card's ID
-- is a Synchron monster.
--------------------------
function IsSynchronMonster(CardId)
  if IsSynchronTunerMonster(CardId) == 1 or
     CardId == 36643046 then                -- Synchron Explorer
    return 1
  end
  return 0
end


-----------------------------
-- Checks if the card's ID is
-- a Destiny HERO monster.
-----------------------------
function IsDHeroMonster(CardId)
  if CardId == 55461064  or CardId == 77608643 or    -- Blade M, Captain T
     CardId == 100000275 or CardId == 81866673 or    -- Celestial, Dasher
     CardId == 54749427  or CardId == 39829561 or    -- Defender, Departed
     CardId == 13093792  or CardId == 56570271 or    -- Diamond Dude, Disc
     CardId == 17132130  or CardId == 41613948 or    -- Dogma, Doom Lord
     CardId == 28355718  or CardId == 36625827 or    -- Double, Dread Serv
     CardId == 80744121  or CardId == 09411399 or    -- Fear Monger, Mali
     CardId == 83965310  or CardId == 100000274 then -- Plasma, The Dark A
    return 1
  end
  return 0
end

---------------------------------------------------------
-- Checks if the specified card ID is in this "blacklist"
-- of cards to never normal summon or set, and returns
-- True or False depending on if it's in the list.
---------------------------------------------------------
NSBL={
   -- 
19665973,98777036,50933533,18964575,   -- Battle Fader, Trag,AGG Dragon, Scarecrow
53804307,89399912,44330098,26400609,   -- Blaster, Tempest,Gorz, Tidal
53797637,89185742,90411554,27415516,   -- Burner, Lightning,Redox, Stream
07902349,70903634,91020571,33396948,   -- Left Arm, Right Arm,Reactan, Exodia
70095154,88264978,44519536,08124921,   -- CyDra, REDMD,Left Leg, Right Leg
74530899,37742478,83039729,63176202,   -- Metaion, Honest,Grandmaster, Shogun                   
40240595,40640057,75498415,51945556,   -- Cocoon of Evolution, Kuriboh,Sirocco, Zaborg the Thunder Monarch 
74131780,91949988,57116033,00423585,   -- Exiled Force, Gaia Dragon, Winged Kuriboh, Summoner Monk 
45812361,37742478,09748752,78364470,   -- Cardcar D, Honest, Caius the Shadow Monarch, Constellar Pollux
66762372,92572371,23434538,03534077,   -- Boar, Buffalo, Maxx "C", Wolfbark
01662004,06353603,43748308,39699564,   -- Spirit, Bear, Dragon, Leopard
44860890,93294869,70355994,17475251,   -- Raven, Wolf, Gorilla, Hawk
80344569,30929786,97268402,41269771,   -- Neo-Spacian Grand Mole, FF Chicken, Effect Veiler, Constellar Algiedi
87255382,19310321,82293134,60316373,   -- Amphisbaena, Twin Eagle, Heraldic Beasts: Leo, Aberconway
56921677,86445415,45705025,82315772,   -- Basilisk, Red Gadget, Unicorn, Eale
42940404,05556499,41172955,13839120,   -- Machina Gearframe, Machina Fortress, Green Gadget, Yellow Gadget
53573406,32339440,39284521,18063928,   -- Masked Chameleon, Bujin Yamato, Machina Cannon, Tin Goldfish
68601507,59251766,53678698,23979249,  -- Bujin Crane, Hare, Bujin Mikazuchi, Arasuda
88940154,50474354,05818294,69723159,  -- Centipede, Peacock, Turtle, Quilin
21954587,22446869,37104630,00706925,  -- Mermail AbyssMegalo, Mermail Abyssteus, Atlantean Heavy Infantry, Atlantean Marksman
58471134,22076135,37781520,74311226,  -- Mermail Apysspike, Mermail Abyssturge, Mermail Abyssleed, Atlantean Dragoons
78868119,26400609,23899727,74298287,  -- Deep Sea Diva, Tidal, Dragon Ruler of Waterfalls Mermail Abysslinde, Mermail Abyssdine
30328508,77723643,37445295,04939890,  -- Shadoll Lizard, Shadoll Dragon, Shadoll Falcon, Shadoll Hedgehog
85103922,12697630,03717252,24062258,  -- Artifact Moralltach, Artifact Beagalltach, Shadoll Beast, Secret Sect Druid Dru
75878039,02273734,38667773,00109227,  -- Satellarknights Deneb,Altair,Vega,Sirius
38331564,91110378,69293721  -- Star Seraphs Scepter,Sovereign,Mermail Abyssgunde
}
function NormalSummonBlacklist(CardId) 
  for i=1,#NSBL do
    if NSBL[i]==CardId then
      return 1
    end
  end
  return 0
end

------------------------------------------------
-- Checks if the card ID is in this "whitelist"
-- of cards to always normal summon, and returns
-- True or False depending on the result.
------------------------------------------------
function NormalSummonWhitelist(CardId)
  if CardId == 88241506 or                          -- Blue-Eyed Maiden
     CardId == 03657444 or CardId == 93816465  then -- Cyber Valley, 0 Gardna
    return 1
  end
  return 0
end

---------------------------------------------------
-- Prefer monsters that benefit from being tributed
---------------------------------------------------
function TributeWhitelist(id)
  if id == 03300267 or id == 77901552 -- Hieratic Dragons of Su, Tefnuit,
  or id == 31516413 or id == 78033100 -- Eset, Gebeb
  then
    return 1
  end
  return 0
end

---------------------------------------------------------
-- Checks if the specified card ID is in this "blacklist"
-- of cards to never special summon, and returns
-- True or False depending on if it's in the list.
---------------------------------------------------------
function SpecialSummonBlacklist(CardId)
  for i=1,#SSBL do
    if SSBL[i]==CardId then
      return 1
    end
  end
  return 0
end

SSBL={
01710476,00598988,09433350, -- Sin End, Sin Bow, Sin Blue
36521459,55343236,95992081, -- Sin Dust, Sin Red, Leviair
80117527,34230233,33347467, -- No.11, Grapha, Ghost Ship
41269771,48579379,14536035, -- Constellar Algiedi, PU Great Moth, Dark Grepher
72989439,09596126,99365553, -- BLS, Chaos Sorcerer, Lightpulsar
98012938,58504745,96381979, -- Vulcan, Cardinal, Tiger King
74168099,37057743,88264978, -- Horse Prince, Lion Emperor, REDMD 
47387961,23649496,02407234, -- Number 8, Number 18, Number 69
11398059,22653490,34086406, -- King of the Feral Imps, Chidori, Lavalval Chain
12014404,46772449,48739166, -- Gagaga Cowboy, Evilswarm Exciton Knight, SHArk Knight
89856523,38495396,94380860, -- Kirin, Constellar Ptolemy M7, Ragna Zero
61344030,82315772,28912357, -- Starliege Paladynamo, Heraldic Beast Eale, Gear Gigant X
80117527,22110647,88033975, -- Number 11: Big Eye, Mecha Phantom Beast Dracossack, Armades, Keeper of Boundaries
33198837,83994433,76774528, -- Naturia Beast, Stardust Spark Dragon, Scrap Dragon
05556499,39284521,39765958, -- Machina Fortress, Machina Cannon, Jeweled RDA
09418365,68618157,75840616, -- Bujin Hirume, Amaterasu, Susanowo
01855932,73289035,26329679, -- Bujin Kagutsuchi, Tsukuyomi, Constellar Omega
21044178,00440556,59170782, -- Abyss Dweller, Bahamut Shark, Mermail Abysstrite
15914410,50789693,65749035, -- Mechquipped Angineer, Armored Kappa, Gugnir, Dragon of  the Ice Barrier
95169481,70583986,74371660, -- Diamond Dire Wolf, Dewloren Tiger King of the Ice Barrier, Mermail Abyssgaios
73964868,29669359,82633039, -- Pleiades, Volcasaurus, Skyblaster Castel
00581014,33698022,04779823, -- Emeral, Moonlight Rose, Michael
31924889,08561192,63504681, -- Arcanite Magician, Leoh, Rhongomiant
93568288,56638325,00109254, -- Number 80,Delteros, Triveil
17412721,38273745,21501505 -- Noden, ouroboros, Cairngorgon
}


---------------------------------------------------------
-- Checks if the specified card ID is in this "blacklist"
-- of cards to never set in the Spell&Trap zone
---------------------------------------------------------
function SetBlacklist(CardId)
  for i=1,#SetBL do
    if SetBL[i]==CardId then
      return 1
    end
  end
  return 0
end

SetBL={
  61314842,92365601,84220251, -- Advanced Heraldry Art, Rank-Up Magic - Limited Barian's Force, Heraldry Reborn
  73906480,96947648,74845897, -- Bujincarnation, Salvage, Rekindling
  54447022,44394295 -- Soul Charge, Shadoll Fusion
}


function RepositionBlacklist(id)
  for i=1,#RepoBL do
    if RepoBL[i]==CardId then
      return 1
    end
  end
  return 0
end
RepoBL={
  374452950,4939890,30328508,  -- Shadoll Falcon,Hedgehog,Lizard
  777236430,3717252,21502796, -- Shadoll Dragon, Beast,Ryko
  23899727 -- Mermail Abysslinde
}
---------------------------------------------------------
-- Checks if the specified card ID is in this "blacklist"
-- of cards to never negate on the field via cards like
-- Effect Veiler or Breakthrough Skill
---------------------------------------------------------
function NegateBlacklist(CardId)
  for i=1,#NegBL do
    if NegBL[i]==CardId then
      return 1
    end
  end
  return 0
end

NegBL={
  53804307,26400609,89399912,90411554 -- the 4 Dragon Rulers
}

function ToHandBlacklist(id) -- cards to not return to your opponent's hand 
  for i=1,#ToHandBL do
    if ToHandBL[i]==id then
      return true
    end
  end
  return false
end

ToHandBL={
  70095154,57774843,92841002 -- Cyber Dragon, JD, Mythic Water Dragon
}

function DestroyBlacklist(id) -- cards to not destroy in your opponent's possession
  for i=1,#DestroyBL do
    if DestroyBL[i]==id then
      return true
    end
  end
  return false
end

DestroyBL={
  19337371,07452945,14745409, -- Hysteric Sign, Noble Arms of Destiny, Gallatin
  23562407,83438826 -- Caliburn, Arfeudutyr
}

-----------------------------------------------------
-- Checks if the card's ID is in a list of spell/trap
-- cards that work well when multiple copies are
-- activated in the same chain.
-----------------------------------------------------
function MultiActivationOK(CardId)
  if CardId == 39526584 or CardId == 21466326 or   -- Gift Card, Blast Ruins
     CardId == 50470982 or CardId == 18807108 then -- The Paths of Destiny
    return 1
  end
  return 0
end

-----------------------------------------------------
-- List of cards that shouldn't be activated when Necrovalley is on field.
-----------------------------------------------------
function isUnactivableWithNecrovalley(CardId)
  if CardId == 83764718 or --Reborn
     CardId == 97077563 or --Call of the Haunted
     CardId == 67169062 or --Pot of Adarice
     CardId == 95503687 or --Lumina
     CardId == 74848038 or --Monster-Reinkarnation
     CardId == 61962135 or --Glourise Illusion
     CardId == 45906428 or --Miraclefusion
     CardId == 37412656 or --Hero Blast
     CardId == 13391185 or --Noble Knight Gwalchavad
     CardId == 14943837 or --Debris Dragon
     CardId == 30312361 or --Phantom of Chaos
     CardId == 13504844 or --Gottoms`Emercency Call
     CardId == 02204140 or --Book of Life
     CardId == 17259470 then -- Zombymaster
    return 1
  end
  return 0
end

-----------------------------------------------------
-- List of cards that shouldn't be activated in a same chain
-----------------------------------------------------
function isUnchainableTogether(CardId)
  if CardId == 44095762 or -- Mirror force
     CardId == 70342110 or -- Dimensional prison
     CardId == 56120475 or -- Sakuretsu armor
     CardId == 73964868 or -- Constellar Pleiades
	   CardId == 55713623 or -- Shrink
     CardId == 08698851 or -- D-Counter
     CardId == 21481146 or -- Radiant mirror force
     CardId == 62271284 or -- Justi-break
     CardId == 77754944 or -- Widespread Ruin
     CardId == 79178930 or -- Karakuri klock
     CardId == 89041555 or -- Blast held by a tribut
     CardId == 73178098 or -- Ego boost
     CardId == 10759529 or -- Kid guard
     CardId == 25642998 or -- Poseidon wave
     CardId == 29590905 or -- Super junior confrontation
     CardId == 43250041 or -- Draining shiled
     CardId == 43452193 or -- Mirror gate
     CardId == 57115864 or -- Lumenize 
     CardId == 60080151 or -- Memory of an Adversary
     CardId == 62279055 or -- Magic cylinder
     CardId == 75987257 or -- Butterflyoke
     CardId == 23171610 or -- Limiter removal
     CardId == 37390589 or -- Kunai with chain
     CardId == 01005587 or -- Void trap hole
     CardId == 04206964 or -- Trap hole
     CardId == 28654932 or -- Deep dark trap hole
     CardId == 94192409 or -- Compulsory Evacuation Device
	   CardId == 29401950 or -- Bottomless trap hole
     CardId == 62325062 or -- Adhesion trap hole
     CardId == 80723580 or -- Giant trap hole
     CardId == 99590524 or -- Treacherous trap hole
     CardId == 11593137 or -- Chaos trap hole
     CardId == 19230407 or -- Offerings to the doomed
     CardId == 33846209 or -- Gemini spark
     CardId == 04178474 or -- Raigeki-breaker
     CardId == 15083728 or -- House of adhesive tape
     CardId == 30127518 or -- Dark trap hole
     CardId == 39765115 or -- Splash capture
     CardId == 42578427 or -- Eatgaboon
     CardId == 46656406 or -- Mirror of oaths
     CardId == 58990631 or -- Automatic laser
     CardId == 72287557 or -- Chthonian Polymer
     CardId == 86871614 or -- Cloning
     CardId == 84749824 or -- Solem warning
     CardId == 37412656 or -- Hero blast
     CardId == 19665973 or -- Battle Fader
     CardId == 18964575 or -- Swift Scarecrow
     CardId == 29223325 or -- Artifact Ignition
     CardId == 12444060 or -- Artifact Sanctum
     CardId == 85103922 or -- Artifact Moralltach  - to prevent multiple ignitions
     CardId == 12697630 or -- Artifact Beagalltach - chained in a row for no reason
     CardId == 77505534 or -- Facing the Shadows
     CardId == 05318639 or -- Mystical Space Typhoon
     CardId == 53582587 then -- Torrential tribute   
	return 1
  end
  return 0
end

function UnchainableCheck(id)
  local e = nil
  for i=1,Duel.GetCurrentChain() do
    e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
    if e and isUnchainableTogether(e:GetHandler():GetCode())>0 then
      return isUnchainableTogether(id)==0;
    end
  end
  return true
end

----------------------------------------------------
-- Checks if the selected card searches the deck for
-- another card, simply by comparing it to a list of
-- often-used search cards. A work-in-progress, but
-- it gets the job done for now.
----------------------------------------------------
function CardIsASearchCard(CardId)
  local Result = 0
  if CardId == 73628505 or CardId == 32807846 or   -- Terraforming, ROTA
     CardId == 00213326 or CardId == 25377819 or   -- E-Call, Convocation
     CardId == 54031490 or CardId == 94886282 or   -- SSS, Charge
     CardId == 96363153 or CardId == 57103969 or   -- Tuning, FF Tenki
     CardId == 74968065 or CardId == 12171659 or   -- Hecatrice, Zeradias
     CardId == 17393207 or CardId == 51435705 or   -- Commandant, Skull
     CardId == 75064463 or CardId == 48675364 or   -- Harpie Q, ArchF Gen
     CardId == 03431737 or CardId == 43797906 or   -- Assault B, Atlantis
     CardId == 89739383 or CardId == 89997728 then -- Secrets, Toon Table
    Result = 1
  end
  return Result
end

------------------------------------
-- Checks if every card in the index
-- is that of a specified archetype.
------------------------------------
function AllCardsArchetype(Cards,SetCode)
  for i=1,#Cards do
    if Cards[i] ~= false then
      if Cards[i].setcode ~= SetCode then
        return 0
      end
    end
  end
  return 1
end

----------------------------------------------------
-- Checks if the selected card is already scripted 
-- in "OnSelectInitCommand", "SelectChain" functions.
----------------------------------------------------
ScriptedCards ={
27970830,54031490,15259703,79875176,  -- Gateway of the Six, Shien's Smoke Signal, Toon World, Toon Cannon Soldier 
58775978,82878489,41426869,14536035,  -- Nightmare's Steelcage, Shine Palace,Black Illusion Ritual, Dark Grepher
33420078,09411399,65192027,15561463,  -- Plaguespreader Zombie, Malicious, Dark Armed Dragon, Gauntlet Launcher
06353603,73964868,38495396,44635489,  -- Fire Fist - Bear, Constellar Pleiades,Ptolemy M7, Siat
70908596,41142615,68597372,47217354,  -- Constellar Kaust, The Cheerful CoffinWind-Up Zenmaister, Fabled Raven
74131780,36916401,12014404,34086406,  -- Exiled Force, Burnin' Boxin' Spirit,Gagaga Gunman, Lavalval Chain
00423585,40640057,95727991,71413901,  -- Summoner Monk, Kuriboh,Catapult Turtle, Breaker the Magical Warrior
83133491,18807108,87880531,72302403,  -- Zero Gravity, Spellbinding Circle,Diffusion Wave-Motion, Swords of Revealing Light
83746708,25774450,78156759,72892473,  -- Mage Power, Mystic Box,Wind-Up Zenmaines, Number 61: Volcasaurus		   
72892473,72892473,22110647,16435215,  -- Tiras, Card Destruction,Dracossack, Dragged Down into the Grave		   
93554166,74117290,81439173,40240595,  -- Dark World Lightning, Dark World Dealingd,Foolish Burial, Cocoon of Evolution		    		   
72989439,23265313,68005187,98045062,  -- Black Luster Soldier - Envoy of the Beginning, Cost Down,Soul Exchange, Enemy Controller		   
55713623,05758500,43973174,22046459,  -- Shrink, Soul Release,The Flute of Summoning Dragon, Megamorph		   
46910446,12607053,70231910,59385322,  -- Chthonian Alliance, Waboku	,Dark Core, Core Blaster	   
46009906,91595718,27174286,94192409,  -- Beast Fangs, Book of Secret Arts,Return from the Different Dimension, Compulsory Evacuation Device            
19596712,72932673,53610653,69243953,  -- Abyss-scale of Cetus, Abyss-scale of the Mizuchi,Bound Wand, Butterfly Dagger - Elma         
63851864,88190790,08719957,86198326,  -- Break! Draw!, Assault Armor, Abyss-scale of the Kraken, 7 Completed          
40830387,37457534,79965360,84740193,  -- Ancient Gear Fist, Ancient Gear Tank,Amazoness Heirloom, Buster Rancher             
05183693,90374791,00303660,53586134,  -- Amulet of Ambition, Armed Changer,Amplifier, Bubble Blaster          
65169794,40619825,00242146,61127349,  -- Black Pendant, Axe of Despair,Ballista of Rampart Smashing, Big Bang Shot                
50152549,41587307,18937875,24668830,  -- Paralyzing Potion, Broken Bamboo Sword,Burning Spear, Germ Infection           
75560629,39897277,46967601,56948373,  -- Flint, Elf's Light,Cursed Bill, Mask of the accursed       
53129443,07165085,05318639,19613556,  -- Dark Hole, Bait Doll, Mystical Space Typhoon, Heavy Storm           
31036355,93816465,09596126,01475311,  -- Swap, Zero Gardna,Chaos Sorcerer, Allure of darkness        
53567095,74848038,04178474,16255442,  -- Icarus, Monster Reincarnation,Raigeki Break, Beckoning                  
47387961,82732705,95503687,22624373,  -- #8 Genome, Sin Truth,Lumina, Lyla         
51452091,10026986,37742478,94283662,  -- Royal Decree, Worm King,Honest, Trance         
57774843,53582587,55794644,500000090, -- Judgment Dragon, Torrential Tribute,Hyperion, Toon Kingdom 
41420027,84749824,84013237,96216229,  -- Solemn Judgment, Solemn WarningNumber 39: Utopia, Gladiator Beast War Chariotthen
61257789,35952884,44508094,58120309,  -- Stardust Dragon/Assault Mode, Shooting Quasar DragonStardust Dragon, Starlight Road
50078509,14315573,24696097,50091196,  -- Fiendish Chain, Negate AttackShooting Star Dragon,Formula Synchron   
44095762,67987611,29267084,59616123,  -- Mirror Force, Amazoness ArchersShadow Spell, Trap Stun	 
70355994,10719350,39699564,30929786,  -- FireFormation Tenken, FireFist GorillaFireFist Leopard, Chicken
21350571,23434538,44920699,70329348,  -- Horn of the Phantom Beast, Maxx "C"FireFormation Tensen 
43748308,97268402,96381979,19059929,  -- FireFist Dragon, Effect VeilerFireFist Tiger King, FireFormation Gyokko
58504745,36499284,92572371,78474168,  -- FireFist Cardinal, FireFormation YokoFireFist Buffalo, Breakthrough Skill
46772449,58504745,77538567,70342110,  -- Noblswarm Belzebuth, FireFist Cardinal Dark Bribe, Dimensional Prison                       
19310321,45705025,60316373,87255382,  -- Twin Eagle, UnicornHeraldic Beasts: Aberconway, Amphisbaena
59048135,81439173,61314842,84220251,  -- Heraldry Augmentation, Foolish BurialAdvanced Heraldry Art, Heraldry Reborn
38296564,92365601,47387961,23649496,  -- Safe Zone, Rank-Up Magic: Limited Barian's Force,Number 8, Number 18       
44508094,90411554,27243130,94656263,  -- Stardust Dragon, Redox, Dragon Ruler of Boulders,Forbidden Lance, Kagetokage
22110647,33198837,18964575,80117527,  -- Dracossack, Naturia Beast, Swift Scarecrow, Number 11: Big Eye
97077563,94380860,83994433,76774528,  -- Call of the Haunted, Ragna Zero,Stardust Spark Dragon, Scrap Dragon
42940404,39765958,48739166,12744567,  -- Machina Gearframe, Jeweled Red Dragon Archfiend,SHArk Knight, SHDark Knight
09418365,68601507,53678698,23979249,  -- Bujin Hirume, Crane,Bujin Mikazuchi, Arasuda
69723159,88940154,59251766,05818294,  -- Bujin Quilin, Centipede,Bujin Hare, Turtle
32339440,30338466,50474354,73906480,  -- Bujin Yamato, Bujin Regalia - The Sword, Bujin Peacock, Bujincarnation
26329679,95169481,98645731,68618157,  -- Constellar Omega, Diamond Dire Wolf, Pot of Duality, Bujin Amaterasu
75840616,21954587,73289035,01855932,  -- Bujintei Susanowo, Mermail AbyssMegalo, Bujin Tsukuyomi, Kagutsuchi
22076135,58471134,22446869,37781520,  -- Mermail Abyssturge, Mermail Abysspike, Mermail Abyssteus, Mermail Abyssleed
74311226,78868119,23899727,74298287,  -- Atlantean Dragoons, Deep Sea Diva, Mermail Abysslinde, Mermail Abyssdine
34707034,60202749,26400609,96947648,  -- Abyss-squall, Abyss-sphere, Tidal, Salvage
74371660,50789693,00440556,21044178,  -- Mermail Abyssgaios, Armored Kappa, Bahamut Shark, Abyss Dweller
15914410,59170782,70583986,65749035,  -- Mechquipped Angineer, Mermail Abysstrite, Dewloren, Gugnir
30328508,77723643,37445295,04939890,  -- Shadoll Lizard, Shadoll Dragon, Shadoll Falcon, Shadoll Hedgehog
44394295,29223325,03717252,24062258,  -- Shadoll Fusion, Artifact Ignition, Shadoll Beast, Secret Sect Druid Dru
04904633,12444060,01845204,77505534,  -- Facing the Shadows, Artifact Sanctum, Instant Fusion, Facing the Shadows
29669359,82633039,20366274,94977269,  -- Volcasaurus, Skyblaster Castel, El-Shadoll Nephilim, El-Shadoll Midrash
04779823,31924889,00581014,33698022,  -- Michael, Arcanite Magician, Emeral, Moonlight Rose
54447022,74845897,34507039,14087893,  -- Soul Charge, Rekindling, Wiretap, Book of Moon
19665973,18964575,37576645,21954587,  -- Battle Fader, Swift Scarecrow, Reckless Greed, Mermail AbyssMegalo
75878039,02273734,38667773,00109227,  -- Satellarknights Deneb,Altair,Vega,Sirius
38331564,91110378,01845204,14087893,  -- Star Seraphs Scepter,Sovereign,Instant Fusion,Book of Moon
25789292,41510920,93568288,17412721,  -- Forbidden Chalice,Celestial Factor,Number 80,Noden
56638325,00109254,38273745  -- Stellarknights Delteros, Triveil,Evilswarm Ouroboros
}
function CardIsScripted(CardId)
  for i=1,#ScriptedCards do
    if CardId == ScriptedCards[i] then
      return 1
    end
  end
  return 0
end

